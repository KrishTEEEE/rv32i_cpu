#include "Valu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env)
{
    int i;

    Verilated::commandArgs(argc, argv);

    Valu *top = new Valu;

    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("alu.vcd");

    top->alu_op1 = 0;
    top->alu_op2 = 1;
    top->alu_control = 0;

    for (i = 0; i < 31; i++)
    {
        top->alu_control = 5;
        if (i % 2 == 0)
        {
            top->alu_op1 = top->alu_op2 * 2;
        }
        else
        {
            top->alu_op2 = top->alu_op1 + 1;
        }
        top->eval(); // alu is asynchronous, eval should be done whenever a change is applied
        // and not in the clock toggle loop, otherwise only evaluated on clock rising edge

        tfp->dump(i);
        if (Verilated::gotFinish())
            exit(0);
    }
    tfp->close();
    exit(0);
}