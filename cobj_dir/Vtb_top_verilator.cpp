// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtb_top_verilator.h"
#include "Vtb_top_verilator__Syms.h"
#include "verilated_dpi.h"

//============================================================
// Constructors

Vtb_top_verilator::Vtb_top_verilator(VerilatedContext* _vcontextp__, const char* _vcname__)
    : vlSymsp{new Vtb_top_verilator__Syms(_vcontextp__, _vcname__, this)}
    , clk_i{vlSymsp->TOP.clk_i}
    , rst_ni{vlSymsp->TOP.rst_ni}
    , fetch_enable_i{vlSymsp->TOP.fetch_enable_i}
    , tests_passed_o{vlSymsp->TOP.tests_passed_o}
    , tests_failed_o{vlSymsp->TOP.tests_failed_o}
    , rootp{&(vlSymsp->TOP)}
{
}

Vtb_top_verilator::Vtb_top_verilator(const char* _vcname__)
    : Vtb_top_verilator(nullptr, _vcname__)
{
}

//============================================================
// Destructor

Vtb_top_verilator::~Vtb_top_verilator() {
    delete vlSymsp;
}

//============================================================
// Evaluation loop

void Vtb_top_verilator___024root___eval_initial(Vtb_top_verilator___024root* vlSelf);
void Vtb_top_verilator___024root___eval_settle(Vtb_top_verilator___024root* vlSelf);
void Vtb_top_verilator___024root___eval(Vtb_top_verilator___024root* vlSelf);
QData Vtb_top_verilator___024root___change_request(Vtb_top_verilator___024root* vlSelf);
#ifdef VL_DEBUG
void Vtb_top_verilator___024root___eval_debug_assertions(Vtb_top_verilator___024root* vlSelf);
#endif  // VL_DEBUG
void Vtb_top_verilator___024root___final(Vtb_top_verilator___024root* vlSelf);

static void _eval_initial_loop(Vtb_top_verilator__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    Vtb_top_verilator___024root___eval_initial(&(vlSymsp->TOP));
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial loop\n"););
        Vtb_top_verilator___024root___eval_settle(&(vlSymsp->TOP));
        Vtb_top_verilator___024root___eval(&(vlSymsp->TOP));
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = Vtb_top_verilator___024root___change_request(&(vlSymsp->TOP));
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("tb/tb_top_verilator.sv", 14, "",
                "Verilated model didn't DC converge\n"
                "- See https://verilator.org/warn/DIDNOTCONVERGE");
        } else {
            __Vchange = Vtb_top_verilator___024root___change_request(&(vlSymsp->TOP));
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vtb_top_verilator::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtb_top_verilator::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtb_top_verilator___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        Vtb_top_verilator___024root___eval(&(vlSymsp->TOP));
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = Vtb_top_verilator___024root___change_request(&(vlSymsp->TOP));
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("tb/tb_top_verilator.sv", 14, "",
                "Verilated model didn't converge\n"
                "- See https://verilator.org/warn/DIDNOTCONVERGE");
        } else {
            __Vchange = Vtb_top_verilator___024root___change_request(&(vlSymsp->TOP));
        }
    } while (VL_UNLIKELY(__Vchange));
    // Evaluate cleanup
}

//============================================================
// Utilities

VerilatedContext* Vtb_top_verilator::contextp() const {
    return vlSymsp->_vm_contextp__;
}

const char* Vtb_top_verilator::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

VL_ATTR_COLD void Vtb_top_verilator::final() {
    Vtb_top_verilator___024root___final(&(vlSymsp->TOP));
}
