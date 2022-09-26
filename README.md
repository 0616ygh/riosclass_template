# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|

## 
Refer to [README](docs/source/quickstart.rst) for a quick start of how to use caravel_user_project

Refer to [README](docs/source/index.rst) for this sample project documentation. 

## Notice
Here is RIOS Advanced Microprocessor Design Course Lab Template.

Your RTL and C model should be placed in verilog/labrtl and verilog/cmodel.

Your lab report should be placed in verilog/rpt.

We use this template for lab 1, lab 2, lab 3, final project and OpenMPW precheck. 

## Lab 1 Notice

The RTL code path: riosclass_template\verilog\rtl\labrtl

GreenRio, AKA hehe, is a small RISC-V CPU. 

For Lab 1:

1. riosclass_template\verilog\rtl\labrtl\hehe\src is the GreenRio RTL source code path. You will use all files in 'core_empty'(except 'mmu'), 'cache__sram_in_cache', 'params.vh' and 'hehe.v' for simulation and synthesis.
    1. core_empty:  the function_unit modules, pipeline, and core_empty top RTL codes; 'core_empty' means that the source codes here are the pure core parts of the CPU, excluding cache and sram.
    
    2. cache__sram_in_cache: the cache parts of CPU; the sram is instantiated at the top of the cache module.
    
    3. cache__sram_out_cache: the SRAMs are out of cache_top; that means cache module is an interface between sram and core_empty.

2. Other files should not be used in lab1, but will be used in later labs.


