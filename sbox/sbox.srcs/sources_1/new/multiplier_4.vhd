----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2016 11:34:25 PM
-- Design Name: 
-- Module Name: multiplier_4 - Behavioral
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

entity multiplier_4 is
    Port ( numIn1 : in STD_LOGIC_VECTOR (1 downto 0);
           numIn2 : in STD_LOGIC_VECTOR (1 downto 0);
           numOut : out STD_LOGIC_VECTOR (1 downto 0));
end multiplier_4;

architecture Behavioral of multiplier_4 is
    signal up1, up2, low1, low2, mUpper, mLower, theta : std_logic;
begin
    up1 <= numIn1(1);
    up2 <= numIn2(1);
    low1 <= numIn1(0);
    low2 <= numIn2(0);
    theta <= (up1 xor low1) and (up2 xor low2);
    mUpper <= theta xor (up1 and up2);
    mLower <= theta xor (low1 and low2);
    
    numOut(1) <= mUpper;
    numOut(0) <= mLower;

end Behavioral;
