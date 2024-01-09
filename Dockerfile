# to build and run: docker build -t docker-sd-webui:latest .; docker run -it -p 7860:7860 --name "docker-sd-webui" --rm --gpus all docker-sd-webui:latest
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /content

ENV TF_CPP_MIN_LOG_LEVEL 1

RUN apt update

RUN apt install -y libgl1 libcairo2-dev pkg-config python3-dev python3-pip git git-lfs python-is-python3 && rm -rf /var/lib/apt/lists/*
# libglib2.0-0 wget

#RUN pip3 install --upgrade pip
RUN pip install -q torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.2+cu118 torchtext==0.15.2 torchdata==0.6.1 --extra-index-url https://download.pytorch.org/whl/cu118 -U
RUN pip install -q xformers==0.0.20 triton==2.0.0 gradio_client==0.8.0 -U
RUN pip install fastapi==0.90.0 -U

RUN git clone -b v2.7 https://github.com/camenduru/stable-diffusion-webui
RUN git clone https://huggingface.co/embed/negative /content/stable-diffusion-webui/embeddings/negative
RUN git clone https://huggingface.co/embed/lora /content/stable-diffusion-webui/models/Lora/positive
ADD --chown=user https://huggingface.co/embed/upscale/resolve/main/4x-UltraSharp.pth /content/stable-diffusion-webui/models/ESRGAN/4x-UltraSharp.pth
ADD --chown=user https://raw.githubusercontent.com/camenduru/stable-diffusion-webui-scripts/main/run_n_times.py /content/stable-diffusion-webui/scripts/run_n_times.py
RUN git clone https://github.com/deforum-art/deforum-for-automatic1111-webui /content/stable-diffusion-webui/extensions/deforum-for-automatic1111-webui
RUN git clone https://github.com/camenduru/stable-diffusion-webui-images-browser /content/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
RUN git clone https://github.com/camenduru/stable-diffusion-webui-huggingface /content/stable-diffusion-webui/extensions/stable-diffusion-webui-huggingface
RUN git clone https://github.com/camenduru/sd-civitai-browser /content/stable-diffusion-webui/extensions/sd-civitai-browser
RUN git clone https://github.com/kohya-ss/sd-webui-additional-networks /content/stable-diffusion-webui/extensions/sd-webui-additional-networks
RUN git clone https://github.com/Mikubill/sd-webui-controlnet /content/stable-diffusion-webui/extensions/sd-webui-controlnet
RUN git clone https://github.com/fkunn1326/openpose-editor /content/stable-diffusion-webui/extensions/openpose-editor
RUN git clone https://github.com/jexom/sd-webui-depth-lib /content/stable-diffusion-webui/extensions/sd-webui-depth-lib
RUN git clone https://github.com/hnmr293/posex /content/stable-diffusion-webui/extensions/posex
RUN git clone https://github.com/nonnonstop/sd-webui-3d-open-pose-editor /content/stable-diffusion-webui/extensions/sd-webui-3d-open-pose-editor
RUN git clone https://github.com/camenduru/sd-webui-tunnels /content/stable-diffusion-webui/extensions/sd-webui-tunnels
RUN git clone https://github.com/etherealxx/batchlinks-webui /content/stable-diffusion-webui/extensions/batchlinks-webui
RUN git clone https://github.com/camenduru/stable-diffusion-webui-catppuccin /content/stable-diffusion-webui/extensions/stable-diffusion-webui-catppuccin
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg /content/stable-diffusion-webui/extensions/stable-diffusion-webui-rembg
RUN git clone https://github.com/ashen-sensored/stable-diffusion-webui-two-shot /content/stable-diffusion-webui/extensions/stable-diffusion-webui-two-shot
RUN git clone https://github.com/thomasasfk/sd-webui-aspect-ratio-helper /content/stable-diffusion-webui/extensions/sd-webui-aspect-ratio-helper
RUN git clone https://github.com/tjm35/asymmetric-tiling-sd-webui /content/stable-diffusion-webui/extensions/asymmetric-tiling-sd-webui
RUN git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete /content/stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete
RUN git clone https://github.com/mix1009/model-keyword /content/stable-diffusion-webui/extensions/model-keyword
RUN git clone https://github.com/adieyal/sd-dynamic-prompts /content/stable-diffusion-webui/extensions/sd-dynamic-prompts
RUN cd /content/stable-diffusion-webui && git reset --hard
#!git -C /content/stable-diffusion-webui/repositories/stable-diffusion-stability-ai reset --hard

ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11e_sd15_ip2p_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11e_sd15_shuffle_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_canny_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11f1p_sd15_depth_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_inpaint_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_lineart_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_mlsd_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_normalbae_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_openpose_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_scribble_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_seg_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_softedge_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15s2_lineart_anime_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11f1e_sd15_tile_fp16.safetensors
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11e_sd15_ip2p_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11e_sd15_shuffle_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_canny_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11f1p_sd15_depth_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_inpaint_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_lineart_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_mlsd_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_normalbae_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_openpose_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_scribble_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_seg_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15_softedge_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11p_sd15s2_lineart_anime_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/control_v11f1e_sd15_tile_fp16.yaml
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_style_sd14v1.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_sketch_sd14v1.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_seg_sd14v1.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_openpose_sd14v1.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_keypose_sd14v1.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_depth_sd14v1.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_color_sd14v1.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_canny_sd14v1.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_canny_sd15v2.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_depth_sd15v2.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_sketch_sd15v2.pth
ADD --chown=user https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth /content/stable-diffusion-webui/extensions/sd-webui-controlnet/models/t2iadapter_zoedepth_sd15v1.pth

#ADD --chown=user https://huggingface.co/ckpt/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.ckpt /content/stable-diffusion-webui/models/Stable-diffusion/sd-v1-4.vae.pt
ADD --chown=user https://huggingface.co/ckpt/sd14/resolve/main/sd-v1-4.ckpt /content/stable-diffusion-webui/models/Stable-diffusion/sd-v1-4.ckpt

#RUN sed -i -e '''/from modules import launch_utils/a\import os''' /content/stable-diffusion-webui/launch.py
#RUN sed -i -e '''/        prepare_environment()/a\        os.system\(f\"""sed -i -e ''\"s/dict()))/dict())).cuda()/g\"'' /content/stable-diffusion-webui/repositories/stable-diffusion-stability-ai/ldm/util.py""")''' /content/stable-diffusion-webui/launch.py
#RUN sed -i -e 's/\["sd_model_checkpoint"\]/\["sd_model_checkpoint","sd_vae","CLIP_stop_at_last_layers"\]/g' /content/stable-diffusion-webui/modules/shared.py
#RUN sed -i -e 's/typing.Optional\[dict\[str, str\]\]/typing.Optional\[typing.Dict\[str, str\]\]/g' /content/stable-diffusion-webui/extensions/sd-webui-3d-open-pose-editor/scripts/openpose_editor.py
#RUN sed -i -e '$ a httpx==0.24.1' /content/stable-diffusion-webui/requirements_versions.txt

RUN sed -i -e 's/\["sd_model_checkpoint"\]/\["sd_model_checkpoint","sd_vae","CLIP_stop_at_last_layers"\]/g' /content/stable-diffusion-webui/modules/shared_options.py

CMD cd stable-diffusion-webui && python launch.py --listen --xformers --enable-insecure-extension-access --theme dark --skip-torch-cuda-test

EXPOSE 7860
