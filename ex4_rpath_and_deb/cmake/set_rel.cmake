## for path
function(func_set_rel_path pathStart pathEnd result)
  if (NOT (${pathStart} STREQUAL ${pathEnd}))
    string(REGEX REPLACE "[^/]+" ".." to_common_base ${pathStart})
    string(CONCAT rel_path ${to_common_base} "/" ${pathEnd})
    
    set(${result} ${rel_path} PARENT_SCOPE)
  else ()
    set(${result} "" PARENT_SCOPE)
  endif ()
endfunction()

## for Rpath
function(func_set_rel_rpath originPrefix pathStart pathEnd result)
  func_set_rel_path(${pathStart} ${pathEnd} rel_path)
  string(CONCAT res ${originPrefix} ${rel_path})

  set(${result} ${res} PARENT_SCOPE)
endfunction()
