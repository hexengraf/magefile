# define a library name
libs:=MyLibA
# point to files defining public API
MyLibA.sources:=$(wildcard src/libA/moduleA/*.cpp src/libA/moduleE/*.cpp src/libA/moduleI/*.cpp)
# filter out *.test.cpp files, since they're not part of the lib
MyLibA.sources:=$(filter-out %.test.cpp,$(MyLibA.sources))
# define one test binary for each module of the library
MyLibA.tests:=unitA unitE unitI
# use built-in function to list all *.test.cpp files inside each module for MyLibA
MyLibA.unitA.sources=$(call .gettestsources,MyLibA,src/libA/moduleA)
MyLibA.unitE.sources=$(call .gettestsources,MyLibA,src/libA/moduleE)
MyLibA.unitI.sources=$(call .gettestsources,MyLibA,src/libA/moduleI)

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
