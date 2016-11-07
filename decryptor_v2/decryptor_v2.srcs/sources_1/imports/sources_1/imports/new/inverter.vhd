----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2016 10:32:00 PM
-- Design Name: 
-- Module Name: inverter - Behavioral
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

entity inverter is
    Port ( numIn : in STD_LOGIC_VECTOR (7 downto 0);
           numOut : out STD_LOGIC_VECTOR (7 downto 0));
end inverter;

architecture Behavioral of inverter is
    component inverter_16 is port (
        numIn : in std_logic_vector (3 downto 0);
        numOut : out std_logic_vector (3 downto 0));
    end component;
    component multiplier_16 is port (
        numIn1 : in std_logic_vector (3 downto 0);
        numIn2 : in std_logic_vector (3 downto 0);
        numOut : out std_logic_vector (3 downto 0));
    end component;
    component square_scale_16 is port (
        numIn : in std_logic_vector (3 downto 0);
        numOut : out std_logic_vector (3 downto 0));
    end component;
    
    signal upper, lower, prod, sum : std_logic_vector (3 downto 0);
    signal scaled, theta, invtheta, mUpper, mLower : std_logic_vector (3 downto 0);    
begin
    upper <= numIn (7 downto 4);
    lower <= numIn (3 downto 0);
    sum <= upper xor lower;
    theta <= scaled xor prod;
    numOut (7 downto 4) <= mUpper;
    numOut (3 downto 0) <= mLower;
    
    mul_16_1 : multiplier_16 port map (
        numIn1 => upper,
        numIn2 => lower,
        numOut => prod);
        
    sq_scale : square_scale_16 port map (
        numIn => sum,
        numOut => scaled);
    
    invert_16: inverter_16 port map (
        numIn => theta,
        numOut => invtheta);    
        
    mul_upper : multiplier_16 port map (
        numIn1 => invtheta,
        numIn2 => lower,
        numOut => mUpper);
        
    mul_lower : multiplier_16 port map (
        numIn1 => invtheta,
        numIn2 => upper,
        numOut => mLower);
                
end Behavioral;
