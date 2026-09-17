`include "master.sv"
`include "slave0.sv"
`include "slave1.sv"
`include "output_mux.sv"
`include "assertions.sv"

module apb_top #(
  parameter ADDR_WIDTH = 16,
  parameter DATA_WIDTH = 32
)(
  input logic PCLK,
  input logic PRESETN,

  input logic req,
  input logic [ADDR_WIDTH-1:0] addr,
  input logic write,
  input logic [DATA_WIDTH-1:0] wdata,

  output logic [DATA_WIDTH-1:0] rdata,
  output logic done,
  output logic error,

  output logic [ADDR_WIDTH-1:0] PADDR,
  output logic [DATA_WIDTH-1:0] PWDATA,
  output logic PWRITE,
  output logic PENABLE,
  output logic PSEL0,
  output logic PSEL1,

  output logic [DATA_WIDTH-1:0] PRDATA,
  output logic PREADY,
  output logic PSLVERR
);

  logic [DATA_WIDTH-1:0] PRDATA0;
  logic PREADY0;
  logic PSLVERR0;

  logic [DATA_WIDTH-1:0] PRDATA1;
  logic PREADY1;
  logic PSLVERR1;


  apb_master #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) master (
    .PCLK(PCLK),
    .PRESETN(PRESETN),

    .addr(addr),
    .wdata(wdata),
    .write(write),
    .req(req),

    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR),

    .rdata(rdata),
    .done(done),
    .error(error),

    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .PSEL0(PSEL0),
    .PSEL1(PSEL1)
  );


  apb_slave0 #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) slave0 (
    .PCLK(PCLK),
    .PRESETN(PRESETN),

    .PSEL0(PSEL0),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .PADDR(PADDR),
    .PWDATA(PWDATA),

    .PRDATA0(PRDATA0),
    .PREADY0(PREADY0),
    .PSLVERR0(PSLVERR0)
  );


  apb_slave1 #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) slave1 (
    .PCLK(PCLK),
    .PRESETN(PRESETN),

    .PSEL1(PSEL1),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .PADDR(PADDR),
    .PWDATA(PWDATA),

    .PRDATA1(PRDATA1),
    .PREADY1(PREADY1),
    .PSLVERR1(PSLVERR1)
  );


  apb_response_mux #(
    .DATA_WIDTH(DATA_WIDTH)
  ) response_mux (
    .PSEL0(PSEL0),
    .PSEL1(PSEL1),

    .PRDATA0(PRDATA0),
    .PREADY0(PREADY0),
    .PSLVERR0(PSLVERR0),

    .PRDATA1(PRDATA1),
    .PREADY1(PREADY1),
    .PSLVERR1(PSLVERR1),

    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR)
  );
  
  apb_assertions #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) assertions (
    .PCLK(PCLK),
    .PRESETN(PRESETN),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .PSEL0(PSEL0),
    .PSEL1(PSEL1),
    .PREADY(PREADY)
  );

endmodule
