# CUDA Image Processing - Batch Grayscale Converter

## Project Description

This project implements a high-performance batch image processing system using CUDA (Compute Unified Device Architecture) for parallel grayscale conversion. The program processes multiple images simultaneously on NVIDIA GPUs, converting color images (RGB) to grayscale using the standard luminance formula.

### What Does It Do?

The program reads all images from an input folder, converts each one from RGB to grayscale using GPU acceleration, and saves the results to an output folder. Each pixel is processed independently by a separate CUDA thread, allowing thousands of pixels to be processed simultaneously.

### Grayscale Formula

The conversion uses the human perception-based luminance formula (ITU-R BT.601 standard):
Gray = 0.299 × Red + 0.587 × Green + 0.114 × Blue
