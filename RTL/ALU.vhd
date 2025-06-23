LIBRARY ieee;
USE ieee.std_logic_1164.all;

--32 bit ALU
ENTITY ALU IS
    PORT MAP(
        a, b: IN STD_LOGIC_VECTOR(31 downto 0);
        ALUOp: IN STD_LOGIC_VECTOR(3 downto 0);
        Result: OUT STD_LOGIC_VECTOR(31 downto 0);
        Zero: OUT STD_LOGIC;
        Overflow: OUT STD_LOGIC;
        CarryOut: OUT STD_LOGIC;
    );
END ALU;

ARCHITECTURE structural OF ALU IS
    SIGNAL carryOut: STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL less: STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL set: STD_LOGIC;

    COMPONENT oneBitALU IS
        PORT (
            a, b, less: IN STD_LOGIC;
            Ainvert, Binvert, CarryIn: IN STD_LOGIC;
            Operation: IN STD_LOGIC_VECTOR(1 downto 0);
            Result, Set, CarryOut: OUT STD_LOGIC
        );
    END COMPONENT;

begin

    ALU_LSB: oneBitALU
        PORT MAP (
            a => a(0),
            b => b(0),
            less => set,
            Ainvert => ALUOp(3),
            Binvert => ALUOp(2),
            CarryIn => ALUOp(2),
            Operation => ALUOp(1 downto 0),
            Result => Result(0),
            Set => open,
            CarryOut => carryOut(0)
        );

    ALU_MSB: oneBitALU
        PORT MAP (
            a => a(31),
            b => b(31),
            less => '0', -- Connect to the previous carryOut for less than operation
            Ainvert => ALUOp(3),
            Binvert => ALUOp(2),
            CarryIn => carryOut(30), -- Connect to the previous carryOut
            Operation => ALUOp(1 downto 0),
            Result => Result(31),
            Set => set,
            CarryOut => carryOut(31)
        );

    -- Repeat for all other bits (1 to 30)
    ALU_Loop: FOR i IN 1 TO 30 GENERATE
        ALU_Bit: oneBitALU
            PORT MAP (
                a => a(i),
                b => b(i),
                less => '0', -- Connect to the previous carryOut for less than operation
                Ainvert => ALUOp(3),
                Binvert => ALUOp(2),
                CarryIn => carryOut(i - 1), -- Connect to the previous carryOut
                Operation => ALUOp(1 downto 0),
                Result => Result(i),
                Set => open,
                CarryOut => carryOut(i)
            );
    END GENERATE;

    -- Set Flags
    Zero <= '1' when Result = "00000000000000000000000000000000000" else '0';
    Overflow <= carryOut(31) xor carryOut(30); -- Example for overflow detection
    CarryOut <= carryOut(31); -- Final carry out from the most significant bit

END structural;