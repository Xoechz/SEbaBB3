cmake_minimum_required(VERSION 3.16)
project(CNW VERSION 1.0.0 LANGUAGES C CXX)

set_property(GLOBAL PROPERTY USE_FOLDERS ON) # enable virtual folders for projects if supported by the build system/IDE

# set output directories
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/static)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_executable(socket1 socket1/server.c socket1/WordCheck.h socket1/WordCheck.c)


if(MSVC)
    # Suppress warnings for "unsafe" C functions (e.g., sprintf, strcpy) in MSVC.
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)

    # /W4          enable almost all "necessary" warnings
    # /permissive- enforce strict standard compliance
    # /JMC         optimize debugging experience
    # /MP          enable parallel compilation
    target_compile_options(socket1 PRIVATE /W4 /permissive- /JMC /MP )
else(MSVC)
    # -Wall        enable "all" warnings
    # -Wextra      enable extra warnings
    # -Wpedantic   enable strict conformance warnings
    # -Wconversion enable warnings for dangerous implicit conversions
    # -Werror=vla  disable support for VLAs
    target_compile_options(socket1 PRIVATE -Wall -Wextra -Wpedantic -Wconversion -Werror=vla)
endif(MSVC)
