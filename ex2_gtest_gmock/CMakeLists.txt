cmake_minimum_required(VERSION 3.2)
project(cmake_demo)


###########
# Toolchain
###########
set(toolchain   "$ENV{HOME}/toolchain_desktop.cmake"      CACHE FILEPATH     "")  # override with e.g. -D toolchain=~/toolchain_embedded.cmake
                                                                                  # e.g. cmake -D toolchain="" ..

if (toolchain AND EXISTS ${toolchain})
  message("==> Including toolchain_file ${toolchain}")
  include(${toolchain})
endif()



###########
# Debug or Release
###########
if (NOT CMAKE_BUILD_TYPE)
  ## set default to Debug
  set(CMAKE_BUILD_TYPE Debug)  # override with -DCMAKE_BUILD_TYPE=Release
  message("==> CMAKE_BUILD_TYPE empty. Changing it to Debug.")
else()
  message("==> CMAKE_BUILD_TYPE == ${CMAKE_BUILD_TYPE}.")
endif()



## https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_macros.html
## During Debug, use debug version of libstdc++ (asserts on access to invalid iterators, etc!)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D_GLIBCXX_DEBUG")


###########
# Suppress certain warnings
###########
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations")


##############
# C++ Standard
##############
set(CMAKE_CXX_STANDARD   14)
set(CMAKE_CXX_EXTENSIONS OFF)


##############
# Sources and Target Name
##############
set(src    main.cpp mytest.cpp)
set(target go)


##############
# PThread
##############
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package (Threads)
set(libs ${libs} ${CMAKE_THREAD_LIBS_INIT})

##############
# GMock, GTest
##############
include(cmake/gmock_gtest.cmake)
set(libs ${libs} gmock)
## also need line
##    add_dependencies(${target} gtest_gmock)
## below add_executable (see below)


##############
# Build and Link
##############
# execute_process(COMMAND "${CMAKE_COMMAND}" "-E" "remove" "${target}"
#   WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
# )
add_executable(       ${target} ${src})
target_link_libraries(${target} ${libs})
if (GTEST_GMOCK_DEPENDENCY AND NOT ${GTEST_GMOCK_DEPENDENCY} STREQUAL "")
  add_dependencies(     ${target} ${GTEST_GMOCK_DEPENDENCY}) # here ${GTEST_GMOCK_DEPENDENCY} is empty, func_load_gmock_gtest_from_github needs to be run
endif()

############
# Test with
# $ make test
############
enable_testing()
add_test(NAME ${target}
  COMMAND     ${target})
