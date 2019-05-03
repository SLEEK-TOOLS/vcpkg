# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH 
    REPO sebastiandev/zipper
    REF v1.0.1
    SHA512 4aa9a837ea49bf229fd2fd422353acf403afb106e3270a7b53b22c045dfb0ac5fd3b56b105ae43f725f3d8338d64f6d70467ba08f6fbe222590bd1886c4b6f2a
)

vcpkg_download_distfile(MINIZIP_ARCHIVE
    URLS "https://github.com/sebastiandev/minizip/archive/0b46a2b4ca317b80bc53594688883f7188ac4d08.tar.gz"
    FILENAME "minizip.tar.gz"
    SHA512 c88f7bbbf679830b2046ae295ece783c751cba98dd4cf4c27fd9e7cce05d8b4a5c717a672649a22ee845b140a665d2e18f5dfe30ac71fb226f21d46e6e66b970
)

file(REMOVE_RECURSE ${SOURCE_PATH}/minizip)

vcpkg_extract_source_archive(${MINIZIP_ARCHIVE} ${SOURCE_PATH})

file(RENAME ${SOURCE_PATH}/minizip-0b46a2b4ca317b80bc53594688883f7188ac4d08 ${SOURCE_PATH}/minizip)


if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    set(ST_BUILD_STATIC ON)
    set(ST_BUILD_SHARED OFF)
else()
    set(ST_BUILD_STATIC OFF)
    set(ST_BUILD_SHARED ON)
endif()
    
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA 
    OPTIONS -DBUILD_TEST=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/zipper RENAME copyright)
