----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2016 10:53:58 PM
-- Design Name: 
-- Module Name: multiplier_16 - Behavioral
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

entity multiplier_16 is
    Port ( numIn1 : in STD_LOGIC_VECTOR (3 downto 0);
           numIn2 : in STD_LOGIC_VECTOR (3 downto 0);
           numOut : out STD_LOGIC_VECTOR (3 downto 0));
end multiplier_16;

architecture Behavioral of multiplier_16 is
    component multiplier_4 is port (
        numIn1 : in std_logic_vector (1 downto 0);
        numIn2 : in std_logic_vector (1 downto 0);
        numOut : out std_logic_vector (1 downto 0));
    end component;
    signal up1, up2, low1, low2, sum1, sum2 : std_logic_vector (1 downto 0);
    signal scaled, theta, prodUp, prodLow, mUpper, mLower : std_logic_vector (1 downto 0);    
begin
    up1 <= numIn1 (3 downto 2);
    up2 <= numIn2 (3 downto 2);
    low1 <= numIn1 (1 downto 0);
    low2 <= numIn2 (1 downto 0);
    sum1 <= up1 xor low1;
    sum2 <= up2 xor low2;
    
    scaled(1) <= theta(0);
    scaled(0) <= theta(0) xor theta(1); 
    
    mUpper <= prodUp xor scaled;
    mLower <= prodLow xor scaled;
    
    numOut (3 downto 2) <= mUpper;
    numOut (1 downto 0) <= mLower;
    
    mul_4_theta : multiplier_4 port map (
        numIn1 => sum1,
        numIn2 => sum2,
        numOut => theta);
        
    mul_4_up : multiplier_4 port map (
        numIn1 => up1,
        numIn2 => up2,
        numOut => prodUp);
        
    mul_4_low : multiplier_4 port map (
        numIn1 => low1,
        numIn2 => low2,
        numOut => prodLow);     

end Behavioral;
