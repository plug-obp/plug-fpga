// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.3
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

#include "murmur3.h"
#include "AESL_pkg.h"

using namespace std;

namespace ap_rtl {

const sc_logic murmur3::ap_const_logic_1 = sc_dt::Log_1;
const sc_logic murmur3::ap_const_logic_0 = sc_dt::Log_0;
const sc_lv<1> murmur3::ap_ST_fsm_pp0_stage0 = "1";
const sc_lv<32> murmur3::ap_const_lv32_0 = "00000000000000000000000000000000";
const bool murmur3::ap_const_boolean_1 = true;
const bool murmur3::ap_const_boolean_0 = false;
const sc_lv<32> murmur3::ap_const_lv32_CC9E2D51 = "11001100100111100010110101010001";
const sc_lv<32> murmur3::ap_const_lv32_16A88000 = "10110101010001000000000000000";
const sc_lv<32> murmur3::ap_const_lv32_11 = "10001";
const sc_lv<32> murmur3::ap_const_lv32_1F = "11111";
const sc_lv<32> murmur3::ap_const_lv32_F = "1111";
const sc_lv<32> murmur3::ap_const_lv32_1B873593 = "11011100001110011010110010011";
const sc_lv<32> murmur3::ap_const_lv32_13 = "10011";
const sc_lv<2> murmur3::ap_const_lv2_0 = "00";
const sc_lv<32> murmur3::ap_const_lv32_E6546B64 = "11100110010101000110101101100100";
const sc_lv<32> murmur3::ap_const_lv32_4 = "100";
const sc_lv<32> murmur3::ap_const_lv32_10 = "10000";
const sc_lv<32> murmur3::ap_const_lv32_85EBCA6B = "10000101111010111100101001101011";
const sc_lv<32> murmur3::ap_const_lv32_D = "1101";
const sc_lv<32> murmur3::ap_const_lv32_C2B2AE35 = "11000010101100101010111000110101";

murmur3::murmur3(sc_module_name name) : sc_module(name), mVcdFile(0) {

    SC_METHOD(thread_ap_clk_no_reset_);
    dont_initialize();
    sensitive << ( ap_clk.pos() );

    SC_METHOD(thread_ap_clk_pos_reset_);
    dont_initialize();
    sensitive << ( ap_rst_n_inv.posedge_event() );
    sensitive << ( ap_clk.pos() );

    SC_METHOD(thread_ap_CS_fsm_pp0_stage0);
    sensitive << ( ap_CS_fsm );

    SC_METHOD(thread_ap_block_pp0_stage0);

    SC_METHOD(thread_ap_block_pp0_stage0_11001);
    sensitive << ( ap_start );
    sensitive << ( seed_ap_vld_in_sig );
    sensitive << ( key_ap_vld_in_sig );

    SC_METHOD(thread_ap_block_pp0_stage0_subdone);
    sensitive << ( ap_start );
    sensitive << ( seed_ap_vld_in_sig );
    sensitive << ( key_ap_vld_in_sig );

    SC_METHOD(thread_ap_block_state1_pp0_stage0_iter0);
    sensitive << ( ap_start );
    sensitive << ( seed_ap_vld_in_sig );
    sensitive << ( key_ap_vld_in_sig );

    SC_METHOD(thread_ap_block_state2_pp0_stage0_iter1);

    SC_METHOD(thread_ap_block_state3_pp0_stage0_iter2);

    SC_METHOD(thread_ap_block_state4_pp0_stage0_iter3);

    SC_METHOD(thread_ap_block_state5_pp0_stage0_iter4);

    SC_METHOD(thread_ap_block_state6_pp0_stage0_iter5);

    SC_METHOD(thread_ap_block_state7_pp0_stage0_iter6);

    SC_METHOD(thread_ap_done);
    sensitive << ( ap_enable_reg_pp0_iter6 );
    sensitive << ( ap_block_pp0_stage0_11001 );

    SC_METHOD(thread_ap_enable_pp0);
    sensitive << ( ap_idle_pp0 );

    SC_METHOD(thread_ap_enable_reg_pp0_iter0);
    sensitive << ( ap_start );

    SC_METHOD(thread_ap_idle);
    sensitive << ( ap_start );
    sensitive << ( ap_CS_fsm_pp0_stage0 );
    sensitive << ( ap_idle_pp0 );

    SC_METHOD(thread_ap_idle_pp0);
    sensitive << ( ap_enable_reg_pp0_iter0 );
    sensitive << ( ap_enable_reg_pp0_iter1 );
    sensitive << ( ap_enable_reg_pp0_iter2 );
    sensitive << ( ap_enable_reg_pp0_iter3 );
    sensitive << ( ap_enable_reg_pp0_iter4 );
    sensitive << ( ap_enable_reg_pp0_iter5 );
    sensitive << ( ap_enable_reg_pp0_iter6 );

    SC_METHOD(thread_ap_idle_pp0_0to5);
    sensitive << ( ap_enable_reg_pp0_iter0 );
    sensitive << ( ap_enable_reg_pp0_iter1 );
    sensitive << ( ap_enable_reg_pp0_iter2 );
    sensitive << ( ap_enable_reg_pp0_iter3 );
    sensitive << ( ap_enable_reg_pp0_iter4 );
    sensitive << ( ap_enable_reg_pp0_iter5 );

    SC_METHOD(thread_ap_ready);
    sensitive << ( ap_start );
    sensitive << ( ap_CS_fsm_pp0_stage0 );
    sensitive << ( ap_block_pp0_stage0_11001 );

    SC_METHOD(thread_ap_reset_idle_pp0);
    sensitive << ( ap_start );
    sensitive << ( ap_idle_pp0_0to5 );

    SC_METHOD(thread_ap_return);
    sensitive << ( ap_enable_reg_pp0_iter6 );
    sensitive << ( ap_block_pp0_stage0_11001 );
    sensitive << ( h_7_reg_290 );
    sensitive << ( tmp_10_fu_242_p1 );

    SC_METHOD(thread_ap_rst_n_inv);
    sensitive << ( ap_rst_n );

    SC_METHOD(thread_h_1_fu_144_p3);
    sensitive << ( tmp_2_fu_130_p1 );
    sensitive << ( tmp_3_fu_134_p4 );

    SC_METHOD(thread_h_2_fu_172_p2);
    sensitive << ( tmp1_fu_166_p2 );
    sensitive << ( p_shl_fu_156_p4 );

    SC_METHOD(thread_h_3_fu_178_p2);
    sensitive << ( h_2_fu_172_p2 );

    SC_METHOD(thread_h_4_fu_198_p2);
    sensitive << ( h_3_fu_178_p2 );
    sensitive << ( tmp_s_fu_194_p1 );

    SC_METHOD(thread_h_5_fu_204_p2);
    sensitive << ( h_4_reg_270 );

    SC_METHOD(thread_h_6_fu_222_p2);
    sensitive << ( h_5_reg_275 );
    sensitive << ( tmp_9_fu_219_p1 );

    SC_METHOD(thread_h_7_fu_227_p2);
    sensitive << ( h_6_reg_285 );

    SC_METHOD(thread_h_fu_126_p2);
    sensitive << ( seed_read_reg_250_pp0_iter1_reg );
    sensitive << ( k_2_reg_265 );

    SC_METHOD(thread_k_1_fu_114_p3);
    sensitive << ( tmp_1_reg_255 );
    sensitive << ( tmp_5_reg_260 );

    SC_METHOD(thread_k_2_fu_120_p2);
    sensitive << ( k_1_fu_114_p3 );

    SC_METHOD(thread_k_fu_82_p1);
    sensitive << ( ap_start );
    sensitive << ( ap_CS_fsm_pp0_stage0 );
    sensitive << ( key_in_sig );
    sensitive << ( ap_block_pp0_stage0 );

    SC_METHOD(thread_k_fu_82_p2);
    sensitive << ( k_fu_82_p1 );

    SC_METHOD(thread_key_ap_vld_in_sig);
    sensitive << ( key_ap_vld );
    sensitive << ( key_ap_vld_preg );

    SC_METHOD(thread_key_blk_n);
    sensitive << ( ap_start );
    sensitive << ( ap_CS_fsm_pp0_stage0 );
    sensitive << ( key_ap_vld );
    sensitive << ( ap_block_pp0_stage0 );

    SC_METHOD(thread_key_in_sig);
    sensitive << ( key_ap_vld );
    sensitive << ( key );
    sensitive << ( key_preg );

    SC_METHOD(thread_p_shl_fu_156_p4);
    sensitive << ( tmp_3_fu_134_p4 );
    sensitive << ( tmp_4_fu_152_p1 );

    SC_METHOD(thread_seed_ap_vld_in_sig);
    sensitive << ( seed_ap_vld );
    sensitive << ( seed_ap_vld_preg );

    SC_METHOD(thread_seed_blk_n);
    sensitive << ( ap_start );
    sensitive << ( ap_CS_fsm_pp0_stage0 );
    sensitive << ( seed_ap_vld );
    sensitive << ( ap_block_pp0_stage0 );

    SC_METHOD(thread_seed_in_sig);
    sensitive << ( seed_ap_vld );
    sensitive << ( seed );
    sensitive << ( seed_preg );

    SC_METHOD(thread_tmp1_fu_166_p2);
    sensitive << ( h_1_fu_144_p3 );

    SC_METHOD(thread_tmp_10_fu_242_p1);
    sensitive << ( tmp_8_reg_295 );

    SC_METHOD(thread_tmp_2_fu_130_p1);
    sensitive << ( h_fu_126_p2 );

    SC_METHOD(thread_tmp_3_fu_134_p4);
    sensitive << ( h_fu_126_p2 );

    SC_METHOD(thread_tmp_4_fu_152_p1);
    sensitive << ( h_fu_126_p2 );

    SC_METHOD(thread_tmp_6_fu_184_p4);
    sensitive << ( h_3_fu_178_p2 );

    SC_METHOD(thread_tmp_9_fu_219_p1);
    sensitive << ( tmp_7_reg_280 );

    SC_METHOD(thread_tmp_fu_88_p1);
    sensitive << ( ap_start );
    sensitive << ( ap_CS_fsm_pp0_stage0 );
    sensitive << ( key_in_sig );
    sensitive << ( ap_block_pp0_stage0 );

    SC_METHOD(thread_tmp_fu_88_p2);
    sensitive << ( tmp_fu_88_p1 );

    SC_METHOD(thread_tmp_s_fu_194_p1);
    sensitive << ( tmp_6_fu_184_p4 );

    SC_METHOD(thread_ap_NS_fsm);
    sensitive << ( ap_CS_fsm );
    sensitive << ( ap_block_pp0_stage0_subdone );
    sensitive << ( ap_reset_idle_pp0 );

    SC_THREAD(thread_hdltv_gen);
    sensitive << ( ap_clk.pos() );

    ap_CS_fsm = "1";
    ap_enable_reg_pp0_iter1 = SC_LOGIC_0;
    ap_enable_reg_pp0_iter2 = SC_LOGIC_0;
    ap_enable_reg_pp0_iter3 = SC_LOGIC_0;
    ap_enable_reg_pp0_iter4 = SC_LOGIC_0;
    ap_enable_reg_pp0_iter5 = SC_LOGIC_0;
    ap_enable_reg_pp0_iter6 = SC_LOGIC_0;
    key_preg = "00000000000000000000000000000000";
    key_ap_vld_preg = SC_LOGIC_0;
    seed_preg = "00000000000000000000000000000000";
    seed_ap_vld_preg = SC_LOGIC_0;
    static int apTFileNum = 0;
    stringstream apTFilenSS;
    apTFilenSS << "murmur3_sc_trace_" << apTFileNum ++;
    string apTFn = apTFilenSS.str();
    mVcdFile = sc_create_vcd_trace_file(apTFn.c_str());
    mVcdFile->set_time_unit(1, SC_PS);
    if (1) {
#ifdef __HLS_TRACE_LEVEL_PORT__
    sc_trace(mVcdFile, ap_clk, "(port)ap_clk");
    sc_trace(mVcdFile, ap_rst_n, "(port)ap_rst_n");
    sc_trace(mVcdFile, ap_start, "(port)ap_start");
    sc_trace(mVcdFile, ap_done, "(port)ap_done");
    sc_trace(mVcdFile, ap_idle, "(port)ap_idle");
    sc_trace(mVcdFile, ap_ready, "(port)ap_ready");
    sc_trace(mVcdFile, seed_ap_vld, "(port)seed_ap_vld");
    sc_trace(mVcdFile, key_ap_vld, "(port)key_ap_vld");
    sc_trace(mVcdFile, key, "(port)key");
    sc_trace(mVcdFile, seed, "(port)seed");
    sc_trace(mVcdFile, ap_return, "(port)ap_return");
#endif
#ifdef __HLS_TRACE_LEVEL_INT__
    sc_trace(mVcdFile, ap_rst_n_inv, "ap_rst_n_inv");
    sc_trace(mVcdFile, ap_CS_fsm, "ap_CS_fsm");
    sc_trace(mVcdFile, ap_CS_fsm_pp0_stage0, "ap_CS_fsm_pp0_stage0");
    sc_trace(mVcdFile, ap_enable_reg_pp0_iter0, "ap_enable_reg_pp0_iter0");
    sc_trace(mVcdFile, ap_enable_reg_pp0_iter1, "ap_enable_reg_pp0_iter1");
    sc_trace(mVcdFile, ap_enable_reg_pp0_iter2, "ap_enable_reg_pp0_iter2");
    sc_trace(mVcdFile, ap_enable_reg_pp0_iter3, "ap_enable_reg_pp0_iter3");
    sc_trace(mVcdFile, ap_enable_reg_pp0_iter4, "ap_enable_reg_pp0_iter4");
    sc_trace(mVcdFile, ap_enable_reg_pp0_iter5, "ap_enable_reg_pp0_iter5");
    sc_trace(mVcdFile, ap_enable_reg_pp0_iter6, "ap_enable_reg_pp0_iter6");
    sc_trace(mVcdFile, ap_idle_pp0, "ap_idle_pp0");
    sc_trace(mVcdFile, seed_ap_vld_in_sig, "seed_ap_vld_in_sig");
    sc_trace(mVcdFile, key_ap_vld_in_sig, "key_ap_vld_in_sig");
    sc_trace(mVcdFile, ap_block_state1_pp0_stage0_iter0, "ap_block_state1_pp0_stage0_iter0");
    sc_trace(mVcdFile, ap_block_state2_pp0_stage0_iter1, "ap_block_state2_pp0_stage0_iter1");
    sc_trace(mVcdFile, ap_block_state3_pp0_stage0_iter2, "ap_block_state3_pp0_stage0_iter2");
    sc_trace(mVcdFile, ap_block_state4_pp0_stage0_iter3, "ap_block_state4_pp0_stage0_iter3");
    sc_trace(mVcdFile, ap_block_state5_pp0_stage0_iter4, "ap_block_state5_pp0_stage0_iter4");
    sc_trace(mVcdFile, ap_block_state6_pp0_stage0_iter5, "ap_block_state6_pp0_stage0_iter5");
    sc_trace(mVcdFile, ap_block_state7_pp0_stage0_iter6, "ap_block_state7_pp0_stage0_iter6");
    sc_trace(mVcdFile, ap_block_pp0_stage0_11001, "ap_block_pp0_stage0_11001");
    sc_trace(mVcdFile, key_preg, "key_preg");
    sc_trace(mVcdFile, key_in_sig, "key_in_sig");
    sc_trace(mVcdFile, key_ap_vld_preg, "key_ap_vld_preg");
    sc_trace(mVcdFile, seed_preg, "seed_preg");
    sc_trace(mVcdFile, seed_in_sig, "seed_in_sig");
    sc_trace(mVcdFile, seed_ap_vld_preg, "seed_ap_vld_preg");
    sc_trace(mVcdFile, key_blk_n, "key_blk_n");
    sc_trace(mVcdFile, ap_block_pp0_stage0, "ap_block_pp0_stage0");
    sc_trace(mVcdFile, seed_blk_n, "seed_blk_n");
    sc_trace(mVcdFile, seed_read_reg_250, "seed_read_reg_250");
    sc_trace(mVcdFile, seed_read_reg_250_pp0_iter1_reg, "seed_read_reg_250_pp0_iter1_reg");
    sc_trace(mVcdFile, tmp_1_reg_255, "tmp_1_reg_255");
    sc_trace(mVcdFile, tmp_5_reg_260, "tmp_5_reg_260");
    sc_trace(mVcdFile, k_2_fu_120_p2, "k_2_fu_120_p2");
    sc_trace(mVcdFile, k_2_reg_265, "k_2_reg_265");
    sc_trace(mVcdFile, h_4_fu_198_p2, "h_4_fu_198_p2");
    sc_trace(mVcdFile, h_4_reg_270, "h_4_reg_270");
    sc_trace(mVcdFile, h_5_fu_204_p2, "h_5_fu_204_p2");
    sc_trace(mVcdFile, h_5_reg_275, "h_5_reg_275");
    sc_trace(mVcdFile, tmp_7_reg_280, "tmp_7_reg_280");
    sc_trace(mVcdFile, h_6_fu_222_p2, "h_6_fu_222_p2");
    sc_trace(mVcdFile, h_6_reg_285, "h_6_reg_285");
    sc_trace(mVcdFile, h_7_fu_227_p2, "h_7_fu_227_p2");
    sc_trace(mVcdFile, h_7_reg_290, "h_7_reg_290");
    sc_trace(mVcdFile, tmp_8_reg_295, "tmp_8_reg_295");
    sc_trace(mVcdFile, ap_block_pp0_stage0_subdone, "ap_block_pp0_stage0_subdone");
    sc_trace(mVcdFile, k_fu_82_p1, "k_fu_82_p1");
    sc_trace(mVcdFile, tmp_fu_88_p1, "tmp_fu_88_p1");
    sc_trace(mVcdFile, k_fu_82_p2, "k_fu_82_p2");
    sc_trace(mVcdFile, tmp_fu_88_p2, "tmp_fu_88_p2");
    sc_trace(mVcdFile, k_1_fu_114_p3, "k_1_fu_114_p3");
    sc_trace(mVcdFile, h_fu_126_p2, "h_fu_126_p2");
    sc_trace(mVcdFile, tmp_2_fu_130_p1, "tmp_2_fu_130_p1");
    sc_trace(mVcdFile, tmp_3_fu_134_p4, "tmp_3_fu_134_p4");
    sc_trace(mVcdFile, tmp_4_fu_152_p1, "tmp_4_fu_152_p1");
    sc_trace(mVcdFile, h_1_fu_144_p3, "h_1_fu_144_p3");
    sc_trace(mVcdFile, tmp1_fu_166_p2, "tmp1_fu_166_p2");
    sc_trace(mVcdFile, p_shl_fu_156_p4, "p_shl_fu_156_p4");
    sc_trace(mVcdFile, h_2_fu_172_p2, "h_2_fu_172_p2");
    sc_trace(mVcdFile, h_3_fu_178_p2, "h_3_fu_178_p2");
    sc_trace(mVcdFile, tmp_6_fu_184_p4, "tmp_6_fu_184_p4");
    sc_trace(mVcdFile, tmp_s_fu_194_p1, "tmp_s_fu_194_p1");
    sc_trace(mVcdFile, tmp_9_fu_219_p1, "tmp_9_fu_219_p1");
    sc_trace(mVcdFile, tmp_10_fu_242_p1, "tmp_10_fu_242_p1");
    sc_trace(mVcdFile, ap_NS_fsm, "ap_NS_fsm");
    sc_trace(mVcdFile, ap_idle_pp0_0to5, "ap_idle_pp0_0to5");
    sc_trace(mVcdFile, ap_reset_idle_pp0, "ap_reset_idle_pp0");
    sc_trace(mVcdFile, ap_enable_pp0, "ap_enable_pp0");
#endif

    }
    mHdltvinHandle.open("murmur3.hdltvin.dat");
    mHdltvoutHandle.open("murmur3.hdltvout.dat");
}

murmur3::~murmur3() {
    if (mVcdFile) 
        sc_close_vcd_trace_file(mVcdFile);

    mHdltvinHandle << "] " << endl;
    mHdltvoutHandle << "] " << endl;
    mHdltvinHandle.close();
    mHdltvoutHandle.close();
}

void murmur3::thread_ap_clk_no_reset_() {
    if (esl_seteq<1,1,1>(ap_block_pp0_stage0_11001.read(), ap_const_boolean_0)) {
        h_4_reg_270 = h_4_fu_198_p2.read();
        h_5_reg_275 = h_5_fu_204_p2.read();
        h_6_reg_285 = h_6_fu_222_p2.read();
        h_7_reg_290 = h_7_fu_227_p2.read();
        tmp_7_reg_280 = h_5_fu_204_p2.read().range(31, 13);
        tmp_8_reg_295 = h_7_fu_227_p2.read().range(31, 16);
    }
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && esl_seteq<1,1,1>(ap_block_pp0_stage0_11001.read(), ap_const_boolean_0))) {
        k_2_reg_265 = k_2_fu_120_p2.read();
        seed_read_reg_250 = seed_in_sig.read();
        seed_read_reg_250_pp0_iter1_reg = seed_read_reg_250.read();
        tmp_1_reg_255 = k_fu_82_p2.read().range(31, 17);
        tmp_5_reg_260 = tmp_fu_88_p2.read().range(31, 15);
    }
}

