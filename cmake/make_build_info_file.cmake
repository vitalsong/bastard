find_package(Git QUIET REQUIRED)

execute_process(
    COMMAND "${GIT_EXECUTABLE}" diff --quiet --exit-code
    WORKING_DIRECTORY "${src_dir}"
    RESULT_VARIABLE diff_exit_code
)

if (diff_exit_code EQUAL 0)
    set(BUILD_DIRTY 0)
else()
    set(BUILD_DIRTY 1)
endif()

string(TIMESTAMP BUILD_TIMESTAMP "%Y-%m-%d %H:%M:%S")

# TODO: not working?
set(BUILD_COMPILER "${compiler}")

# Format PACKAGE_NAME
set(PACKAGE_NAME ${package_name})
string(REPLACE "-" "_" PACKAGE_NAME ${PACKAGE_NAME})
string(TOUPPER ${PACKAGE_NAME} PACKAGE_NAME)

# Generating an output file
configure_file("${input_template}" "${output_file}" @ONLY)
