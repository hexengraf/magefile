################################# <github.com/hexengraf/magefile> ##################################
# Copyright (c) 2017-2024 Marleson Graf

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute,
# sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
# OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

######################################## Project Variables #########################################
## All non-test binaries should be defined in the 'binaries' variable, e.g.:
# binaries:=progA progB
## The resulting binaries will be saved in '$(outdir)/$(bindir)'.

## For each binary, define '<binary>.sources' containing at least the file with main(), e.g.:
# progA.sources:=src/progA/main.cpp
# progB.sources:=src/progB/main.cpp
## The discovery phase will automatically expand '.sources' to include all required sources.

## Similarly, libraries are defined in the 'libs', 'slibs', and 'dlibs' variables, where:
## - 'libs' contain libraries which should be compiled as both, static and dynamic libraries.
## - 'slibs' contain libraries which should only be compiled as static libraries.
## - 'dlibs' contain libraries which should only be compiled as dynamic libraries.
## A library defined in 'libs' should not appear in the other two variables. E.g.:
# libs:=someC someD
# slibs:=someE
# dlibs:=someF
## Each name declared in these variables will be automatically prefixed with 'lib' and postfixed
## with the appropriate extension (.a or .so).
## The resulting libraries will be saved in '$(outdir)/$(libdir)'.

## For each library, its sources are defined in the same manner as binaries:
# someC.sources:=<sources defining public API>
# someD.sources:=<sources defining public API>
# someE.sources:=<sources defining public API>
# someF.sources:=<sources defining public API>
## As long as .sources contain the entire public API, the rest of the sources will be automatically
## tracked by the discovery phase.

## There are two flavors of tests. Both types are saved in '$(outdir)/$(testdir)'.
## The first one is defined in 'tests', like follows:
# tests:=testX testY testZ
## It follows the same syntax and logic as binaries and libraries declaration.

## The second flavor of tests is declared as part of an existing binary/library. The main difference
## is that it creates a dependency between the tests and the binary/library: the discovery phase of
## the binary/library must happen before the tests can be compiled. This is particularly useful when
## using Merged Test Placement to define unit tests.
## For instance, to compile the unit tests of 'progA', first declare the test binary:
# progA.tests:=unit
## The resulting binary will be named '<binary name>.<test name>' ('progA.unit' in this case).
## Now, a predefined function can be used to list all '*.test.$(cpp)' files related to 'progA':
# progA.unit.sources=$(call gettestsources,progA,$(srcdir))

## The following variables are used by the rules and can be freely modified:
cxx?=g++
cxxflags?=
ldflags?=
ldlibs?=
ar?=ar
arflags?=

## It is possible to set target-specific values for the variables above, e.g.:
# progA.cxxflags:=-O3
# someD.cxx:=clang++
## Don't use target-specific variables if multiple targets are sharing the same objects.
## It is also possible to extend the variable instead of fully replacing its value, e.g.:
# progA.cxxflags=$(cxxflags) -O3
## Note that '=' is used instead of ':=' to be compatible with compilation modes (see below).

## Another way to override variables is by defining compilation modes. A variable can be redefined
## for a given mode as follows:
# debug.cxxflags:=-Wall -g
## To use a compilation mode, pass mode=<mode name> in the make command, e.g.: `make mode=debug`
## Each mode will result in its own subdirectory inside '$(outdir)', e.g. '$(outdir)/debug'.

## Beyond target-specific values and compilation modes, there are two more sets of values that can
## be used as global fallback for libraries and tests. They can be used as follows:
# tests.ldlibs=$(lDLIBS) $(shell pkg-config --libs gtest_main)
# tests.cxxflags=$(cxxflags) $(shell pkg-config --cflags gtest_main)
# libs.cxxflags=$(cxxflags) -DSOMELIBFLAG

## By default, discovery and compilation phases will be performed together. Comment out the line
## below or define '.mergephases' as empty to split discovery and compilation phases.
.mergephases?=Y
## If parallelism is low, try disabling this option or enabling the option below.

