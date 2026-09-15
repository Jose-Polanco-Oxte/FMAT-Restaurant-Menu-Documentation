"""Executable contract/fixture checks, NOT an implementation of Menu."""
from pathlib import Path
import json, re, copy
from decimal import Decimal
from jsonschema import Draft202012Validator, FormatChecker
from referencing import Registry, Resource

root=Path(__file__).resolve().parent
repo=root.parents[1]
schemas=list((root/'schemas').glob('*.json'))
registry=Registry().with_resources((p.as_uri(),Resource.from_contents(json.loads(p.read_text(encoding='utf-8')))) for p in schemas)
def validator(name):
    return Draft202012Validator({'$ref':(root/'schemas'/f'{name}.schema.json').as_uri()},registry=registry,format_checker=FormatChecker())
errors=[];checks=0
def check(condition,label):
    global checks
    checks+=1
    if not condition: errors.append(label)
def valid(name,value,expected,label): check(validator(name).is_valid(value)==expected,label)

summary={'unitPrice':'200.00','extrasTotal':'15.00','unitSubtotal':'215.00','currency':'MXN'}
valid('PriceSummary',summary,True,'aggregate summary accepted')
for key in ['terms','slots','components','modifiers','pricingInputs']:
    valid('PriceSummary',{**summary,key:[]},False,'summary rejects '+key)
for key in ['unitPrice','extrasTotal','unitSubtotal']:
    valid('PriceSummary',{**summary,key:'-1'},False,'negative '+key)
valid('Money',{'amount':'0','currency':'MXN'},True,'zero price accepted')
valid('Money',{'amount':'-0.01','currency':'MXN'},False,'negative adjustment rejected')
for quantity in ['0','0.000','-1']:
    valid('Ingredient',{'inventoryItemId':'i','quantity':quantity,'unit':'g'},False,'physical rejects '+quantity)
for quantity in ['0.001','1','100.00']:
    valid('Ingredient',{'inventoryItemId':'i','quantity':quantity,'unit':'g'},True,'physical accepts '+quantity)
valid('IngredientEffect',{'operation':'OMIT','inventoryItemId':'i','quantity':'1'},False,'OMIT has no quantity')
option={'optionId':'o','enabled':True,'itemVariantId':'v','quantity':2,'priceDelta':{'amount':'10','currency':'MXN'}}
valid('ComboOption',option,True,'combo option with concrete leaf and price delta')
valid('ComboOption',{**option,'suppliedQuantity':2},False,'legacy supplied quantity rejected')
slot={'slotId':'s','name':'Choice','minSelections':1,'maxSelections':1,'options':[option],'baseOptionIds':['o']}
valid('ComboSlot',slot,True,'administrative base selection')
valid('ComboSlot',{**slot,'baseOptionIds':['o','o']},False,'duplicate base IDs rejected')
valid('CommercialComboSlot',slot,False,'commercial slot rejects admin reference')
commercial=copy.deepcopy(slot);commercial.pop('baseOptionIds')
valid('CommercialComboSlot',commercial,True,'commercial slot without admin reference')
valid('ReviewConfirmation',{'configurations':[]},False,'confirmation cannot acknowledge implicit all')
valid('ReviewConfirmation',{'configurations':[{'configurationId':'cfg','reviewToken':'seen'}],'state':'UP_TO_DATE'},False,'client cannot set review state')
valid('PriceTerm',{},False,'retired price terms not accepted')

# These are independent expected examples, not execution of the Menu service.
fixtures=[
 {'name':'included A','base':'200','extras':[],'expected':'200'},
 {'name':'included B costs more individually','base':'200','extras':[],'expected':'200'},
 {'name':'only one of two units has cheese','base':'200','extras':[{'quantity':1,'pinned':'5'}],'expected':'205'},
 {'name':'two independently personalized units','base':'200','extras':[{'quantity':1,'pinned':'5'},{'quantity':2,'pinned':'5'}],'expected':'215'},
 {'name':'old pinned extra remains five','base':'200','extras':[{'quantity':1,'pinned':'5','current':'7'}],'expected':'205'},
 {'name':'free variant','base':'0','extras':[],'expected':'0'}]
