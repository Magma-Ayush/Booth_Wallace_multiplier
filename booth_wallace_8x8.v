`timescale 1ns / 1ps



module booth_wallace_8x8 (
    input wire signed [7:0] A,
    input wire signed [7:0] B,
    output wire signed [15:0] P
);

    
    localparam M_WIDTH  = 18;
    
    localparam PP_WIDTH = 24;

   
    wire signed [M_WIDTH-1:0] M_ext = {{ (M_WIDTH-8){A[7]} }, A};
    
   
    wire [9:0] m_ext = {B[7], B, 1'b0};

    
    wire signed [PP_WIDTH-1:0] pp[3:0];


    // generating partial  products of 3 bits
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_gen
            
            wire [2:0] booth_bits = m_ext[2*i+2 -: 3];
            
            reg signed [M_WIDTH+2:0] prod;

           //booth table
            always @(*) begin
                case (booth_bits)
                    3'b000, 3'b111: prod = 0;
                    3'b001, 3'b010: prod = M_ext;
                    3'b011:         prod = M_ext <<< 1; //  +2*M
                    3'b100:         prod = -(M_ext <<< 1); //-2*M
                    3'b101, 3'b110: prod = -M_ext;
                    default:        prod = 0;
                endcase
            end
            
            // Sign-extention
            assign pp[i] = {{ (PP_WIDTH-(M_WIDTH+3)){prod[M_WIDTH+2]} }, prod} << (2*i);
        end
    endgenerate

    // Wallace Tree Reduction 
    
    wire [PP_WIDTH-1:0] s1, c1; 
    wire [PP_WIDTH-1:0] s2, c2; 


    csa3 #(.W(PP_WIDTH)) csa1 (
        .a(pp[0]), 
        .b(pp[1]), 
        .c(pp[2]), 
        .sum(s1), 
        .cout(c1)
    );

    
    csa3 #(.W(PP_WIDTH)) csa2 (
        .a(s1), 
        .b(c1 << 1), // Carry from Stage 1 is shifted left by 1
        .c(pp[3]), 
        .sum(s2), 
        .cout(c2)
    );

   
    assign P = $signed(s2) + $signed(c2 << 1);

    
endmodule
