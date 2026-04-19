cmake_minimum_required(VERSION 3.20)

project(CUDA_Image_Processing LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)

find_package(OpenCV REQUIRED)

include_directories(include ${OpenCV_INCLUDE_DIRS})

add_executable(app
    src/main.cu
    src/kernels.cu
)

target_link_libraries(app ${OpenCV_LIBS})

set_target_properties(app PROPERTIES CUDA_SEPARABLE_COMPILATION ON)