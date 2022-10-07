FROM intel/oneapi:2022.3.0-devel-ubuntu20.04

RUN mkdir -p /workspace

RUN pip3 install torchvision==0.11.1 numpy==1.23.3  torchmetrics==0.9.3 --no-deps

WORKDIR /workspace

RUN wget http://mlpc.intel.com/downloads/gpu-new/validation/IPEX/weekly/PVC/ww38_master/torch-1.10.0a0+git3702f05-cp39-cp39-linux_x86_64.whl
RUN wget http://mlpc.intel.com/downloads/gpu-new/validation/IPEX/weekly/PVC/ww38_master/intel_extension_for_pytorch-1.10.100+945faac5-cp39-cp39-linux_x86_64.whl
RUN wget http://mlpc.intel.com/downloads/gpu-new/validation/IPEX/weekly/PVC/ww38_master/intel_optimization_for_horovod-0.22.1up3-cp39-cp39-linux_x86_64.whl

RUN pip3 install --force-reinstall *.whl

ENV OverrideDefaultFP64Settings=1
ENV IGC_EnableDPEmulation=1

WORKDIR /workspace

RUN git clone https://github.com/adelchaibi/MoD

WORKDIR /workspace/MoD

