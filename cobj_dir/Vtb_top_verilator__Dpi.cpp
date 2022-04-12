// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Implementation of DPI export functions.
//
// Verilator compiles this file in when DPI functions are used.
// If you have multiple Verilated designs with the same DPI exported
// function names, you will get multiple definition link errors from here.
// This is an unfortunate result of the DPI specification.
// To solve this, either
//    1. Call Vtb_top_verilator::{export_function} instead,
//       and do not even bother to compile this file
// or 2. Compile all __Dpi.cpp files in the same compiler run,
//       and #ifdefs already inserted here will sort everything out.

#include "Vtb_top_verilator__Dpi.h"
#include "Vtb_top_verilator.h"

#ifndef VL_DPIDECL_read_byte_
#define VL_DPIDECL_read_byte_
int read_byte(const svLogicVecVal* byte_addr) {
    // DPI export at tb/dp_ram.sv:75:18
    return Vtb_top_verilator::read_byte(byte_addr);
}
#endif

#ifndef VL_DPIDECL_write_byte_
#define VL_DPIDECL_write_byte_
void write_byte(const svLogicVecVal* byte_addr, const svLogicVecVal* val, svLogicVecVal* other) {
    // DPI export at tb/dp_ram.sv:79:10
    return Vtb_top_verilator::write_byte(byte_addr, val, other);
}
#endif

