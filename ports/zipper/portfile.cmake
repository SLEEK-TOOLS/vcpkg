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
    REF 3b0ca4e18caa04d61434c23716d410e581ffd1b5
    SHA512 8242fc4d367d1fd17c4df74bbfe82b0b9c4cbfce04189e3da64cc1e0acc87296651de9638a17e7c0974edb06c29748159f59906f2ff3dbeb1c7c3486623b8986
    PATCHES
        debug_postfix.patch
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
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/zipper RENAME copyright)
