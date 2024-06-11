Introduction
This repository contains the implementation of a hardware accelerator for QR decomposition. The project is designed as an ASIC to provide scalable QR decomposition tailored for scientific and engineering applications.

Modified Gram-Schmidt Algorithm
We chose the Modified Gram-Schmidt (MGS) algorithm for its robustness and ability to produce more accurate orthogonal matrices compared to the classical Gram-Schmidt process. The MGS algorithm helps in reducing numerical instability and provides sounder values for the orthogonal matrix Q.

Limitations
Despite the robust design, there are some limitations:

Division Module Approximation: Our division module uses approximation, which may affect the precision of the results.
Input Constraints: The current implementation only supports positive integer inputs.
Resource Constraints: The design may face scalability issues with large-scale matrices or real-time processing requirements.

Future Optimization
To enhance the performance and scalability of the QR decomposition module, future optimizations include:

Algorithmic Refinement: Investigate alternative algorithms to reduce computational complexity and improve performance.
Hardware Architecture Optimization: Explore parallel processing techniques, pipelining, and memory hierarchy enhancements.
Verification Methodologies: Implement advanced verification methods like formal verification and constrained-random testing.
Power and Energy Efficiency: Use power-aware design techniques and dynamic voltage and frequency scaling (DVFS).
Fault Tolerance and Reliability: Enhance fault tolerance mechanisms and error correction codes to improve robustness.

Usage
1. Clone the Repository
2. Navigate to the Project Directory
3. Run Simulations: Use simulation scripts with tools like Vivado, Quartus/ModelSim, or VCS.
4. QR Decomposition Module: The qr_decomp is the main module. You can add any input matrix (3x3) in the qrdecomp_tb test bench (please take a look at the limitations).
5. Synthesize the Design: Convert RTL code to gate-level netlist and verify performance.
6. Generate GDSII: Perform place and route using VLSI design tools and generate the GDSII file for fabrication.

