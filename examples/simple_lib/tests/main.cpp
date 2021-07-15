#include <gtest/gtest.h>
#include <mylib/mylib.h>

TEST(Mylib, Version) {
  std::cout << "version: " << mylib_version() << std::endl;
}

TEST(Mylib, Commit) {
  std::cout << "commit: " << mylib_commit() << std::endl;
}

int main(int argc, char *argv[]) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}