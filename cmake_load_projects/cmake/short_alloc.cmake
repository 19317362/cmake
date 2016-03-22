if(RE_DOWNLOAD_ALL)
  execute_process(
    COMMAND bash -c "rm -rf short_alloc tmp_HowardHinnant.github.io.git"
    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
    )
endif()

execute_process(
  COMMAND bash -c "if [[ ! -e short_alloc/short_alloc.h ]]; then
                     rm -rf               tmp
                     git clone --depth 1 --branch master https://github.com/HowardHinnant/HowardHinnant.github.io.git tmp_HowardHinnant.github.io.git
                     mkdir -p                                             short_alloc
                     mv     tmp_HowardHinnant.github.io.git/short_alloc.h short_alloc
                     rm -rf tmp_HowardHinnant.github.io.git
                   fi"
  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
  )
