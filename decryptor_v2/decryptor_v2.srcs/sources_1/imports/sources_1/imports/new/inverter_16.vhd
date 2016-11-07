----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2016 10:53:58 PM
-- Design Name: 
-- Module Name: inverter_16 - Behavioral
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

entity inverter_16 is
    Port ( numIn : in STD_LOGIC_VECTOR (3 downto 0);
           numOut : out STD_LOGIC_VECTOR (3 downto 0));
end inverter_16;

architecture Behavioral of inverter_16 is
    component multiplier_4 is port (
        numIn1 : in std_logic_vector (1 downto 0);
        numIn2 : in std_logic_vector (1 downto 0);
        numOut : out std_logic_vector (1 downto 0));
        end component;
          
    signal upper, lower, prod, sum : std_logic_vector (1 downto 0);
    signal inv, theta, scaled, mUpper, mLower : std_logic_vector (1 downto 0);
        
begin
    upper <= numIn (3 downto 2);
    lower <= numIn (1 downto 0);
    sum <= upper xor lower;
    
    scaled(1) <= sum(1);
    scaled(0) <= sum(0) xor sum(1);
    
    theta <= scaled xor prod;
    inv(1) <= theta(0);
    inv(0) <= theta(1); 
    
    numOut (3 downto 2) <= mUpper;
    numOut (1 downto 0) <= mLower;
    
    mul_4_prod : multiplier_4 port map (
        numIn1 => upper,
        numIn2 => lower,
        numOut => prod);
            
    mul_4_up : multiplier_4 port map (
        numIn1 => lower,
        numIn2 => inv,
        numOut => mUpper);
        
    mul_4_low : multiplier_4 port map (
        numIn1 => upper,
        numIn2 => inv,
        numOut => mLower);
            
end Behavioral;
