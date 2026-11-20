from pathlib import Path
import re
source=Path('lib/mpt_daily_duas_additions.dart').read_text(encoding='utf-8')
blocks=re.split(r'\n  MptDailyDuaAddition\(',source)[1:]
expected={'bathroom_in','bathroom_out','home_out','home_in','mosque_in','mosque_out','vehicle'}
langs={'en','bn','ko','ar','ur','uz','id','hi'}
assert len(blocks)==7, f'Expected 7 dua blocks, got {len(blocks)}'
ids=set()
for block in blocks:
    id=block.split("'",2)[1]; ids.add(id)
    sections=re.findall(r'\{([^{}]+)\}',block)
    assert len(sections)==3, f'{id}: expected title, pronunciation, meaning maps'
    for i,sec in enumerate(sections):
        keys=set(re.findall(r"'([a-z]{2})'\s*:",sec))
        assert keys==langs, f'{id}: section {i} languages {keys} != {langs}'
assert ids==expected, f'Unexpected dua IDs: {ids}'
workflow=Path('codemagic.yaml').read_text()
assert 'python3 verify_source.py' in workflow
assert 'python3 integrate_daily_duas.py' in workflow
assert workflow.index('python3 verify_source.py')<workflow.index('python3 integrate_daily_duas.py')<workflow.index('flutter create --platforms=android')
assert 'flutter analyze' in workflow and 'flutter build apk --debug' in workflow
print('PASS: 7 unique duas, 8 titles + pronunciations + meanings per dua (168 localized fields)')
print('PASS: original build verification preserved; integration precedes Flutter compile')
