# Magefile - (mostly) automatic makefile template
Magefile is a generic, non-recursive makefile template designed for C++ projects. Its main goal is to provide a template that is easy to use and requires the minimum amount of manual configuration. It was born from my despise of having to manually list source files to compile a program. IMHO this should be an option of the compiler, even more so after the introduction of modules, but dreams can only be dreams.

What Magefile supports:
* Minimal initial configuration to get things going.
* Almost no manual listing of source files (most of them are automatically discovered).
* Multiple targets within the same project.
* Three types of targets: binaries/programs, libraries, and tests.
* Target-specific flags.
* Compilation modes (to define different sets of flags, e.g. debug, testing, etc).
* Parallel compilation.
* Header dependencies tracking.
* More features can be built on top of it according to one's needs.

What Magefile doesn't support:
* External dependency resolution (it will require a separate solution).
* Projects non-compliant with a subset of the project layout conventions outlined by [Pitchfork](https://github.com/vector-of-bool/pitchfork).
* C++20 Modules (I still have to play around to check if the same can be achieved for modules).

A minimal configuration is defined as:
* A name for the target (be it a program, a library, or a test).
* One or more sources from which the rest of required sources can be discovered (i.e. the file implementing the main function for a binary or the files implementing the public API for a library).
* Compiler and flags.

## Requirements
About the environment:
* Linux.
* Bash version 4 or superior (although it is possible to adapt the rules to use POSIX compliant shells).
* A modern version of GNU Make (GNU Make extensions are used, tested with 4.4.1).
* A compiler capable of generating dependency files (-MM or -MMD flags).

About the project layout:
* Follow the [Pitchfork](https://github.com/vector-of-bool/pitchfork)'s layout conventions defined for src/include directories ('submodules' layout is currently unsupported).
    * It works with either the Separate or the Merged Header Placements (i.e. if include/ is used or not).
* Do not use spaces for file and directory names.

## How to use
Copy Makefile to your project and edit it directly, or rename it to something like magefile.mk and include it at the end of your Makefile.

As a simple example, let's say we have a program called 'programA'. First, we need to define it in the `binaries` variable:
```make
binaries:=programA
```
Next, we need to provide the file with the main function:
```make
programA.sources:=src/programA/main.cpp
```
And define the compiler and required flags:
```make
cxx:=g++
cxxflags:=-Wall -std=c++17
```
With this you're pretty much good to go.

If you're using Merged Test Placement for unit tests and auto-generated main with `gtest_main`, a very easy way to setup it is as follows:
```make
programA.tests=unit
programA.unit.sources=$(call gettestsources,programA,$(srcdir))
tests.ldlibs=$(ldlibs) $(shell pkg-config --libs gtest_main)
tests.cxxflags=$(cxxflags) $(shell pkg-config --cflags gtest_main)
```

For more detailed information, check the Makefile itself and the `examples` folder.

Magefile provides the following goals:
* `all`: default goal, builds all binaries and libraries.
* `libs`: builds libs only.
* `tests`: builds all tests.
* `<target-name>`: builds the provided target (one of the names defined in either `binaries`, `libs`, `slibs`, `dlibs`, or `tests`).
* `clean`: deletes all files produced by the build (except dependency files).
* `distclean`: deletes all files produced by the build (including dependency files).
