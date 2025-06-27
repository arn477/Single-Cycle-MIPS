LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_lpm_top IS
END tb_lpm_top;

ARCHITECTURE tb OF tb_lpm_top IS

    -- Component under test
    COMPONENT lpm_top
        PORT(
            clk   : IN STD_LOGIC;
            reset : IN STD_LOGIC
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk_tb   : STD_LOGIC := '0';
    SIGNAL reset_tb : STD_LOGIC := '0';

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: lpm_top
        PORT MAP (
            clk   => clk_tb,
            reset => reset_tb
        );

    -- One-line clock generator (10 ns period)
    clk_tb <= NOT clk_tb AFTER 5 ns;

    -- Reset process
    stim_proc: PROCESS
    BEGIN
        -- Initial reset
        reset_tb <= '1';
        WAIT FOR 10 ns;
        reset_tb <= '0';

        -- Let simulation run
        WAIT;
    END PROCESS;

END tb;