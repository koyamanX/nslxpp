
# Bulid flex
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.cc
    COMMAND ${FLEXPP_EXECUTABLE} -+ -o ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.cc ${CMAKE_CURRENT_SOURCE_DIR}/nslxx.ll
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/nslxx.ll
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Generating nslxx.yy.cc"
)

# Build bison
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/nslxx.tab.cc ${CMAKE_CURRENT_BINARY_DIR}/nslxx.tab.hh
    COMMAND ${BISON_EXECUTABLE} -d -o ${CMAKE_CURRENT_BINARY_DIR}/nslxx.tab.cc ${CMAKE_CURRENT_SOURCE_DIR}/nslxx.yy
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/nslxx.yy
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Generating nslxx.tab.cc and nslxx.tab.hh"
)

add_executable(nslxx nslxx.tab.cc lex.yy.cc nslxx.cc main.cc nslgen.cc nslxx_parser.cc node.cc scope.cc)

#target_compile_options(nslxx PRIVATE -Wall -Wextra -pedantic -Werror)

target_include_directories(nslxx PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

target_include_directories(nslxx PRIVATE ../include)

install(TARGETS nslxx DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/nsl DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
