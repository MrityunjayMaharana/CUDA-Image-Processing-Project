#include <iostream>

void cpuGray(unsigned char* input, unsigned char* output, int w, int h) {

    for (int i = 0;i < w * h;i++) {
        int idx = i * 3;
        output[i] = 0.299 * input[idx] + 0.587 * input[idx + 1] + 0.114 * input[idx + 2];
    }
}