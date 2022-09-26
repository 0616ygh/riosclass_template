# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|

## 
Refer to [README](docs/source/quickstart.rst) for a quick start of how to use caravel_user_project

Refer to [README](docs/source/index.rst) for this sample project documentation. 

## Notice
Here is RIOS Advanced Microprocessor Design Course Lab Template.

Your RTL and C model should be placed in riosclass_template/verilog and riosclass_template/cmodel.

Your lab report should be placed in riosclass_template/rpt.

We use this template for lab 1, lab 2, lab 3, final project and OpenMPW precheck. 

## Lab 1 Notice

The RTL code path: riosclass_template\verilog\rtl\lab_1\src

GreenRio, AKA hehe, is a small RISC-V CPU. 

For Lab 1:

### RTL
1. "riosclass_template\verilog\rtl\lab_1\src" is the GreenRio RTL source code path. Some tests have been passed. You will use all files in 'core_empty'(except 'mmu'), 'cache', 'params.vh', 'bus_arbiter.v' and 'hehe.v' for simulation and logic synthesis.
    1. core_empty:  the function_unit modules, pipeline, and core_empty top RTL codes; 'core_empty' means that the source codes here are the pure core parts of the CPU, excluding cache and sram.
    
    2. cache: the cache parts of CPU; the sram is instantiated at the top of the cache module.

    3. bus_arbiter: communication bus between SoC and core.

    4. hehe: the top of GreenRio CPU.
    

2. Other files should not be used in lab1, but will be used in later labs.

3. You can access the spec documentaion at riosclass_template\spec\HeHecore.md.

