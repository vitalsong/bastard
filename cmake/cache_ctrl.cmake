include_guard(GLOBAL)

include(${CMAKE_CURRENT_LIST_DIR}/fetch_helper.cmake)

find_package(Git QUIET REQUIRED)

# ------------------------------------------------------------------------------------
# check local git repo exists
function(RepoIsValid src_dir _valid)
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" rev-parse --is-inside-work-tree
        WORKING_DIRECTORY ${src_dir}
        OUTPUT_VARIABLE stdout
        OUTPUT_STRIP_TRAILING_WHITESPACE
        RESULT_VARIABLE exit_code
    )

    set(valid FALSE)
    if (exit_code EQUAL 0)
        set(valid TRUE)
    endif()
    set(${_valid} ${valid} PARENT_SCOPE)
endfunction(RepoIsValid)

# ------------------------------------------------------------------------------------
function(CreateGitMirror src_dir url)
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" clone --mirror ${url} ${src_dir}
        OUTPUT_VARIABLE stdout
        OUTPUT_STRIP_TRAILING_WHITESPACE
        RESULT_VARIABLE exit_code
    )
endfunction(CreateGitMirror)

# ------------------------------------------------------------------------------------
function(UpdateGitMirror src_dir)
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" remote update
        WORKING_DIRECTORY ${src_dir}
        OUTPUT_VARIABLE stdout
        OUTPUT_STRIP_TRAILING_WHITESPACE
        RESULT_VARIABLE exit_code
        TIMEOUT 5
    )
endfunction()

# ------------------------------------------------------------------------------------
function(GitCommitContains src_dir commit_id _contains)
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" branch --contains ${commit_id}
        WORKING_DIRECTORY ${src_dir}
        OUTPUT_VARIABLE stdout
        OUTPUT_STRIP_TRAILING_WHITESPACE
        RESULT_VARIABLE exit_code
    )

    set(contains FALSE)
    if (exit_code EQUAL 0)
        set(contains TRUE)
    endif()
    set(${_contains} ${contains} PARENT_SCOPE)
endfunction(GitCommitContains)

# ------------------------------------------------------------------------------------
# check/update local mirror and return dir
function(UpdateGlobalDepsCache url commit _cache_dir)
    set(home $ENV{HOME})
    set(cache_dir "${home}/.cache/bastard")

    # name by url
    set(name ${url})
    string(REGEX REPLACE "^git@" "" name ${name})
    string(REGEX REPLACE "^https://" "" name ${name})
    string(REGEX REPLACE "^http://" "" name ${name})
    string(REGEX REPLACE ":" "/" name ${name})
    string(MD5 name ${name})

    # check dir exists
    set(dep_dir "${cache_dir}/${name}")
    if (NOT EXISTS "${dep_dir}")
        file(MAKE_DIRECTORY "${dep_dir}")
    endif()

    # check repo exists
    RepoIsValid(${dep_dir} valid_repo)
    if (NOT valid_repo)
    message(STATUS "Create local mirror: ${dep_dir}")
        CreateGitMirror(${dep_dir} ${url})
    endif()

    # update mirror
    GitCommitContains(${dep_dir} ${commit} commit_exists)
    if (NOT commit_exists)
        message(STATUS "Updating local mirror: ${dep_dir}")
        UpdateGitMirror(${dep_dir})
    endif()

    set(${_cache_dir} ${dep_dir} PARENT_SCOPE)
endfunction(UpdateGlobalDepsCache)

