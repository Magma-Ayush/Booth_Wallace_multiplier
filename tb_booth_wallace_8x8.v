`timescale 1ns / 1ps

module tb_booth_wallace_8x8;

    reg signed [7:0] A, B;
    wire signed [15:0] P;

    
    booth_wallace_8x8 uut (.A(A), .B(B), .P(P));

    
    initial begin
    
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_booth_wallace_8x8);
        
        
        $display("Time\t\tA\tB\tProduct (P)\tExpected");
        $monitor("%0t\t%d\t%d\t%d\t\t%d", $time, A, B, P, A*B);

        
        A = 5; B = -3; #10;
        if (P !== A*B) $display("ERROR at t=%0t: Mismatch for %d * %d", $time, A, B);
        
        A = -12; B = -7; #10;
        if (P !== A*B) $display("ERROR at t=%0t: Mismatch for %d * %d", $time, A, B);
        
        A = 127; B = 1; #10;
        if (P !== A*B) $display("ERROR at t=%0t: Mismatch for %d * %d", $time, A, B);

        A = -128; B = 1; #10;
        if (P !== A*B) $display("ERROR at t=%0t: Mismatch for %d * %d", $time, A, B);
        
        A = 127; B = -128; #10;
        if (P !== A*B) $display("ERROR at t=%0t: Mismatch for %d * %d", $time, A, B);

        A = 0; B = -55; #10;
        if (P !== A*B) $display("ERROR at t=%0t: Mismatch for %d * %d", $time, A, B);

        // Random test cases
        repeat(10) begin
            A = $random; B = $random; #10;
            if (P !== A*B) $display("ERROR at t=%0t: Mismatch for %d * %d", $time, A, B);
        end
        
        $display("Test complete.");
        $finish;
    end

endmodule

