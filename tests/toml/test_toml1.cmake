include_guard(GLOBAL)

cmake_policy(SET CMP0057 NEW)
cmake_policy(SET CMP0054 NEW)

include("${CMAKE_CURRENT_LIST_DIR}/../../cmake/toml_parser.cmake")

TomlParser("${CMAKE_CURRENT_LIST_DIR}/test1.toml" "test")

function(ASSERT_TRUE val)
    if (NOT val OR "${val}" STREQUAL "false")
        message(FATAL_ERROR "${val} != TRUE")
    endif()
endfunction(ASSERT_TRUE)

function(ASSERT_EQ val1 val2)
    if (NOT "${val1}" STREQUAL "${val2}")
        message(FATAL_ERROR "${val1} != ${val2}")
    endif()
endfunction(ASSERT_EQ)

function(ASSERT_LEN_EQ src_list src_size)
    list(LENGTH src_list len)
    ASSERT_EQ(${src_size} ${len})
endfunction(ASSERT_LEN_EQ)

ASSERT_EQ("${test.package.name}" "test-package")
ASSERT_EQ("${test.bin.lang}" "c++11")

ASSERT_LEN_EQ("${test.sys-dependencies.Threads.components}" 1)
ASSERT_EQ("${test.sys-dependencies.Threads.components}" "Threads")

ASSERT_LEN_EQ("${test.sys-dependencies.Boost.components}" 3)
ASSERT_EQ("${test.sys-dependencies.Boost.components}" "system;thread;program_options")

ASSERT_LEN_EQ("${test.dependencies.lib1.__keys__}" 1)
ASSERT_EQ("${test.dependencies.lib1.git}" "git@github.com:user1/lib1.git")

ASSERT_LEN_EQ("${test.dependencies.lib2.__keys__}" 2)
ASSERT_EQ("${test.dependencies.lib2.git}" "git@github.com:user2/lib2.git")
ASSERT_EQ("${test.dependencies.lib2.tag}" "v1.0.0")

ASSERT_LEN_EQ("${test.dependencies.lib3.__keys__}" 3)
ASSERT_EQ("${test.dependencies.lib3.git}" "git@github.com:user3/lib3.git")
ASSERT_EQ("${test.dependencies.lib3.tag}" "v2.0.0")
ASSERT_EQ("${test.dependencies.lib3.interface}" "include")

ASSERT_TRUE("${test.options.lib1.SOMETHING_ENABLED}")