class apb_environment extends uvm_env;

  `uvm_component_utils(apb_environment)

  apb_agent agent;
  apb_scoreboard scoreboard;
  apb_coverage coverage;

  //constructor standard
  function new(string name = "apb_environment", uvm_component parent);
    super.new(name,parent);
  endfunction

  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = apb_agent::type_id::create("agent", this);
    scoreboard = apb_scoreboard::type_id::create("scoreboard", this);
    coverage = apb_coverage::type_id::create("coverage", this);

  endfunction

  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agent.mon.item_collected_port.connect(scoreboard.item_collected_export);
    agent.mon.item_collected_port.connect(coverage.analysis_export);

  endfunction

endclass