void murmur3::thread_ap_clk_pos_reset_() {
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        ap_CS_fsm = ap_ST_fsm_pp0_stage0;
    } else {
        ap_CS_fsm = ap_NS_fsm.read();
    }
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        ap_enable_reg_pp0_iter1 = ap_const_logic_0;
    } else {
        if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && 
             esl_seteq<1,1,1>(ap_block_pp0_stage0_subdone.read(), ap_const_boolean_0))) {
            ap_enable_reg_pp0_iter1 = ap_start.read();
        }
    }
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        ap_enable_reg_pp0_iter2 = ap_const_logic_0;
    } else {
        if (esl_seteq<1,1,1>(ap_block_pp0_stage0_subdone.read(), ap_const_boolean_0)) {
            ap_enable_reg_pp0_iter2 = ap_enable_reg_pp0_iter1.read();
        }
    }
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        ap_enable_reg_pp0_iter3 = ap_const_logic_0;
    } else {
        if (esl_seteq<1,1,1>(ap_block_pp0_stage0_subdone.read(), ap_const_boolean_0)) {
            ap_enable_reg_pp0_iter3 = ap_enable_reg_pp0_iter2.read();
        }
    }
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        ap_enable_reg_pp0_iter4 = ap_const_logic_0;
    } else {
        if (esl_seteq<1,1,1>(ap_block_pp0_stage0_subdone.read(), ap_const_boolean_0)) {
            ap_enable_reg_pp0_iter4 = ap_enable_reg_pp0_iter3.read();
        }
    }
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        ap_enable_reg_pp0_iter5 = ap_const_logic_0;
    } else {
        if (esl_seteq<1,1,1>(ap_block_pp0_stage0_subdone.read(), ap_const_boolean_0)) {
            ap_enable_reg_pp0_iter5 = ap_enable_reg_pp0_iter4.read();
        }
    }
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        ap_enable_reg_pp0_iter6 = ap_const_logic_0;
    } else {
        if (esl_seteq<1,1,1>(ap_block_pp0_stage0_subdone.read(), ap_const_boolean_0)) {
            ap_enable_reg_pp0_iter6 = ap_enable_reg_pp0_iter5.read();
        }
    }
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        key_ap_vld_preg = ap_const_logic_0;
    } else {
        if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && 
             esl_seteq<1,1,1>(ap_const_logic_1, ap_start.read()) && 
             esl_seteq<1,1,1>(ap_block_pp0_stage0_11001.read(), ap_const_boolean_0))) {
            key_ap_vld_preg = ap_const_logic_0;
        } else if ((esl_seteq<1,1,1>(ap_const_logic_1, key_ap_vld.read()) && 
                    !(esl_seteq<1,1,1>(ap_const_logic_0, ap_start.read()) && esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read())))) {
            key_ap_vld_preg = key_ap_vld.read();
        }
    }
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        key_preg = ap_const_lv32_0;
    } else {
        if ((esl_seteq<1,1,1>(ap_const_logic_1, key_ap_vld.read()) && 
             !(esl_seteq<1,1,1>(ap_const_logic_0, ap_start.read()) && esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read())))) {
            key_preg = key.read();
        }
    }
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        seed_ap_vld_preg = ap_const_logic_0;
    } else {
        if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && 
             esl_seteq<1,1,1>(ap_const_logic_1, ap_start.read()) && 
             esl_seteq<1,1,1>(ap_block_pp0_stage0_11001.read(), ap_const_boolean_0))) {
            seed_ap_vld_preg = ap_const_logic_0;
        } else if ((!(esl_seteq<1,1,1>(ap_const_logic_0, ap_start.read()) && esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read())) && 
                    esl_seteq<1,1,1>(ap_const_logic_1, seed_ap_vld.read()))) {
            seed_ap_vld_preg = seed_ap_vld.read();
        }
    }
    if ( ap_rst_n_inv.read() == ap_const_logic_1) {
        seed_preg = ap_const_lv32_0;
    } else {
        if ((!(esl_seteq<1,1,1>(ap_const_logic_0, ap_start.read()) && esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read())) && 
             esl_seteq<1,1,1>(ap_const_logic_1, seed_ap_vld.read()))) {
            seed_preg = seed.read();
        }
    }
}

