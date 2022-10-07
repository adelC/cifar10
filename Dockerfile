FROM intel/oneapi:2022.3.0-devel-ubuntu20.04

RUN mkdir -p /workspace

COPY ./pkgs /tmp/pkgs

RUN pip3 install torchvision
RUN pip3 install --force-reinstall /tmp/pkgs/*.whl


WORKDIR /workspace

RUN git clone https://github.com/adelchaibi/MoD

WORKDIR /workspace/MoD

