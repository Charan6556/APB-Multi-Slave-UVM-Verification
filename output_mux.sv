module apb_response_mux #(
  parameter DATA_WIDTH = 32
)(
  input  logic                  PSEL0,
  input  logic                  PSEL1,

  input  logic [DATA_WIDTH-1:0] PRDATA0,
  input  logic                  PREADY0,
  input  logic                  PSLVERR0,

  input  logic [DATA_WIDTH-1:0] PRDATA1,
  input  logic                  PREADY1,
  input  logic                  PSLVERR1,

  output logic [DATA_WIDTH-1:0] PRDATA,
  output logic                  PREADY,
  output logic                  PSLVERR
);

  always_comb begin

    PRDATA  = '0;
    PREADY  = 1'b0;
    PSLVERR = 1'b0;

    if (PSEL0) begin
      PRDATA  = PRDATA0;
      PREADY  = PREADY0;
      PSLVERR = PSLVERR0;
    end

    else if (PSEL1) begin
      PRDATA  = PRDATA1;
      PREADY  = PREADY1;
      PSLVERR = PSLVERR1;
    end

  end

endmodule