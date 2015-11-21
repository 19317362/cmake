set(target mysqrt)

set(src mysqrt.cpp)
add_library(${target} ${src})

install(TARGETS ${target} DESTINATION ${LIB_INSTALL_DIR})
install(FILES   mysqrt.h  DESTINATION ${INC_INSTALL_DIR})
