class apb_monitor extends uvm_monitor;

  `uvm_component_utils(apb_monitor)

  virtual apb_intf intf;
  uvm_analysis_port #(apb_seq_item) item_collected_port;
  apb_seq_item tx;

  //constructor
  function new(string name = "apb_monitor", uvm_component parent);
    super.new(name,parent);
  endfunction

  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    item_collected_port = new("item_collected_port",this);

    if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",intf))
      `uvm_fatal("NO_INTF_MON","virtual interface get failed in monitor")

  endfunction

  //run phase
  task run_phase(uvm_phase phase);

    wait(intf.PRESETN);

    forever begin

      @(intf.monitor_cb);

      if((intf.monitor_cb.PSEL0 || intf.monitor_cb.PSEL1) &&
         intf.monitor_cb.PENABLE &&
         intf.monitor_cb.PREADY) begin

        tx = apb_seq_item::type_id::create("tx");

        tx.addr  = intf.monitor_cb.PADDR;
        tx.write = intf.monitor_cb.PWRITE;
        tx.wdata = intf.monitor_cb.PWDATA;
        tx.rdata = intf.monitor_cb.PRDATA;
        tx.error = intf.monitor_cb.PSLVERR;
        tx.psel0 = intf.monitor_cb.PSEL0;
        tx.psel1 = intf.monitor_cb.PSEL1;

        item_collected_port.write(tx);

      end

    end

  endtask

endclass
