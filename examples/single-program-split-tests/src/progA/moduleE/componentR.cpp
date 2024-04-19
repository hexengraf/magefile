#include "progA/moduleE/componentR.hpp"
#include "progA/moduleE/moduleG/componentY.hpp"
#include "progA/moduleE/moduleG/componentZ.hpp"
#include "progA/moduleE/moduleG/componentBA.hpp"
#include "progA/moduleE/moduleG/componentBB.hpp"

unsigned long long progA_moduleE_componentR() { return progA_moduleE_moduleG_componentY()+progA_moduleE_moduleG_componentZ()+progA_moduleE_moduleG_componentBA()+progA_moduleE_moduleG_componentBB(); }
