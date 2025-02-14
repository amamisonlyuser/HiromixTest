from PIL import Image
import os

# Define file paths
input_path = r"C:\Users\digbi\Downloads\paji.jpg"  # Original image
output_path = r"C:\Users\digbi\Downloads\hyey.jpg"  # Resized image

def resize_and_compress(input_path, output_path, max_width=700, max_height=900, target_size_kb=700):
    # Open the image
    image = Image.open(input_path)

    # Get original dimensions
    width, height = image.size

    # Maintain aspect ratio while resizing
    aspect_ratio = width / height
    if width > max_width or height > max_height:
        if width / max_width > height / max_height:
            new_width = max_width
            new_height = int(max_width / aspect_ratio)
        else:
            new_height = max_height
            new_width = int(max_height * aspect_ratio)
    else:
        new_width, new_height = width, height  # Keep original size if already within limits

    # Resize image with high-quality resampling
    resized_image = image.resize((new_width, new_height), Image.LANCZOS)

    # Try different quality levels to get close to 700 KB
    quality = 95  # Start with high quality
    resized_image.save(output_path, quality=quality)
    
    while os.path.getsize(output_path) > target_size_kb * 1024 and quality > 10:
        quality -= 5
        resized_image.save(output_path, quality=quality)

    print(f"Image resized to {new_width}x{new_height}, saved as {output_path} (~{os.path.getsize(output_path) / 1024:.2f} KB)")

# Run the function
resize_and_compress(input_path, output_path)
