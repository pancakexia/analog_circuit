# Analog Electronic Circuits - Coursework & 2-Stage OpAmp Design Project

This repository contains the lab sessions and design project for **Analog Electronic Circuits** (VUB - ETRO).

## Repository Structure

| Folder | Description |
| :--- | :--- |
| **[Lab_Sessions](./Lab_Sessions)** | Lab sessions, MATLAB sizing scripts (`circuitDesign`, `UMC65_RVT` models), LTspice schematics, and lab guides |
| **[Project](./Project)** | **2-Stage CMOS OpAmp Design Project**: MATLAB sizing code (`final_project.m`), LTspice schematic (`final_project.asc`), simulation data (`final_project_data.txt`), and final design report (`AE2024-2025 - Project Report_2nd_session.pdf`) |

---

## Design Project Overview
Design and verification of a **2-stage Miller-compensated CMOS Operational Amplifier (OpAmp)** in **UMC 65nm RVT technology** (`VDD = 1.1 V`) driving a `10 pF` capacitive load.

### Target Specifications
- **Load Capacitance (`Cload`)**: `10 pF`
- **DC Gain (`Av`)**: `>= 47 dB` (`223.87 V/V`)
- **Gain-Bandwidth Product (`fGBW`)**: `>= 50 MHz`
- **Phase Margin (`PM`)**: `> 70 deg`
- **Output Voltage Swing**: `> 0.7 V`
