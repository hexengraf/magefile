#include "progA/moduleA/componentA.hpp"
#include "progA/moduleA/moduleB/componentE.hpp"
#include "progA/moduleA/moduleB/componentF.hpp"
#include "progA/moduleA/moduleB/componentG.hpp"
#include "progA/moduleA/moduleB/componentH.hpp"

unsigned long long progA_moduleA_componentA() { return progA_moduleA_moduleB_componentE()+progA_moduleA_moduleB_componentF()+progA_moduleA_moduleB_componentG()+progA_moduleA_moduleB_componentH(); }
