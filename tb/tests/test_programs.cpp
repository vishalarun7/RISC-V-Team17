#include <cstdlib>
#include <utility>
#include <string>
#include <iostream>
#include "vbuddy.cpp"

#include "cpu_testbench.h"

#define CYCLES 10000
#define F1_CYCLES 120

TEST_F(CpuTestbench, TestPdf)
{
    setupTest("5_pdf");
    setData("reference/gaussian.mem");
    initSimulation();
    runSimulation(CYCLES * 100);
    EXPECT_EQ(top_->a0, 15363);
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
    
    for (cyc = 0; cyc < F1_CYCLES; cyc++) {
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
