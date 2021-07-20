#include <iostream>
#include <mylib/mylib.h>

int main(int argc, char const *argv[]) {
  std::cout << "start app: app3" << std::endl;
  std::cout << "version: " << mylib_version() << std::endl;
  return 0;
}
