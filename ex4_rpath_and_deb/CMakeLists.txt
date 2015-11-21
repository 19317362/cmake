cmake_minimum_required(VERSION 3.2)
project(tut1)

## cmake -DCMAKE_INSTALL_PREFIX=$(pwd)/install  -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release ..                                ## install with    rpath
## cmake -DCMAKE_INSTALL_PREFIX=$(pwd)/install  -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_SKIP_INSTALL_RPATH=ON ..  ## install without rpath

set(target tut1)

include(cmake/set_rel.cmake)

###############
## C++ Standard
###############
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_EXTENSIONS OFF)

if (CMAKE_COMPILER_IS_GNUCC)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations")
endif ()

option(BUILD_SHARED_LIBS "Build shared libs" ON)

###############
## Install Paths
###############
set (CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")                           ##              <---- \
message("## Note: always setting CMAKE_INSTALL_PREFIX to ${CMAKE_INSTALL_PREFIX}") ## comment out the line above, if you dislike this!
set (LIB_INSTALL_DIR lib)
set (BIN_INSTALL_DIR bin)
set (INC_INSTALL_DIR include)
# RPATH
func_set_rel_rpath("$ORIGIN/" "${BIN_INSTALL_DIR}" "${LIB_INSTALL_DIR}" CMAKE_INSTALL_RPATH)



###############
## Options
###############
option(USE_MYSQRT "use mysqrt (own sqrt implementation)" ON)
if (USE_MYSQRT)
  add_subdirectory(mysqrt)
  include_directories(${CMAKE_SOURCE_DIR}/mysqrt)
  set(libs ${libs} mysqrt)
endif ()

###############
## Configured Files
###############
set(TUTORIAL_version_major 1)
set(TUTORIAL_version_minor 1)

configure_file (
  "${PROJECT_SOURCE_DIR}/config.h.in"
  "${PROJECT_BINARY_DIR}/config.h"
  )

include_directories(${PROJECT_BINARY_DIR})




###############
## Targets
###############
add_executable(${target} tutorial.cpp)
target_link_libraries(${target} ${libs})

install(TARGETS ${target} DESTINATION bin)


enable_testing()
add_subdirectory(test)


###############
## Packaging
###############
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
  include(cmake/package_deb.cmake)
  INCLUDE(CPack)
else()
  message("## For \"make package\" to create deb package, you need to configure with configure with:   cmake -DCMAKE_BUILD_TYPE=Release ${CMAKE_BINARY_DIR}")
endif()

# make
# make package
# sudo dpkg -i tut1*.deb
# sudo aptitude install   # in case of unresolved dependencies in the prev step