## To save '*.sources' variables into .mk files inside the root dir, define '.savelists' with a
## non-empty value, e.g.:
# .savelists:=Y
## This is useful in projects where parallel compilation is limited by the discovery phase.
####################################################################################################
########################### Below here you don't need to change anything ###########################
########################################## Project Layout ##########################################
# Default values follow a subset of The Pitchfork Layout (PFL).
outdir?=build
srcdir?=src
incdir?=include
testdir?=tests
# bindir path is implicitly relative to outdir
bindir?=bin
# libdir path is implicitly relative to outdir
libdir?=lib
## C++ suffixes
cpp?=cpp
hpp?=hpp
######################################## Control Variables #########################################
## Comment out this variable to print all recipes that are being executed:
.silent?=@
## Built-in variables and rules are disabled to provide a cleaner and more consistent behavior
MAKEFLAGS+=--no-builtin-rules --no-builtin-variables
## Bash is required for some of the rules
SHELL:=bash
## Some useful bash flags
.SHELLFLAGS:=-eu -o pipefail -c
############################################ Utilities #############################################
.gettestsources=$(wildcard $(filter $2/%,$($1.testpatterns)))
############################################ Mode Setup ############################################
.mutablevars:=cxx cxxflags ldflags ldlibs ar arflags
ifdef mode
$(foreach v,$(.mutablevars),$(if $($(mode).$v),$(eval $v:=$($(mode).$v))))
outdir:=$(outdir)/$(mode)
endif
######################################### Common Variables #########################################
.mdir:=$(outdir)/.mg
.objdir:=$(outdir)/objects
.all:=$(binaries) $(libs) $(slibs) $(dlibs)
tests+=$(foreach t,$(.all),$(addprefix $t.,$($t.tests)))
.targets:=$(filter $(.all) $(tests) all libs tests,$(or $(MAKECMDGOALS),all))
.targets:=$(subst tests,$(tests),$(.targets))
.targets:=$(subst all,$(.all),$(subst libs,$(libs) $(slibs) $(dlibs),$(.targets)))
.binaries:=$(filter $(binaries),$(.targets))
.slibs:=$(filter $(slibs) $(libs),$(.targets))
.dlibs:=$(filter $(dlibs) $(libs),$(.targets))
.tests:=$(filter $(tests),$(.targets))
########################################### Tests Setup ############################################
ifneq ($(.tests),)
$(foreach v,$(.mutablevars),$(if $(tests.$v),$(foreach t,$(.tests),$(eval $t.$v?=$(tests.$v)))))
.parents:=$(foreach t,$(.all),$(if $(filter $t.%,$(.tests)),$t))
.targets:=$(.parents) $(filter-out $(.parents),$(.targets))
endif
####################################### Tracker Definitions ########################################
define .setlocalvar=
$(.mdir)/$1.mk $1: $2:=$($1.$2)

endef
define .expandtarget=
$1.patterns=$$(patsubst $(incdir)/%,$(srcdir)/%,$$($1.headers:.$(hpp)=[.,.*.]$(cpp)))
$1.testpatterns=$$(patsubst $(incdir)/%,$(srcdir)/%,$$($1.headers:.$(hpp)=.test.$(cpp)))
$1.sources:=$$(sort $$($1.sources) $$(filter-out %.test.$(cpp),$$(wildcard $$($1.patterns))))
$1.objects=$$($1.sources:%.$(cpp)=$(.objdir)/%.o)
$1.markers:=$$($1.sources:%.$(cpp)=$(.mdir)/%.$1)
$$($1.markers): $(.mdir)/%.$1: $(.mdir)/%.d
	$$(file >$$@,)
