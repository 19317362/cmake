cmake_minimum_required(VERSION 3.0)
project(main)

include(../cmake/cpp_standard.cmake)
set_cxx_standard(14)

set(target main)

file(GLOB cplusplus_SRC "*.cpp" "*.h")
add_executable(${target} ${cplusplus_SRC})
target_link_libraries(${target} getter getter1)



option(BUILD_SHARED_LIBS "build shared libraries" OFF)

if (NOT TARGET getter)
  add_subdirectory(getter)
endif()
if (NOT TARGET getter1)
  add_subdirectory(getter1)
endif()

if (NOT ${CMAKE_BINARY_DIR} STREQUAL ${CMAKE_CURRENT_BINARY_DIR})
  add_custom_command(TARGET ${target} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${CMAKE_CURRENT_BINARY_DIR}/${target}" "${CMAKE_BINARY_DIR}/${target}"
  )
endif()
