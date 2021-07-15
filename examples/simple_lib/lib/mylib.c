#include <mylib/mylib.h>
#include <mylib/version.h>

const char* mylib_version()
{
    return MYLIB_VERSION;
}

const char *mylib_commit()
{
    return MYLIB_GIT_COMMIT;
}