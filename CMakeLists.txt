cmake_minimum_required(VERSION 3.14)
project(nslxx VERSION 0.0.1 LANGUAGES CXX)

find_package(BISON REQUIRED)
if(NOT BISON_FOUND)
    message(FATAL_ERROR "Bison not found")
endif()

# find flex++ by manually
find_program(FLEXPP_EXECUTABLE flex++)
if(NOT FLEXPP_EXECUTABLE)
    message(FATAL_ERROR "Flex++ not found")
endif()

execute_process(COMMAND ${FLEXPP_EXECUTABLE} --version OUTPUT_VARIABLE FLEXPP_VERSION)
string(REGEX MATCH "flex\\+\\+ ([0-9]+)\\.([0-9]+)\\.([0-9]+)" _ ${FLEXPP_VERSION})

find_library(FLEXPP_LIBRARIES fl)

find_path(FLEXPP_INCLUDE_PATH FlexLexer.h)

include(CTest)
enable_testing()

add_subdirectory(src)
add_subdirectory(tests)
