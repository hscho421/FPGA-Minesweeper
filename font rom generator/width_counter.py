def count_coe_width(coe_file):
    with open(coe_file, 'r') as f:
        lines = f.readlines()
        
        # Skip header lines
        data_lines = [l for l in lines if l.strip() and not l.startswith('memory')]
        
        # Get first data line
        first_line = data_lines[0]
        
        # Count values in first line (values are separated by commas)
        width = len(first_line.strip().rstrip(',;').split(','))
        
        # Count total lines of data
        height = len(data_lines)
        
        print(f"Image dimensions: {width}x{height} pixels")
        print(f"Total pixels: {width * height}")
        print(f"ROM depth needed: {width * height}")
        return width, height

# Use it on your file
width, height = count_coe_width("title.coe")