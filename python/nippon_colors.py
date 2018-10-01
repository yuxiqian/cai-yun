# nippon_colors.py
#
# Copyright (c) 2018 yuxiqian. all rights reserved.

import re
import json
import requests
import urllib
import os
from color import *
from lxml import etree

target_url = "http://nipponcolors.com/"

palette_name = "nippon_colors"

current_path = os.path.dirname(os.path.abspath(__file__))
xml_path = os.path.abspath(os.path.join(current_path, "./%s.xml" % (palette_name)))
json_path = os.path.abspath(os.path.join(current_path, "../palette/%s.json" % (palette_name)))

session = requests.session()

headers = {
    'Connection': 'keep-alive',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.81 Safari/537.36'
}

session.headers.update(headers)

init_page = session.get(target_url).content

init_html = etree.HTML(init_page)

color_names = init_html.xpath('//*[@id="colors"]/*')

color_count = len(color_names)

color_array = []

color_list = {
    'color': []
}

input("即将读取 %d 枚色彩数据。按任意键继续。" % color_count)

while len(color_array) < color_count:
    detail_data = session.get(target_url).content
    detail_str = str(detail_data, 'utf-8')
    detail_html = etree.HTML(detail_str)
    kanji_name = detail_html.xpath('//*[@id="colorTitle"]')[0].text
    romaji_name = detail_html.xpath('//*[@id="colorRuby"]')[0].text.lower()
    hex_color = detail_html.xpath('//*[@id="RGBvalue"]/input/@value')[0]
    cyan_value = int(detail_html.xpath('//*[@id="CMYKcolor"]/dd[1]/span[1]')[0].text)
    magenta_value = int(detail_html.xpath('//*[@id="CMYKcolor"]/dd[2]/span[1]')[0].text)
    yellow_value = int(detail_html.xpath('//*[@id="CMYKcolor"]/dd[3]/span[1]')[0].text)
    black_value = int(detail_html.xpath('//*[@id="CMYKcolor"]/dd[4]/span[1]')[0].text)
    print("c, m, y, k = %d, %d, %d, %d" % (cyan_value, magenta_value, yellow_value, black_value))
    # input("gotta %d" % cyan_value)
    print(kanji_name)
    print(romaji_name)
    print(hex_color)
    print()
    # input()

    col = Color(name = kanji_name, alias_name = romaji_name, hex_str = hex_color[1:])
    col.setCMYK(cyan_value, magenta_value, yellow_value, black_value)

    if col in color_array:
        continue
    color_array.append(col)

print('done.')
for col in color_array:
    color_list['color'].append(
        {
            'name': col.name,
            'alias_name': col.alias_name,
            'r': col.red_int,
            'g': col.green_int,
            'b': col.blue_int,
            'c': col.cyan_int,
            'm': col.magenta_int,
            'y': col.yellow_int,
            'k': col.black_int,
        }
    )



with open(json_path, 'w', encoding = 'utf-8') as json_file:
    json.dump(color_list, json_file, ensure_ascii = False)
json_file.close()
