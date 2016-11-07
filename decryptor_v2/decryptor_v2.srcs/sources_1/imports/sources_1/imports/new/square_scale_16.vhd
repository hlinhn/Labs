----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2016 10:53:58 PM
-- Design Name: 
-- Module Name: square_scale_16 - Behavioral
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

entity square_scale_16 is
    Port ( numIn : in STD_LOGIC_VECTOR (3 downto 0);
           numOut : out STD_LOGIC_VECTOR (3 downto 0));
end square_scale_16;

architecture Behavioral of square_scale_16 is
    signal upper, lower, sum, mUpper, mLower, invLow : std_logic_vector (1 downto 0);
begin
    upper <= numIn (3 downto 2);
    lower <= numIn (1 downto 0);
    sum <= upper xor lower;
    
    mUpper(1) <= sum(0);
    mUpper(0) <= sum(1);
    
    invLow(1) <= lower(0);
    invLow(0) <= lower(1);
    
    mLower(1) <= invLow(1) xor invLow(0);
    mLower(0) <= invLow(1);
    
    numOut (3 downto 2) <= mUpper;
    numOut (1 downto 0) <= mLower;
    
end Behavioral;
