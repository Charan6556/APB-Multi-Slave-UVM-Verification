#!/usr/bin/env bash

set -e

xrun -Q -unbuffered \
  -timescale 1ns/1ns \
  -sysv \
  -access +rw \
  -coverage all \
  -uvm \
  design.sv testbench.sv
