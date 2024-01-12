import os
import html

# Add placeholder image URL
placeholder_image = "https://via.placeholder.com/640x896.png?text=Loading"

def generate_gallery():
    # Get the directory
    folder_path = os.path.join(os.getcwd(), 'images')

    # Get a list of all image files in the folder
    image_files = [f for f in os.listdir(folder_path) if os.path.isfile(os.path.join(folder_path, f)) and f.lower().endswith(('.png', '.jpg', '.jpeg', '.gif'))]

    # Generate the HTML code for the gallery
    html_code = '''
    <!DOCTYPE html>
    <html>
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
        <style>
            body {{
                background-color: #f2f2f2;
                margin: 0;
                padding: 20px;
                font-family: 'Roboto', sans-serif;
            }}
            .gallery {{
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
            }}
            .gallery-item {{
                position: relative;
                margin: 10px;
                flex: 1 0 300px;
                max-width: 300px;
                border-radius: 10px;
                overflow: hidden;
                aspect-ratio: 640/896; /* Set the aspect ratio to 640:896 */
            }}
            .gallery-item img {{
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 10px;
                cursor: pointer; /* Add cursor pointer to indicate clickable */
            }}
            .gallery-item .overlay {{
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                background-color: rgba(0, 0, 0, 0.7);
                color: #fff;
                padding: 5px;
                font-size: 14px;
                text-align: center;
            }}
            .gallery-item .overlay a {{
                color: #fff;
                text-decoration: none;
            }}
            .image-viewer {{
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: rgba(0, 0, 0, 0.9);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 999;
                opacity: 0;
                pointer-events: none;
                transition: opacity 0.3s ease;
            }}
            .image-viewer.active {{
                opacity: 1;
                pointer-events: auto;
            }}
            .image-viewer img {{
                max-width: 90%;
                max-height: 90%;
            }}
        </style>
        <script>
            document.addEventListener("DOMContentLoaded", function() {{
                var lazyImages = [].slice.call(document.querySelectorAll("img.lazy"));
                var loadedImages = [];

                function unloadImage(image) {{
                    image.src = "{0}";
                    image.classList.add("lazy");
                    loadedImages.splice(loadedImages.indexOf(image), 1);
                }}
                
                function loadImage(image) {{
                    image.src = image.dataset.src;
                    image.classList.remove("lazy");
                    loadedImages.push(image);
                }}

                function loadVisibleImages() {{
                    lazyImages.forEach(function(lazyImage) {{
                        var lazyImageRect = lazyImage.getBoundingClientRect();
                        if (lazyImageRect.top < window.innerHeight && lazyImageRect.bottom >= 0 && loadedImages.indexOf(lazyImage) === -1) {{
                            loadImage(lazyImage);
                        }} else if ((lazyImageRect.top >= window.innerHeight || lazyImageRect.bottom <= 0) && loadedImages.indexOf(lazyImage) !== -1) {{
                            unloadImage(lazyImage);
                        }}
                    }});
                }}

                loadVisibleImages();

                window.addEventListener("scroll", function() {{
                    loadVisibleImages();
                }});
                
                // Image viewer functionality
                var imageViewer = document.querySelector(".image-viewer");
                var imageViewerImg = document.querySelector(".image-viewer img");

                function openImageViewer(imageUrl) {{
                    imageViewerImg.src = imageUrl;
                    imageViewer.classList.add("active");
                    document.body.style.overflow = "hidden"; // Disable scrolling
                }}

                function closeImageViewer() {{
                    imageViewer.classList.remove("active");
                    document.body.style.overflow = ""; // Enable scrolling
                }}

                document.addEventListener("click", function(event) {{
                    if (event.target.tagName === "IMG" && event.target.classList.contains("gallery-image")) {{
                        openImageViewer(event.target.dataset.src);
                    }} else if (event.target === imageViewer) {{
                        closeImageViewer();
                    }}
                }});
            }});
        </script>
    </head>
    <body>
        <div class="gallery">
    '''.format(placeholder_image)

    for image_file in image_files:
        # Get the filename without extension
        filename = os.path.splitext(image_file)[0]

        # Extract the part of the filename after the first numbers and underscore
        tag = filename.split('_', 1)[1]

        # Generate HTML code for each image
        html_code += '''
            <div class="gallery-item">
                <img class="lazy gallery-image" data-src="{}" src="{}" alt="{}">
                <div class="overlay"><a href="https://e621.net/posts?tags={}">{}</a></div>
            </div>
        '''.format("images/" + image_file, placeholder_image, filename, tag, filename)

    html_code += '''
        </div>

        <!-- Image viewer -->
        <div class="image-viewer">
            <img src="" alt="Image">
        </div>
    </body>
    </html>
    '''

    # Write the HTML code to a file
    with open('gallery.html', 'w') as file:
        file.write(html_code)

generate_gallery()
