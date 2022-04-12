// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Implementation of DPI export functions.
//
#include "Vtb_top_verilator.h"
#include "Vtb_top_verilator__Syms.h"
#include "verilated_dpi.h"


int Vtb_top_verilator::read_byte(const svLogicVecVal* byte_addr) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_verilator___024root::read_byte\n"); );
    // Init
    IData/*21:0*/ byte_addr__Vcvt;
    IData/*31:0*/ read_byte__Vfuncrtn__Vcvt;
    // Body
    static int __Vfuncnum = -1;
    if (VL_UNLIKELY(__Vfuncnum == -1)) __Vfuncnum = Verilated::exportFuncNum("read_byte");
    const VerilatedScope* __Vscopep = Verilated::dpiScope();
    Vtb_top_verilator__Vcb_read_byte_t __Vcb = (Vtb_top_verilator__Vcb_read_byte_t)(VerilatedScope::exportFind(__Vscopep, __Vfuncnum));
    byte_addr__Vcvt = (0x3fffffU & VL_SET_I_SVLV(byte_addr));
    (*__Vcb)((Vtb_top_verilator__Syms*)(__Vscopep->symsp()), byte_addr__Vcvt, read_byte__Vfuncrtn__Vcvt);
    int read_byte__Vfuncrtn;
    for (size_t read_byte__Vfuncrtn__Vidx = 0; read_byte__Vfuncrtn__Vidx < 1; ++read_byte__Vfuncrtn__Vidx) read_byte__Vfuncrtn = read_byte__Vfuncrtn__Vcvt;
    return read_byte__Vfuncrtn;
}

void Vtb_top_verilator::write_byte(const svLogicVecVal* byte_addr, const svLogicVecVal* val, svLogicVecVal* other) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_verilator___024root::write_byte\n"); );
    // Init
    IData/*21:0*/ byte_addr__Vcvt;
    CData/*7:0*/ val__Vcvt;
    CData/*7:0*/ other__Vcvt;
    // Body
    static int __Vfuncnum = -1;
    if (VL_UNLIKELY(__Vfuncnum == -1)) __Vfuncnum = Verilated::exportFuncNum("write_byte");
    const VerilatedScope* __Vscopep = Verilated::dpiScope();
    Vtb_top_verilator__Vcb_write_byte_t __Vcb = (Vtb_top_verilator__Vcb_write_byte_t)(VerilatedScope::exportFind(__Vscopep, __Vfuncnum));
    byte_addr__Vcvt = (0x3fffffU & VL_SET_I_SVLV(byte_addr));
    val__Vcvt = (0xffU & VL_SET_I_SVLV(val));
    (*__Vcb)((Vtb_top_verilator__Syms*)(__Vscopep->symsp()), byte_addr__Vcvt, val__Vcvt, other__Vcvt);
    for (size_t other__Vidx = 0; other__Vidx < 1; ++other__Vidx) VL_SET_SVLV_I(8, other + 1 * other__Vidx, other__Vcvt);
}
