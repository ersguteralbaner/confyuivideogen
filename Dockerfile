# Use the provided image with PyTorch and CUDA support
FROM mybigpai-public-registry.cn-beijing.cr.aliyuncs.com/easycv/torch_cuda:cogvideox_fun

# Set working directory to /app
WORKDIR /app

# Install system dependencies (git, wget, etc.)
RUN apt-get update && apt-get install -y \
    git \
    wget \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies (including onnxruntime)
RUN pip install --no-cache-dir \
    onnxruntime \
    numpy \
    torch \
    torchvision \
    torchaudio \
    transformers \
    xformers

# Clone ComfyUI repo (assuming it's already available)
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI

# Change to custom_nodes directory
WORKDIR /app/ComfyUI/custom_nodes/

# Clone VideoX-Fun repo
RUN git clone https://github.com/aigc-apps/VideoX-Fun.git

# Clone ComfyUI-VideoHelperSuite repo
RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

# Download the CogVideoX-Fun model file and ensure the directory exists
RUN mkdir -p /app/ComfyUI/models/Fun_Models && \
    wget https://pai-aigc-photog.oss-cn-hangzhou.aliyuncs.com/cogvideox_fun/Diffusion_Transformer/CogVideoX-Fun-V1.1-2b-InP.tar.gz -O /app/ComfyUI/models/Fun_Models/CogVideoX-Fun-V1.1-2b-InP.tar.gz

# Extract the downloaded model
RUN tar -xvf /app/ComfyUI/models/Fun_Models/CogVideoX-Fun-V1.1-2b-InP.tar.gz -C /app/ComfyUI/models/Fun_Models/

# Install VideoX-Fun requirements
WORKDIR /app/ComfyUI/custom_nodes/VideoX-Fun/
RUN python install.py

# Install ComfyUI requirements to ensure frontend package is installed
WORKDIR /app/ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

# Set entrypoint to launch ComfyUI with main.py
ENTRYPOINT ["python", "main.py"]
