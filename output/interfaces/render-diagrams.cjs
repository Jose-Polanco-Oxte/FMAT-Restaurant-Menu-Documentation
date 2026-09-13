const fs = require('fs');
const path = require('path');
const http = require('http');
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'C:/Users/tony/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const root = __dirname;
const dist = path.join(root, '.validation-tools/node_modules/mermaid/dist');
const out = path.join(root, 'validation');
fs.mkdirSync(out, {recursive:true});
const server = http.createServer((req,res) => {
  const url = new URL(req.url, 'http://localhost');
  if(url.pathname === '/') {res.setHeader('Content-Type','text/html'); return res.end('<html><body><div id="view"></div><script type="module">import mermaid from "/mermaid.esm.min.mjs";mermaid.initialize({startOnLoad:false,securityLevel:"strict"});window.mermaid=mermaid;</script></body></html>');}
  const file = path.resolve(dist, '.' + decodeURIComponent(url.pathname));
  if(!file.startsWith(dist+path.sep) || !fs.existsSync(file)) {res.statusCode=404; return res.end();}
  res.setHeader('Content-Type','application/javascript');fs.createReadStream(file).pipe(res);
});
(async()=>{
  await new Promise(r=>server.listen(0,'127.0.0.1',r));
  let browser;
  try {
    browser=await chromium.launch({channel:'msedge',headless:true});
    const page=await browser.newPage({viewport:{width:1500,height:1200},deviceScaleFactor:1});
    await page.goto(`http://127.0.0.1:${server.address().port}`);
    await page.waitForFunction(()=>!!window.mermaid);
    const conceptual=path.resolve(root,'../../docs/diagrams/flujo-ordenar.md');
    const sources=[{file:path.join(root,'flujos.md'),count:3},{file:conceptual,count:1}];
    const diagrams=[];
    for(const spec of sources) {
      const text=fs.readFileSync(spec.file,'utf8').replace(/\r\n/g,'\n');
      const blocks=[...text.matchAll(/```mermaid\n([\s\S]*?)\n```/g)].map(m=>m[1]);
      if(blocks.length!==spec.count) throw new Error(`Unexpected diagram count in ${spec.file}`);
      blocks.forEach((source,index)=>diagrams.push({source,file:spec.file,index}));
    }
    const results=[];
    for(let i=0;i<diagrams.length;i++) {
      const svg=await page.evaluate(async({source,index})=>{await window.mermaid.parse(source);const {svg}=await window.mermaid.render('diagram'+index,source);document.querySelector('#view').innerHTML=svg;return svg;},{source:diagrams[i].source,index:i});
      const target=diagrams[i].file===conceptual?conceptual.replace(/\.md$/,''):path.join(out,`diagram-${diagrams[i].index+1}`);
      fs.writeFileSync(target+'.svg',svg);
      await page.locator('#view svg').screenshot({path:target+'.png'});
      results.push({source:path.relative(root,diagrams[i].file),diagram:diagrams[i].index+1,parsed:true,rendered:true});
    }
    fs.writeFileSync(path.join(out,'mermaid.json'),JSON.stringify({result:'PASS',mermaidVersion:require('./.validation-tools/node_modules/mermaid/package.json').version,results},null,2)+'\n');
    console.log(JSON.stringify(results));
  } finally {if(browser)await browser.close();server.close();}
})().catch(e=>{fs.writeFileSync(path.join(out,'mermaid.json'),JSON.stringify({result:'FAIL',error:String(e)},null,2));console.error(e);process.exitCode=1;});
