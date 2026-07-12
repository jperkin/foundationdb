# Download doctest repo.
if(EXISTS /opt/doctest_proj_2.4.8)
    set(DOCTEST_INCLUDE_DIR "/opt/doctest_proj_2.4.8/doctest" CACHE INTERNAL "Path to include folder for doctest")
    add_library(doctest INTERFACE)
    add_dependencies(doctest doctest_proj)
    target_include_directories(doctest INTERFACE "${DOCTEST_INCLUDE_DIR}")
else()
    include(ExternalProject)
    find_package(Git REQUIRED)

    ExternalProject_Add(
        doctest_proj
        PREFIX ${CMAKE_BINARY_DIR}/doctest
        GIT_REPOSITORY https://github.com/onqtam/doctest.git
        GIT_TAG ae7a13539fb71f270b87eb2e874fbac80bc8dda2 # v2.4.11: log10(unsigned) is ambiguous against illumos math_iso.h; fixed upstream after v2.4.8
        TIMEOUT 10
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        LOG_DOWNLOAD ON
    )

    ExternalProject_Get_Property(doctest_proj source_dir)
    set(DOCTEST_INCLUDE_DIR "${source_dir}/doctest" CACHE INTERNAL "Path to include folder for doctest")
    add_library(doctest INTERFACE)
    add_dependencies(doctest doctest_proj)
    target_include_directories(doctest INTERFACE "${DOCTEST_INCLUDE_DIR}")
endif()