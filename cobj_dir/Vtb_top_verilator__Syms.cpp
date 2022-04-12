// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtb_top_verilator__Syms.h"
#include "Vtb_top_verilator.h"
#include "Vtb_top_verilator___024root.h"

void Vtb_top_verilator___024root____Vdpiexp_tb_top_verilator__DOT__cv32e40p_tb_wrapper_i__DOT__ram_i__DOT__dp_ram_i__DOT__read_byte_TOP(Vtb_top_verilator__Syms* __restrict vlSymsp, IData/*21:0*/ byte_addr, IData/*31:0*/ &read_byte__Vfuncrtn);
void Vtb_top_verilator___024root____Vdpiexp_tb_top_verilator__DOT__cv32e40p_tb_wrapper_i__DOT__ram_i__DOT__dp_ram_i__DOT__write_byte_TOP(Vtb_top_verilator__Syms* __restrict vlSymsp, IData/*21:0*/ byte_addr, CData/*7:0*/ val, CData/*7:0*/ &other);

// FUNCTIONS
Vtb_top_verilator__Syms::~Vtb_top_verilator__Syms()
{
}

Vtb_top_verilator__Syms::Vtb_top_verilator__Syms(VerilatedContext* contextp, const char* namep,Vtb_top_verilator* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    // Setup scopes
    __Vscope_tb_top_verilator.configure(this, name(), "tb_top_verilator", "tb_top_verilator", -12, VerilatedScope::SCOPE_OTHER);
    __Vscope_tb_top_verilator__cv32e40p_tb_wrapper_i__ram_i.configure(this, name(), "tb_top_verilator.cv32e40p_tb_wrapper_i.ram_i", "ram_i", -12, VerilatedScope::SCOPE_OTHER);
    __Vscope_tb_top_verilator__cv32e40p_tb_wrapper_i__ram_i__dp_ram_i.configure(this, name(), "tb_top_verilator.cv32e40p_tb_wrapper_i.ram_i.dp_ram_i", "dp_ram_i", -12, VerilatedScope::SCOPE_OTHER);
    // Setup export functions
    for (int __Vfinal=0; __Vfinal<2; __Vfinal++) {
        __Vscope_tb_top_verilator__cv32e40p_tb_wrapper_i__ram_i__dp_ram_i.exportInsert(__Vfinal, "read_byte", (void*)(&Vtb_top_verilator___024root____Vdpiexp_tb_top_verilator__DOT__cv32e40p_tb_wrapper_i__DOT__ram_i__DOT__dp_ram_i__DOT__read_byte_TOP));
        __Vscope_tb_top_verilator__cv32e40p_tb_wrapper_i__ram_i__dp_ram_i.exportInsert(__Vfinal, "write_byte", (void*)(&Vtb_top_verilator___024root____Vdpiexp_tb_top_verilator__DOT__cv32e40p_tb_wrapper_i__DOT__ram_i__DOT__dp_ram_i__DOT__write_byte_TOP));
    }
}
