#include <cstdlib>
#include <utility>

#include "cpu_testbench.h"

#define CYCLES 10000

// ANDI test
TEST_F(CpuTestbench, AndiMask)
{
    setupTest("itype/andi_mask");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// ORI test
TEST_F(CpuTestbench, OriSet)
{
    setupTest("itype/ori_set");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// XORI test
TEST_F(CpuTestbench, XoriToggle)
{
    setupTest("itype/xori_toggle");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SLLI test
TEST_F(CpuTestbench, SlliShift)
{
    setupTest("itype/slli_shift");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SRLI test
TEST_F(CpuTestbench, SrliShift)
{
    setupTest("itype/srli_shift");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SRAI test
TEST_F(CpuTestbench, SraiNegative)
{
    setupTest("itype/srai_negative");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SLTI tests
TEST_F(CpuTestbench, SltiFalse)
{
    setupTest("itype/slti_false");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, SltiTrue)
{
    setupTest("itype/slti_true");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SLTIU test
TEST_F(CpuTestbench, SltiuUnsigned)
{
    setupTest("itype/sltiu_unsigned");
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
