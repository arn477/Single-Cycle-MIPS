LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALUcontrol is
    PORT(
        clk, reset: IN STD_LOGIC;
        aluOP: IN STD_LOGIC_VECTOR(1 downto 0); -- 2 bit alu op
        funcCode: IN STD_LOGIC_VECTOR(5 downto 0); -- 6 bit function code
        operation: OUT STD_LOGIC_VECTOR(2 downto 0); -- ALU control output
    ); 
END ALUcontrol;

ARCHITECTURE Behavioural OF ALUcontrol is
    SIGNAL opAndFunc: STD_LOGIC_VECTOR(7 downto 0);

BEGIN 
    process(aluOP, funcCode)
    opAndFunc  <= aluOP & funcCode; 
    begin
    --funcCode is taken from the hex value from the MIPS reference sheet
    case opAndFunc is
    when "00100000" => 
        operation <= "010"; --add
    when "10100000" => 
        operation <= "010";
    when "01100010" => 
        operation <= "110"; --sub
    when "10100010" => 
        operation <= "110";
    when "10100100" => 
        operation <= "000"; --and
    when "10100101" => 
        operation <= "001"; --or
    when "10101010" => 
        operation <= "111"; --stl 
    when others => 
        operation <= "000"; --default is and if anything

    end case;
    end process;

end Behavioural;