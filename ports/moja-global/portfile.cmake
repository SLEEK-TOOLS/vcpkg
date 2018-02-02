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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/moja.global-1.0.5)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/SLEEK-TOOLS/moja.global/archive/v1.0.5.tar.gz"
    FILENAME "moja.global-1.0.5.zip"
    SHA512 fdf816d329846999e983058d90f7ae7001ec34d7de76d1e5a592b329dd668c043f9a6f149d72ea5caa24f224270d888ae41791dc2bed13a61c76a96f4c4ea985
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/Source
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS
        -DENABLE_TESTS=OFF
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

# Remove duplicate headers installed from debug build
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
# Remove data installed from debug build
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools)
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/moja.cli.exe ${CURRENT_PACKAGES_DIR}/tools/moja.cli.exe)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/debug)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/bin/moja.cli.exe ${CURRENT_PACKAGES_DIR}/tools/debug/moja.cli.exe)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/moja-global)
# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/moja-global RENAME copyright)
