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

#header-only library
include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/turtle-1.3.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/SLEEK-TOOLS/turtle/archive/v1.3.0.tar.gz"
    FILENAME "turtle-1.3.0.zip"
    SHA512 2808483f5af19590c7131b430dd6a82e145d2f9139cc590c2c98eb9effed042fa01219dfb406a97624f81af38b7adca30e5e1e36626a9b8d20abb04fe0246013
)
vcpkg_extract_source_archive(${ARCHIVE})

# Put the licence file where vcpkg expects it
file(COPY ${SOURCE_PATH}/LICENSE_1_0.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/turtle)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/turtle/LICENSE_1_0.txt ${CURRENT_PACKAGES_DIR}/share/turtle/copyright)

# Copy the turtle header files
file(INSTALL ${SOURCE_PATH}/include DESTINATION ${CURRENT_PACKAGES_DIR} FILES_MATCHING PATTERN "*.hpp")
