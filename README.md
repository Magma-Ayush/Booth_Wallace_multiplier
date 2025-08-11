# 8x8 Signed Booth-Wallace Multiplier in Verilog

## 📝 Description

This project is a hardware implementation of an 8x8-bit signed multiplier written in Verilog. It is designed to be synthesized on a Xilinx 7-Series FPGA.

The design uses two key optimization techniques for high-speed multiplication:
* **Radix-4 Booth's Algorithm:** To reduce the number of partial products from 8 to 4.
* **Wallace Tree Compressor:** To sum the partial products efficiently using a tree of Carry-Save Adders (CSAs), which minimizes carry propagation delay.

---

## ✨ Features

* Multiplies two 8-bit signed inputs (`A` and `B`).
* Produces a 16-bit signed product (`P`).
* Fully synthesizable Verilog code.
* Includes a self-checking testbench with random stimulus to verify correctness.

---

## 🎯 Hardware Target

* **FPGA:** Xilinx Artix-7
* **Device:** `xc7a35tcpg236-1`

---

## 🚀 How to Run the Project

1.  **Clone the repository:**
    ```sh
    git clone <your-repository-url>
    ```
2.  **Open Vivado:** Create a new project in Vivado.
3.  **Add Sources:**
    * Add the Verilog files (`booth_wallace_8x8.v`, `csa3.v`) as design sources.
    * Add the testbench file (`tb_booth_wallace_8x8.v`) as a simulation source.
    * Add your `.xdc` constraints file if you plan to implement on hardware.
4.  **Run Simulation:** Set the testbench as the top simulation module and run the behavioral simulation. The results will be printed to the Tcl console.
5.  **Synthesize & Implement:** Run synthesis and implementation to see the resource utilization and timing reports for the target FPGA.
