import json
import random
import pyperclip

# ANSI escape sequence for changing the text color to #fbd67f
color_start = '\033[38;2;251;214;127m'
color_end = '\033[0m'

# Load the JSON data from the file
with open('e621_artists.json') as file:
    data = json.load(file)

# Filter artists with post counts outside the range (99-500)
filtered_artists = [artist for artist in data if artist['post_count'] < 99 or artist['post_count'] > 500]

# Randomly select up to three artist names
selected_artists = random.sample(filtered_artists, min(3, len(filtered_artists)))

# Shuffle the selected artists
random.shuffle(selected_artists)

# Find the minimum and maximum post counts
min_count = min(artist['post_count'] for artist in selected_artists)
max_count = max(artist['post_count'] for artist in selected_artists)

# Calculate the color scale based on the post count range
color_scale = lambda count: int((count - min_count) / (max_count - min_count) * 255)

# Create a list of artist names with the color escape sequence and post count
colored_artist_names = []
for artist in selected_artists:
    count = artist['post_count']
    color = f'\033[38;2;255;{color_scale(count)};0m'
    colored_artist_names.append(f'{color}{artist["name"]} ({count}){color_end}')

# Create a list of artist names without the color escape sequence
plain_artist_names = [f'{artist["name"]} ({artist["post_count"]})' for artist in selected_artists]

# Format the output with colored artist names
colored_output = 'by ' + ', by '.join(colored_artist_names)

# Format the output with plain artist names (without color)
plain_output = 'by ' + ', by '.join(plain_artist_names)

# Copy the plain text output to the clipboard
pyperclip.copy(plain_output + ', ')

# Print the output with colored artist names
print(colored_output)