for f in fixtures:
    extra=sum((Decimal(e['pinned'])*e['quantity'] for e in f['extras']),Decimal(0))
    example={'unitPrice':f['base'],'extrasTotal':str(extra),'unitSubtotal':f['expected'],'currency':'MXN'}
    valid('PriceSummary',example,True,f['name']+' schema')
    check(Decimal(f['base'])+extra==Decimal(f['expected']),f['name']+' expected arithmetic')

contracts=json.loads((root/'contracts.json').read_text(encoding='utf-8'))
review_example=copy.deepcopy(next(c for c in contracts if c['id']=='E-20')['responseExample'])
valid('ComboReview',review_example,True,'pending review example')
missing_expiry=copy.deepcopy(review_example);missing_expiry['configurations'][0].pop('reviewTokenExpiresAt')
valid('ComboReview',missing_expiry,False,'review observation requires explicit expiry')
bad_expiry=copy.deepcopy(review_example);bad_expiry['configurations'][0]['reviewTokenExpiresAt']='invalid'
valid('ComboReview',bad_expiry,False,'review expiry must be a timestamp')
inconsistent=copy.deepcopy(review_example);inconsistent['state']='UP_TO_DATE'
valid('ComboReview',inconsistent,False,'aggregate cannot hide pending variants')
inconsistent=copy.deepcopy(review_example);inconsistent['configurations'][0]['state']='UP_TO_DATE'
valid('ConfigurationReview',inconsistent['configurations'][0],False,'updated configuration cannot have pending changes')
inconsistent=copy.deepcopy(review_example);inconsistent['configurations'][0]['changes']=[]
valid('ConfigurationReview',inconsistent['configurations'][0],False,'pending configuration must expose pending changes')
updated=copy.deepcopy(review_example);updated['state']='UP_TO_DATE';updated['configurations'][0]['state']='UP_TO_DATE';updated['configurations'][0]['changes']=[]
valid('ComboReview',updated,True,'acknowledgement can leave no pending changes')
inconsistent=copy.deepcopy(updated);inconsistent['state']='REVIEW_REQUIRED'
valid('ComboReview',inconsistent,False,'pending aggregate requires a pending variant')
page=copy.deepcopy(next(c for c in contracts if c['id']=='E-19')['responseExample'])
inconsistent=copy.deepcopy(page);inconsistent['items'][0]['fulfillmentType']='PREPARED'
valid('AdminMenuItemPage',inconsistent,False,'PREPARED cannot receive combo review state')
inconsistent=copy.deepcopy(page);inconsistent['items'][0]['pendingConfigurationIds']=[]
valid('AdminMenuItemPage',inconsistent,False,'pending list item must identify affected configurations')
noncombo=copy.deepcopy(page);noncombo['items'][0].update(fulfillmentType='STOCKED',reviewState=None,pendingConfigurationIds=[])
valid('AdminMenuItemPage',noncombo,True,'noncombo has no review state')
ids={c['id'] for c in contracts}
check(ids=={f'E-{n:02}' for n in range(1,22) if n!=10},'active endpoint inventory')
e16=next(c for c in contracts if c['id']=='E-16')['responseExample']
check('pricingInputs' not in e16 and set(e16['pricing'])==set(summary),'E-16 actual example is aggregate only')
combo=copy.deepcopy(e16)
combo['menuItem']={'menuItemId':'mi-combo','menuItemVersion':'1_2026-09-12T00:00:00Z','configurationId':'cfg-combo'}
component={'menuItemId':'mi-burger','menuItemVersion':'1_2026-09-12T00:00:00Z','variantId':'v-burger'}
combo['selection']={'modifiers':[],'components':[{'slotId':'s','optionId':'o','units':[{'unitIndex':1,'modifiers':[{'configId':'cheese','quantity':1}]},{'unitIndex':2,'modifiers':[{'configId':'cheese','quantity':2}]}]}]}
recipe={'recipeId':'recipe-burger','recipeVersion':'1_2026-09-12T00:00:00Z','name':'Hamburguesa','components':[{'inventoryItemId':'meat','quantity':'100','unit':'g'}]}
combo['recipeRefs']=[{'recipeId':recipe['recipeId'],'recipeVersion':recipe['recipeVersion']}]
combo['ingredients']=[{'inventoryItemId':'meat','quantity':'200','unit':'g'},{'inventoryItemId':'cheese','quantity':'30','unit':'g'}]
combo['preparationUnits']=[{'scope':f's/o/{i}','menuItem':component,'name':'Hamburguesa','variantLabel':'Individual','recipe':recipe,'modifiers':[{'configId':'cheese','name':'Queso','quantity':i,'effects':[{'operation':'ADD','inventoryItemId':'cheese','quantity':'10','unit':'g'}]}]} for i in [1,2]]
combo['pricing']=summary
valid('Resolution',combo,True,'complete combo with two personalized units and only aggregated money')
leaked=copy.deepcopy(combo);leaked['preparationUnits'][0]['modifiers'][0]['priceDelta']={'amount':'5','currency':'MXN'}
valid('Resolution',leaked,False,'preparation cannot leak modifier prices')
for c in contracts:
    if c['id'] in ['E-19','E-20','E-21']:
        check(c['permission']==('menu:definition:write' if c['id']=='E-21' else 'menu:definition:read'),c['id']+' authorization')

