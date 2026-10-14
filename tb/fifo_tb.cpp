#include "Vfifo.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env)
{
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);

    Vfifo *top = new Vfifo;
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("fifo.vcd");

    top->clk1 = 1;
    top->rd_en = 0;
    top->rst = 1;
    top->rd_en = 0;
    top->wr_en = 0;
    top->din = 0;

    for (i = 0; i < 100; i++)
    {
        top->din = 2 * i + 1; // avoid writing 0
        top->rst = i < 5;
        top->rd_en = ((i > 10) && (i < 15)) || i > 25;
        top->wr_en = ((i >= 15) && (i < 40)) || i > 60;

        for (clk = 0; clk < 2; clk++)
        {
            top->clk1 = !top->clk1;
            top->eval();
            tfp->dump(2 * i + clk);
        }

        if (Verilated::gotFinish())
            exit(0);
    }
    tfp->close();
    exit(0);
}