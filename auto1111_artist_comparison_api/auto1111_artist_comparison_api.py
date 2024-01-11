import webuiapi
import asyncio
import re
import os
import json
import time
import json
import requests
import io
import base64
from PIL import Image

async def main():   
    # Where images should be saved
    save_folder = os.path.join(os.getcwd(), 'nsfw_anthro_nude_crouching_presenting_post_count_jpg')

    # Create the directory if it doesn't exist
    os.makedirs(save_folder, exist_ok=True)

    # Skip all artists up to and including the one set here, for resume
    last_artist = ''

    # auto1111 hostname and port
    url = "http://localhost:7860"
    
    artists = []
    # Open and load the JSON file
    with open("e621_artists.json", 'r') as file:
        artists = json.load(file)

    # Loop through each artist and generate an image
    for artist in artists:
        artist_name = artist["name"].strip()  # Remove any leading/trailing whitespace     
        post_count = artist["post_count"]
        
        if artist_name and last_artist == '':  # Check if the artist_name is not empty
            image = await generate_image(artist_name, post_count, url)
            # Create a valid file name from the artist_name
            filename = f"{str(post_count).zfill(5)}_{sanitize_filename(artist_name)}.jpg"
            
            # Convert RGBA to RGB if necessary
            if image.mode == 'RGBA':
                image = image.convert('RGB')   
            
            # Save the image
            image.save(os.path.join(save_folder, filename), 'JPEG', quality=90)
            print(f"Image saved as: {filename}")
        else:
            print(f"Skipping: {artist_name}")
            
        # Disable skipping once we find the last artist
        if artist_name == last_artist:
            last_artist = ''

    print("All images have been generated.")


# Function to generate an image based on a given artist
async def generate_image(artist_name, post_count, url):
    replaced_artist_name = artist_name.replace("(", "\\(").replace(")", "\\)")

    parameters = {
        "prompt": f"{replaced_artist_name}, red fox, female, outdoors, forest, crouching, red hair, long hair, nude, looking at viewer, seductive, smile, bedroom eyes, green eyes, spread pussy, nipples, tail, presenting pussy",
        "negative_prompt": "(child, toddler, baby, loli, cub:0.9)",
        "height": 896,
        "width": 640,
        "cfg_scale": 7.5,
        "seed": 2962006351,
        "sampler_name": "DPM++ SDE Karras",
        "tiling": False,
        "steps": 22,
        "n_iter": 1,
        "batch_size": 1,
        "restore_faces": False,
        "enable_hr": False,
        "hr_scale": 1.35,
        "hr_upscaler": "4x_foolhardy_Remacri",
        "alwayson_script": {
            "cfg rescale extension": {
                "args": [
                    0.7,
                    False,
                    1,
                    False
                ]
            }
        },
        "denoising_strength": 0.50,
        "hr_second_pass_steps": 14
    }
    
    max_attempts = 3
    attempt = 0
    
    # Retry loop, as can timeout and face other failures
    while attempt < max_attempts:
        try:
            response = requests.post(url=f'{url}/sdapi/v1/txt2img', json=parameters, timeout=60)
            response_json = response.json()
            return Image.open(io.BytesIO(base64.b64decode(response_json['images'][0])))
        except Exception as e:
            print(f"An error occurred: {e}")
            attempt += 1
            if attempt < max_attempts:
                print(f"Retrying... (Attempt {attempt} of {max_attempts})")
                time.sleep(1)  # Wait for 1 second before retrying
            else:
                print("Maximum attempts reached. Giving up.")
    
# Sanitize artist to create a valid file name
def sanitize_filename(artist_name):
    # Remove invalid file name characters
    sanitized = re.sub(r'[<>:"/\\|?*]', '', artist_name)
    # Truncate to a reasonable file name length
    max_length = 100
    if len(sanitized) > max_length:
        sanitized = sanitized[:max_length]
    return sanitized
    
def read_names_from_json(file_path):
    try:
        # Open and load the JSON file
        with open(file_path, 'r') as file:
            data = json.load(file)

        # Extract the "name" field from each element in the array
        names = [item["name"] for item in data]

        return names
    except Exception as e:
        return str(e)

if __name__ == "__main__":
    asyncio.run(main())