void murmur3::thread_ap_CS_fsm_pp0_stage0() {
    ap_CS_fsm_pp0_stage0 = ap_CS_fsm.read()[0];
}

void murmur3::thread_ap_block_pp0_stage0() {
    ap_block_pp0_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void murmur3::thread_ap_block_pp0_stage0_11001() {
    ap_block_pp0_stage0_11001 = (esl_seteq<1,1,1>(ap_const_logic_1, ap_start.read()) && (esl_seteq<1,1,1>(ap_const_logic_0, ap_start.read()) || 
  esl_seteq<1,1,1>(ap_const_logic_0, seed_ap_vld_in_sig.read()) || 
  esl_seteq<1,1,1>(ap_const_logic_0, key_ap_vld_in_sig.read())));
}

void murmur3::thread_ap_block_pp0_stage0_subdone() {
    ap_block_pp0_stage0_subdone = (esl_seteq<1,1,1>(ap_const_logic_1, ap_start.read()) && (esl_seteq<1,1,1>(ap_const_logic_0, ap_start.read()) || 
  esl_seteq<1,1,1>(ap_const_logic_0, seed_ap_vld_in_sig.read()) || 
  esl_seteq<1,1,1>(ap_const_logic_0, key_ap_vld_in_sig.read())));
}

void murmur3::thread_ap_block_state1_pp0_stage0_iter0() {
    ap_block_state1_pp0_stage0_iter0 = (esl_seteq<1,1,1>(ap_const_logic_0, ap_start.read()) || esl_seteq<1,1,1>(ap_const_logic_0, seed_ap_vld_in_sig.read()) || esl_seteq<1,1,1>(ap_const_logic_0, key_ap_vld_in_sig.read()));
}

void murmur3::thread_ap_block_state2_pp0_stage0_iter1() {
    ap_block_state2_pp0_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void murmur3::thread_ap_block_state3_pp0_stage0_iter2() {
    ap_block_state3_pp0_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void murmur3::thread_ap_block_state4_pp0_stage0_iter3() {
    ap_block_state4_pp0_stage0_iter3 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void murmur3::thread_ap_block_state5_pp0_stage0_iter4() {
    ap_block_state5_pp0_stage0_iter4 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void murmur3::thread_ap_block_state6_pp0_stage0_iter5() {
    ap_block_state6_pp0_stage0_iter5 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void murmur3::thread_ap_block_state7_pp0_stage0_iter6() {
    ap_block_state7_pp0_stage0_iter6 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void murmur3::thread_ap_done() {
    if ((esl_seteq<1,1,1>(ap_block_pp0_stage0_11001.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp0_iter6.read()))) {
        ap_done = ap_const_logic_1;
    } else {
        ap_done = ap_const_logic_0;
    }
}

void murmur3::thread_ap_enable_pp0() {
    ap_enable_pp0 = (ap_idle_pp0.read() ^ ap_const_logic_1);
}

void murmur3::thread_ap_enable_reg_pp0_iter0() {
    ap_enable_reg_pp0_iter0 = ap_start.read();
}

void murmur3::thread_ap_idle() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_start.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_idle_pp0.read()))) {
        ap_idle = ap_const_logic_1;
    } else {
        ap_idle = ap_const_logic_0;
    }
}

void murmur3::thread_ap_idle_pp0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter4.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter5.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter6.read()))) {
        ap_idle_pp0 = ap_const_logic_1;
    } else {
        ap_idle_pp0 = ap_const_logic_0;
    }
}

