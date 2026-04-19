#!/bin/bash
echo "========================================"
echo "CUDA Image Processor - Batch Runner"
echo "========================================"
echo

if [ ! -d "data/input_images" ]; then
    echo "ERROR: data/input_images folder not found!"
    exit 1
fi

mkdir -p data/output_images

echo "Building project..."
echo

nvcc -gencode=arch=compute_75,code=sm_75 -o cuda_processor \
    src/main.cu src/kernels.cu src/cpu_reference.cpp \
    -I include -I /usr/local/include/opencv4 \
    -lopencv_core -lopencv_imgproc -lopencv_imgcodecs \
    -std=c++17

if [ $? -ne 0 ]; then
    echo
    echo "BUILD FAILED!"
    exit 1
fi

echo
echo "BUILD SUCCESSFUL!"
echo
echo "Running CUDA processor..."
echo

./cuda_processor

echo
echo "========================================"
echo "Done! Check data/output_images/ folder"
echo "========================================"
