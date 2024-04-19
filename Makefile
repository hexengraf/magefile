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

## To export '*.sources' variables to .mk files inside the root dir, define:
# exportsources:=1
## This is useful in projects where parallel compilation is limited by the discovery phase.

## The discovery phase and the compilation phase can be merged together by defining:
# mergephases:=1
## When 'exportsources' is not used, better parallelism might be achieved without 'mergephases',
## since only the discovery phase will be limited.

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
silent?=@
## Built-in variables and rules are disabled to provide a cleaner and more consistent behavior
MAKEFLAGS+=--no-builtin-rules --no-builtin-variables
## Bash is required for some of the rules
SHELL:=bash
## Some useful bash flags
.SHELLFLAGS:=-eu -o pipefail -c
############################################ Utilities #############################################
gettestsources=$(wildcard $(addsuffix .test.$(cpp),$(filter $(2)/%,$($(1).stems))))
############################################ Mode Setup ############################################
m.mutablevars:=cxx cxxflags ldflags ldlibs ar arflags
ifdef mode
$(foreach v,$(m.mutablevars),$(if $($(mode).$(v)),$(eval $(v):=$($(mode).$(v)))))
outdir:=$(outdir)/$(mode)
endif
############################################ Variables #############################################
m.mdir:=$(outdir)/.mg
m.objdir:=$(outdir)/objects
m.include:=-I$(incdir) -I$(srcdir)
m.alllibs:=$(libs) $(slibs) $(dlibs)
m.defaults:=$(binaries) $(m.alllibs)
m.subtests:=$(foreach t,$(m.defaults),$(addprefix $(t).,$($(t).tests)))
m.alltests:=$(tests) $(m.subtests)
m.targets:=$(subst tests,$(m.alltests),$(subst libs,$(m.alllibs),$(MAKECMDGOALS)))
m.targets:=$(filter $(m.defaults) $(m.alltests),$(or $(filter-out all,$(m.targets)),$(m.defaults)))
m.binaries:=$(filter $(binaries),$(m.targets))
m.slibs:=$(filter $(slibs) $(libs),$(m.targets))
m.dlibs:=$(filter $(dlibs) $(libs),$(m.targets))
m.trackers:=$(m.targets:%=$(m.mdir)/%.mk)
########################################### Tests Setup ############################################
m.tests:=$(filter $(tests),$(m.targets))
m.subtests:=$(filter $(m.subtests),$(m.targets))
ifneq ($(m.subtests),)
define m.setupsubtests=
ifeq ($(wildcard $(m.mdir)/$(2).mk),)
m.trackers:=$$(filter-out $(m.mdir)/$(2).$(1).mk,$$(m.trackers))
endif
m.trackers:=$(m.mdir)/$(2).mk $$(filter-out $(m.mdir)/$(2).mk,$$(m.trackers))
m.targets:=$(2) $$(filter-out $(2),$$(m.targets))
endef
$(foreach t,$(m.defaults),$(foreach s,$($(t).tests),$(eval $(call m.setupsubtests,$(s),$(t)))))
endif
$(foreach v,$(m.mutablevars),$(if $(tests.$(v)),$(foreach t,$(m.tests) $(m.subtests),\
$(if $($(t).$(v)),,$(eval $(t).$(v):=$(tests.$(v)))))))
######################################### Target to Output #########################################
$(foreach b,$(m.binaries),$(eval $(b).out:=$(outdir)/$(bindir)/$(b)))
$(foreach t,$(m.tests) $(m.subtests),$(eval $(t).out:=$(outdir)/$(testdir)/$(t)))
$(foreach l,$(m.slibs),$(eval $(l).out:=$(outdir)/$(libdir)/lib$(l).a))
$(foreach l,$(m.dlibs),$(eval $(l).out:=$(outdir)/$(libdir)/lib$(l).so $($(l).out)))
###################################### Commands & Extensions #######################################
m.cxx:=$(cxx) $(cxxflags) $(m.include)
define m.stemgrep=
grep -Eohw "($(srcdir)|$(incdir)|$(testdir))/[^ ]*.$(hpp)" $(1) | sort -u \
| sed -r -e "s:.$(hpp)::g" -e "s:$(incdir):$(srcdir):g"
endef
define m.setlocalvar=
$(3): $(1):=$($(2).$(1))