void murmur3::thread_ap_idle_pp0_0to5() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter4.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter5.read()))) {
        ap_idle_pp0_0to5 = ap_const_logic_1;
    } else {
        ap_idle_pp0_0to5 = ap_const_logic_0;
    }
}

void murmur3::thread_ap_ready() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_start.read()) && 
         esl_seteq<1,1,1>(ap_block_pp0_stage0_11001.read(), ap_const_boolean_0))) {
        ap_ready = ap_const_logic_1;
    } else {
        ap_ready = ap_const_logic_0;
    }
}

void murmur3::thread_ap_reset_idle_pp0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_start.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_idle_pp0_0to5.read()))) {
        ap_reset_idle_pp0 = ap_const_logic_1;
    } else {
        ap_reset_idle_pp0 = ap_const_logic_0;
    }
}

void murmur3::thread_ap_return() {
    ap_return = (tmp_10_fu_242_p1.read() ^ h_7_reg_290.read());
}

void murmur3::thread_ap_rst_n_inv() {
    ap_rst_n_inv =  (sc_logic) (~ap_rst_n.read());
}

void murmur3::thread_h_1_fu_144_p3() {
    h_1_fu_144_p3 = esl_concat<19,13>(tmp_2_fu_130_p1.read(), tmp_3_fu_134_p4.read());
}

