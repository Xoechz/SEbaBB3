cmake_minimum_required(VERSION 3.20)
project(ue3)

set(CMAKE_C_FLAGS "-Wall -Wextra -Werror -std=c99")

add_executable(ue3 printf1.c lib.c)