module apb_slave1 #(
  parameter ADDR_WIDTH = 16,
  parameter DATA_WIDTH = 32
)(
  input  logic                  PCLK,
  input  logic                  PRESETN,
  input  logic                  PSEL1,
  input  logic                  PWRITE,
  input  logic                  PENABLE,
  input  logic [ADDR_WIDTH-1:0] PADDR,
  input  logic [DATA_WIDTH-1:0] PWDATA,

  output logic [DATA_WIDTH-1:0] PRDATA1,
  output logic                  PREADY1,
  output logic                  PSLVERR1
);

  logic [DATA_WIDTH-1:0] mem [0:7];
  logic [1:0] wait_count;

  integer i;

  // Wait-state counter
  always_ff @(posedge PCLK) begin
    if (!PRESETN)
      wait_count <= 0;

    else if (PSEL1 && PENABLE) begin
      if (wait_count < 2)
        wait_count <= wait_count + 1;
      else
        wait_count <= 0;
    end

    else
      wait_count <= 0;
  end

  // Ready and error response
  always_comb begin
    PREADY1  = 1'b0;
    PSLVERR1 = 1'b0;

    if (PSEL1 && PENABLE && wait_count == 2)
      PREADY1 = 1'b1;
  end

  // Write
  always_ff @(posedge PCLK) begin
    if (!PRESETN) begin
      for (i = 0; i < 8; i = i + 1)
        mem[i] <= '0;
    end

    else if (PSEL1 && PENABLE && PREADY1 && PWRITE)
      mem[PADDR[4:2]] <= PWDATA;
  end

  // Read
  always_comb begin
    PRDATA1 = '0;

    if (PSEL1 && PENABLE && PREADY1 && !PWRITE)
      PRDATA1 = mem[PADDR[4:2]];
  end

endmodule