import os
import re

directory = 'lib/src/screens'

fab_code = """
  Widget _buildFab() {
    return appFab(
      context: context,
      icon: Icons.tune,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black26,
          builder: (context) => PlaygroundControls(
            state: _state,
            onChanged: (s) {
              setState(() => _state = s);
            },
          ),
        );
      },
    );
  }
"""

for filename in os.listdir(directory):
    if not filename.endswith('.dart'):
        continue
    path = os.path.join(directory, filename)
    with open(path) as file:
        lines = file.readlines()
        
    # We will do a line-by-line processing to remove the Positioned block safely.
    new_lines = []
    in_positioned = False
    open_brackets = 0
    
    for i, line in enumerate(lines):
        if 'Positioned(' in line and 'PlaygroundControls' in ''.join(lines[i:i+6]):
            in_positioned = True
            open_brackets += line.count('(') - line.count(')')
            continue
        
        if in_positioned:
            open_brackets += line.count('(') - line.count(')')
            # If we hit an extra comma after the close parenthesis of Positioned
            if open_brackets <= 0:
                if '),' in line.replace(' ', ''):
                    in_positioned = False
                elif open_brackets < 0:
                    in_positioned = False
            continue
            
        new_lines.append(line)
        
    content = ''.join(new_lines)
    
    # Now find where to put the _buildFab()
    # It should go right before the last '}' of the class.
    last_brace = content.rfind('}')
    if last_brace != -1:
        content = content[:last_brace] + fab_code + content[last_brace:]
        
    # Add FAB to BaseWidget or Nav bar
    if 'FrostedNavigationButtomBar(' in content:
        content = re.sub(r'(bottomNavigationBar:\s*FrostedNavigationButtomBar\()', r'\1\n        action: _buildFab(),', content)
    else:
        content = re.sub(r'(return BaseWidget\()', r'\1\n      floatingActionButton: _buildFab(),', content)
        
    with open(path, 'w') as file:
        file.write(content)
