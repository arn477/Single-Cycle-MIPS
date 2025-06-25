LIBRARY ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library lpm; -- required for all lpm functions
use lpm.lpm_components.all;

ENTITY tb_lpm_ram IS
END tb_lpm_ram;

ARCHITECTURE behavioural of tb_lpm_ram IS
    SIGNAL clk: STD_LOGIC := '0';
    SIGNAL Address: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    SIGNAL Data: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    SIGNAL output: STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL WriteEnable, WriteEnableReg: STD_LOGIC := '0';

    component LPM_RAM_DQ
        generic (LPM_WIDTH : natural;    -- MUST be greater than 0
                 LPM_WIDTHAD : natural;    -- MUST be greater than 0
                 LPM_NUMWORDS : natural := 0;
                 LPM_INDATA : string := "REGISTERED";
                 LPM_ADDRESS_CONTROL: string := "REGISTERED";
                 LPM_OUTDATA : string := "REGISTERED";
                 LPM_FILE : string := "UNUSED";
                 LPM_TYPE : string := "L_RAM_DQ";
                 USE_EAB  : string := "ON";
                 INTENDED_DEVICE_FAMILY  : string := "UNUSED";
                 LPM_HINT : string := "UNUSED");
        port (DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
                ADDRESS : in std_logic_vector(LPM_WIDTHAD-1 downto 0);
                INCLOCK : in std_logic := '0';
                OUTCLOCK : in std_logic := '0';
                WE : in std_logic;
                Q : out std_logic_vector(LPM_WIDTH-1 downto 0)
        );
    end component;

begin
    clk <= not clk after 10 ns;  -- Clock generation with a period of 10 ns

    -- configure RAM so that it stores 256 32 bit words
    -- Write is synchronous, but reading is async
    dataMem: LPM_RAM_DQ
        generic map (
            LPM_WIDTH => 32,
            LPM_WIDTHAD => 8,
            LPM_NUMWORDS => 256,
            LPM_INDATA => "REGISTERED",
            LPM_ADDRESS_CONTROL => "UNREGISTERED",
            LPM_OUTDATA => "UNREGISTERED",
            LPM_FILE => "C:\Users\arnav\Desktop\Single-Cycle-MIPS\Project\testDataMem.mif" -- file path is machine dependent
            -- must have complete file path to mif file for modelsim
        )
        port map (
            DATA => Data,
            ADDRESS => Address,
            INCLOCK => clk,
            WE => WriteEnableReg,
            Q => output
        );
    -- DFF for write enable
    -- Data is latched, and to have fully synchronous writes, we must latch the write enable as well
    -- Otherwise the data will change too early
    process (clk)
    begin
        if rising_edge(clk) then
            WriteEnableReg <= WriteEnable;
        end if;
    end process;

    -- Check first two addresses and then write to the second address
    -- Confirm that reading the data is asynchronous (i.e. if the address port is set, the output change is reflected in the same clock cycle)
    -- Confirm that writing is synchronous (i.e. output changes at the end of the clock cycle where the data port and write enable are set)
    process
    begin
        Address <= "00000000";  -- Start at address 0
        -- Read first address
        -- Data should be 00000055

        wait until rising_edge(clk);
        assert output = x"00000055" report "Data at address should be 00000055" severity error;
        Address <= "00000001";  -- Move to address 1
        -- Read second address
        -- Data should be 000000AA

        -- still at second address
        wait until rising_edge(clk);
        assert output = x"000000AA" report "Data at address should be 000000AA" severity error;
        Data <= x"000000BB";
        WriteEnable <= '1';


        wait until rising_edge(clk);
        assert output = x"000000AA" report "Data at address should be 000000AA" severity error;
        
        wait for 50 ns; -- wait for extra visibility in output waveform
        assert output = x"000000BB" report "Data at address should be 000000BB" severity error;
        -- end simulation
        assert false report "Simulation finished successfully" severity failure;
    end process;
end behavioural;