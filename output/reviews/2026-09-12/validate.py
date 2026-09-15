"""Structural validation of both ERS editions; not a semantic or software test."""
from pathlib import Path
import re, json

root=Path(__file__).resolve().parents[3]
errors=[]
catalogs=[]
open_states=[]
for folder in ('ers','ers-es'):
    out=root/'output'/folder
    ids={}
    confirmed={}
    for path in out.glob('*.md'):
        text=path.read_text(encoding='utf-8')
        for match in re.finditer(r'^### ((?:REQ|BR|DATA)-(?:MENU|UI)-\d+|(?:INT|QA|CON)-MENU-\d+|OPEN-\d+|SUPERSEDED-\d+) —',text,re.M):
            id=match[1]
            if id in ids: errors.append(f'{folder}: duplicate {id}')
            ids[id]=path.name
        for label,target in re.findall(r'\[([^\]]+)\]\(([^)]+)\)',text):
            if '://' in target: continue
            name,_,fragment=target.partition('#')
            dest=(path.parent/name).resolve() if name else path
            if not dest.exists(): errors.append(f'{path.name}: missing link {target}'); continue
            if fragment and f'id="{fragment}"' not in dest.read_text(encoding='utf-8'):
                errors.append(f'{folder}/{path.name}: missing anchor {target}')
        for block in re.split(r'(?=^### (?:(?:REQ|BR|DATA)-(?:MENU|UI)|(?:INT|QA|CON)-MENU)-)',text,flags=re.M)[1:]:
            id=re.match(r'### (\S+)',block)[1]
            fields=[('Requirement','Requisito','Rule Statement','Enunciado de regla'),('Source','Fuente'),('Verification','Verificación','Enforcement','Aplicación'),('Status','Estado')]
            if not id.startswith('BR-UI-001'):
                fields.insert(1,('Type','Tipo'))
            for field in fields:
                if not any(f'**{s}:**' in block for s in field): errors.append(f'{folder}/{id}: missing {field}')
            status=re.search(r'\*\*(?:Status|Estado):\*\* (\w+)',block)[1]
            confirmed[id]=status
            if status in ('Confirmed','Confirmado'):
                norm_match=re.search(r'\*\*(?:Requirement|Requisito|Rule Statement|Enunciado de regla):\*\*\s*\n([^\n]+)',block)
                norm=norm_match[1] if norm_match else ''
                if ('shall' if folder=='ers' else 'deberá') not in norm: errors.append(f'{folder}/{id}: no normative verb')
                if id.startswith('REQ') and re.search(r'\b(?:REST|gRPC|HTTP|SQL|ORM|CASCADE|isDeleted|COALESCE)\b|\bsoft.delete\b',norm,re.I): errors.append(f'{folder}/{id}: technology leakage')
            source=re.search(r'\*\*(?:Source|Fuente):\*\* ([^\n]+)',block)[1]
            for f,pages in re.findall(r'`(docs/md/[^`]+)` pp\. ([\d, –-]+)',source):
                content=(root/f).read_text(encoding='utf-8')
                available={int(x) for x in re.findall(r'## Página (\d+)',content)}
                for p in map(int,re.findall(r'\d+',pages)):
                    if p not in available: errors.append(f'{id}: missing page {p} in {f}')
    allowed_gaps={'REQ-MENU': {23}}
    for prefix in ('REQ-MENU','REQ-UI','BR-MENU','BR-UI','DATA-MENU','DATA-UI','INT-MENU','QA-MENU','CON-MENU','OPEN','SUPERSEDED'):
        nums=sorted(int(x.rsplit('-',1)[1]) for x in ids if x.startswith(prefix+'-'))
        missing=set(range(1,max(nums)+1))-set(nums)
        if missing-set(allowed_gaps.get(prefix,set())): errors.append(f'{folder}: gap in {prefix}')
    matrix=(out/'10-traceability-matrix.md').read_text(encoding='utf-8')
    matrix_ids=re.findall(r'^\| \[([^\]]+)\]',matrix,re.M)
    if sorted(matrix_ids)!=sorted(ids): errors.append(f'{folder}: matrix coverage mismatch')
    for path in out.glob('*.md'):
        for id in set(re.findall(r'\b(?:REQ|BR|DATA)-(?:MENU|UI)-\d+\b|\b(?:INT|QA|CON)-MENU-\d+\b|\b(?:OPEN|SUPERSEDED)-\d+\b',path.read_text(encoding='utf-8'))):
            if id not in ids: errors.append(f'{folder}/{path.name}: unknown reference {id}')
    counts={p:sum(k.startswith(p+'-') and v in ('Confirmed','Confirmado') for k,v in confirmed.items()) for p in ('REQ','BR','DATA','INT','QA','CON')}
    index=(out/'index.md').read_text(encoding='utf-8')
    for category,count in counts.items():
        if f'| {category} | {count} |' not in index: errors.append(f'{folder}: index count for {category} mismatches {count}')
    if f'**{sum(counts.values())}**' not in index: errors.append(f'{folder}: total mismatch')
    decisions=(out/'09-conflicts-and-open-items.md').read_text(encoding='utf-8')
    states={}
    for block in re.split(r'(?=^### OPEN-)',decisions,flags=re.M)[1:]:
        id=re.match(r'### (OPEN-\d+)',block)[1]
        state=re.search(r'\*\*(?:Status|Estado):\*\* (\w+)',block)
        if not state:
            errors.append(f'{folder}/{id}: missing decision status'); continue
        states[id]=state[1]
        if state[1] in ('Closed','Cerrado'):
            if not any(s in block for s in ('Decisiones-cierre-invariantes.md#adr-', 'ers-interfaces-alignment/decisions.md', 'Auditoria-4.md')): errors.append(f'{folder}/{id}: no closure decision')
            refs=re.findall(r'\b(?:REQ|BR|DATA|INT|QA|CON)-(?:MENU|UI)-\d+\b',block)
            if not refs: errors.append(f'{folder}/{id}: no propagated requirements')
            for ref in refs:
                if confirmed.get(ref) not in ('Confirmed','Confirmado'): errors.append(f'{folder}/{id}: unresolved closure dependency {ref}')
    expected_closed={f'OPEN-{n:03}' for n in range(1,10)}
    if {id for id,st in states.items() if st in ('Closed','Cerrado')}!=expected_closed: errors.append(f'{folder}: closed scope mismatch')
    if {id for id,st in states.items() if st in ('Partial','Parcial')}!={'OPEN-010'}: errors.append(f'{folder}: partial scope mismatch')
    open_states.append(states)
    catalogs.append((ids,confirmed,counts))
if catalogs[0][0]!=catalogs[1][0]: errors.append('Edition identifier mismatch')
translation={'Confirmed':'Confirmado','Pending':'Pendiente','Reclassified':'Reclasificado'}
if {k:translation[v] for k,v in catalogs[0][1].items()}!=catalogs[1][1]: errors.append('Edition status mismatch')
state_translation={'Closed':'Cerrado','Pending':'Pendiente','Partial':'Parcial','Open':'Abierto'}
if {k:state_translation[v] for k,v in open_states[0].items()}!=open_states[1]: errors.append('Edition OPEN status mismatch')
result={'result':'PASS' if not errors else 'FAIL','scope':'Document structure and closure propagation only; current correction reviews are docs/reviews/ers-interfaces-alignment/closure-report.md and execution-audit.md. No implementation or performance tests executed.','editions':2,'identifiers_per_edition':len(catalogs[0][0]),'confirmed_by_category':catalogs[0][2],'open_statuses':open_states[0],'errors':errors}
(root/'output/reviews/2026-09-12/validation.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
raise SystemExit(bool(errors))
