#include "libA/moduleA/componentB.hpp"
#include "libA/moduleA/moduleC/componentI.hpp"
#include "libA/moduleA/moduleC/componentJ.hpp"
#include "libA/moduleA/moduleC/componentK.hpp"
#include "libA/moduleA/moduleC/componentL.hpp"

unsigned long long progA_moduleA_componentB() { return progA_moduleA_moduleC_componentI()+progA_moduleA_moduleC_componentJ()+progA_moduleA_moduleC_componentK()+progA_moduleA_moduleC_componentL(); }
