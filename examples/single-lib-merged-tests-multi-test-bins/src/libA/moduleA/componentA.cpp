#include "libA/moduleA/componentA.hpp"
#include "libA/moduleA/moduleB/componentE.hpp"
#include "libA/moduleA/moduleB/componentF.hpp"
#include "libA/moduleA/moduleB/componentG.hpp"
#include "libA/moduleA/moduleB/componentH.hpp"

unsigned long long progA_moduleA_componentA() { return progA_moduleA_moduleB_componentE()+progA_moduleA_moduleB_componentF()+progA_moduleA_moduleB_componentG()+progA_moduleA_moduleB_componentH(); }
