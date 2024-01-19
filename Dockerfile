# to build and run: docker build --no-cache -t docker-sd-webui:latest .; docker run -it -p 7860:7860 --name "docker-sd-webui" --rm --gpus all docker-sd-webui:latest
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /content

ENV TF_CPP_MIN_LOG_LEVEL 1

ARG LISTEN_PORT="7860"
ENV LISTEN_PORT=${LISTEN_PORT:-$LISTEN_PORT}

RUN apt update && \
    apt install -y libgl1 libcairo2-dev pkg-config python3-dev python3-pip git aria2 wget unzip python-is-python3 && \
    rm -rf /var/lib/apt/lists/*

#RUN pip3 install --upgrade pip
RUN pip install -q torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.2+cu118 torchtext==0.15.2 torchdata==0.6.1 --extra-index-url https://download.pytorch.org/whl/cu118 -U && \
    pip install -q xformers==0.0.20 triton==2.0.0 gradio_client==0.8.0 -U && \
    pip install fastapi==0.90.0 -U

RUN git clone --depth 1 -b v2.7 https://github.com/camenduru/stable-diffusion-webui && \
#   git clone --depth 1 https://huggingface.co/embed/negative /content/stable-diffusion-webui/embeddings/negative && \
#   git clone --depth 1 https://huggingface.co/embed/lora /content/stable-diffusion-webui/models/Lora/positive && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/embed/upscale/resolve/main/4x-UltraSharp.pth -d /content/stable-diffusion-webui/models/ESRGAN -o 4x-UltraSharp.pth && \
    wget https://raw.githubusercontent.com/camenduru/stable-diffusion-webui-scripts/main/run_n_times.py -O /content/stable-diffusion-webui/scripts/run_n_times.py && \
    git clone --depth 1 https://github.com/deforum-art/deforum-for-automatic1111-webui /content/stable-diffusion-webui/extensions/deforum-for-automatic1111-webui && \
    git clone --depth 1 https://github.com/camenduru/stable-diffusion-webui-images-browser /content/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser && \
#   git clone --depth 1 https://github.com/camenduru/stable-diffusion-webui-huggingface /content/stable-diffusion-webui/extensions/stable-diffusion-webui-huggingface && \
#   git clone --depth 1 https://github.com/camenduru/sd-civitai-browser /content/stable-diffusion-webui/extensions/sd-civitai-browser && \
    git clone --depth 1 https://github.com/kohya-ss/sd-webui-additional-networks /content/stable-diffusion-webui/extensions/sd-webui-additional-networks && \
    git clone --depth 1 https://github.com/Mikubill/sd-webui-controlnet /content/stable-diffusion-webui/extensions/sd-webui-controlnet && \
    git clone --depth 1 https://github.com/fkunn1326/openpose-editor /content/stable-diffusion-webui/extensions/openpose-editor && \
    git clone --depth 1 https://github.com/jexom/sd-webui-depth-lib /content/stable-diffusion-webui/extensions/sd-webui-depth-lib && \
    git clone --depth 1 https://github.com/hnmr293/posex /content/stable-diffusion-webui/extensions/posex && \
    git clone --depth 1 https://github.com/nonnonstop/sd-webui-3d-open-pose-editor /content/stable-diffusion-webui/extensions/sd-webui-3d-open-pose-editor && \
    git clone --depth 1 https://github.com/camenduru/sd-webui-tunnels /content/stable-diffusion-webui/extensions/sd-webui-tunnels && \
#   git clone --depth 1 https://github.com/etherealxx/batchlinks-webui /content/stable-diffusion-webui/extensions/batchlinks-webui && \
    git clone --depth 1 https://github.com/camenduru/stable-diffusion-webui-catppuccin /content/stable-diffusion-webui/extensions/stable-diffusion-webui-catppuccin && \
    git clone --depth 1 https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg /content/stable-diffusion-webui/extensions/stable-diffusion-webui-rembg && \
#   git clone --depth 1 https://github.com/ashen-sensored/stable-diffusion-webui-two-shot /content/stable-diffusion-webui/extensions/stable-diffusion-webui-two-shot && \
    git clone --depth 1 https://github.com/thomasasfk/sd-webui-aspect-ratio-helper /content/stable-diffusion-webui/extensions/sd-webui-aspect-ratio-helper && \
#   git clone --depth 1 https://github.com/tjm35/asymmetric-tiling-sd-webui /content/stable-diffusion-webui/extensions/asymmetric-tiling-sd-webui && \
    git clone --depth 1 https://github.com/DominikDoom/a1111-sd-webui-tagcomplete /content/stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete && \
#   git clone --depth 1 https://github.com/mix1009/model-keyword /content/stable-diffusion-webui/extensions/model-keyword && \
    git clone --depth 1 https://github.com/adieyal/sd-dynamic-prompts /content/stable-diffusion-webui/extensions/sd-dynamic-prompts && \
    git clone --depth 1 https://github.com/Seshelle/CFG_Rescale_webui /content/stable-diffusion-webui/extensions/CFG_Rescale_webui && \
    git clone --depth 1 https://github.com/hako-mikan/sd-webui-negpip /content/stable-diffusion-webui/extensions/sd-webui-negpip && \
    git clone --depth 1 https://github.com/hako-mikan/sd-webui-regional-prompter /content/stable-diffusion-webui/extensions/sd-webui-regional-prompter && \
    git clone --depth 1 https://github.com/kousw/stable-diffusion-webui-daam && \
    #git merge capricorncd/stable-diffusion-webui/master -m "Apply prompt commenting patch" && \
    cd /content/stable-diffusion-webui && git reset --hard

RUN echo "\
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11e_sd15_ip2p_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11e_sd15_shuffle_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_canny_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11f1p_sd15_depth_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_inpaint_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_lineart_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_mlsd_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_normalbae_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_openpose_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_scribble_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_seg_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_softedge_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15s2_lineart_anime_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11f1e_sd15_tile_fp16.safetensors \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11e_sd15_ip2p_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11e_sd15_shuffle_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_canny_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11f1p_sd15_depth_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_inpaint_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_lineart_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_mlsd_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_normalbae_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_openpose_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_scribble_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_seg_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15_softedge_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11p_sd15s2_lineart_anime_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=control_v11f1e_sd15_tile_fp16.yaml \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_style_sd14v1.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_sketch_sd14v1.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_seg_sd14v1.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_openpose_sd14v1.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_keypose_sd14v1.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_depth_sd14v1.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_color_sd14v1.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_canny_sd14v1.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_canny_sd15v2.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_depth_sd15v2.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_sketch_sd15v2.pth \
    \nhttps://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth \n dir=/content/stable-diffusion-webui/extensions/sd-webui-controlnet/models \n out=t2iadapter_zoedepth_sd15v1.pth \
    \n" | aria2c --console-log-level=error --continue --max-connection-per-server 16 --split 16 --min-split-size 10M --input-file -

RUN aria2c --header 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.3' --console-log-level=error -c -s 16 -k 1M https://www.swisstransfer.com/api/download/1aa5051d-b437-4688-b76d-2d03375fe171 -d /tmp -o dl.zip && \
    unzip /tmp/dl.zip -d /tmp && \
    tar -xzvf /tmp/fluffusion_r3_e10_704x_vpred.tar.gz -C /content/stable-diffusion-webui/models/Stable-diffusion && \
    rm /tmp/dl.zip && \
    rm /tmp/fluffusion_r3_e10_704x_vpred.tar.gz

RUN wget https://raw.githubusercontent.com/coffeegrind123/docker-sd-webui/fluffusion/fluffusion_r3_eX_704x_vpred.yaml -O /content/stable-diffusion-webui/models/Stable-diffusion/fluffusion_r3_e10_704x_vpred.yaml
RUN wget https://raw.githubusercontent.com/coffeegrind123/docker-sd-webui/fluffusion/fluffusion_r3_tags.csv -O /content/stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete/tags/fluffusion_r3_tags.csv
RUN wget https://raw.githubusercontent.com/coffeegrind123/docker-sd-webui/fluffusion/config.json -O /content/stable-diffusion-webui/config.json
RUN wget https://raw.githubusercontent.com/coffeegrind123/docker-sd-webui/fluffusion/ui-config.json -O /content/stable-diffusion-webui/ui-config.json

RUN sed -i -e 's/\["sd_model_checkpoint"\]/\["sd_model_checkpoint","sd_vae","CLIP_stop_at_last_layers"\]/g' /content/stable-diffusion-webui/modules/shared_options.py

EXPOSE 7860

CMD cd stable-diffusion-webui && python launch.py --listen --port $LISTEN_PORT --xformers --enable-insecure-extension-access --theme dark --skip-torch-cuda-test --api
