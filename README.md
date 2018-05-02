# MaGEfile - the official MaGES build system
MaGEfile is a generic, non-recursive makefile designed for C++ projects. Its main goal is to provide a build system which requires a minimum amount of manual configuration, using automatic detection of dependencies and probing all necessary objects to link each executable specified by the user. A further goal is to create a well-defined structure to include new functionalities within the makefile, without directly editing its base file. The core ideas and source of inspiration come mostly from [this](http://aegis.sourceforge.net/auug97.pdf) insightful paper.

## How to use
The functionalities of this makefile will be devided in Configuration, Building and Diagnosis. Currently, there is no support to diagnosis and configuration only addresses which variables you should consider to change manually. Support to diagnosis and more complex, automated configuration is expected to be added some time in the future.

### Configuration
All variables of interest to the user are placed inside a section named __PROJECT VARIABLES__, quite visible. I may change this extravagant style later, but for now it is what it is. Most of the variables are straight-forward. The meaning of each one is listed bellow:
* __HEADER_SUFFIXES__: the suffixes that are accepted in header filenames. It affects the automatic detection of necessary object files, so make sure you don't forget to add any unorthodox suffix you may come to use. SOURCE_SUFFIXES will be added in later development, for now it only supports .cpp files (unless you search for all occurrencies and change them);
* Variables terminated in __DIR__ specifies the directories of the project. At the moment, only one directory is supported for each variable, but with any depth of subdirectories;
    * __SRCDIR__: the sources directory (i.e., where you placed your implementation files);
    * __INCDIR__: the headers directory (i.e., where you placed your interface/definition files). If you prefer to organize your code in modules, each module correponding to a directory with both, headers and implementations, you can emulate this by setting SRCDIR and INCDIR to the same directory (project's root (.), for instance);
    * __OBJDIR__: the objects directory (i.e., where the building rules places all generated objects for the project). Usually, you will not need to change this;
    * __TSTDIR__: the tests directory (i.e., where you put your test files, if any - good practices, dude). __Notice__: you don't need to remove the default value if you're not going to actually use it;
    * __DEPDIR__: the dependencies directory (i.e., where the building rules places all aditional rules to track dependencies). You only need to change this in case you already use a directory with same name;
* __MAINFILES__: the files that contains the main entry to a program (i.e., the main function of C++). Through each of this files the makefile will know which objects it should link to create a program. This variable is intrinsically related to __BINARIES__;
* __BINARIES__: for each file with a main function specified in __MAINFILES__, the makefile expects a corresponding binary in this variable. The relation is constructed based on the order of files, where the first file in __MAINFILES__ is related to the first binary in __BINARIES__, the second file with the second binary, and so on. __Notice__: you need to specify the relative path from the root of the project in both variables;
* __CXXFLAGS__: flags to give to the C++ compiler;
* __LDFLAGS__: "Extra flags to give to compilers when they are supposed to invoke the linker, ‘ld’, such as -L. Libraries (-lfoo) should be added to the LDLIBS variable instead" - [GNU Make Manual](https://www.gnu.org/software/make/manual/make.html);
* __LDLIBS__: "Library flags or names given to compilers when they are supposed to invoke the linker, ‘ld’. LOADLIBES is a deprecated (but still supported) alternative to LDLIBS. Non-library linker flags, such as -L, should go in the LDFLAGS variable." - [GNU Make Manual](https://www.gnu.org/software/make/manual/make.html);
* __INCLUDE__: the directories that should be added with -I flag. The __INCDIR__ is added by default;
* __TMAINFILES__: see __MAINFILES__, applied to tests;
* __TBINARIES__: see __BINARIES__, applied to tests;
* __TCXXFLAGS__: see __CXXFLAGS__, applied to tests;
* __TLDFLAGS__: see __LDFLAGS__, applied to tests;
* __TLDLIBS__: see __LDLIBS__, applied to tests;
* __TINCLUDE__: see __INCLUDE__, applied to tests;
* __DEBUG__: if different of 0, removes all supressing of commands echoing;

All the flags and libs specific to tests are appended to the flags and libs of the project.

### Building
The basic goals supported so far by this makefile are listed bellow:
* __all__: default goal. Compiles and links all binaries listed in __BINARIES__;
* __tests__: compiles and links all binaries listed in __TBINARIES__;
* __clean__: removes all generated objects and binaries;
* __distclean__: executes __clean__ and removes all generated dependencies as well;

Besides these goals, the makefile autogenerate goals with the name of each binary (from both, __BINARIES__ and __TBINARIES__). It is also possible to give a specific name of a file, which will result in the execution of any rule to create or update it (if necessary).

### Diagnosis
Not present in this Plane of Existence, __yet__.

## Requirements
* updated version of GNU Make (tested with 4.2.1, probably works with any version above 3.80);
* compiler with support to dependency-related flags (used to generate dependency files); GCC/g++ is recommended;
