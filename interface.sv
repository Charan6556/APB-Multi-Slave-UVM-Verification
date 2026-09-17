interface apb_intf(input logic PCLK);

  logic PRESETN;

  logic req;
  logic [15:0] addr;
  logic write;
  logic [31:0] wdata;
  logic [31:0] rdata;
  logic done;
  logic error;

  logic [15:0] PADDR;
  logic [31:0] PWDATA;
  logic PWRITE;
  logic PENABLE;
  logic PSEL0;
  logic PSEL1;
  logic [31:0] PRDATA;
  logic PREADY;
  logic PSLVERR;

  //driver clocking block
  clocking driver_cb @(negedge PCLK);
    output req;
    output addr;
    output write;
    output wdata;
    input done;
    input rdata;
    input error;
  endclocking

  //monitor clocking block
  clocking monitor_cb @(posedge PCLK);
    input PADDR;
    input PWDATA;
    input PWRITE;
    input PENABLE;
    input PSEL0;
    input PSEL1;
    input PRDATA;
    input PREADY;
    input PSLVERR;
  endclocking

  //driver modport
  modport DRIVER (
    clocking driver_cb,
    input PRESETN
  );

  //monitor modport
  modport MONITOR (
    clocking monitor_cb,
    input PRESETN
  );

endinterface