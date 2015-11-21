set(target test1)
set(src main.cpp)


add_executable(${target} ${src})
target_link_libraries(${target} mysqrt)

string(REPLACE "${CMAKE_SOURCE_DIR}/" "" PATH_TO_TEST "${CMAKE_CURRENT_LIST_DIR}/${target}")
add_test(NAME                          ${PATH_TO_TEST}
         COMMAND                       ${target})
