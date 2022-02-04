module IC74194(clk, CLR, S1, S0, A, B, C, D, LIN, QA, QB, QC, QD);
    input clk, CLR, S1, S0, A, B, C, D;
    output LIN, QA, QB, QC, QD;
    reg LIN, QA, QB, QC, QD;
    always @(posedge clk or negedge CLR) begin
        if (!CLR) begin
            QA <= 0; QB <= 0; QC <= 0; QD <= 0;
        end 
        else if (S1 == 0 & S0 == 0) begin // HOLD
            QA <= QA; QB <= QB; QC <= QC; QD <= QD;
        end
        /*
        else if (S1 == 0 & S0 == 1) begin // Q >> 1
            QA <= RIN; QB <= A; QC <= B; QD <= C;
        end
        */
        else if (S1 == 1 & S0 == 0) begin // Q << 1
            QA <= B; QB <= C; QC <= D; QD <= LIN;
        end
        // (S1 == 1 & S0 == 1)
        else begin // LOAD
            QA <= A; QB <= B; QC <= C; QD <= D;
        end
    end

    always @(posedge clk or negedge CLR) begin
        LIN <= (~(QD | QC) | (QC | QB));
    end

endmodule // IC74194

module tb_IC74194;
    reg clk, CLR, S1, S0, A, B, C, D;
    wire LIN, QA, QB, QC, QD;

    IC74194 inst(clk, CLR, S1, S0, A, B, C, D, LIN, QA, QB, QC, QD);

    initial begin
        clk = 1'b0;
        // initialization to avoid dont care state
        CLR = 1'b0; A = 0; B = 0; C = 0; D = 0;
        repeat(50)
        #10 clk = ~clk;
    end

    initial begin
        #10 CLR = 1'b1; S1 = 1'b0; S0 = 1'b0;
        #50 S1 = 1'b1; S0 = 1'b0;
        #50 A = 1'b0; B = 1'b0; C = 1'b0; D = 1'b1;
        #250 $finish;    
    end
endmodule // tb_IC74194