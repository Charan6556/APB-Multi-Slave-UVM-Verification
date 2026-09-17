`timescale 1ns/1ns

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "seq_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"
`include "agent.sv"
`include "environment.sv"
`include "test.sv"

module top;

  logic PCLK;

  apb_intf intf(.PCLK(PCLK));

  apb_top DUT (

    .PCLK(PCLK),
    .PRESETN(intf.PRESETN),

    .req(intf.req),
    .addr(intf.addr),
    .write(intf.write),
    .wdata(intf.wdata),

    .rdata(intf.rdata),
    .done(intf.done),
    .error(intf.error),

    .PADDR(intf.PADDR),
    .PWDATA(intf.PWDATA),
    .PWRITE(intf.PWRITE),
    .PENABLE(intf.PENABLE),

    .PSEL0(intf.PSEL0),
    .PSEL1(intf.PSEL1),

    .PRDATA(intf.PRDATA),
    .PREADY(intf.PREADY),
    .PSLVERR(intf.PSLVERR)

  );

  //share interface with uvm components
  initial begin
    uvm_config_db#(virtual apb_intf)::set(null, "*", "vif", intf);
    run_test("apb_test");
  end

  //clock generation
  initial
    PCLK = 0;

  always #5 PCLK = ~PCLK;

  //reset dut
  initial begin

    intf.PRESETN = 0;

    intf.req   = 0;
    intf.addr  = '0;
    intf.write = 0;
    intf.wdata = '0;

    repeat(2) @(posedge PCLK);

    @(negedge PCLK);

    intf.PRESETN = 1;

  end

  //waveform
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, DUT);
  end

endmodule
