class apb_test extends uvm_test;

  `uvm_component_utils(apb_test)

  apb_environment env;
  apb_write_read_sequence seq;

  //constructor
  function new(string name = "apb_test",
               uvm_component parent);
    super.new(name, parent);
  endfunction

  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_environment::type_id::create("env", this);
  endfunction

  //end of elaboration
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();
  endfunction

  //run phase
  task run_phase(uvm_phase phase);

    //allow monitor and scoreboard to finish final transaction
    phase.phase_done.set_drain_time(this, 50ns);

    phase.raise_objection(this);

    seq = apb_write_read_sequence::type_id::create("seq");

    seq.start(env.agent.seqr);

    phase.drop_objection(this);

  endtask

endclass
