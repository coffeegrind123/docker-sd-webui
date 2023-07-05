To run docker containers with wsl2 on windows 11, update WSL (wsl.exe --update) and set WSL2 as the default version (wsl --set-default-version 2
). Then install docker desktop. To build and run the image: docker build -t docker-sd-webui:latest .; docker run -it -p 7860:7860 --name "docker-sd-webui" --rm --gpus all docker-sd-webui:latest