void murmur3::thread_h_2_fu_172_p2() {
    h_2_fu_172_p2 = (!tmp1_fu_166_p2.read().is_01() || !p_shl_fu_156_p4.read().is_01())? sc_lv<32>(): (sc_biguint<32>(tmp1_fu_166_p2.read()) + sc_biguint<32>(p_shl_fu_156_p4.read()));
}

void murmur3::thread_h_3_fu_178_p2() {
    h_3_fu_178_p2 = (h_2_fu_172_p2.read() ^ ap_const_lv32_4);
}

void murmur3::thread_h_4_fu_198_p2() {
    h_4_fu_198_p2 = (tmp_s_fu_194_p1.read() ^ h_3_fu_178_p2.read());
}

void murmur3::thread_h_5_fu_204_p2() {
    h_5_fu_204_p2 = (!ap_const_lv32_85EBCA6B.is_01() || !h_4_reg_270.read().is_01())? sc_lv<32>(): sc_bigint<32>(ap_const_lv32_85EBCA6B) * sc_bigint<32>(h_4_reg_270.read());
}

void murmur3::thread_h_6_fu_222_p2() {
    h_6_fu_222_p2 = (tmp_9_fu_219_p1.read() ^ h_5_reg_275.read());
}

void murmur3::thread_h_7_fu_227_p2() {
    h_7_fu_227_p2 = (!ap_const_lv32_C2B2AE35.is_01() || !h_6_reg_285.read().is_01())? sc_lv<32>(): sc_bigint<32>(ap_const_lv32_C2B2AE35) * sc_bigint<32>(h_6_reg_285.read());
}

