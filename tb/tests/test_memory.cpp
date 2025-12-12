#include <cstdlib>
#include <utility>

#include "cpu_testbench.h"

#define CYCLES 10000

TEST_F(CpuTestbench, TestLbuSb)
{
    setupTest("3_lbu_sb");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 300);
}

TEST_F(CpuTestbench, LwSwBasic)
{
    setupTest("memory/lw_sw_basic");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, LwSwOffset)
{
    setupTest("memory/lw_sw_offset");
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
