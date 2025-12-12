#include <cstdlib>
#include <utility>
#include <string>
#include <iostream>
#include "vbuddy.cpp"

#include "cpu_testbench.h"

#define CYCLES 10000

TEST_F(CpuTestbench, TestAddiBne)
{
    setupTest("1_addi_bne");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 254);
}

TEST_F(CpuTestbench, TestLiAdd)
{
    setupTest("2_li_add");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1000);
}

TEST_F(CpuTestbench, TestLbuSb)
{
    setupTest("3_lbu_sb");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 300);
}

TEST_F(CpuTestbench, TestJalRet)
{
    setupTest("4_jal_ret");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 53);
}



TEST_F(CpuTestbench, TestPdfGauss)
{
    setupTest("5_pdf");
    setData("reference/gaussian.mem");
    initSimulation();
    if (vbdOpen() != 1)
        FAIL();
    vbdHeader("PDF Gaussian");
    int cyc = 0;
    int tick;

    while (top_->a0 == 0) {
        runSimulation(1);
        cyc++;
    }
    
    for (; cyc < CYCLES * 100; cyc++) {
        runSimulation(1);

        vbdCycle(cyc);
        vbdPlot(top_->a0, 0, 255);

        if (Verilated::gotFinish() || top_->a0 == 15363) {
            vbdClose();
            EXPECT_EQ(top_->a0, 15363);
        }
    }

    vbdClose();
    
}
TEST_F(CpuTestbench, TestPdfNoisy)
{
    setupTest("5_pdf");
    setData("reference/noisy.mem");
    initSimulation();
    if (vbdOpen() != 1)
        FAIL();
    vbdHeader("PDF Noisy");
    int cyc = 0;
    int tick;

    while (top_->a0 == 0) {
        runSimulation(1);
        cyc++;
    }
    
    for (; cyc < CYCLES * 100; cyc++) {
        runSimulation(1);

        vbdCycle(cyc);
        vbdPlot(top_->a0, 0, 255);

        if (Verilated::gotFinish() || top_->a0 == 15363) {
            vbdClose();
            EXPECT_EQ(top_->a0, 15363);
        }
    }

    vbdClose();
    
}
TEST_F(CpuTestbench, TestPdfTriangle)
{
    setupTest("5_pdf");
    setData("reference/triangle.mem");
    initSimulation();
    if (vbdOpen() != 1)
        FAIL();
    vbdHeader("PDF Triangle");
    int cyc = 0;
    int tick;

    while (top_->a0 == 0) {
        runSimulation(1);
        cyc++;
    }
    
    for (; cyc < CYCLES * 100; cyc++) {
        runSimulation(1);

        vbdCycle(cyc);
        vbdPlot(top_->a0, 0, 255);

        if (Verilated::gotFinish() || top_->a0 == 15363) {
            vbdClose();
            EXPECT_EQ(top_->a0, 15363);
        }
    }

    vbdClose();
    
}

TEST_F(CpuTestbench, F1)
{
    setupTest("f1");
    initSimulation();
    if (vbdOpen() != 1)
        FAIL();
    vbdHeader("F1 RISC-V");
    vbdSetMode(1);
    vbdBar(0);

    int cyc;
    int tick;
    
    for (cyc = 0; cyc < CYCLES / 100; cyc++) {
        runSimulation(1);

        vbdCycle(cyc);
        vbdBar(top_->a0 & 0xFF);
        vbdHex(3,(int(top_->a0)>>8)&0xF);
        vbdHex(2,(int(top_->a0)>>4)&0xF);
        vbdHex(1,int(top_->a0)&0xF);

        if (Verilated::gotFinish()) {
            vbdClose();
            EXPECT_EQ(top_->a0, 255);
        }
    }

    vbdClose();
}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}
