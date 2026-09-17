class apb_seq_item extends uvm_sequence_item;

  rand bit [15:0] addr;
  rand bit        write;
  rand bit [31:0] wdata;

  logic [31:0] rdata;
  logic        error;
  logic        psel0;
  logic        psel1;

  `uvm_object_utils_begin(apb_seq_item)
    `uvm_field_int(addr,   UVM_ALL_ON)
    `uvm_field_int(write,  UVM_ALL_ON)
    `uvm_field_int(wdata,  UVM_ALL_ON)
    `uvm_field_int(rdata,  UVM_ALL_ON)
    `uvm_field_int(error,  UVM_ALL_ON)
    `uvm_field_int(psel0,  UVM_ALL_ON)
    `uvm_field_int(psel1,  UVM_ALL_ON)
  `uvm_object_utils_end

  constraint addr_c {
    addr inside {
      [16'h0000 : 16'h001C],
      [16'h0100 : 16'h011C]
    };
  }

  constraint align_c {
    addr[1:0] == 2'b00;
  }

  constraint write_c {
    write dist {
      1'b1 := 50,
      1'b0 := 50
    };
  }

  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction

endclass
