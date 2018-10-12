from color import *
import subprocess
import yaml
import json
import os

palette_name = "github_colors"

current_path = os.path.dirname(os.path.abspath(__file__))
xml_path = os.path.abspath(os.path.join(current_path, "./%s.xml" % (palette_name)))
json_path = os.path.abspath(os.path.join(current_path, "../palette/%s.json" % (palette_name)))


replace_names = {
    'C++': 'cpp',
    'C#': 'C Sharp'
}

subprocess.call(['wget', 'https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml', '-q'])

with open('languages.yml') as f:
    colors = yaml.load(f)
os.remove('languages.yml')

color_list = {
    'color': []
}

for name, color in colors.items():
    if not 'color' in color:
        continue
    replace_names.get(name, name)
    col = Color(name, '', hex_str=color['color'][1:])
    color_list['color'].append({
        'name': name,
        'alias_name': '',
        'r': col.red_int,
        'g': col.green_int,
        'b': col.blue_int,
        'c': magic_invalid_number,
        'm': magic_invalid_number,
        'y': magic_invalid_number,
        'k': magic_invalid_number,
    })
# colors = dict((replace_names.get(name, name), color['color']) for name, color in colors.items() if 'color' in color)

with open(json_path, 'w') as f:
    json.dump(color_list, f, indent=4)
