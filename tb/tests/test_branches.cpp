#include <cstdlib>
#include <utility>

#include "cpu_testbench.h"

#define CYCLES 10000

// BEQ tests
TEST_F(CpuTestbench, BeqEqual)
{
    setupTest("branch/beq_equal");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, BeqNegative)
{
    setupTest("branch/beq_negative");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, BeqNotEqual)
{
    setupTest("branch/beq_not_equal");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, BeqZero)
{
    setupTest("branch/beq_zero");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// BNE tests
TEST_F(CpuTestbench, BneEqual)
{
    setupTest("branch/bne_equal");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, BneNotEqual)
{
    setupTest("branch/bne_not_equal");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// BLT tests
TEST_F(CpuTestbench, BltGreater)
{
    setupTest("branch/blt_greater");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, BltNegative)
{
    setupTest("branch/blt_negative");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, BltPositive)
{
    setupTest("branch/blt_positive");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// BGE tests
TEST_F(CpuTestbench, BgeEqual)
{
    setupTest("branch/bge_equal");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, BgeGreater)
{
    setupTest("branch/bge_greater");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, BgeLess)
{
    setupTest("branch/bge_less");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// BLTU tests
TEST_F(CpuTestbench, BltuSmall)
{
    setupTest("branch/bltu_small");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, BltuUnsigned)
{
    setupTest("branch/bltu_unsigned");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// BGEU tests
TEST_F(CpuTestbench, BgeuGreater)
{
    setupTest("branch/bgeu_greater");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, BgeuUnsigned)
{
    setupTest("branch/bgeu_unsigned");
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
