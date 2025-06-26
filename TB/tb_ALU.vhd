library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ALU is
end entity;

architecture testbench of tb_ALU is
    component ALU is
        port (
            a, b: in std_logic_vector(31 downto 0);
            ALUOp: in std_logic_vector(3 downto 0);
            Result: out std_logic_vector(31 downto 0);
            Zero: out std_logic;
            Overflow: out std_logic;
            CarryOut: out std_logic
        );
    end component;

    signal a, b, result: std_logic_vector(31 downto 0);
    signal ALUOp: std_logic_vector(3 downto 0);
    signal zero, overflow, carryout: std_logic;

begin
    uut: ALU
        port map (
            a => a,
            b => b,
            ALUOp => ALUOp,
            Result => result,
            Zero => zero,
            Overflow => overflow,
            CarryOut => carryout
        );

    process
    begin
        -- Test 1: ADD (2 + 3 = 5)
        a <= std_logic_vector(to_unsigned(2, 32));
        b <= std_logic_vector(to_unsigned(3, 32));
        ALUOp <= "0010";  -- ADD
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(5, 32)) report "Test 1 failed: ADD result" severity error;
        assert zero = '0' report "Test 1 failed: Zero flag should be 0" severity error;

        -- Test 2: SUB (5 - 5 = 0)
        a <= std_logic_vector(to_unsigned(5, 32));
        b <= std_logic_vector(to_unsigned(5, 32));
        ALUOp <= "0110";  -- SUB
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(0, 32)) report "Test 2 failed: SUB result" severity error;
        assert zero = '1' report "Test 2 failed: Zero flag should be 1" severity error;

        -- Test 3: AND (F0F0F0F0 AND 0F0F0F0F = 00000000)
        a <= x"F0F0F0F0";
        b <= x"0F0F0F0F";
        ALUOp <= "0000";  -- AND
        wait for 10 ns;
        assert result = x"00000000" report "Test 3 failed: AND result" severity error;
        assert zero = '1' report "Test 3 failed: Zero flag should be 1" severity error;

        -- Test 4: OR (F0F0F0F0 OR 0F0F0F0F = FFFFFFFF)
        a <= x"F0F0F0F0";
        b <= x"0F0F0F0F";
        ALUOp <= "0001";  -- OR
        wait for 10 ns;
        assert result = x"FFFFFFFF" report "Test 4 failed: OR result" severity error;
        assert zero = '0' report "Test 4 failed: Zero flag should be 0" severity error;

        -- Test 5: SLT (-5 < 3 → result = 0x00000001)
        a <= std_logic_vector(to_signed(-5, 32));
        b <= std_logic_vector(to_signed(3, 32));
        ALUOp <= "0111";  -- SLT
        wait for 10 ns;
        assert result = x"00000001" report "Test 5 failed: SLT result incorrect" severity error;
        assert zero = '0' report "Test 5 failed: Zero flag should be 0" severity error;

        report "All tests passed." severity note;
        wait;
    end process;
end architecture;
