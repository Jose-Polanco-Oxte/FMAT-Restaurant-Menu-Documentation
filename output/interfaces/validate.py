"""Validate contracts and examples, not service implementation."""
from pathlib import Path
import json
import re
from jsonschema import Draft202012Validator, FormatChecker
from referencing import Registry, Resource

root=Path(__file__).resolve().parent
errors=[]
schemas=sorted((root/'schemas').glob('*.json'))
registry=Registry().with_resources((p.as_uri(),Resource.from_contents(json.loads(p.read_text(encoding='utf-8')))) for p in schemas)
def validator(name):
    return Draft202012Validator({'$ref':(root/'schemas'/f'{name}.schema.json').as_uri()},registry=registry,format_checker=FormatChecker())
for p in schemas:
    schema=json.loads(p.read_text(encoding='utf-8'))
    try: Draft202012Validator.check_schema(schema)
    except Exception as e: errors.append(f'{p.name}: {e}')
    for target in re.findall(r'"\$ref":\s*"([^"]+)"',p.read_text(encoding='utf-8')):
        if not (p.parent/target).exists(): errors.append(f'Missing schema {target}')
contracts=json.loads((root/'contracts.json').read_text(encoding='utf-8'))
events=json.loads((root/'events.json').read_text(encoding='utf-8'))
validated=0
for c in contracts:
    for schema,example in [(c['requestSchema'],c['requestExample']),(c['responseSchema'],c['responseExample'])]:
        if schema:
            for e in validator(schema).iter_errors(example): errors.append(f"{c['id']} {list(e.path)}: {e.message}")
            validated+=1
    doc=(root/c['document']).read_text(encoding='utf-8')
    for section in ['Endpoint versionado','Autorización y headers','Parámetros','Body','Respuesta','Comportamiento y errores']:
        if f'## {section}' not in doc: errors.append(f"{c['id']}: missing {section}")
    if not c['path'].startswith('/v1/restaurants/{restaurantId}/'): errors.append(f"Unversioned endpoint {c['id']}")
    blocks=re.findall(r'```json\n(.*?)\n```',doc,re.S)
    expected=([c['requestExample']] if c['requestSchema'] else [])+[c['responseExample']]
    if [json.loads(x) for x in blocks]!=expected: errors.append(f"Examples drifted in {c['id']}")
for c in events:
    for e in validator(c['schema']).iter_errors(c['example']): errors.append(f"{c['id']} {list(e.path)}: {e.message}")
    validated+=1
    if c['id']=='M-04' and not c['example']['data'].get('reevaluationRequestId'): errors.append('Missing reevaluation identity')
    doc=(root/c['document']).read_text(encoding='utf-8')
    blocks=re.findall(r'```json\n(.*?)\n```',doc,re.S)
    if len(blocks)!=1 or json.loads(blocks[0])!=c['example']: errors.append(f"Example drifted in {c['id']}")
links=examples=diagrams=0
docs=[p for p in root.rglob('*.md') if '.validation-tools' not in p.parts]
conceptual=root.parent.parent/'docs/diagrams/flujo-ordenar.md'
if not conceptual.exists(): errors.append('Missing conceptual ordering diagram')
else:
    content=conceptual.read_text(encoding='utf-8')
    for raw in re.findall(r'\]\(([^)]+)\)',content):
        if raw.startswith(('http:','https:')): continue
        file=raw.partition('#')[0]
        if not (conceptual.parent/file).exists(): errors.append(f'Missing conceptual diagram link: {raw}')
    if len(re.findall(r'```mermaid',content))!=1: errors.append('Expected one conceptual diagram')
for p in docs:
    text=p.read_text(encoding='utf-8')
    if re.search(r'Product|productId|productVersion|/products|orders/|/movements|/kitchen-jobs|line-resolutions',text): errors.append(f'Out-of-scope vocabulary/route in {p.relative_to(root)}')
    for raw in re.findall(r'\]\(([^)]+)\)',text):
        if raw.startswith(('http:','https:')): continue
        path,_,anchor=raw.partition('#'); target=(p.parent/path).resolve(); links+=1
        if not target.exists(): errors.append(f'{p.name}: missing {raw}')
        elif anchor and f'id="{anchor}"' not in target.read_text(encoding='utf-8'): errors.append(f'{p.name}: missing anchor {raw}')
    for b in re.findall(r'```json\n(.*?)\n```',text,re.S):
        try:
            data=json.loads(b)
            if b!=json.dumps(data,ensure_ascii=False,indent=2): errors.append(f'JSON not formatted in {p.name}')
        except Exception as e: errors.append(f'JSON in {p.name}: {e}')
        examples+=1
    for b in re.findall(r'```mermaid\n(.*?)\n```',text,re.S):
        diagrams+=1
        if ';' in b or '&gt;' in b: errors.append(f'Unsafe Mermaid separator in {p.name}')
negative=[('IngredientEffect',{'operation':'OMIT','inventoryItemId':'i','quantity':'1'}),('ResolutionRequest',{'requestId':'r'}),('MenuItemVariant',{'variantId':'v','status':'ACTIVE'})]
sample=next(c['example'] for c in events if c['id']=='M-03')
recovery=json.loads(json.dumps(sample));recovery['data']['reevaluationRequestId']='reeval-1'
recovery['correlationId']='trace-optional'
for example in [sample,recovery]:
    for e in validator('EventM03').iter_errors(example): errors.append(f'M-03 variant: {e.message}')
legacy=json.loads(json.dumps(sample));legacy['causationId']='old-message'
negative.append(('EventM03',legacy))
for p in schemas:
    def check_descriptions(value):
        if isinstance(value,dict):
            for key,field in value.get('properties',{}).items():
                if not field.get('description'): errors.append(f'Missing field explanation: {p.name} {key}')
            for child in value.values(): check_descriptions(child)
        elif isinstance(value,list):
            for child in value: check_descriptions(child)
    check_descriptions(json.loads(p.read_text(encoding='utf-8')))
if {e['id'] for e in events}!={'M-01','M-02','M-03','M-04','M-07','M-08'}: errors.append('Unexpected active messages')
if any(c['id']=='E-10' for c in contracts): errors.append('E-10 should be retired')
for name,example in negative:
    if validator(name).is_valid(example): errors.append(f'Negative example accepted: {name}')
report={'result':'FAIL' if errors else 'PASS','scope':'Schema validity, local references, examples, documentation structure and vocabulary. Mermaid rendering separate. No service tests.','apiEntries':len(contracts),'outboundHttpApis':0,'messageContracts':len(events),'schemas':len(schemas),'schemaValidatedExamples':validated,'negativeExamples':len(negative),'formattedJsonExamples':examples,'mermaidBlocks':diagrams,'localLinks':links,'errors':errors}
(root/'validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(report,ensure_ascii=True))
raise SystemExit(bool(errors))
