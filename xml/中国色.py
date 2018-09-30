import json
import os
from color import *
from lxml import etree

# target_url = "http://zhongguose.com/"

palette_name = "中国色"

current_path = os.path.dirname(os.path.abspath(__file__))
xml_path = os.path.abspath(os.path.join(current_path, "./%s.xml" % (palette_name)))
json_path = os.path.abspath(os.path.join(current_path, "../palette/%s.json" % (palette_name)))


color_html = etree.parse(xml_path)
palette_html = color_html.xpath('//*[@id="colors"]/li')
for i in palette_html:
    name = i.xpath('//span[1]')[0].text
    hex_str = i.xpath('//span[3]')[0].text
    print(name)
    print(hex_str)
