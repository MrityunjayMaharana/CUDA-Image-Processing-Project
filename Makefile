# Makefile for CUDA Image Processing
# Run with: make, make run, or make clean

CXX = nvcc
CXXFLAGS = -gencode=arch=compute_75,code=sm_75 -std=c++17
INCLUDES = -I include -I C:/opencv/build/include
LDFLAGS = -L C:/opencv/build/x64/vc15/lib -lopencv_world4120

SRCDIR = src
TARGET = cuda_processor

.PHONY: all clean run help

all:
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRCDIR)/main.cu $(SRCDIR)/kernels.cu $(SRCDIR)/cpu_reference.cpp $(INCLUDES) $(LDFLAGS)
	@echo "Build complete! Run: ./$(TARGET) or make run"

clean:
	rm -f $(TARGET)
	@echo "Clean complete"

run: all
	./$(TARGET)

help:
	@echo "CUDA Image Processing Makefile"
	@echo "  make      - Build the project"
	@echo "  make run  - Build and run"
	@echo "  make clean- Remove executable"
