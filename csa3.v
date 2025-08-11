module csa3 #(parameter W = 24) (
    input wire [W-1:0] a,
    input wire [W-1:0] b,
    input wire [W-1:0] c,
    output wire [W-1:0] sum,
    output wire [W-1:0] cout
);

    
    assign sum = a ^ b ^ c;
    
  
    assign cout = (a & b) | (b & c) | (c & a);

endmodule