void murmur3::thread_h_fu_126_p2() {
    h_fu_126_p2 = (k_2_reg_265.read() ^ seed_read_reg_250_pp0_iter1_reg.read());
}

void murmur3::thread_k_1_fu_114_p3() {
    k_1_fu_114_p3 = esl_concat<17,15>(tmp_5_reg_260.read(), tmp_1_reg_255.read());
}

void murmur3::thread_k_2_fu_120_p2() {
    k_2_fu_120_p2 = (!ap_const_lv32_1B873593.is_01() || !k_1_fu_114_p3.read().is_01())? sc_lv<32>(): sc_biguint<32>(ap_const_lv32_1B873593) * sc_bigint<32>(k_1_fu_114_p3.read());
}

void murmur3::thread_k_fu_82_p1() {
    k_fu_82_p1 = key_in_sig.read();
}

void murmur3::thread_k_fu_82_p2() {
    k_fu_82_p2 = (!ap_const_lv32_CC9E2D51.is_01() || !k_fu_82_p1.read().is_01())? sc_lv<32>(): sc_bigint<32>(ap_const_lv32_CC9E2D51) * sc_bigint<32>(k_fu_82_p1.read());
}

void murmur3::thread_key_ap_vld_in_sig() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, key_ap_vld.read())) {
        key_ap_vld_in_sig = key_ap_vld.read();
    } else {
        key_ap_vld_in_sig = key_ap_vld_preg.read();
    }
}

