# chinese_colors.py
#
# Copyright (c) 2018 yuxiqian. all rights reserved.


import json
import os
from color import *
from lxml import etree

# target_url = "http://zhongguose.com/"

palette_name = "chinese_colors"

current_path = os.path.dirname(os.path.abspath(__file__))
xml_path = os.path.abspath(os.path.join(current_path, "./%s.xml" % (palette_name)))
json_path = os.path.abspath(os.path.join(current_path, "../palette/%s.json" % (palette_name)))


color_html = etree.parse(xml_path)
palette_html = color_html.xpath('//*[@id="colors"]/*')
color_list = {
    'color': []
}
for i in palette_html:
    color = etree.HTML(etree.tostring(i))
    name = (color.xpath('//span[1]')[0].text)
    hex_str = (color.xpath('//span[3]')[0].text)
    r, g, b = to_int(hex_str)
    color_list['color'].append(
        {
            'name': name,
            'r': r,
            'g': g,
            'b': b,
        }
    )

with open(json_path, 'w', encoding = 'utf-8') as json_file:
    json.dump(color_list, json_file, ensure_ascii = False)
json_file.close()
