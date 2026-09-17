module apb_slave0 #(
  parameter ADDR_WIDTH = 16,
  parameter DATA_WIDTH = 32
)(
  input  logic                  PCLK,
  input  logic                  PRESETN,
  input  logic                  PSEL0,
  input  logic                  PWRITE,
  input  logic                  PENABLE,
  input  logic [ADDR_WIDTH-1:0] PADDR,
  input  logic [DATA_WIDTH-1:0] PWDATA,
  
  output logic [DATA_WIDTH-1:0] PRDATA0,
  output logic                  PREADY0,
  output logic                  PSLVERR0
);
  
  logic [DATA_WIDTH-1:0] mem [0:7];
  
  integer i;

  //ready response
  always_comb begin
    PREADY0  = 1'b0;
    PSLVERR0 = 1'b0;

    if (PSEL0 && PENABLE)
      PREADY0 = 1'b1;
  end

  //write
  always_ff @(posedge PCLK) begin
    if (!PRESETN) begin
      for (i = 0; i < 8; i = i + 1)
        mem[i] <= '0;
    end
    else if (PSEL0 && PENABLE && PWRITE)
      mem[PADDR[4:2]] <= PWDATA;
  end

  //read
  always_comb begin
    PRDATA0 = '0;

    if (PSEL0 && PENABLE && !PWRITE)
      PRDATA0 = mem[PADDR[4:2]];
  end

endmodule
