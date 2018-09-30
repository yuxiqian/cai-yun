def to_hex(int):
    h = hex(int)[2:]
    return ('0' * (2 - len(h))) + h

class Color:

    name = ""

    red_int = 0
    green_int = 0
    blue_int = 0

    def __init__(self, name, r, g, b):
        self.name = name
        self.red_int = r
        self.green_int = g
        self.blue_int = b

    def generate_hex(self):
        return "0x" + to_hex(self.red_int) + to_hex(self.green_int) + to_hex(self.blue_int)
