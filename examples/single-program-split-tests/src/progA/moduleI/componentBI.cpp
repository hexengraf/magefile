#include "progA/moduleI/componentBI.hpp"
#include "progA/moduleI/moduleL/componentBS.hpp"
#include "progA/moduleI/moduleL/componentBT.hpp"
#include "progA/moduleI/moduleL/componentBU.hpp"
#include "progA/moduleI/moduleL/componentBV.hpp"

unsigned long long progA_moduleI_componentBI() { return progA_moduleI_moduleL_componentBS()+progA_moduleI_moduleL_componentBT()+progA_moduleI_moduleL_componentBU()+progA_moduleI_moduleL_componentBV(); }
