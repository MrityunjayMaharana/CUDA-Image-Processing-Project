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
