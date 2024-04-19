# define a binary name
binaries:=MyProgA
# point to file with the main function
MyProgA.sources:=src/progA/main.cpp

# define a binary for unit tests
tests:=unit
# list all test files from the 'tests' directory
unit.sources=$(shell find tests/ -name "*.cpp" 2>/dev/null)

# use GCC to compile
cxx:=g++
# enable -O3 in default build
cxxflags:=-O3
# define different flags for 'debug' compilation mode
debug.cxxflags:=-Og -Wall

# add additional flags required to compile the tests using gtest
tests.ldlibs=$(shell pkg-config --libs gtest_main)
tests.cxxflags=$(cxxflags) $(shell pkg-config --cflags gtest_main)

# include magefile
-include ../../Makefile
