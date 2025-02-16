# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(torrent_library VERSION 0.0.1 LANGUAGES C)

add_library(torrent SHARED
  "torrent.c"
)

set_target_properties(torrent PROPERTIES
  PUBLIC_HEADER torrent.h
  OUTPUT_NAME "torrent"
)

target_compile_definitions(torrent PUBLIC DART_SHARED_LIB)
