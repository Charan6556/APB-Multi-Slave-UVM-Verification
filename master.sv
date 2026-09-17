module apb_master #(
  parameter ADDR_WIDTH = 16,
  parameter DATA_WIDTH = 32
)(
  input  logic                  PCLK,
  input  logic                  PRESETN,
  input  logic [ADDR_WIDTH-1:0] addr,
  input  logic [DATA_WIDTH-1:0] wdata,
  input  logic                  write,
  input  logic                  req,
  input  logic [DATA_WIDTH-1:0] PRDATA,
  input  logic                  PREADY,
  input  logic                  PSLVERR,

  output logic [DATA_WIDTH-1:0] rdata,
  output logic                  done,
  output logic                  error,
  output logic [ADDR_WIDTH-1:0] PADDR,
  output logic [DATA_WIDTH-1:0] PWDATA,
  output logic                  PWRITE,
  output logic                  PENABLE,
  output logic                  PSEL0,
  output logic                  PSEL1
);

  typedef enum logic [1:0] {
    IDLE,
    SETUP,
    ACCESS
  } state_t;

  state_t current_state, next_state;

  logic [ADDR_WIDTH-1:0] addr_reg;
  logic [DATA_WIDTH-1:0] wdata_reg;
  logic                  write_reg;


  // State register
  always_ff @(posedge PCLK) begin
    if (!PRESETN)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end


  // Capture request
  always_ff @(posedge PCLK) begin
    if (!PRESETN) begin
      addr_reg  <= '0;
      wdata_reg <= '0;
      write_reg <= 1'b0;
    end
    else if (current_state == IDLE && req) begin
      addr_reg  <= addr;
      wdata_reg <= wdata;
      write_reg <= write;
    end
  end


  // Next-state logic
  always_comb begin
    next_state = current_state;

    case (current_state)

      IDLE: begin
        if (req)
          next_state = SETUP;
      end

      SETUP: begin
        next_state = ACCESS;
      end

      ACCESS: begin
        if (PREADY)
          next_state = IDLE;
        else
          next_state = ACCESS;
      end

      default:
        next_state = IDLE;

    endcase
  end


  // APB output logic
  always_comb begin

    PADDR   = addr_reg;
    PWDATA  = wdata_reg;
    PWRITE  = write_reg;

    PENABLE = 1'b0;
    PSEL0   = 1'b0;
    PSEL1   = 1'b0;

    case (current_state)

      IDLE: begin
      end

      SETUP: begin
        if (addr_reg <= 16'h00FF)
          PSEL0 = 1'b1;
        else if ((addr_reg >= 16'h0100) &&
                 (addr_reg <= 16'h01FF))
          PSEL1 = 1'b1;
      end

      ACCESS: begin
        PENABLE = 1'b1;

        if (addr_reg <= 16'h00FF)
          PSEL0 = 1'b1;
        else if ((addr_reg >= 16'h0100) &&
                 (addr_reg <= 16'h01FF))
          PSEL1 = 1'b1;
      end

      default: begin
      end

    endcase
  end


  // Response handling
  always_ff @(posedge PCLK) begin
    if (!PRESETN) begin
      rdata <= '0;
      done  <= 1'b0;
      error <= 1'b0;
    end
    else begin
      done  <= 1'b0;
      error <= 1'b0;

      if (current_state == ACCESS && PREADY) begin
        done  <= 1'b1;
        error <= PSLVERR;

        if (!write_reg)
          rdata <= PRDATA;
      end
    end
  end

endmodule
