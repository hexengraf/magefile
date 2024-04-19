#include "libA/moduleI/componentBI.hpp"
#include "libA/moduleI/moduleL/componentBS.hpp"
#include "libA/moduleI/moduleL/componentBT.hpp"
#include "libA/moduleI/moduleL/componentBU.hpp"
#include "libA/moduleI/moduleL/componentBV.hpp"

unsigned long long progA_moduleI_componentBI() { return progA_moduleI_moduleL_componentBS()+progA_moduleI_moduleL_componentBT()+progA_moduleI_moduleL_componentBU()+progA_moduleI_moduleL_componentBV(); }
