include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO jtv/libpqxx
    REF 6.4.5
    SHA512 b6f79c4af93876eaf859626c2deae3b23bd4fa1a438390bc01513ccc48b90565d59588f6977e7475bb7b8dbeb8b1c8ef2a4737d8eb4d15682531fbf78590ed5e
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
	OPTIONS
		-DBUILD_TEST=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(INSTALL ${CURRENT_PACKAGES_DIR}/lib/cmake/libpqxx/libpqxx-config-version.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpqxx)
file(INSTALL ${CURRENT_PACKAGES_DIR}/lib/cmake/libpqxx/libpqxx-config.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpqxx)
file(INSTALL ${CURRENT_PACKAGES_DIR}/lib/cmake/libpqxx/libpqxx-targets-release.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpqxx)
file(INSTALL ${CURRENT_PACKAGES_DIR}/lib/cmake/libpqxx/libpqxx-targets.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpqxx)
file(INSTALL ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libpqxx/libpqxx-config-version.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/debug/share/libpqxx)
file(INSTALL ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libpqxx/libpqxx-config.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/debug/share/libpqxx)
file(INSTALL ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libpqxx/libpqxx-targets-debug.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/debug/share/libpqxx)
file(INSTALL ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libpqxx/libpqxx-targets.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/debug/share/libpqxx)

vcpkg_fixup_cmake_targets(CONFIG_PATH share/libpqxx)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share/)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/pqxx/doc)

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpqxx RENAME copyright)
