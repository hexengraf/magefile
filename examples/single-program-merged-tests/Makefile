# define the binary name
binaries:=MyProgA
# point to file with the main function
MyProgA.sources:=src/progA/main.cpp
# define the binary for unit tests
MyProgA.tests:=unit
# use built-in function to list all *.test.cpp files inside src/ for MyProgA
MyProgA.unit.sources=$(call .gettestsources,MyProgA,src)

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
