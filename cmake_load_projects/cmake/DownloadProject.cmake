if(RE_DOWNLOAD_ALL)
  execute_process(
    COMMAND bash -c "rm -rf DownloadProject tmp_DownloadProject"
    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
    )
endif()

execute_process(
  COMMAND bash -c "if [[ ! -e DownloadProject ]]; then
                     rm -rf               tmp
                     git clone --depth 1 --branch master https://github.com/Crascit/DownloadProject.git tmp_DownloadProject
                     mkdir -p                                     DownloadProject
                     mv     tmp_DownloadProject/DownloadProject.* DownloadProject
                     rm -rf tmp_DownloadProject
                   fi"
  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
  )