endef
define m.expandtracker=
$(1).sources:=$$($(1).sources) $$(wildcard $$(addsuffix .$(cpp),$$($(1).stems)))
$(1).sources+=$$(filter-out %.test.$(cpp),$$(wildcard $$(addsuffix .*.$(cpp),$$($(1).stems))))
$(1).sources:=$$(sort $$($(1).sources))
$(1).objects:=$$($(1).sources:%.$(cpp)=$(m.objdir)/%.o)
$(1).deplist:=$$($(1).sources:%.$(cpp)=$(m.mdir)/%.d)
$(1).markers:=$$($(1).deplist:d=$(1))
$$($(1).markers): $(m.mdir)/%.$(1): $(m.mdir)/%.d
	$$(file >$$@,)
$(foreach v,$(m.mutablevars),$(if $($(1).$(v)),$(call m.setlocalvar,$(v),$(1),$(2) $($(1).out))))
endef
define m.binrecipe=
mkdir -p $(@D)
$(m.cxx) $(ldflags) $(ldlibs) @$(m.mdir)/$*.in -o $@
$(info [ bin ] $@) $(file >$(m.mdir)/$*.in,$^)
endef
############################################## Rules ###############################################
.ONESHELL:
.DELETE_ON_ERROR:
.SECONDEXPANSION:
.PHONY: all libs tests clean distclean $(m.defaults) $(m.alltests) $(modes)

all: $(m.defaults)
libs: $(m.alllibs)
tests: $(m.alltests)
$(m.targets): %: $$($$*.out)

$(outdir)/$(bindir)/%: $$($$*.objects)
	$(silent)$(m.binrecipe) $(if $(exportsources),$(file >$*.mk,$*.sources:=$($*.sources)))

$(outdir)/$(testdir)/%: $$($$*.objects)
	$(silent)$(m.binrecipe)

$(outdir)/$(libdir)/lib%.so: $$($$*.objects)
	$(silent)mkdir -p $(@D)
	$(m.cxx) -shared $(ldflags) $(ldlibs) @$(m.mdir)/$*.in -o $@
	$(info [ lib ] $@) $(file >$(m.mdir)/$*.in,$^)

$(outdir)/$(libdir)/lib%.a: $$($$*.objects)
	$(silent)mkdir -p $(@D)
	$(ar) rc $(arflags) $@ $?
	$(info [ lib ] $@)

$(m.objdir)/%.o: %.$(cpp)
	$(silent)mkdir -p $(@D)
	$(m.cxx) -c $< -o $@
	$(info [ obj ] $< -> .o)

$(m.mdir)/%.d: %.$(cpp)
ifdef mergephases
	$(silent)mkdir -p {$(m.objdir),$(m.mdir)}/$(dir $*)
	$(m.cxx) -c $< -o $(m.objdir)/$*.o -MMD -MT "$(m.objdir)/$*.o $@" -MF $@
	$(info [ obj ] $< -> .o .d)
else
	$(silent)mkdir -p $(@D)
	$(m.cxx) $< -MM -MT "$(m.objdir)/$*.o $@" -MF $@
	$(info [ dep ] $< -> .d)
endif

$(m.trackers): $(m.mdir)/%.mk: $$($$*.markers)
	$(silent)mkdir -p $(@D)
	$(if $($*.ready),\
	$(call m.stemgrep,$(^:$*=d)) > $(m.mdir)/$*.txt,\
	$(call m.stemgrep,$(?:$*=d)) >> $(m.mdir)/$*.txt; sort -u -o $(m.mdir)/$*.txt $(m.mdir)/$*.txt)
	mapfile -t stems < $(m.mdir)/$*.txt
	count=$${#stems[@]}
	echo "$*.stems:=$${stems[@]}" > $@
	echo "$*.count:=$${count}" >> $@
	if [[ "$${count}" -le "$($*.count)" ]]; then echo "$*.ready:=1" >> $@; fi
	$(info [track] $@)

clean:
	$(silent)rm -rf $(outdir)/{$(srcdir),$(bindir)}
	$(info [ del ] $(outdir)/$(srcdir) $(outdir)/$(bindir))

distclean:
	$(silent)rm -rf $(outdir)
	$(info [ del ] $(outdir))

-include $(m.trackers)

ifdef exportsources
-include $(foreach t,$(m.targets),$(if $($(t).count),,$(t).mk))
endif

$(eval $(foreach t,$(m.targets),$(call m.expandtracker,$(t),$(m.mdir)/$(t).mk)))
-include $(foreach t,$(m.targets),$(if $($(t).ready),$($(t).deplist)))