void murmur3::thread_key_blk_n() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_start.read()) && 
         esl_seteq<1,1,1>(ap_start.read(), ap_const_logic_1) && 
         esl_seteq<1,1,1>(ap_block_pp0_stage0.read(), ap_const_boolean_0))) {
        key_blk_n = key_ap_vld.read();
    } else {
        key_blk_n = ap_const_logic_1;
    }
}

void murmur3::thread_key_in_sig() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, key_ap_vld.read())) {
        key_in_sig = key.read();
    } else {
        key_in_sig = key_preg.read();
    }
}

void murmur3::thread_p_shl_fu_156_p4() {
    p_shl_fu_156_p4 = esl_concat<30,2>(esl_concat<17,13>(tmp_4_fu_152_p1.read(), tmp_3_fu_134_p4.read()), ap_const_lv2_0);
}

void murmur3::thread_seed_ap_vld_in_sig() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, seed_ap_vld.read())) {
        seed_ap_vld_in_sig = seed_ap_vld.read();
    } else {
        seed_ap_vld_in_sig = seed_ap_vld_preg.read();
    }
}

void murmur3::thread_seed_blk_n() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_start.read()) && 
         esl_seteq<1,1,1>(ap_start.read(), ap_const_logic_1) && 
         esl_seteq<1,1,1>(ap_block_pp0_stage0.read(), ap_const_boolean_0))) {
        seed_blk_n = seed_ap_vld.read();
    } else {
        seed_blk_n = ap_const_logic_1;
    }
}

