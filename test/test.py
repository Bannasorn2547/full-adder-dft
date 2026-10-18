
# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_full_adder_dft(dut):
    dut._log.info("Start Full Adder DFT test")

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Normal mode: tmode = 0
    for a in range(2):
        for b in range(2):
            for cin in range(2):
                dut.ui_in.value = (a << 0) | (b << 1) | (cin << 2)
                await Timer(10, unit="ns")

                expected_sum = a ^ b ^ cin
                expected_cout = (a & b) | (cin & (a ^ b))
                expected = (expected_cout << 1) | expected_sum

                assert int(dut.uo_out.value) == expected, (
                    f"A={a}, B={b}, Cin={cin}: "
                    f"expected {expected}, got {int(dut.uo_out.value)}"
                )

    # Test mode: tmode = 1, tin1 = 1
    # ui_in[3] = tmode, ui_in[4] = tin1
    dut.ui_in.value = 0b11000
    await Timer(10, unit="ns")

    # A=0, B=0, Cin=0, tmode=1, tin1=1
    # z1=1, w2=0, Sum=0, Cout=0
    assert int(dut.uo_out.value) == 0b00

    dut._log.info("Full Adder DFT test passed")
