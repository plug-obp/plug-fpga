cmake_minimum_required (VERSION 3.1)

project(murmur3)



include_directories(.)


add_executable(murmur3 murmur3_tb.c murmur3.c murmur3.h)


