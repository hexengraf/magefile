#include "progA/moduleI/componentBG.hpp"
#include "progA/moduleI/moduleJ/componentBK.hpp"
#include "progA/moduleI/moduleJ/componentBL.hpp"
#include "progA/moduleI/moduleJ/componentBM.hpp"
#include "progA/moduleI/moduleJ/componentBN.hpp"

unsigned long long progA_moduleI_componentBG() { return progA_moduleI_moduleJ_componentBK()+progA_moduleI_moduleJ_componentBL()+progA_moduleI_moduleJ_componentBM()+progA_moduleI_moduleJ_componentBN(); }
