#include "libA/moduleI/componentBG.hpp"
#include "libA/moduleI/moduleJ/componentBK.hpp"
#include "libA/moduleI/moduleJ/componentBL.hpp"
#include "libA/moduleI/moduleJ/componentBM.hpp"
#include "libA/moduleI/moduleJ/componentBN.hpp"

unsigned long long progA_moduleI_componentBG() { return progA_moduleI_moduleJ_componentBK()+progA_moduleI_moduleJ_componentBL()+progA_moduleI_moduleJ_componentBM()+progA_moduleI_moduleJ_componentBN(); }
