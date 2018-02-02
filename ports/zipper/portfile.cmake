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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/zipper-1.0.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/SLEEK-TOOLS/zipper/archive/1.0.0.tar.gz"
    FILENAME "zipper-1.0.0.zip"
    SHA512 4ff6f4aa525744186f1801e503353e639253668b91f1485a697ed6774d63834118b94e9e6e446e5cd136c9fbd54e6db6e8c89fab5d8fa47a984732b2176a3d7e
)
vcpkg_extract_source_archive(${ARCHIVE})

# work around for git submodule 
vcpkg_from_github(OUT_SOURCE_PATH SOURCE_PATH_MINIZIP
    REPO "sebastiandev/minizip"
    REF "4acd44bf24025b58e9cf6f8545eb42d2ab36d714"
    HEAD_REF master
    SHA512 35c6f32f7af3e37435fb91c6f30b2472893b1ee73990607fd1069ed6db2fcd264425bb3b75b9793b3994051fbaea1c198a3ba346c58c923071670f4e3d5d87d9)

file(GLOB MINIZIP_FILES 
    "${CURRENT_BUILDTREES_DIR}/src/minizip-4acd44bf24025b58e9cf6f8545eb42d2ab36d714/*.h"
    "${CURRENT_BUILDTREES_DIR}/src/minizip-4acd44bf24025b58e9cf6f8545eb42d2ab36d714/*.c"
    )
file(COPY ${MINIZIP_FILES} DESTINATION ${CURRENT_BUILDTREES_DIR}/src/zipper-1.0.0/minizip)    

file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR}/src/zipper-1.0.0/minizip/aes)
file(GLOB MINIZIP_AES_FILES 
    "${CURRENT_BUILDTREES_DIR}/src/minizip-4acd44bf24025b58e9cf6f8545eb42d2ab36d714/aes/*.h"
    "${CURRENT_BUILDTREES_DIR}/src/minizip-4acd44bf24025b58e9cf6f8545eb42d2ab36d714/aes/*.c"
    )
file(COPY ${MINIZIP_AES_FILES} DESTINATION ${CURRENT_BUILDTREES_DIR}/src/zipper-1.0.0/minizip/aes)    

file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/src/minizip-4acd44bf24025b58e9cf6f8545eb42d2ab36d714)
file(REMOVE ${CURRENT_BUILDTREES_DIR}/src/sebastiandev-minizip-4acd44bf24025b58e9cf6f8545eb42d2ab36d714.tar.gz.extracted)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    set(ST_BUILD_STATIC ON)
    set(ST_BUILD_SHARED OFF)
else()
    set(ST_BUILD_STATIC OFF)
    set(ST_BUILD_SHARED ON)
endif()
    
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
# Doesnt export anything when built as dll    
#    OPTIONS -DBUILD_TEST=OFF -DBUILD_TESTING=OFF -DBUILD_STATIC_VERSION=${ST_BUILD_STATIC} -DBUILD_SHARED_VERSION=${ST_BUILD_SHARED}
    OPTIONS -DBUILD_TEST=OFF -DBUILD_STATIC_VERSION=ON -DBUILD_SHARED_VERSION=OFF

    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/zipper RENAME copyright)
