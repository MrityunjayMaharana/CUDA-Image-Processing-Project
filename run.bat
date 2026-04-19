@echo off
echo ========================================
echo CUDA Image Processor - Batch Runner
echo ========================================
echo.

REM Check if input folder exists
if not exist "data\input_images" (
    echo ERROR: data\input_images folder not found!
    echo Please create the folder and add images.
    pause
    exit /b 1
)

REM Create output folder if needed
if not exist "data\output_images" (
    mkdir data\output_images
    echo Created output folder: data\output_images\
)

echo Building project...
echo.

REM Build with nvcc
nvcc -gencode=arch=compute_75,code=sm_75 -o cuda_processor.exe ^
    src\main.cu src\kernels.cu src\cpu_reference.cpp ^
    -I include -I C:\opencv\build\include ^
    -L C:\opencv\build\x64\vc16\lib -lopencv_world4120 ^
    -std=c++17

if errorlevel 1 (
    echo.
    echo BUILD FAILED!
    pause
    exit /b 1
)

echo.
echo BUILD SUCCESSFUL!
echo.

echo Running CUDA processor...
echo.
cuda_processor.exe

echo.
echo ========================================
echo Done! Check data\output_images\ folder
echo ========================================
pause
