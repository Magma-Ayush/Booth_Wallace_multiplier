`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ayush Sharma
// 
// Create Date: 11.08.2025 18:08:34
// Design Name: 
// Module Name: booth_wallace_8x8
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module booth_wallace_8x8 (
    input wire signed [7:0] A,
    input wire signed [7:0] B,
    output wire signed [15:0] P
);

    // Width of the sign-extended multiplicand
    localparam M_WIDTH  = 18;
    // Width of each partial product after Booth decoding and shifting
    localparam PP_WIDTH = 24;

    // Sign-extended multiplicand (A)
    wire signed [M_WIDTH-1:0] M_ext = {{ (M_WIDTH-8){A[7]} }, A};
    
    // Multiplier (B) extended for Radix-4 Booth recoding: {B_sign, B[7:0], 0}
    // This creates overlapping groups of 3 bits for recoding.
    wire [9:0] m_ext = {B[7], B, 1'b0};

    // Array to hold the 4 partial products
    wire signed [PP_WIDTH-1:0] pp[3:0];


    // Generate block for Radix-4 Booth Partial Product Generation
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_gen
            // Select 3 bits of the multiplier for recoding
            wire [2:0] booth_bits = m_ext[2*i+2 -: 3];
            // Intermediate product from Booth table lookup
            reg signed [M_WIDTH+2:0] prod;

            // Combinational block to implement the Booth recoding logic
            always @(*) begin
                case (booth_bits)
                    3'b000, 3'b111: prod = 0;
                    3'b001, 3'b010: prod = M_ext;
                    3'b011:         prod = M_ext <<< 1; // Corresponds to +2*M
                    3'b100:         prod = -(M_ext <<< 1); // Corresponds to -2*M
                    3'b101, 3'b110: prod = -M_ext;
                    default:        prod = 0;
                endcase
            end
            
            // Sign-extend the intermediate product to the full partial product width
            // and then shift it left by the appropriate amount (2*i for Radix-4).
            assign pp[i] = {{ (PP_WIDTH-(M_WIDTH+3)){prod[M_WIDTH+2]} }, prod} << (2*i);
        end
    endgenerate

    // Wallace Tree Reduction using two stages of Carry-Save Adders
    
    wire [PP_WIDTH-1:0] s1, c1; // Sum and Carry from stage 1
    wire [PP_WIDTH-1:0] s2, c2; // Sum and Carry from stage 2

    // Stage 1: Reduce 3 partial products (pp0, pp1, pp2) into one sum (s1) and one carry (c1) vector.
    csa3 #(.W(PP_WIDTH)) csa1 (
        .a(pp[0]), 
        .b(pp[1]), 
        .c(pp[2]), 
        .sum(s1), 
        .cout(c1)
    );

    // Stage 2: Reduce the sum (s1) and shifted carry (c1<<1) from stage 1, and the final
    // partial product (pp3), into a final sum (s2) and carry (c2) vector.
    csa3 #(.W(PP_WIDTH)) csa2 (
        .a(s1), 
        .b(c1 << 1), // Carry from Stage 1 is shifted left by 1
        .c(pp[3]), 
        .sum(s2), 
        .cout(c2)
    );

    // Final Adder Stage (Propagate Carry Adder)
    // Adds the final sum and shifted carry vectors to get the final product.
    // The result is automatically truncated to P's 16-bit width.
    assign P = $signed(s2) + $signed(c2 << 1);

    
endmodule
