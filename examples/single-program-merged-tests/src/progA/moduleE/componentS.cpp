#include "progA/moduleE/componentS.hpp"
#include "progA/moduleE/moduleH/componentBC.hpp"
#include "progA/moduleE/moduleH/componentBD.hpp"
#include "progA/moduleE/moduleH/componentBE.hpp"
#include "progA/moduleE/moduleH/componentBF.hpp"

unsigned long long progA_moduleE_componentS() { return progA_moduleE_moduleH_componentBC()+progA_moduleE_moduleH_componentBD()+progA_moduleE_moduleH_componentBE()+progA_moduleE_moduleH_componentBF(); }
