#include "libA/moduleA/componentC.hpp"
#include "libA/moduleA/moduleD/componentM.hpp"
#include "libA/moduleA/moduleD/componentN.hpp"
#include "libA/moduleA/moduleD/componentO.hpp"
#include "libA/moduleA/moduleD/componentP.hpp"

unsigned long long progA_moduleA_componentC() { return progA_moduleA_moduleD_componentM()+progA_moduleA_moduleD_componentN()+progA_moduleA_moduleD_componentO()+progA_moduleA_moduleD_componentP(); }
