----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 12:58:39 PM
-- Design Name: 
-- Module Name: mul_decr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mul_decr is
    Port ( numIn : in STD_LOGIC_VECTOR (7 downto 0);
           numsOut : out STD_LOGIC_VECTOR (31 downto 0));
end mul_decr;

architecture Behavioral of mul_decr is
    signal num2, num4, num8 : std_logic_vector(7 downto 0);
    signal add2, add4, add8 : std_logic_vector(7 downto 0);
begin
    add2 <= x"00" when numIn(7) = '0' else x"1b";
    num2 <= (numIn(6 downto 0) & '0') xor add2;
    add4 <= x"00" when num2(7) = '0' else x"1b";
    num4 <= (num2(6 downto 0) & '0') xor add4;
    add8 <= x"00" when num4(7) = '0' else x"1b";
    num8 <= (num4(6 downto 0) & '0') xor add8;
    
    numsOut (7 downto 0) <= num8 xor numIn;
    numsOut (15 downto 8) <= num8 xor num2 xor numIn;
    numsOut (23 downto 16) <= num8 xor num4 xor numIn;
    numsOut (31 downto 24) <= num8 xor num4 xor num2;

end Behavioral;
