# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(torrent_library VERSION 0.0.1)

# Set output file name and build mode based on platform
if (WIN32)
    set(OUTPUT_FILE "libtorrent.dll")
    set(BUILD_MODE "c-shared")
else()
    set(OUTPUT_FILE "libtorrent.so")
    set(BUILD_MODE "c-shared")
endif()

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/include/${OUTPUT_FILE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMAND go build -o ./include/${OUTPUT_FILE} -buildmode=${BUILD_MODE} main.go
    COMMENT "Building Go shared library"
)

add_custom_target(
    go_build ALL
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/include/${OUTPUT_FILE}
)

add_library(torrent STATIC IMPORTED GLOBAL)
add_dependencies(torrent go_build)

set_target_properties(torrent PROPERTIES
    IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/include/${OUTPUT_FILE}
    INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR}/build
    OUTPUT_NAME "torrent"
)

if (WIN32)
    set_target_properties(torrent PROPERTIES
      WINDOWS_EXPORT_ALL_SYMBOLS ON
    )
endif (WIN32)

# Creating a dummy target to apply compile definitions
add_library(torrent_defs INTERFACE)
target_compile_definitions(torrent_defs INTERFACE DART_SHARED_LIB)

# Use the dummy target's compile definitions with the torrent target
add_dependencies(torrent torrent_defs)
