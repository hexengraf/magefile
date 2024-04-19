#include "libA/moduleA/moduleD/componentM.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleAmoduleDTest, componentMValue) {
  EXPECT_EQ(12, progA_moduleA_moduleD_componentM());
}
