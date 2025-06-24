LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY instructionMem IS
    PORT(
        clk: IN STD_LOGIC;
        i_address: IN STD_LOGIC_VECTOR(7 downto 0);
        o_instruction: OUT STD_LOGIC_VECTOR(31 downto 0)
    );
END instructionMem;

ARCHITECTURE rtl OF instructionMem IS
    component LPM_ROM
        generic (LPM_WIDTH : natural;    -- MUST be greater than 0
                LPM_WIDTHAD : natural;    -- MUST be greater than 0
                LPM_NUMWORDS : natural := 0;
                LPM_ADDRESS_CONTROL : string := "REGISTERED";
                LPM_OUTDATA : string := "REGISTERED";
                LPM_FILE : string;
                LPM_TYPE : string := "L_ROM";
                INTENDED_DEVICE_FAMILY  : string := "UNUSED";
                LPM_HINT : string := "UNUSED");

        port (ADDRESS : in STD_LOGIC_VECTOR(LPM_WIDTHAD-1 downto 0);
            INCLOCK : in STD_LOGIC := '0';
            OUTCLOCK : in STD_LOGIC := '0';
            MEMENAB : in STD_LOGIC := '1';
            Q : out STD_LOGIC_VECTOR(LPM_WIDTH-1 downto 0)
        );
    end component;
begin
    -- configure ROM so that it stores 256 32 bit instructions
    -- To make single cycle work the input and output must not be registered
    mem: LPM_ROM
        generic map (
            LPM_WIDTH => 32,
            LPM_WIDTHAD => 8,
            LPM_NUMWORDS => 256,
            LPM_ADDRESS_CONTROL => "REGISTERED",
            LPM_OUTDATA => "UNREGISTERED",
            LPM_FILE => "testInstructionMem.mif"
        )
        port map (
            ADDRESS => i_address,
			INCLOCK => clk,
            Q => o_instruction
        );
end rtl;