#include <cstdlib>
#include <utility>

#include "cpu_testbench.h"

#define CYCLES 10000

// LUI tests
TEST_F(CpuTestbench, LuiBasic)
{
    setupTest("utype/lui_basic");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}


TEST_F(CpuTestbench, LuiAddi)
{
    setupTest("utype/lui_addi");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}
