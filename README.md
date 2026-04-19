# CUDA Image Processing - Batch Grayscale Converter

## Project Description

This project implements a high-performance batch image processing system using CUDA (Compute Unified Device Architecture) for parallel grayscale conversion. The program processes multiple images simultaneously on NVIDIA GPUs, converting color images (RGB) to grayscale using the standard luminance formula.

### What Does It Do?

The program reads all images from an input folder, converts each one from RGB to grayscale using GPU acceleration, and saves the results to an output folder. Each pixel is processed independently by a separate CUDA thread, allowing thousands of pixels to be processed simultaneously.

### Grayscale Formula

The conversion uses the human perception-based luminance formula (ITU-R BT.601 standard):
Gray = 0.299 × Red + 0.587 × Green + 0.114 × Blue

## Requirements

### Software
| Software | Version | Purpose |
|----------|---------|---------|
| Windows OS | 10 or 11 | Operating system |
| CUDA Toolkit | 13.2 or later | GPU programming |
| OpenCV | 4.x | Image loading/saving |
| Visual Studio | 2019/2022/2026 | C++ compiler |
| Make (optional) | 4.0+ | For Makefile builds |

## How to Run

### Method 1: One-Click Run (Easiest)

**Simply double-click `run.bat`** in the project folder.

That's it! The program will:
1. Build itself automatically
2. Process all images in `data/input_images/`
3. Save results to `data/output_images/`


### Method 2: Commad line

nvcc -gencode=arch=compute_75,code=sm_75 -o cuda_processor.exe src/main.cu src/kernels.cu src/cpu_reference.cpp -I include -I C:/opencv/build/include -L C:/opencv/build/x64/vc15/lib -lopencv_world4120 -std=c++17

cuda_processor.exe


### Method 3: Using Make

Open terminal in project folder:

make          # Build only
make run      # Build and run
make clean    # Clean build files

