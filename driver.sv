class apb_driver extends uvm_driver #(apb_seq_item);

  `uvm_component_utils(apb_driver)

  virtual apb_intf intf;
  apb_seq_item tx;

  //constructor
  function new(string name = "apb_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (!uvm_config_db#(virtual apb_intf)::get(this, "", "vif", intf))
      `uvm_fatal("NO_INTF_DRIVER",
                 "Virtual interface get failed from config db")
  endfunction

  //run phase
  task run_phase(uvm_phase phase);

    //wait until reset is released
    wait(intf.PRESETN == 1'b1);

    //keep request low initially
    intf.driver_cb.req <= 1'b0;

    forever begin
      seq_item_port.get_next_item(tx);
      drive(tx);
      seq_item_port.item_done();
    end

  endtask

  //drive one apb request
  task drive(apb_seq_item tx);

    //drive request before next rising edge
    @(intf.driver_cb);

    intf.driver_cb.addr  <= tx.addr;
    intf.driver_cb.write <= tx.write;
    intf.driver_cb.wdata <= tx.wdata;
    intf.driver_cb.req   <= 1'b1;

    //keep request high for one clock cycle
    @(intf.driver_cb);
    intf.driver_cb.req <= 1'b0;

    //wait until apb master completes transaction
    while (!intf.driver_cb.done)
      @(intf.driver_cb);

  endtask

endclass