$(foreach v,$(.mutablevars),$(if $($1.$v),$(call .setlocalvar,$1,$v)))
endef
.expandtargets=$(foreach t,$(.targets),$(call .expandtarget,$t))
.trackers:=$(.targets:%=$(.mdir)/%.mk)
-include $(.trackers)
-include $(if $(.savelists),$(foreach t,$(.targets),$(if $($t.count),,$t.mk)))
############################################# Commands #############################################
.cxx=$(cxx) $(cxxflags) -I$(incdir) -I$(srcdir)
.stemgrep=grep -Eoh "($(srcdir)|$(incdir)|$(testdir))/[^ ]*.$(hpp)" $1 | sort -u
########################################## Canned Recipes ##########################################
define .binrecipe=
mkdir -p $(@D)
$(.cxx) $(cxxflags) $(ldflags) $(ldlibs) @$(.mdir)/$*.in -o $@
$(info [ bin ] $@) $(file >$(.mdir)/$*.in,$^)
endef
############################################## Rules ###############################################
.ONESHELL:
.DELETE_ON_ERROR:
.SECONDEXPANSION:
.PHONY: all libs tests clean distclean $(.all) $(tests)

all: $(.all)
libs: $(libs) $(slibs) $(dlibs)
tests: $(tests)
$(binaries): %: $(outdir)/$(bindir)/%
$(tests): %: $(outdir)/$(testdir)/%
$(libs) $(slibs): %: $(outdir)/$(libdir)/lib%.a
$(libs) $(dlibs): %: $(outdir)/$(libdir)/lib%.so

$(eval $(.expandtargets))

$(outdir)/$(bindir)/%: $$($$*.objects)
	$(.silent)$(.binrecipe) $(if $(.savelists),$(file >$*.mk,$*.sources:=$($*.sources)))

$(outdir)/$(testdir)/%: $$($$*.objects)
	$(.silent)$(.binrecipe)

$(outdir)/$(libdir)/lib%.so: $$($$*.objects)
	$(.silent)mkdir -p $(@D)
	$(.cxx) -shared $(ldflags) $(ldlibs) @$(.mdir)/$*.in -o $@
	$(info [ lib ] $@) $(file >$(.mdir)/$*.in,$^)

$(outdir)/$(libdir)/lib%.a: $$($$*.objects)
	$(.silent)mkdir -p $(@D)
	$(ar) rc $(arflags) $@ $?
	$(info [ lib ] $@)

$(.objdir)/%.o: %.$(cpp)
	$(.silent)mkdir -p $(@D)
	$(.cxx) -c $< -o $@
	$(info [ obj ] $< -> .o)

$(.mdir)/%.d: %.$(cpp)
ifneq ($(.mergephases),)
	$(.silent)mkdir -p {$(.objdir),$(.mdir)}/$(dir $*)
	$(.cxx) -c $< -o $(.objdir)/$*.o -MMD -MT "$(.objdir)/$*.o $@" -MF $@
	$(info [ obj ] $< -> .o .d)
else
	$(.silent)mkdir -p $(@D)
	$(.cxx) $< -MM -MT "$(.objdir)/$*.o $@" -MF $@
	$(info [ dep ] $< -> .d)
endif

$(.trackers): $(.mdir)/%.mk: $$($$*.markers)
	$(.silent)mkdir -p $(@D)
	$(if $?,$(if $($*.ready),\
	$(call .stemgrep,$(^:.$*=.d)) > $(.mdir)/$*.txt,\
	$(call .stemgrep,$(?:.$*=.d)) >> $(.mdir)/$*.txt; sort -u -o $(.mdir)/$*.txt $(.mdir)/$*.txt))
	if [[ -f $(.mdir)/$*.txt ]]; then
		mapfile -t headers < $(.mdir)/$*.txt
		echo "$*.headers:=$${headers[@]}" > $@
		if [[ "$${#headers[@]}" -le "$(words $($*.headers))" ]]; then echo "$*.ready:=1" >> $@; fi
	fi
	$(info [track] $@)

clean:
	$(.silent)rm -rf $(.objdir) $(outdir)/$(bindir)
	$(info [ del ] $(.objdir) $(outdir)/$(bindir))

distclean:
	$(.silent)rm -rf $(outdir)
	$(info [ del ] $(outdir))

-include $(foreach t,$(.targets),$(if $($t.ready),$($t.sources:%.$(cpp)=$(.mdir)/%.d)))
