module apb_assertions #(
  parameter ADDR_WIDTH = 16,
  parameter DATA_WIDTH = 32
)(
  input logic PCLK,
  input logic PRESETN,
  input logic [ADDR_WIDTH-1:0] PADDR,
  input logic [DATA_WIDTH-1:0] PWDATA,
  input logic PWRITE,
  input logic PENABLE,
  input logic PSEL0,
  input logic PSEL1,
  input logic PREADY
);

  //both slaves should not select together
  property p_one_slave;
    @(posedge PCLK)
    disable iff(!PRESETN)
    !(PSEL0 && PSEL1);
  endproperty

  a_one_slave : assert property(p_one_slave);


  //setup should move to access
  property p_setup_to_access;
    @(posedge PCLK)
    disable iff(!PRESETN)
    ((PSEL0 || PSEL1) && !PENABLE) |=> PENABLE;
  endproperty

  a_setup_to_access : assert property(p_setup_to_access);


  //penable should have a selected slave
  property p_enable_with_select;
    @(posedge PCLK)
    disable iff(!PRESETN)
    PENABLE |-> (PSEL0 || PSEL1);
  endproperty

  a_enable_with_select : assert property(p_enable_with_select);


  //address stable during wait state
  property p_addr_stable;
    @(posedge PCLK)
    disable iff(!PRESETN)
    (PENABLE && !PREADY) |=> $stable(PADDR);
  endproperty

  a_addr_stable : assert property(p_addr_stable);


  //write control stable during wait state
  property p_write_stable;
    @(posedge PCLK)
    disable iff(!PRESETN)
    (PENABLE && !PREADY) |=> $stable(PWRITE);
  endproperty

  a_write_stable : assert property(p_write_stable);


  //write data stable during wait state
  property p_wdata_stable;
    @(posedge PCLK)
    disable iff(!PRESETN)
    (PENABLE && !PREADY && PWRITE) |=> $stable(PWDATA);
  endproperty

  a_wdata_stable : assert property(p_wdata_stable);


  //slave select stable during wait state
  property p_select_stable;
    @(posedge PCLK)
    disable iff(!PRESETN)
    (PENABLE && !PREADY) |=> $stable({PSEL0,PSEL1});
  endproperty

  a_select_stable : assert property(p_select_stable);


  //reset should keep control low
  property p_reset;
    @(posedge PCLK)
    !PRESETN |-> (!PSEL0 && !PSEL1 && !PENABLE);
  endproperty

  a_reset : assert property(p_reset);

endmodule
