import PIL
from PIL import Image
import numpy as np

def image_to_hex_colors(img):
    """Convert entire image to hex colors in a single list"""
    width, height = img.size
    colors = []
    
    # Convert image to RGB mode
    img = img.convert('RGB')
    
    # Process all pixels in a single list
    for y in range(height):
        for x in range(width):
            pixel = img.getpixel((x, y))
            # Convert RGB to 12-bit color (4 bits per channel)
            r = (pixel[0] >> 4) & 0xF
            g = (pixel[1] >> 4) & 0xF
            b = (pixel[2] >> 4) & 0xF
            color = (r << 8) | (g << 4) | b
            colors.append(f"{color:03X}")
    return colors

def create_coe_file(image_path, output_file="text.coe"):
    """Create a COE file from the entire image"""
    img = Image.open(image_path)
    print(f"Original image dimensions: {img.size}")
    
    # Get all colors as a single list
    colors = image_to_hex_colors(img)
    
    # Write to COE file
    with open(output_file, "w") as f:
        f.write("memory_initialization_radix=16;\n")
        f.write("memory_initialization_vector=\n")
        
        # Format in rows of 32 values for readability
        rows = []
        for i in range(0, len(colors), img.size[0]):
            row = colors[i:i+img.size[0]]
            rows.append(",".join(row))
        
        # Join rows with comma and newline
        f.write(",\n".join(rows))
        f.write(";")
    
    print(f"Created COE file with {len(colors)} total pixels")

# Use the function
create_coe_file("text.png")

