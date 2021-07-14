include_guard(GLOBAL)

# check git client hooks for autotag from version
function(CheckPostCommitHook path)
    # TODO: check script equal (or format/version?)
    file(COPY "${BASTARD_DIR}/hooks/post-commit" "${BASTARD_DIR}/hooks/bastard-post-commit" 
        DESTINATION "${path}/.git/hooks"
        FILE_PERMISSIONS OWNER_EXECUTE OWNER_READ
    )
endfunction(CheckPostCommitHook)
