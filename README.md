# LV Distribution Network Voltage Mitigation

## Overview
This repository contains a **low-voltage (LV) distribution network analysis and mitigation study** focused on **voltage rise, imbalance, and hosting capacity issues** caused by high rooftop solar PV penetration.

The work models a **realistic LV feeder supplied by a 160 kVA Dyn11 distribution transformer**, incorporating:
- Phase-wise load imbalance
- Distributed single-phase solar PV connections
- Line impedance effects
- Statutory voltage limits
- Practical mitigation strategies

The goal is **engineering realism**.

---

## Problem Statement
High penetration of single-phase rooftop PV in LV networks leads to:
- Over-voltage at customer terminals
- Phase imbalance
- Transformer loading issues
- Non-compliance with statutory voltage limits

Traditional planning assumptions fail under modern prosumer behavior.  
This project evaluates **where and why** violations occur and **what actually works** to mitigate them.

---

## What This Repository Contains
- 📊 MATLAB scripts for LV network analysis  
- ⚡ Voltage, loading, and phase imbalance calculations  
- 🔌 Transformer-centric modeling (160 kVA Dyn11)  
- 🌞 Load and PV allocation logic (phase-aware)  
- 📉 Mitigation approaches (PF control, phase balancing, hosting limits)  
- 📁 Supporting documentation (`.md` files) for assumptions and methodology  

Detailed explanations are intentionally split into separate markdown files to keep this repository readable.

---

## Key Engineering Focus
- Realistic LV feeder modeling (not per-unit abstractions)
- Phase-wise voltage behavior
- Impact of uneven PV distribution
- Transformer secondary voltage regulation
- Practical mitigation strategies suitable for utility deployment

---

## Tools & Environment
- **MATLAB / Simulink**
- Power Systems Toolbox
- Script-driven model generation
- Data-driven analysis (hourly load & PV profiles)

---

## Intended Audience
- Power systems engineers  
- Utility planning & R&D teams  
- Researchers working on LV grid modernization  
- Engineers transitioning from theory to field-realistic modeling  

---

## Project Status
Core modeling and analysis completed.  
Current focus:
- Debugging edge-case MATLAB/Simulink errors
- Final validation against voltage compliance criteria
- Documentation consolidation

---

## How to Navigate
Start here:
1. Read this `README.md`
2. Open the supporting `.md` files for modeling assumptions and methodology in the 'docs' folder
3. Review MATLAB scripts for implementation details

---

## Disclaimer
This project is for **engineering analysis and educational use**.  
It is not a turnkey utility planning tool — but it is built using **utility-grade assumptions**.

---

## Author
Electrical & Electronic Engineering  
Focus: Power Systems • Embedded Systems • Cyber-Physical Infrastructure
