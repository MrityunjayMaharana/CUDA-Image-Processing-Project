#include <iostream>
#include <opencv2/opencv.hpp>
#include <filesystem>
#include <chrono>
#include <iomanip>
#include "kernels.h"

using namespace cv;
using namespace std;
namespace fs = std::filesystem;

int main()
{
    cout << "\n";
    
    cout << "CUDA IMAGE PROCESSING AT SCALE \n";
    cout << "Batch Grayscale Converter\n";
    
    cout << "\n";

    string inputFolder = "data/input_images/";
    string outputFolder = "data/output_images/";

    // Check CUDA devices
    int deviceCount = 0;
    cudaGetDeviceCount(&deviceCount);
    cout << "CUDA devices found: " << deviceCount << "\n";

    if (deviceCount > 0) {
        cudaDeviceProp prop;
        cudaGetDeviceProperties(&prop, 0);
        cout << "GPU: " << prop.name << "\n";
    }

    cout << "\n";

    // Check if input folder exists
    if (!fs::exists(inputFolder)) {
        cerr << "Error: Input folder not found: " << inputFolder << "\n";
        return 1;
    }

    // Create output folder if needed
    if (!fs::exists(outputFolder)) {
        fs::create_directories(outputFolder);
    }

    // Collect all images
    vector<fs::path> images;
    for (const auto& entry : fs::directory_iterator(inputFolder)) {
        string ext = entry.path().extension().string();
        transform(ext.begin(), ext.end(), ext.begin(), ::tolower);
        if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".bmp" || ext == ".tiff") {
            images.push_back(entry.path());
        }
    }

    cout << "Found " << images.size() << " images\n";
    cout << "Mode: GPU\n";
    cout << "\n";

    auto totalStart = chrono::high_resolution_clock::now();
    int count = 0;

    for (const auto& imagePath : images) {
        Mat img = imread(imagePath.string());
        if (img.empty()) {
            cout << "  Failed: " << imagePath.filename().string() << "\n";
            continue;
        }

        int w = img.cols;
        int h = img.rows;

        cout << "  Processing: " << imagePath.filename().string()
            << " (" << w << "x" << h << ")\n";

        unsigned char* gray = new unsigned char[w * h];

        launchGray(img.data, gray, w, h);

        Mat output(h, w, CV_8UC1, gray);
        imwrite(outputFolder + imagePath.filename().string(), output);

        delete[] gray;
        count++;
    }

    auto totalEnd = chrono::high_resolution_clock::now();
    double totalTime = chrono::duration<double, milli>(totalEnd - totalStart).count();

    cout << "\n";
    
    cout << "RESULTS\n";
    cout << "  Images processed: " << count << "\n";
    cout << "  Total time: " << fixed << setprecision(2) << totalTime << " ms\n";
    if (count > 0) {
        cout << "  Average per image: " << (totalTime / count) << " ms\n";
    }
    cout << "  Output folder: " << outputFolder << "\n";
    cout << "\n";
    cout << "Done GPU batch processing!\n";

    return 0;
}