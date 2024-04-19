#include "progA/moduleA/componentA.hpp"
#include "progA/moduleA/componentB.hpp"
#include "progA/moduleA/componentC.hpp"
#include "progA/moduleA/componentD.hpp"
#include "progA/moduleE/componentQ.hpp"
#include "progA/moduleE/componentR.hpp"
#include "progA/moduleE/componentS.hpp"
#include "progA/moduleE/componentT.hpp"
#include "progA/moduleI/componentBG.hpp"
#include "progA/moduleI/componentBH.hpp"
#include "progA/moduleI/componentBI.hpp"
#include "progA/moduleI/componentBJ.hpp"

#include <cassert>
#include <iostream>

int main(int, char**) {
    auto value = progA_moduleA_componentA()+progA_moduleA_componentB()+progA_moduleA_componentC()+progA_moduleA_componentD()+progA_moduleE_componentQ()+progA_moduleE_componentR()+progA_moduleE_componentS()+progA_moduleE_componentT()+progA_moduleI_componentBG()+progA_moduleI_componentBH()+progA_moduleI_componentBI()+progA_moduleI_componentBJ();
    std::cout << value << std::endl;
    assert(value == 1037);
}
