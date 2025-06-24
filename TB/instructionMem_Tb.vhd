LIBRARY ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library lpm; -- required for all lpm functions
use lpm.lpm_components.all;

-- Instantiates the LPM_ROM module with contents from testInstructionMem.mif
-- This testbench is not self checking
ENTITY instructionMem_Tb IS
END instructionMem_Tb;

ARCHITECTURE rtl OF instructionMem_Tb IS
    SIGNAL clk: STD_LOGIC := '0';
    SIGNAL Address: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    SIGNAL Instruction: STD_LOGIC_VECTOR(31 downto 0);

  component LPM_ROM
        generic (LPM_WIDTH : natural;    -- MUST be greater than 0
                LPM_WIDTHAD : natural;    -- MUST be greater than 0
                LPM_NUMWORDS : natural := 0;
                LPM_ADDRESS_CONTROL : string := "REGISTERED";
                LPM_OUTDATA : string := "REGISTERED";
                LPM_FILE : string;
                LPM_TYPE : string := "L_ROM";
                INTENDED_DEVICE_FAMILY  : string := "UNUSED";
                LPM_HINT : string := "UNUSED"
        );
        port (ADDRESS : in STD_LOGIC_VECTOR(LPM_WIDTHAD-1 downto 0);
            INCLOCK : in STD_LOGIC := '0';
            OUTCLOCK : in STD_LOGIC := '0';
            MEMENAB : in STD_LOGIC := '1';
            Q : out STD_LOGIC_VECTOR(LPM_WIDTH-1 downto 0)
        );
    end component;
begin
    clk <= not clk after 10 ns;  -- Clock generation with a period of 20 ns

    -- configure ROM so that it stores 256 32 bit instructions
    -- To make single cycle work the input and output must not be registered
    instructionMem: LPM_ROM
        generic map (
            LPM_WIDTH => 32,
            LPM_WIDTHAD => 8,
            LPM_NUMWORDS => 256,
            LPM_ADDRESS_CONTROL => "UNREGISTERED",
            LPM_OUTDATA => "UNREGISTERED",
            LPM_FILE => "C:\Users\arnav\Desktop\Single-Cycle-MIPS\Project\testInstructionMem.mif"
        )
        port map (
            ADDRESS => Address,
            INCLOCK => clk,
            Q => Instruction
        ); 
    -- Address incrementer
    -- On every clock cycle, the output should match the data stored at the address according to the .mif file
    process (clk)
    begin
        if rising_edge(clk) then
            Address <= Address + "1";  -- Increment address on each clock cycle
        end if;
    end process;

end rtl;