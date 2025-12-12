#include <cstdlib>
#include <utility>

#include "cpu_testbench.h"

#define CYCLES 10000

// AND test
TEST_F(CpuTestbench, AndBitwise)
{
    setupTest("rtype/and_bitwise");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// OR test
TEST_F(CpuTestbench, OrBitwise)
{
    setupTest("rtype/or_bitwise");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// XOR test
TEST_F(CpuTestbench, XorBitwise)
{
    setupTest("rtype/xor_bitwise");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SUB test
TEST_F(CpuTestbench, SubBasic)
{
    setupTest("rtype/sub_basic");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SLL test
TEST_F(CpuTestbench, SllShift)
{
    setupTest("rtype/sll_shift");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SRL test
TEST_F(CpuTestbench, SrlShift)
{
    setupTest("rtype/srl_shift");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SRA test
TEST_F(CpuTestbench, SraNegative)
{
    setupTest("rtype/sra_negative");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SLT tests
TEST_F(CpuTestbench, SltFalse)
{
    setupTest("rtype/slt_false");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

TEST_F(CpuTestbench, SltTrue)
{
    setupTest("rtype/slt_true");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1);
}

// SLTU test
TEST_F(CpuTestbench, SltuUnsigned)
{
    setupTest("rtype/sltu_unsigned");
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
