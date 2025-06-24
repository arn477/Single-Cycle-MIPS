LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlLogicUnit IS
    PORT(
        clk, reset : IN STD_LOGIC;
        opcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0); -- 6-bit opcode
        regDst : OUT STD_LOGIC;
        jump : OUT STD_LOGIC;
        branch : OUT STD_LOGIC;
        memRead : OUT STD_LOGIC;
        memToReg : OUT STD_LOGIC;
        aluOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        memWrite : OUT STD_LOGIC;
        aluSrc : OUT STD_LOGIC;
        regWrite : OUT STD_LOGIC;
        branchNotEq : OUT STD_LOGIC
    ); 
END controlLogicUnit;

ARCHITECTURE Behavioural OF controlLogicUnit IS
BEGIN 
    PROCESS(reset, opcode)
    BEGIN
        IF (reset = '1') THEN
            regDst <= '0';
            aluSrc <= '0';
            memToReg <= '0';
            regWrite <= '0';
            memRead <= '0';
            memWrite <= '0';
            jump <= '0';
            branch <= '0';
            branchNotEq <= '0';
            aluOp <= "00";
        ELSE 
            CASE opcode IS
                WHEN "000000" => -- R-type
                    regDst <= '1';
                    aluSrc <= '0';
                    memToReg <= '0';
                    regWrite <= '1';
                    memRead <= '0';
                    memWrite <= '0';
                    jump <= '0';
                    branch <= '0';
                    branchNotEq <= '0';
                    aluOp <= "10";

                WHEN "100011" => -- lw
                    regDst <= '0';
                    aluSrc <= '1';
                    memToReg <= '1';
                    regWrite <= '1';
                    memRead <= '1';
                    memWrite <= '0';
                    jump <= '0';
                    branch <= '0';
                    branchNotEq <= '0';
                    aluOp <= "00";

                WHEN "101011" => -- sw
                    regDst <= '0'; -- don't care
                    aluSrc <= '1';
                    memToReg <= '0'; -- don't care
                    regWrite <= '0';
                    memRead <= '0';
                    memWrite <= '1';
                    jump <= '0';
                    branch <= '0';
                    branchNotEq <= '0';
                    aluOp <= "00";

                WHEN "000100" => -- beq
                    regDst <= '0'; -- don't care
                    aluSrc <= '0';
                    memToReg <= '0'; -- don't care
                    regWrite <= '0';
                    memRead <= '0';
                    memWrite <= '0';
                    jump <= '0';
                    branch <= '1';
                    branchNotEq <= '0';
                    aluOp <= "01";

                WHEN "000101" => -- bne
                    regDst <= '0'; -- don't care
                    aluSrc <= '0';
                    memToReg <= '0'; -- don't care
                    regWrite <= '0';
                    memRead <= '0';
                    memWrite <= '0';
                    jump <= '0';
                    branch <= '0';
                    branchNotEq <= '1';
                    aluOp <= "01";

                WHEN "000010" => -- jump
                    regDst <= '0'; 
                    aluSrc <= '0';
                    memToReg <= '0'; 
                    regWrite <= '0';
                    memRead <= '0';
                    memWrite <= '0';
                    jump <= '1';
                    branch <= '0';
                    branchNotEq <= '0';
                    aluOp <= "00";

                WHEN OTHERS =>
                    regDst <= '0';
                    aluSrc <= '0';
                    memToReg <= '0';
                    regWrite <= '0';
                    memRead <= '0';
                    memWrite <= '0';
                    jump <= '0';
                    branch <= '0';
                    branchNotEq <= '0';
                    aluOp <= "00";
                    
            END CASE;
        END IF;
    END PROCESS;
END Behavioural;
