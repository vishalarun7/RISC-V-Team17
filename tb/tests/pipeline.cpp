#include <cstdlib>
#include <utility>

#include "cpu_testbench.h"

#define CYCLES 10000

TEST_F(CpuTestbench, TestAdd1)
{
    setupTest("pipeline/1_add");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 80);
}

TEST_F(CpuTestbench, TestAdd2)
{
    setupTest("pipeline/2_add_sub");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 7);
}

TEST_F(CpuTestbench, LoadHazard)
{
    setupTest("pipeline/3_l_hazard");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 10);
}

TEST_F(CpuTestbench, StoreHazard)
{
    setupTest("pipeline/4_s_hazard");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 8);
}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}
