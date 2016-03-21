function(set_cxx_standard standard_num)
  if (NOT    CMAKE_VERSION VERSION_LESS 3.1)
    set(CMAKE_CXX_STANDARD   ${standard_num}  PARENT_SCOPE)
    set(CMAKE_CXX_EXTENSIONS OFF              PARENT_SCOPE)
  else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++${standard_num}"  PARENT_SCOPE) ## -std=c++11, or -std=c++14 ...
  endif()
endfunction()
