###########
## GTEST GMOCK
###########

function(func_load_gtest_gmock_from_github)
  
  # If func_load_gtest_gmock_from_github was called, and you want to change between shared and static libraries... then:
  # Be sure to clean entire build directory, when changing between the following:
  #   cmake -DBUILD_SHARED_LIBS=ON
  #   cmake -DBUILD_SHARED_LIBS=OFF
  # Reason: func_load_gtest_gmock_from_github creates
  #         googletest_with_googlemock/src/gtest_gmock-build/googlemock/libgmock.a  for static libs
  #         googletest_with_googlemock/src/gtest_gmock-build/googlemock/libgmock.so for shared libs
  # Both shared and static will exist, and you will NOT know which one gets chosen with: target_link_libraries(${target} gmock)
  
  include(ExternalProject)
  ExternalProject_Add(gtest_gmock
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG master # Git branch name, commit id or tag
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/googletest_with_googlemock
    CMAKE_ARGS
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}   ## same as master project
            -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS} ## same as master project
            -DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}
    PATCH_COMMAND          "${CMAKE_COMMAND}" "-E" "echo" "cmake_minimum_required(VERSION 3.2)" >   CMakeLists.txt
                   COMMAND "${CMAKE_COMMAND}" "-E" "echo" "add_subdirectory(googlemock)"        >>  CMakeLists.txt # next line
    INSTALL_COMMAND ""
    )



  ExternalProject_Get_Property(gtest_gmock
    SOURCE_DIR
    BINARY_DIR)

  set(ENV{GMOCK_INCLUDE} ${SOURCE_DIR}/googlemock/include PARENT_SCOPE)
  set(ENV{GTEST_INCLUDE} ${SOURCE_DIR}/googletest/include PARENT_SCOPE)
  set(GMOCK_LIB          ${BINARY_DIR}/googlemock         PARENT_SCOPE)
  set(GTEST_LIB          ${BINARY_DIR}/googlemock/gtest   PARENT_SCOPE)
  
endfunction()



# ========================================================

function(func_gtest_gmock_env_release exist)
  set(${exist} "no" PARENT_SCOPE) # default return
  if (        EXISTS $ENV{GMOCK_INCLUDE})
    if (      EXISTS $ENV{GTEST_INCLUDE})
      if (    EXISTS $ENV{GMOCK_LIB_REL})
        if (  EXISTS $ENV{GTEST_LIB_REL})
          set(${exist} "yes" PARENT_SCOPE)
        endif()
      endif()
    endif()
  endif()
endfunction()

function(func_gtest_gmock_env_debug exist)
  set(${exist} "no" PARENT_SCOPE) # default return
  if (        EXISTS $ENV{GMOCK_INCLUDE})
    if (      EXISTS $ENV{GTEST_INCLUDE})
      if (    EXISTS $ENV{GMOCK_LIB_DBG})
        if (  EXISTS $ENV{GTEST_LIB_DBG})
          set(${exist} "yes" PARENT_SCOPE)
        endif()
      endif()
    endif()
  endif()
endfunction()


## If env-variables indicate no gtest/gmock, then call func_load_gtest_gmock_from_github from above
if (CMAKE_BUILD_TYPE AND ${CMAKE_BUILD_TYPE} STREQUAL "Release")
  ## Release Build
  
  func_gtest_gmock_env_release(exist)
  if (${exist} STREQUAL "yes")

    set(GMOCK_LIB $ENV{GMOCK_LIB_REL}) # using location of release library
    set(GTEST_LIB $ENV{GTEST_LIB_REL}) # using location of release library

  else()

    message("## calling (release) func_load_gtest_gmock_from_github()")
    set(GTEST_GMOCK_DEPENDENCY "gtest_gmock") # name of ExternalProject_Add
    func_load_gtest_gmock_from_github()
    
  endif()
    
else()
  ## Debug Build

  func_gtest_gmock_env_debug(exist)
  if (${exist} STREQUAL "yes")

    set(GMOCK_LIB $ENV{GMOCK_LIB_DBG}) # using location of release library
    set(GTEST_LIB $ENV{GTEST_LIB_DBG}) # using location of release library

  else()

    message("## calling (debug) func_load_gtest_gmock_from_github()")
    set(GTEST_GMOCK_DEPENDENCY "gtest_gmock") # name of ExternalProject_Add
    func_load_gtest_gmock_from_github()
    
  endif()
endif()



# ========================================================

# setup include_directories and link_directories so that
#    gmock, gmock_main, gtest and gtest_main
# can be found

include_directories("$ENV{GMOCK_INCLUDE}"       "$ENV{GTEST_INCLUDE}")
link_directories(      "${GMOCK_LIB}"              "${GTEST_LIB}")
