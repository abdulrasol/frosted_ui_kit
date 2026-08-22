import os
import re

directory = 'lib/src/screens'
for f in os.listdir(directory):
    if not f.endswith('.dart'):
        continue
    path = os.path.join(directory, f)
    with open(path) as file:
        text = file.read()
    
    # We want to remove the dangling `          ),` that was left behind
    # Look for a `)` that is followed by `        ],`
    text = re.sub(r'^\s*\),\s*\]\,\s*', r'        ],\n', text, flags=re.MULTILINE)
    
    with open(path, 'w') as file:
        file.write(text)
