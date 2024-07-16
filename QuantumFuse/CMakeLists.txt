cmake_minimum_required(VERSION 3.15)

# Project name and version
project(QuantumFuseBlockchain VERSION 1.0)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Specify the required dependencies
find_package(Protobuf REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(PkgConfig REQUIRED)

# Add directories for includes
include_directories(${Protobuf_INCLUDE_DIRS})
include_directories(${OPENSSL_INCLUDE_DIR})
include_directories(${CMAKE_SOURCE_DIR}/QuantumFuse/core)

# Add the executable
add_executable(QuantumFuseBlockchain main.cpp)

# Link the libraries
target_link_libraries(QuantumFuseBlockchain ${Protobuf_LIBRARIES})
target_link_libraries(QuantumFuseBlockchain ${OPENSSL_LIBRARIES})
