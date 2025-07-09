# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appMap__autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appMap__autogen.dir/ParseCache.txt"
  "appMap__autogen"
  )
endif()
