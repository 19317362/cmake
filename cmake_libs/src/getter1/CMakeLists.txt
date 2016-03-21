cmake_minimum_required(VERSION 3.0)
project(getter1)

include(../../cmake/cpp_standard.cmake)
set_cxx_standard(14)

set(target getter1)

file(GLOB cplusplus_SRC "*.cpp" "include/*.h")
add_library(${target} ${cplusplus_SRC})
target_link_libraries(${target} getter)
target_include_directories(${target} PUBLIC "${CMAKE_CURRENT_LIST_DIR}/include")

if (NOT TARGET getter)
  add_subdirectory(../getter getter)
endif()


