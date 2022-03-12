# bastard
![testing](https://github.com/vitalsong/bastard/actions/workflows/blank.yml/badge.svg)

![bastard](https://user-images.githubusercontent.com/43682603/125679677-645bafd4-fa57-4d9b-a33b-0ccadda39db3.png)

## Another package manager
Cmake package manager in rust-cargo style
- unloading and caching of dependencies;
- formalization of the project structure and configuration;
- semantic version control;
- automatic target generation (lib/bin/test/bench);
- cross-compilation;
- post-commit hook for clang-format
- pre-commit hook for auto-tagg by version

## Requirements
* CMake >= 3.10
* git
* python3 (optional for git-hooks)

## Integration
Copy and include bastard_setup.cmake file in CMakeLists.txt:
```cmake
cmake_minimum_required(VERSION 3.10)
include(cmake/bastard_setup.cmake)
bastard_setup()
project(${BASTARD_PACKAGE_NAME})
```

Run cmake
```sh
cd build && cmake ..
```

Project initialization will begin. Bastard's files will be unloaded into the .deps directory as an simple dependence. Next, config of the package will be unloaded from bastard.toml file and all build targets will be generated.

Project initialization begins after calling the bastard_setup() function, so any global specific options must be set higher.

## TOML description
* [package]
    * ```name: str``` Package name (must be unique for build)
    * ```authors: list[str]``` List of authors
    * ```autogen-defines: bool``` Defines autogeneration from options (with prefix) 
    * ```version: str``` Package version (vX.X.X)
    * ```lang: str``` Default lang for all targets of package ```c90|c99|c++98|c++11|c++14|c++17|c++20```
    * ```system: [str]``` Default platform specification (usually ```Unix | Windows | Generic```)
    * ```processor: [str]``` Default processor specification (see. CMAKE_SYSTEM_PROCESSOR)

* [dependencies] General package dependencies
    * ```<package>: str``` Package name
        * ```git: str``` Git url (```git@``` or ```http```)
        * ```tag: str``` Git tag (format ```vX.X.X```)
        * ```branch: str``` Git branch
        * ```rev: str``` Git hash
        * ```links: list[str]``` List of libraries for links. Only for non-bastard packages, cause bastard package can contain only single library.
        * ```path: str``` Path for local dependency
        * ```interface: str``` Path for header library files
        * ```system: [str]``` Platform specification (see [package.system])
        * ```processor: [str]``` Processor specification (see [package.processor])
* [dev-dependencies] Developers dependencies
    * Similar to ```[dependencies]```
* [sys-dependencies] System dependencies (cmake find_package)
    * ```<package>: str``` Package name (example Thread, Boost)
    * ```components: list[str]``` Components list
    * ```links: list[str]``` Library list
* [lib] General package library
    * ```name: str``` Library name
    * ```lang: str``` Using language (see. package.lang)
    * ```include: [str]``` Include files relative by ```lib``` dir (example ```[*.cpp, *.c]```)
    * ```exclude: [str]``` Exclude files (see ```include```)
* [[bin]] Package binaries
    * ```name: str``` Target name (or path for default, if ```path``` section not exist)
    * ```path: str``` Path of file/directory for build
    * ```lang: str``` Using language (see. package.lang)
    * ```include: [str]``` Include files
    * ```exclude: [str]``` Exclude files
    * ```include``` и ```exclude``` relative ```bin/name``` or ```bin``` directory
    * ```console: bool``` If application is console (by default true)
* [[test]] Package test-binaries
    * Similar to ```[bin]```
* [[example]] Package examples
    * Similar to ```[bin]```
* [options] CMake variables for targets (legacy)
    * ```<package> = { <name>=<value> }```

## Project structure

By default, if the sections ```[lib]``` ```[[bin]]``` are not specified, the legacy agreement is accepted when all dependencies are connected manually in CMakeLists.txt. For legacy mode, it is possible to use any project structure, however, the bastard functionality is limited only to uploading dependencies and setting options. If you follow the project structure agreement, then the package configuration will occur automatically.

### library + test
```
-- cmake/
-- include/
---- mylib/
------ mylib.h
-- lib/
---- mylib.cpp
-- tests/
---- main.cpp
-- bastard.toml
-- CMakeLists.txt
```

### binaries
```
-- cmake/
-- bin/
---- app1/
------ main.cpp
---- app2/
------ main.cpp
-- bastard.toml
-- CMakeLists.txt
```

### lib + binaries + tests
```
-- cmake/
-- bin/
---- app1/
------ main.cpp
---- app2/
------ main.cpp
-- include/
---- mylib/
------ mylib.h
-- lib/
---- mylib.cpp
-- tests/
---- test1.cpp
---- test2.cpp
-- bastard.toml
-- CMakeLists.txt
```

to be continued...
