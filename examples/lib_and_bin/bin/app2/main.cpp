#include <app.h> /// only from bin/app2
#include <iostream>
#include <mylib/mylib.h>

std::string app_name() { return "app2"; }

int main(int argc, char const *argv[]) {
  std::cout << "start app: " << app_name() << std::endl;
  std::cout << "version: " << mylib_version() << std::endl;
  return 0;
}
