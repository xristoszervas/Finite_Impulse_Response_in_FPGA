`timescale 1ns / 1ps

module fir_simulation;

  parameter N1 = 8;
  parameter N2 = 16;
  parameter N3 = 32;

  reg CLK;
  reg RST;
  reg ENABLE; // Added declaration for ENABLE
  reg [N2-1:0] input_data;
  reg [N2-1:0] data[99:0];
  wire [N3-1:0] output_data;
  wire [N2-1:0] sampleT;

  // Instantiate the FIR filter
  fir_filter UUT (
    .input_data(input_data),
    .output_data(output_data),
    .CLK(CLK),
    .RST(RST),
    .ENABLE(ENABLE),
    .sampleT(sampleT)
  );

  integer k;
  integer FILE1;

  // Clock generation: 20 ns period (10 ns high, 10 ns low)
  always #10 CLK = ~CLK;

  initial begin
      // Load input data and open output file
      $readmemb("input.data", data);
      FILE1 = $fopen("save.data", "w");

      // Initialize signals 
      CLK = 0;
      RST = 1'b1;    // Assert reset (modify if your design uses active-low reset)
      ENABLE = 1'b0; // Disable the filter initially

      // Deassert reset and enable the filter
      #20;
      RST = 1'b0;
      ENABLE = 1'b1; 
      input_data <= data[0];

      #10;
      // Process remaining samples
      for (k = 1; k < 100; k = k + 1) begin
          @ (posedge CLK);
          $fdisplay(FILE1, "%b", output_data);
          input_data <= data[k];
          if (k == 99)
              $fclose(FILE1);
      end
      
      $finish; // End the simulation
  end

endmodule

