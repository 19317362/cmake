cmake_minimum_required(VERSION 3.2)

project(MyProject)


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




# Enable testing
set(BUILD_TESTING ON)
include(CTest)



# if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
#   # see https://www.johnlamp.net/cmake-tutorial-4-libraries-and-subdirectories.html
#   # see http://stackoverflow.com/a/11921648
#   #
#   # force this option to ON so that Google Test will use /MD instead of /MT
#   # /MD is now the default for Visual Studio, so it should be our default, too
#   option(gtest_force_shared_crt
#     "Use shared (DLL) run-time lib even when Google Test is built as static lib."
#     ON)
# endif()

# Download gtest_gmock at configure time
include(cmake/add_dl_project.cmake)
add_dl_project(
  PROJ     gtest_gmock
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG        master # Git branch name, commit id or tag

  # URL          https://googletest.googlecode.com/files/gtest-1.7.0.zip
  # URL_HASH     SHA1=f85f6d2481e2c6c4a18539e391aa4ea8ab0394af

  EXCLUDE_FROM_ALL
  INCLUDE_DIRS   googlemock/include googletest/include

  # see https://www.johnlamp.net/cmake-tutorial-4-libraries-and-subdirectories.html
  # see http://stackoverflow.com/a/11921648
  PATCH_COMMAND "echo cmake_minimum_required(VERSION 3.2)                                               > CMakeLists.txt"
        COMMAND "echo \"add_subdirectory(googlemock)\"                                                   >> CMakeLists.txt"
        COMMAND "echo \"if (${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC)\"                                    >> CMakeLists.txt"
        COMMAND "echo \"  # force this option to ON so that Google Test will use /MD instead of /MT\"    >> CMakeLists.txt"
        COMMAND "echo \"  # /MD is now the default for Visual Studio, so it should be our default, too\" >> CMakeLists.txt"
        COMMAND "echo \"  option(gtest_force_shared_crt Use_shared_DLL_run_time_lib_even_when_Google_Test_is_built_as_static_lib\" >> CMakeLists.txt"
        COMMAND "echo \"  ON)\"   >> CMakeLists.txt"
        COMMAND "echo \"endif()\" >> CMakeLists.txt"

  #PATCH_COMMAND  "${CMAKE_COMMAND} -E echo \"cmake_minimum_required(VERSION 3.2)\" > CMakeLists.txt" COMMAND "${CMAKE_COMMAND} -E echo \"add_subdirectory(googlemock)\" >> CMakeLists.txt"
  #PATCH_COMMAND "echo \"cmake_minimum_required(VERSION 3.2)\" > CMakeLists.txt" COMMAND "echo \"add_subdirectory(googlemock)\"  >> CMakeLists.txt"
)




# Example for how to define a test which uses gtest_gmock
add_executable(mytest tester.cpp)
target_link_libraries(mytest gmock_main)
add_test(NAME mytest COMMAND mytest)
