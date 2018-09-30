def to_hex(integer):
    h = hex(integer)[2:]
    return ('0' * (2 - len(h))) + h

def to_int(hex_str):
    return int(hex_str[0:2], 16), int(hex_str[2:4], 16), int(hex_str[4:6], 16)

class Color:

    name = ""

    red_int = 0
    green_int = 0
    blue_int = 0

    def __init__(self, name, hex_str):
        self.name = name
        self.red_int = int(hex_str[0:2], 16)
        self.green_int = int(hex_str[2:4], 16)
        self.blue_int = int(hex_str[4:6], 16)

    def __init__(self, name, r, g, b):
        self.name = name
        self.red_int = r
        self.green_int = g
        self.blue_int = b

    def generate_hex(self):
        return "0x" + to_hex(self.red_int) + to_hex(self.green_int) + to_hex(self.blue_int)
