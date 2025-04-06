`timescale 1ns / 1ps

module fir_filter(
    input signed [15:0] input_data, // N2 = 16 bits for input
    input CLK,
    input RST,
    input ENABLE,                   // Added ENABLE declaration
    output signed [31:0] output_data, // N3 = 32 bits for output
    output signed [15:0] sampleT    // sampleT output (example connection)
);

// Parameter definitions
parameter N1 = 8;  // Coefficient word width
parameter N2 = 16; // Input data word width
parameter N3 = 32; // Output data word width

// Coefficient array for FIR filter (8 taps)
wire signed [N1-1:0] b [0:7];

// Filter coefficients (each set to 8'b00010000 as an example)
assign b[0] = 8'b00010000;
assign b[1] = 8'b00010000;
assign b[2] = 8'b00010000;
assign b[3] = 8'b00010000;
assign b[4] = 8'b00010000;
assign b[5] = 8'b00010000;
assign b[6] = 8'b00010000;
assign b[7] = 8'b00010000;

// Internal registers for past input samples (7 registers for an 8-tap filter)
// samples[0] holds the most recent past sample, samples[6] the oldest.
reg signed [N2-1:0] samples [0:6];

// Register for the filter output
reg signed [N3-1:0] output_data_reg;

// Connect the internal register to the module output
assign output_data = output_data_reg;

// For this example, we assign sampleT to the current input_data (modify as needed)
assign sampleT = input_data;

always @(posedge CLK) begin
    if (RST == 1'b1) begin   
        // Reset all registers to 0
        samples[0] <= 0;
        samples[1] <= 0;
        samples[2] <= 0;
        samples[3] <= 0;
        samples[4] <= 0;
        samples[5] <= 0;
        samples[6] <= 0;
        output_data_reg <= 0;
    end
    else if ((ENABLE == 1'b1) && (RST == 1'b0)) begin
        // Calculate the FIR filter output
        output_data_reg <= b[0]*input_data +
                           b[1]*samples[0] +
                           b[2]*samples[1] +
                           b[3]*samples[2] +
                           b[4]*samples[3] +
                           b[5]*samples[4] +
                           b[6]*samples[5] +
                           b[7]*samples[6];
                
        // Shift the sample registers:
        // The oldest sample is dropped and each sample is updated
        samples[6] <= samples[5];
        samples[5] <= samples[4];
        samples[4] <= samples[3];
        samples[3] <= samples[2];
        samples[2] <= samples[1];
        samples[1] <= samples[0];
        samples[0] <= input_data;
    end
end
assign output_data=output_data_reg;
assign sampleT=samples[0];

endmodule

