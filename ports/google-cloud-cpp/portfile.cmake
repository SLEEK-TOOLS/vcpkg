include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO GoogleCloudPlatform/google-cloud-cpp
    REF v0.6.1
    SHA512 ebeffafeb0d168b6a0d903029621b1548dd13744a19041b7bfe1b35e4de6a3f77c8efb18f9d31e23d88ed885f2804c1599702bdba008dce86d9d346a61e07a08
    HEAD_REF master
)

set(GOOGLEAPIS_VERSION ca61898878f0926dd9dcc68ba90764f17133efe4)
vcpkg_download_distfile(GOOGLEAPIS
    URLS "https://github.com/google/googleapis/archive/${GOOGLEAPIS_VERSION}.zip"
    FILENAME "googleapis-${GOOGLEAPIS_VERSION}.zip"
    SHA512 6aaf36bdf7e06dd6c409b514edb8bbdad8ee17d4a31916bd33edc3b0770a702ff437b345df673a24f11e2ae354bfa1db1887cd47a063ae344f120a5b4f28f56b
)

file(REMOVE_RECURSE ${SOURCE_PATH}/third_party)
vcpkg_extract_source_archive(${GOOGLEAPIS} ${SOURCE_PATH}/third_party)
file(RENAME ${SOURCE_PATH}/third_party/googleapis-${GOOGLEAPIS_VERSION} ${SOURCE_PATH}/third_party/googleapis)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DGOOGLE_CLOUD_CPP_DEPENDENCY_PROVIDER=package
        -DGOOGLE_CLOUD_CPP_ENABLE_MACOS_OPENSSL_CHECK=OFF
	-DBUILD_TESTING=OFF
)

vcpkg_install_cmake(ADD_BIN_TO_PATH)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake TARGET_PATH share)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/google-cloud-cpp RENAME copyright)

vcpkg_copy_pdbs()
