
if(APPLE AND NOT CPACK_GENERATOR)
	set(CPACK_GENERATOR "Bundle")
elseif(WIN32 AND NOT CPACK_GENERATOR)
	set(CPACK_GENERATOR "WIX" "ZIP")
endif()

set(CPACK_PACKAGE_NAME "RPAN Studio")
set(CPACK_PACKAGE_VENDOR "www.reddit.com")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "RPAN Studio")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/UI/data/license/gplv2.txt")

set(CPACK_PACKAGE_VERSION_MAJOR "0")
set(CPACK_PACKAGE_VERSION_MINOR "0")
set(CPACK_PACKAGE_VERSION_PATCH "1")
set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

if(NOT DEFINED OBS_VERSION_OVERRIDE)
	if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
		execute_process(COMMAND git describe --tags --always --dirty=-modified
			OUTPUT_VARIABLE OBS_VERSION
			WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
			OUTPUT_STRIP_TRAILING_WHITESPACE)
	else()
		set(OBS_VERSION "${CPACK_PACKAGE_VERSION}")
	endif()
else()
	set(OBS_VERSION "${OBS_VERSION_OVERRIDE}")
endif()

MESSAGE(STATUS "OBS_VERSION: ${OBS_VERSION}")

if(INSTALLER_RUN)
	set(CPACK_PACKAGE_EXECUTABLES
		"obs32" "RPAN Studio (32bit)"
		"obs64" "RPAN Studio (64bit)")
	set(CPACK_CREATE_DESKTOP_LINKS
		"obs32"
		"obs64")
else()
	if(WIN32)
		if(CMAKE_SIZEOF_VOID_P EQUAL 8)
			set(_output_suffix "64")
		else()
			set(_output_suffix "32")
		endif()
	else()
		set(_output_suffix "")
	endif()

	set(CPACK_PACKAGE_EXECUTABLES "obs${_output_suffix}" "RPAN Studio")
	set(CPACK_CREATE_DESKTOP_LINKS "obs${_output_suffix}")
endif()

set(CPACK_BUNDLE_NAME "RPAN Studio")
set(CPACK_BUNDLE_PLIST "${CMAKE_SOURCE_DIR}/cmake/osxbundle/Info.plist")
set(CPACK_BUNDLE_ICON "${CMAKE_SOURCE_DIR}/cmake/osxbundle/rpanstudio.icns")
set(CPACK_BUNDLE_STARTUP_COMMAND "${CMAKE_SOURCE_DIR}/cmake/osxbundle/obslaunch.sh")

set(CPACK_WIX_TEMPLATE "${CMAKE_SOURCE_DIR}/cmake/Modules/WIX.template.in")

if(INSTALLER_RUN)
	set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "RPANStudio")
	set(CPACK_WIX_UPGRADE_GUID "6d83f0d7-71bf-43ad-901c-7347f8ac3f67")
	set(CPACK_WIX_PRODUCT_GUID "169585dd-0cfd-4971-878f-726d68b4b727")
	set(CPACK_PACKAGE_FILE_NAME "rpan-studio-${OBS_VERSION}")
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
	if(WIN32)
		set(CPACK_PACKAGE_NAME "RPAN Studio (64bit)")
	endif()
	set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "RPANStudio64")
	set(CPACK_WIX_UPGRADE_GUID "f2dc1daf-963b-4fce-a234-e5032591f7e7")
	set(CPACK_WIX_PRODUCT_GUID "1205fc89-3b9c-45f8-a853-b87c8455d103")
	set(CPACK_PACKAGE_FILE_NAME "rpan-studio-x64-${OBS_VERSION}")
else()
	if(WIN32)
		set(CPACK_PACKAGE_NAME "RPAN Studio (32bit)")
	endif()
	set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "RPANStudio32")
	set(CPACK_WIX_UPGRADE_GUID "832678cc-404d-4746-b20f-176aac2161d9")
	set(CPACK_WIX_PRODUCT_GUID "cfc0bfa9-9995-46cd-b686-a71cd9635edf")
	set(CPACK_PACKAGE_FILE_NAME "rpan-studio-x86-${OBS_VERSION}")
endif()

set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_NAME}")

if(UNIX_STRUCTURE)
	set(CPACK_SET_DESTDIR TRUE)
endif()

include(CPack)
