# chinese_json_adapter.py
#
# Copyright (c) 2018
# yuxiqian. All rights reserved.

import os
import json

palette_name = "chinese_colors"


current_path = os.path.dirname(os.path.abspath(__file__))

json_path = os.path.abspath(os.path.join(current_path, "../palette/%s.json" % (palette_name)))


f = open(palette_name + ".json", mode = "r")

j = json.load(f)

palette = {
    'color': []
}
for color in j:
    palette['color'].append(
        {
            'name': color['name'],
            'alias_name': color['alias'],
            'r': color['RGB'][0],
            'g': color['RGB'][1],
            'b': color['RGB'][2],
            'c': color['CMYK'][0],
            'm': color['CMYK'][1],
            'y': color['CMYK'][2],
            'k': color['CMYK'][3],
        }
    )

with open(json_path, 'w', encoding = 'utf-8') as json_file:
    json.dump(palette, json_file, ensure_ascii = False)
json_file.close()
