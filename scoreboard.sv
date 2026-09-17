class apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp #(apb_seq_item, apb_scoreboard) item_collected_export;

  bit [31:0] ref_slave0 [0:7];
  bit [31:0] ref_slave1 [0:7];

  int write_count;
  int read_count;
  int pass_count;

  function new(string name = "apb_scoreboard",
               uvm_component parent);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    item_collected_export =
      new("item_collected_export", this);
  endfunction


  function void write(apb_seq_item tx);

    int index;
    bit [31:0] expected_data;

    if (tx.error)
      `uvm_error("SCOREBOARD",
        $sformatf("Unexpected error response at addr=%h", tx.addr))

    //slave0

    if ((tx.addr >= 16'h0000) &&
        (tx.addr <= 16'h001C)) begin

      index = tx.addr[4:2];

      //check correct slave selection
      if (!(tx.psel0 && !tx.psel1))
        `uvm_error("SCOREBOARD",
                   $sformatf("Wrong slave selected for addr %h",
                             tx.addr))


      if (tx.write) begin

        //update reference model
        ref_slave0[index] = tx.wdata;
        write_count++;

        `uvm_info("SCOREBOARD",
          $sformatf("SLAVE0 WRITE addr=%h data=%h",
                    tx.addr, tx.wdata),
          UVM_MEDIUM)

      end

      else begin

        read_count++;
        expected_data = ref_slave0[index];

        if (tx.rdata !== expected_data)
          `uvm_error("SCOREBOARD",
            $sformatf(
              "SLAVE0 READ FAIL addr=%h expected=%h actual=%h",
              tx.addr,
              expected_data,
              tx.rdata))

        else begin
          pass_count++;
          `uvm_info("SCOREBOARD",
            $sformatf(
              "SLAVE0 READ PASS addr=%h expected=%h actual=%h",
              tx.addr,
              expected_data,
              tx.rdata),
            UVM_MEDIUM)
        end

      end

    end


    //slave1

    else if ((tx.addr >= 16'h0100) &&
             (tx.addr <= 16'h011C)) begin

      index = (tx.addr - 16'h0100) >> 2;

      //check correct slave selection
      if (!(!tx.psel0 && tx.psel1))
        `uvm_error("SCOREBOARD",
                   $sformatf("Wrong slave selected for addr %h",
                             tx.addr))


      if (tx.write) begin

        ref_slave1[index] = tx.wdata;
        write_count++;

        `uvm_info("SCOREBOARD",
          $sformatf("SLAVE1 WRITE addr=%h data=%h",
                    tx.addr, tx.wdata),
          UVM_MEDIUM)

      end

      else begin

        read_count++;
        expected_data = ref_slave1[index];

        if (tx.rdata !== expected_data)
          `uvm_error("SCOREBOARD",
            $sformatf(
              "SLAVE1 READ FAIL addr=%h expected=%h actual=%h",
              tx.addr,
              expected_data,
              tx.rdata))

        else begin
          pass_count++;
          `uvm_info("SCOREBOARD",
            $sformatf(
              "SLAVE1 READ PASS addr=%h expected=%h actual=%h",
              tx.addr,
              expected_data,
              tx.rdata),
            UVM_MEDIUM)
        end

      end

    end


    //invalid address

    else begin

      `uvm_warning("SCOREBOARD",
        $sformatf("Invalid address observed: %h",
                  tx.addr))

    end

  endfunction

  //report phase
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    `uvm_info("SCOREBOARD",
      $sformatf("writes=%0d reads=%0d read_pass=%0d",
                write_count, read_count, pass_count),
      UVM_NONE)

  endfunction

endclass