def refs(name,seen=None):
    seen=set() if seen is None else seen
    if name in seen:return seen
    seen.add(name)
    for target in re.findall(r'"\$ref":\s*"([^"]+)"',(root/'schemas'/name).read_text(encoding='utf-8')):refs(target,seen)
    return seen
check('PriceTerm.schema.json' not in refs('Resolution.schema.json'),'no detailed monetary schema reachable from E-16')
check('ComboSlot.schema.json' not in refs('CatalogDetail.schema.json'),'commercial reads exclude administrative slot schema')
for p in root.rglob('*.md'):
    text=p.read_text(encoding='utf-8')
    check('../ers-es/' not in text,str(p.relative_to(root))+' canonical links')

# Compare IDs and statuses for every obligation; wording equivalence requires human review.
def edition(folder):
    result={}
    for p in (repo/'output'/folder).glob('*.md'):
        for m in re.finditer(r'^### ((?:REQ|BR|DATA|INT|QA|CON)-MENU-\d+) —[^\n]*\n(.*?)(?=^### |\Z)',p.read_text(encoding='utf-8'),re.M|re.S):
            status=re.search(r'\*\*(?:Status|Estado):\*\* (\w+)',m[2])[1]
            result[m[1]]={'Confirmado':'Confirmed','Reclasificado':'Reclassified','Pendiente':'Pending'}.get(status,status)
    return result
check(edition('ers')==edition('ers-es'),'bilingual IDs and statuses')
trace=(root/'trazabilidad.md').read_text(encoding='utf-8')
rows=re.findall(r'^\| ([EM]-\d{2}) \| ([^\n]+) \|$',trace,re.M)
events=json.loads((root/'events.json').read_text(encoding='utf-8'))
expected=ids|{e['id'] for e in events}
check(len(rows)==len(expected) and {r[0] for r in rows}==expected,'complete unique active contract traceability')
requirements=edition('ers')
for contract,body in rows:
    targets=re.findall(r'(?:REQ|BR|DATA|INT|QA|CON)-MENU-\d+',body)
    check(bool(targets) and all(requirements.get(t)=='Confirmed' for t in targets),contract+' confirmed requirement anchors')
for n in range(1,10):
    check(f'D-{n:02}' in trace,f'D-{n:02} authority trace')
for id in ['E-19','E-20']:
    doc=(root/'apis/entrada'/f'{id}.md').read_text(encoding='utf-8')
    check('Idempotency-Key obligatorio' not in doc and 'E-21 requiere' not in doc,id+' read-only headers')
    check('ETag' in doc,id+' administrative representation headers')
check('E-19:' not in (root/'apis/entrada/E-21.md').read_text(encoding='utf-8'),'confirmation has no list query copy')
report={'result':'FAIL' if errors else 'PASS','checks':checks,'scope':'Schemas, negative examples, arithmetic fixtures, endpoint inventory and bilingual structural parity only. No service/state-machine/integration/UI/performance tests.','errors':errors}
(root/'alignment-validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(report,ensure_ascii=True))
raise SystemExit(bool(errors))
