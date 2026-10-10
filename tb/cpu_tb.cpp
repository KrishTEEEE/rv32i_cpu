#include "Vcpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env)
{

    int i;   // clock cycle
    int clk; // clock signal

    Verilated::commandArgs(argc, argv);

    // Instantiate our cpu
    Vcpu *top = new Vcpu;

    // trace dumping
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("cpu.vcd");

    // initialise simulation inputs
    top->clk = 1;
    top->rst = 1;
    top->en = 0;

    for (i = 0; i < 30; i++)
    {
        for (clk = 0; clk < 2; clk++)
        {
            tfp->dump(2 * i + clk); // dumps all signal values at this moment
            // dumps and labels with 2*i + clk as timestamp
            top->clk = !top->clk;
            top->eval(); // updates outputs if there are changes
        }
        top->rst = (i < 5) || (i > 24);
        top->en = (i > 7) && (i < 20);

        if (Verilated::gotFinish())
            exit(0);
    }
    tfp->close();
    exit(0);
}