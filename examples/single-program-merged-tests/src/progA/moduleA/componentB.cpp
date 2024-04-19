#include "progA/moduleA/componentB.hpp"
#include "progA/moduleA/moduleC/componentI.hpp"
#include "progA/moduleA/moduleC/componentJ.hpp"
#include "progA/moduleA/moduleC/componentK.hpp"
#include "progA/moduleA/moduleC/componentL.hpp"

unsigned long long progA_moduleA_componentB() { return progA_moduleA_moduleC_componentI()+progA_moduleA_moduleC_componentJ()+progA_moduleA_moduleC_componentK()+progA_moduleA_moduleC_componentL(); }
