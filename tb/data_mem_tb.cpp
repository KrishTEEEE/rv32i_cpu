#include "Vdata_mem.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

void clk_toggle(Vdata_mem *top, VerilatedVcdC *tfp, int &sim_t, int idle_time)
{
    for (int i = 0; i < idle_time; i++)
    {
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump(2 * sim_t + clk);
            top->clk = !top->clk;
            top->eval();
        }
        sim_t++;
    }
}

// TODO: Fix testbench
int main(int argc, char **argv, char **env)
{
    int i = 0;
    int clk;

    Verilated::commandArgs(argc, argv);

    Vdata_mem *top = new Vdata_mem;
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("data_mem.vcd");

    top->clk = 1;
    top->rd_addr = 0;
    top->wr_addr = 0;
    top->wr_en = 0;
    top->din = 0;

    clk_toggle(top, tfp, i, 3);
    top->rd_addr = 12;
    if (Verilated::gotFinish())
        exit(0);

    clk_toggle(top, tfp, i, 1);
    top->wr_addr = 12;
    top->din = -15;
    top->wr_en = 1;
    if (Verilated::gotFinish())
        exit(0);

    // Testing mem store
    clk_toggle(top, tfp, i, 1);
    top->rd_addr = 12;
    top->wr_en = 0;
    if (Verilated::gotFinish())
        exit(0);

    // To test behaviour when reading and writing to the same address
    // in the same cycle
    clk_toggle(top, tfp, i, 1);
    top->wr_addr = 12;
    top->din = -1;
    top->wr_en = 1;
    top->rd_addr = 12;
    if (Verilated::gotFinish())
        exit(0);

    // Test wr_en
    clk_toggle(top, tfp, i, 1);
    top->wr_addr = 17;
    top->din = 17;
    top->wr_en = 0;
    top->rd_addr = 17;
    if (Verilated::gotFinish())
        exit(0);

    clk_toggle(top, tfp, i, 1);
    top->rd_addr = 17;
    if (Verilated::gotFinish())
        exit(0);

    clk_toggle(top, tfp, i, 1);
    top->wr_addr = 17;
    top->din = 17;
    top->wr_en = 1;
    top->rd_addr = 17;
    if (Verilated::gotFinish())
        exit(0);

    clk_toggle(top, tfp, i, 1); // to evaluate the last input set

    tfp->close();
    exit(0);
}