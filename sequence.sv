class apb_sequence extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(apb_sequence)

  apb_seq_item tx;

  function new(string name = "apb_sequence");
    super.new(name);
  endfunction

  task body();

    repeat(20) begin

      tx = apb_seq_item::type_id::create("tx");

      start_item(tx);

      if (!tx.randomize())
        `uvm_error("SEQ", "Transaction randomization failed")

      finish_item(tx);

    end

  endtask

endclass

class apb_balanced_sequence extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(apb_balanced_sequence)

  apb_seq_item tx;

  //constructor
  function new(string name = "apb_balanced_sequence");
    super.new(name);
  endfunction

  //body
  task body();

    //slave0 writes
    repeat(5) begin
      tx = apb_seq_item::type_id::create("tx");

      start_item(tx);

      if(!tx.randomize() with {
        addr inside {
          16'h0000,16'h0004,16'h0008,16'h000C,
          16'h0010,16'h0014,16'h0018,16'h001C
        };
        write == 1'b1;
      })
        `uvm_error("SEQ","slave0 write randomization failed")

      finish_item(tx);
    end

    //slave0 reads
    repeat(5) begin
      tx = apb_seq_item::type_id::create("tx");

      start_item(tx);

      if(!tx.randomize() with {
        addr inside {
          16'h0000,16'h0004,16'h0008,16'h000C,
          16'h0010,16'h0014,16'h0018,16'h001C
        };
        write == 1'b0;
      })
        `uvm_error("SEQ","slave0 read randomization failed")

      finish_item(tx);
    end

    //slave1 writes
    repeat(5) begin
      tx = apb_seq_item::type_id::create("tx");

      start_item(tx);

      if(!tx.randomize() with {
        addr inside {
          16'h0100,16'h0104,16'h0108,16'h010C,
          16'h0110,16'h0114,16'h0118,16'h011C
        };
        write == 1'b1;
      })
        `uvm_error("SEQ","slave1 write randomization failed")

      finish_item(tx);
    end

    //slave1 reads
    repeat(5) begin
      tx = apb_seq_item::type_id::create("tx");

      start_item(tx);

      if(!tx.randomize() with {
        addr inside {
          16'h0100,16'h0104,16'h0108,16'h010C,
          16'h0110,16'h0114,16'h0118,16'h011C
        };
        write == 1'b0;
      })
        `uvm_error("SEQ","slave1 read randomization failed")

      finish_item(tx);
    end

  endtask

endclass


class apb_write_read_sequence extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(apb_write_read_sequence)

  apb_seq_item tx;

  bit [15:0] addr_temp;

  //constructor
  function new(string name = "apb_write_read_sequence");
    super.new(name);
  endfunction

  //body
  task body();

    //slave0 write and read
    repeat(5) begin

      //write
      tx = apb_seq_item::type_id::create("tx");

      start_item(tx);

      if(!tx.randomize() with {
        addr inside {
          16'h0000,16'h0004,16'h0008,16'h000c,
          16'h0010,16'h0014,16'h0018,16'h001c
        };
        write == 1'b1;
      })
        `uvm_error("SEQ","slave0 write randomization failed")

      addr_temp = tx.addr;

      finish_item(tx);


      //read same address
      tx = apb_seq_item::type_id::create("tx");

      start_item(tx);

      if(!tx.randomize() with {
        addr == addr_temp;
        write == 1'b0;
        wdata == 32'h0;
      })
        `uvm_error("SEQ","slave0 read randomization failed")

      finish_item(tx);

    end


    //slave1 write and read
    repeat(5) begin

      //write
      tx = apb_seq_item::type_id::create("tx");

      start_item(tx);

      if(!tx.randomize() with {
        addr inside {
          16'h0100,16'h0104,16'h0108,16'h010c,
          16'h0110,16'h0114,16'h0118,16'h011c
        };
        write == 1'b1;
      })
        `uvm_error("SEQ","slave1 write randomization failed")

      addr_temp = tx.addr;

      finish_item(tx);


      //read same address
      tx = apb_seq_item::type_id::create("tx");

      start_item(tx);

      if(!tx.randomize() with {
        addr == addr_temp;
        write == 1'b0;
        wdata == 32'h0;
      })
        `uvm_error("SEQ","slave1 read randomization failed")

      finish_item(tx);

    end

  endtask

endclass
