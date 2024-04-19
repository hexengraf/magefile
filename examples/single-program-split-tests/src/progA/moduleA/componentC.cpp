#include "progA/moduleA/componentC.hpp"
#include "progA/moduleA/moduleD/componentM.hpp"
#include "progA/moduleA/moduleD/componentN.hpp"
#include "progA/moduleA/moduleD/componentO.hpp"
#include "progA/moduleA/moduleD/componentP.hpp"

unsigned long long progA_moduleA_componentC() { return progA_moduleA_moduleD_componentM()+progA_moduleA_moduleD_componentN()+progA_moduleA_moduleD_componentO()+progA_moduleA_moduleD_componentP(); }
