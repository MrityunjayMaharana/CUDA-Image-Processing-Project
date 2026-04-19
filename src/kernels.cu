//#include <cuda_runtime.h>
//#include <stdio.h>  // For printf in error handling
//
//__global__ void rgbToGray(unsigned char* input, unsigned char* output, int w, int h)
//{
//    int x = blockIdx.x * blockDim.x + threadIdx.x;
//    int y = blockIdx.y * blockDim.y + threadIdx.y;
//
//    if (x < w && y < h)
//    {
//        int idx = (y * w + x) * 3;
//
//        unsigned char r = input[idx];
//        unsigned char g = input[idx + 1];
//        unsigned char b = input[idx + 2];
//
//        output[y * w + x] =
//            (unsigned char)(0.299f * r + 0.587f * g + 0.114f * b);
//    }
//}
//
//void launchGray(unsigned char* input, unsigned char* output, int w, int h)
//{
//    if (input == nullptr || output == nullptr) {
//        printf("ERROR: Null pointer passed to launchGray\n");
//        return;
//    }
//
//    if (w <= 0 || h <= 0) {
//        printf("ERROR: Invalid dimensions w=%d, h=%d\n", w, h);
//        return;
//    }
//
//    unsigned char* d_in = nullptr, * d_out = nullptr;
//
//    size_t rgbSize = w * h * 3;
//    size_t graySize = w * h;
//
//    printf("DEBUG: Allocating %zu bytes for RGB, %zu bytes for Gray\n", rgbSize, graySize);
//
//    // CHECK CUDA MALLOC ERRORS
//    cudaError_t err;
//
//    err = cudaMalloc(&d_in, rgbSize);
//    if (err != cudaSuccess) {
//        printf("ERROR: cudaMalloc failed for d_in: %s\n", cudaGetErrorString(err));
//        return;
//    }
//
//    err = cudaMalloc(&d_out, graySize);
//    if (err != cudaSuccess) {
//        printf("ERROR: cudaMalloc failed for d_out: %s\n", cudaGetErrorString(err));
//        cudaFree(d_in);
//        return;
//    }
//
//    // CHECK MEMCPY TO DEVICE
//    err = cudaMemcpy(d_in, input, rgbSize, cudaMemcpyHostToDevice);
//    if (err != cudaSuccess) {
//        printf("ERROR: cudaMemcpy to device failed: %s\n", cudaGetErrorString(err));
//        cudaFree(d_in);
//        cudaFree(d_out);
//        return;
//    }
//
//    dim3 block(16, 16);
//    dim3 grid((w + block.x - 1) / block.x, (h + block.y - 1) / block.y);
//
//    printf("DEBUG: Launching kernel with grid(%d,%d) block(%d,%d)\n", grid.x, grid.y, block.x, block.y);
//
//    rgbToGray << <grid, block >> > (d_in, d_out, w, h);
//
//    // CHECK KERNEL LAUNCH ERRORS
//    err = cudaGetLastError();
//    if (err != cudaSuccess) {
//        printf("ERROR: Kernel launch failed: %s\n", cudaGetErrorString(err));
//        cudaFree(d_in);
//        cudaFree(d_out);
//        return;
//    }
//
//    // WAIT FOR KERNEL AND CHECK ERRORS
//    err = cudaDeviceSynchronize();
//    if (err != cudaSuccess) {
//        printf("ERROR: Kernel execution failed: %s\n", cudaGetErrorString(err));
//        cudaFree(d_in);
//        cudaFree(d_out);
//        return;
//    }
//
//    // CHECK MEMCPY BACK TO HOST
//    err = cudaMemcpy(output, d_out, graySize, cudaMemcpyDeviceToHost);
//    if (err != cudaSuccess) {
//        printf("ERROR: cudaMemcpy to host failed: %s\n", cudaGetErrorString(err));
//        cudaFree(d_in);
//        cudaFree(d_out);
//        return;
//    }
//
//    cudaFree(d_in);
//    cudaFree(d_out);
//
//    printf("DEBUG: launchGray completed successfully\n");
//}

#include <cuda_runtime.h>

__global__ void rgbToGray(unsigned char* input, unsigned char* output, int w, int h)
{
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x < w && y < h)
    {
        int idx = (y * w + x) * 3;

        unsigned char r = input[idx];
        unsigned char g = input[idx + 1];
        unsigned char b = input[idx + 2];

        output[y * w + x] =
            (unsigned char)(0.299f * r + 0.587f * g + 0.114f * b);
    }
}

void launchGray(unsigned char* input, unsigned char* output, int w, int h)
{
    unsigned char* d_in = nullptr, * d_out = nullptr;

    size_t rgbSize = w * h * 3;
    size_t graySize = w * h;

    cudaMalloc(&d_in, rgbSize);
    cudaMalloc(&d_out, graySize);

    cudaMemcpy(d_in, input, rgbSize, cudaMemcpyHostToDevice);

    dim3 block(16, 16);
    dim3 grid((w + 15) / 16, (h + 15) / 16);

    rgbToGray << <grid, block >> > (d_in, d_out, w, h);

    cudaDeviceSynchronize();

    cudaMemcpy(output, d_out, graySize, cudaMemcpyDeviceToHost);

    cudaFree(d_in);
    cudaFree(d_out);
}