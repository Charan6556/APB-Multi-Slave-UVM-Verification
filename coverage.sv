class apb_coverage extends uvm_subscriber #(apb_seq_item);

  `uvm_component_utils(apb_coverage)

  bit [15:0] addr;
  bit write_op;
  int sample_count;

  //coverage
  covergroup CG1;

    option.per_instance = 1;
    option.name = "apb_cg";

    //read write
    CP1 : coverpoint write_op {
      bins read = {0};
      bins write = {1};
    }

    //slave
    CP2 : coverpoint addr {
      bins slave0 = {[16'h0000:16'h001c]};
      bins slave1 = {[16'h0100:16'h011c]};
    }

    //cross
    CROSS1 : cross CP1,CP2;

  endgroup

  //constructor
  function new(string name = "apb_coverage", uvm_component parent);
    super.new(name,parent);
    CG1 = new();
    sample_count = 0;
  endfunction

  //sample
  function void write(apb_seq_item t);

    addr = t.addr;
    write_op = t.write;

    CG1.sample();
    sample_count++;

  endfunction

  //report phase
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    `uvm_info("COVERAGE",
      $sformatf("samples = %0d Functional Coverage = %.2f%%",
                sample_count,
                CG1.get_inst_coverage()),
      UVM_NONE)

  endfunction

endclass
