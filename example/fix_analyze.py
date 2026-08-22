import os, re
# 1. buttons_catalog.dart - remove duplicate floatingActionButton
with open('lib/src/screens/buttons_catalog.dart') as f: c = f.read()
c = re.sub(r'floatingActionButton: appFab\(\n\s*context: context,\n\s*icon: Icons.add,[\s\S]*?\),', '', c, count=1)
with open('lib/src/screens/buttons_catalog.dart', 'w') as f: f.write(c)

# 2. dialogs_catalog.dart - move _buildFab to the end of _DialogsCatalogState, not DialogsCatalog
with open('lib/src/screens/dialogs_catalog.dart') as f: c = f.read()
# Ah wait, I need to move it. Let's just fix it by replacing manually.
