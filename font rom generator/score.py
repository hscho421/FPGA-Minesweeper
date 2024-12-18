import PIL
from PIL import Image
import numpy as np

def extract_sprite(img, x, y, width, height):
    """Extract a sprite from the sheet and convert to hex colors"""
    sprite = []
    for j in range(height):
        row = []
        for i in range(width):
            pixel = img.getpixel((x + i, y + j))
            # Convert RGB to 12-bit color (4 bits per channel)
            r = (pixel[0] >> 4) & 0xF
            g = (pixel[1] >> 4) & 0xF
            b = (pixel[2] >> 4) & 0xF
            color = (r << 8) | (g << 4) | b
            row.append(f"{color:03X}")
        sprite.extend(row)
    return sprite

def create_coe_file(sprites, filename="score.coe"):
    """Create a COE file from sprite data with better formatting"""
    with open(filename, "w") as f:
        f.write("memory_initialization_radix=16;\n")
        f.write("memory_initialization_vector=\n")
        
        # Join all colors with commas
        all_colors = []
        for sprite in sprites:
            all_colors.extend(sprite)
        
        # Format in rows of 16 values
        rows = []
        for i in range(0, len(all_colors), 13):
            row = all_colors[i:i+13]
            rows.append(",".join(row))
        
        # Join rows with comma and newline
        f.write(",\n".join(rows))
        f.write(";")

# Sprite positions in the Windows 3.1/NT4 set (you'll need to adjust these)
sprite_positions = [
    (140, 146, 13, 23),  # 0
    (14, 146, 13, 23),   # 1
    (28, 146, 13, 23),   # 2
    (42, 146, 13, 23),   # 3
    (56, 146, 13, 23),   # 4
    (70, 146, 13, 23),   # 5
    (84, 146, 13, 23),   # 6
    (98, 146, 13, 23),   # 7
    (112, 146, 13, 23),  # 8
    (126, 146, 13, 23),  # 9

]

# Load your sprite sheet
img = Image.open("sprites.png")

# Extract all sprites
sprites = [extract_sprite(img, x, y, w, h) for x, y, w, h in sprite_positions]

# Create the COE file
create_coe_file(sprites)