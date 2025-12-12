#include <cstdlib>
#include <utility>

#include "cpu_testbench.h"

#define CYCLES 10000

// Pipeline Test 1: Simple ADD chain
TEST_F(CpuTestbench, PipelineAddChain)
{
    setupTest("pipeline/1_add");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 80);
}

// Pipeline Test 2: ADD and SUB with dependencies
TEST_F(CpuTestbench, PipelineAddSub)
{
    setupTest("pipeline/2_add_sub");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 7);
}

// Pipeline Test 3: Load-use hazard (load followed by dependent instruction)
TEST_F(CpuTestbench, PipelineLoadHazard)
{
    setupTest("pipeline/3_l_hazard");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 10);
}

// Pipeline Test 4: Store-load hazard
TEST_F(CpuTestbench, PipelineStoreHazard)
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
