import re

with open('lib/src/catalog_home_screen.dart') as f:
    content = f.read()

# We need to insert `],),),` right after the GridView.count block to close firstChild, Column, and children array.
# Let's find the GridView.count block.
pattern = r'(GridView\.count\(.*?children: \[.*?\],[\s\n]*\))'
match = re.search(pattern, content, flags=re.DOTALL)
if match:
    # insert after the match
    block = match.group(1)
    new_block = block + "\n                    ],\n                  ),\n                ),"
    content = content.replace(block, new_block, 1)

with open('lib/src/catalog_home_screen.dart', 'w') as f:
    f.write(content)
