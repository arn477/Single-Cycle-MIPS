LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RegFile is
    PORT(
        i_reset, i_clock: IN STD_LOGIC; -- active high asynchronous reset
        ReadReg1, ReadReg2, WriteReg: IN STD_LOGIC_VECTOR(4 downto 0);
        WriteData: IN STD_LOGIC_VECTOR(31 downto 0);
        ReadData1, ReadData2: OUT STD_LOGIC_VECTOR(31 downto 0);
        RegWrite: IN STD_LOGIC;
        Reg0_out, Reg1_out, Reg2_out, Reg3_out: OUT STD_LOGIC_VECTOR(31 downto 0);
        Reg4_out, Reg5_out, Reg6_out, Reg7_out: OUT STD_LOGIC_VECTOR(31 downto 0)
    );
END RegFile;

ARCHITECTURE rtl OF RegFile IS
    type regFileType is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
	 SIGNAL regArray: regFileType;
    SIGNAL reg_enables: STD_LOGIC_VECTOR(7 downto 0);  
    SIGNAL resetBar: STD_LOGIC;  

    COMPONENT decoder38 IS
        PORT (
            input: IN STD_LOGIC_VECTOR(2 downto 0);
            output: OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT nBitRegister IS
        GENERIC(n : INTEGER := 8);
        PORT(
            i_resetBar, i_load	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC_VECTOR(n-1 downto 0);
            o_Value			: OUT	STD_LOGIC_VECTOR(n-1 downto 0));
    END COMPONENT;

    COMPONENT nbitmux81 IS
        GENERIC ( n: INTEGER := 8 ) ;
        PORT (s0, s1, s2: IN STD_LOGIC ;
            x0, x1, x2, x3: IN STD_LOGIC_VECTOR(n-1 downto 0) ;
            x4, x5, x6, x7: IN STD_LOGIC_VECTOR(n-1 downto 0) ;
            y: OUT STD_LOGIC_VECTOR(n-1 downto 0) ) ;
    END COMPONENT;

BEGIN
    -- Decoder to select which register to write to (only one reg will be written to at a time due to the decoder)
    decoder: decoder38
        PORT MAP (
            input => WriteReg(2 downto 0),
            output => reg_enables
        );

    resetBar <= NOT i_reset;

    zeroReg: nBitRegister
        GENERIC MAP (n => 32)
        PORT MAP (
            i_resetBar => resetBar,
            i_load => '0', -- this reg should never be written to
            i_clock => i_clock,
            i_Value => WriteData,
            o_Value => regArray(0)
        );

    reg_loop: FOR i IN 1 TO 7 GENERATE
        reg: nBitRegister
            GENERIC MAP (n => 32)
            PORT MAP (
                i_resetBar => resetBar,
                i_load => reg_enables(i) AND RegWrite,
                i_clock => i_clock,
                i_Value => WriteData,
                o_Value => regArray(i)
            );
    END GENERATE;

    -- controls read reg 1 port
    read_mux1 : nbitmux81
        GENERIC MAP (n => 32)
        PORT MAP (
            s0 => ReadReg1(0),
            s1 => ReadReg1(1),
            s2 => ReadReg1(2),
            x0 => regArray(0),
            x1 => regArray(1),
            x2 => regArray(2),
            x3 => regArray(3),
            x4 => regArray(4),
            x5 => regArray(5),
            x6 => regArray(6),
            x7 => regArray(7),
            y => ReadData1
        );

    -- controls read reg 2 port
    read_mux2 : nbitmux81
        GENERIC MAP (n => 32)
        PORT MAP (
            s0 => ReadReg2(0),
            s1 => ReadReg2(1),
            s2 => ReadReg2(2),
            x0 => regArray(0),
            x1 => regArray(1),
            x2 => regArray(2),
            x3 => regArray(3),
            x4 => regArray(4),
            x5 => regArray(5),
            x6 => regArray(6),
            x7 => regArray(7),
            y => ReadData2
        );

    Reg0_out <= regArray(0);
    Reg1_out <= regArray(1);
    Reg2_out <= regArray(2);
    Reg3_out <= regArray(3);
    Reg4_out <= regArray(4);
    Reg5_out <= regArray(5);
    Reg6_out <= regArray(6);
    Reg7_out <= regArray(7);

end rtl;