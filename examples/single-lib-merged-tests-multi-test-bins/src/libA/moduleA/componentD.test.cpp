#include "libA/moduleA/componentD.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleATest, componentDValue) {
  EXPECT_EQ(3, progA_moduleA_componentD());
}
