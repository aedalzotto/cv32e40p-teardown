// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VTB_TOP_VERILATOR__SYMS_H_
#define VERILATED_VTB_TOP_VERILATOR__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vtb_top_verilator.h"

// INCLUDE MODULE CLASSES
#include "Vtb_top_verilator___024root.h"

// DPI TYPES for DPI Export callbacks (Internal use)
using Vtb_top_verilator__Vcb_read_byte_t = void (*) (Vtb_top_verilator__Syms* __restrict vlSymsp, IData/*21:0*/ byte_addr, IData/*31:0*/ &read_byte__Vfuncrtn);
using Vtb_top_verilator__Vcb_write_byte_t = void (*) (Vtb_top_verilator__Syms* __restrict vlSymsp, IData/*21:0*/ byte_addr, CData/*7:0*/ val, CData/*7:0*/ &other);

// SYMS CLASS (contains all model state)
class Vtb_top_verilator__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vtb_top_verilator* const __Vm_modelp;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vtb_top_verilator___024root    TOP;

    // SCOPE NAMES
    VerilatedScope __Vscope_tb_top_verilator;
    VerilatedScope __Vscope_tb_top_verilator__cv32e40p_tb_wrapper_i__ram_i;
    VerilatedScope __Vscope_tb_top_verilator__cv32e40p_tb_wrapper_i__ram_i__dp_ram_i;

    // CONSTRUCTORS
    Vtb_top_verilator__Syms(VerilatedContext* contextp, const char* namep, Vtb_top_verilator* modelp);
    ~Vtb_top_verilator__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
