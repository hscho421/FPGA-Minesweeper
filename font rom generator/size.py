from PIL import Image

def resize_pixel_art(input_path, output_path, target_width=280):
    """
    Resize pixel art while maintaining sharpness and aspect ratio
    """
    # Open image
    img = Image.open(input_path)
    
    # Calculate new height maintaining aspect ratio
    aspect_ratio = img.height / img.width
    target_height = int(target_width * aspect_ratio)
    
    # Resize using nearest neighbor to maintain sharp pixels
    resized = img.resize((target_width, target_height), Image.NEAREST)
    
    # Save resized image
    resized.save(output_path)
    
    print(f"Resized image from {img.size} to {resized.size}")
    return resized.size

# Resize the image
resize_pixel_art("text.png", "text.png", target_width=280)