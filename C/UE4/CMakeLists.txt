cmake_minimum_required(VERSION 3.16)
project(SWO3.4 VERSION 1.0.0 LANGUAGES C CXX)

set_property(GLOBAL PROPERTY USE_FOLDERS ON) # enable virtual folders for projects if supported by the build system/IDE

# set output directories
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/static)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# configure C11
set(CMAKE_C_STANDARD 11)          # request C11
set(CMAKE_C_STANDARD_REQUIRED ON) # enforce requested standard
set(CMAKE_C_EXTENSIONS OFF)       # disable compiler specific extensions

# configure C++20
set(CMAKE_CXX_STANDARD 20)          # request C++20
set(CMAKE_CXX_STANDARD_REQUIRED ON) # enforce requested standard
set(CMAKE_CXX_EXTENSIONS OFF)       # disable compiler specific extensions

add_executable(preproc preprocessor/preproc.c)
add_executable(pointers pointers/pointers.c pointers/utils.h)
add_executable(union union/union.c)
add_executable(list list/main.c list/list.h list/list.c)


if(MSVC)
    # Suppress warnings for "unsafe" C functions (e.g., sprintf, strcpy) in MSVC.
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)

    # /W4          enable almost all "necessary" warnings
    # /permissive- enforce strict standard compliance
    # /JMC         optimize debugging experience
    # /MP          enable parallel compilation
    target_compile_options(preproc PRIVATE /W4 /permissive- /JMC /MP )
    target_compile_options(pointers PRIVATE /W4 /permissive- /JMC /MP )
    target_compile_options(union PRIVATE /W4 /permissive- /JMC /MP )
    target_compile_options(list PRIVATE /W4 /permissive- /JMC /MP )
else(MSVC)
    # -Wall        enable "all" warnings
    # -Wextra      enable extra warnings
    # -Wpedantic   enable strict conformance warnings
    # -Wconversion enable warnings for dangerous implicit conversions
    # -Werror=vla  disable support for VLAs
    target_compile_options(preproc PRIVATE -Wall -Wextra -Wpedantic -Wconversion -Werror=vla)
    target_compile_options(pointers PRIVATE -Wall -Wextra -Wpedantic -Wconversion -Werror=vla)
    target_compile_options(union PRIVATE -Wall -Wextra -Wpedantic -Wconversion -Werror=vla)
    target_compile_options(list PRIVATE -Wall -Wextra -Wpedantic -Wconversion -Werror=vla)
endif(MSVC)
