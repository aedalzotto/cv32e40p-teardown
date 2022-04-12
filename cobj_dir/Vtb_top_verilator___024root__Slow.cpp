// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_top_verilator.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vtb_top_verilator__Syms.h"
#include "Vtb_top_verilator___024root.h"

void Vtb_top_verilator___024root___ctor_var_reset(Vtb_top_verilator___024root* vlSelf);

Vtb_top_verilator___024root::Vtb_top_verilator___024root(Vtb_top_verilator__Syms* symsp, const char* name)
    : VerilatedModule{name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtb_top_verilator___024root___ctor_var_reset(this);
}

void Vtb_top_verilator___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vtb_top_verilator___024root::~Vtb_top_verilator___024root() {
}