void murmur3::thread_seed_in_sig() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, seed_ap_vld.read())) {
        seed_in_sig = seed.read();
    } else {
        seed_in_sig = seed_preg.read();
    }
}

void murmur3::thread_tmp1_fu_166_p2() {
    tmp1_fu_166_p2 = (!ap_const_lv32_E6546B64.is_01() || !h_1_fu_144_p3.read().is_01())? sc_lv<32>(): (sc_bigint<32>(ap_const_lv32_E6546B64) + sc_biguint<32>(h_1_fu_144_p3.read()));
}

void murmur3::thread_tmp_10_fu_242_p1() {
    tmp_10_fu_242_p1 = esl_zext<32,16>(tmp_8_reg_295.read());
}

void murmur3::thread_tmp_2_fu_130_p1() {
    tmp_2_fu_130_p1 = h_fu_126_p2.read().range(19-1, 0);
}

void murmur3::thread_tmp_3_fu_134_p4() {
    tmp_3_fu_134_p4 = h_fu_126_p2.read().range(31, 19);
}

void murmur3::thread_tmp_4_fu_152_p1() {
    tmp_4_fu_152_p1 = h_fu_126_p2.read().range(17-1, 0);
}

void murmur3::thread_tmp_6_fu_184_p4() {
    tmp_6_fu_184_p4 = h_3_fu_178_p2.read().range(31, 16);
}

void murmur3::thread_tmp_9_fu_219_p1() {
    tmp_9_fu_219_p1 = esl_zext<32,19>(tmp_7_reg_280.read());
}

void murmur3::thread_tmp_fu_88_p1() {
    tmp_fu_88_p1 = key_in_sig.read();
}

void murmur3::thread_tmp_fu_88_p2() {
    tmp_fu_88_p2 = (!ap_const_lv32_16A88000.is_01() || !tmp_fu_88_p1.read().is_01())? sc_lv<32>(): sc_biguint<32>(ap_const_lv32_16A88000) * sc_bigint<32>(tmp_fu_88_p1.read());
}

void murmur3::thread_tmp_s_fu_194_p1() {
    tmp_s_fu_194_p1 = esl_zext<32,16>(tmp_6_fu_184_p4.read());
}

void murmur3::thread_ap_NS_fsm() {
    switch (ap_CS_fsm.read().to_uint64()) {
        case 1 : 
            ap_NS_fsm = ap_ST_fsm_pp0_stage0;
break;
        default : 
            ap_NS_fsm = "X";
            break;
    }
}

void murmur3::thread_hdltv_gen() {
    const char* dump_tv = std::getenv("AP_WRITE_TV");
    if (!(dump_tv && string(dump_tv) == "on")) return;

    wait();

    mHdltvinHandle << "[ " << endl;
    mHdltvoutHandle << "[ " << endl;
    int ap_cycleNo = 0;
    while (1) {
        wait();
        const char* mComma = ap_cycleNo == 0 ? " " : ", " ;
        mHdltvinHandle << mComma << "{"  <<  " \"ap_rst_n\" :  \"" << ap_rst_n.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"ap_start\" :  \"" << ap_start.read() << "\" ";
        mHdltvoutHandle << mComma << "{"  <<  " \"ap_done\" :  \"" << ap_done.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"ap_idle\" :  \"" << ap_idle.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"ap_ready\" :  \"" << ap_ready.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"seed_ap_vld\" :  \"" << seed_ap_vld.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"key_ap_vld\" :  \"" << key_ap_vld.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"key\" :  \"" << key.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"seed\" :  \"" << seed.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"ap_return\" :  \"" << ap_return.read() << "\" ";
        mHdltvinHandle << "}" << std::endl;
        mHdltvoutHandle << "}" << std::endl;
        ap_cycleNo++;
    }
}

}
