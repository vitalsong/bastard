include_guard(GLOBAL)

if (NOT DEFINED VERSION_SCRIPT_LOC)
    set(VERSION_SCRIPT_LOC "${CMAKE_CURRENT_LIST_DIR}")
endif()

# ---------------------------------------------------------------------------------------------------------
# Adds a header (or source file) generation with version, build time
# and commit information
# The following variables can be used in the template:
#  GIT_COMMIT, BUILD_TIMESTAMP,
#  VERSION, VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH.
function(GenVersionHeader target version input_template output_file)
    find_package(Git QUIET REQUIRED)
    set(target_for_gen "${target}_version_header")
    add_custom_target(${target_for_gen} ALL
    COMMAND ${CMAKE_COMMAND}
        -Dgit="${GIT_EXECUTABLE}"
        -Dpackage_name="${target}"
        -Dversion="${version}"
        -Dinput_template="${input_template}"
        -Doutput_file="${output_file}"
        -Dsrc_dir="${CMAKE_CURRENT_SOURCE_DIR}"
        -P "${VERSION_SCRIPT_LOC}/make_version_file.cmake"
    COMMENT "Create or update '${output_file}'")

    if (TARGET ${target})
        add_dependencies(${target} ${target_for_gen})
    endif()
endfunction(GenVersionHeader)

# ---------------------------------------------------------------------------------------------------------
# check target for generate package/version.h
function(CheckVersion package)
    set(package_version "${${package}.package.version}")
    if (NOT "${package_version}" STREQUAL "")
        set(input_file "${VERSION_SCRIPT_LOC}/version.h.in")
        set(output_file "${CMAKE_BINARY_DIR}/include/${package}/version.h")
        GenVersionHeader(${package} ${package_version} "${input_file}" "${output_file}")
        include_directories("${CMAKE_BINARY_DIR}/include")
    endif()
endfunction(CheckVersion)