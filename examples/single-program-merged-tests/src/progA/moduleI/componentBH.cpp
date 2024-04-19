#include "progA/moduleI/componentBH.hpp"
#include "progA/moduleI/moduleK/componentBO.hpp"
#include "progA/moduleI/moduleK/componentBP.hpp"
#include "progA/moduleI/moduleK/componentBQ.hpp"
#include "progA/moduleI/moduleK/componentBR.hpp"

unsigned long long progA_moduleI_componentBH() { return progA_moduleI_moduleK_componentBO()+progA_moduleI_moduleK_componentBP()+progA_moduleI_moduleK_componentBQ()+progA_moduleI_moduleK_componentBR(); }
