----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2016 05:27:28 PM
-- Design Name: 
-- Module Name: sbox - Behavioral
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

entity sbox is
  Port (
    numIn : in STD_LOGIC_VECTOR (7 downto 0);
    inv : in STD_LOGIC;
    numOut : out STD_LOGIC_VECTOR (7 downto 0));
  
end sbox;
-- there would be 3 phases: 
-- 1. affine transformation + isomorphism combined into one matrix
-- 2. inverse (carried out over the composite field)
-- 3. reverse back to standard representation
-- Sbox and inverse sbox can both use these. 
architecture Behavioral of sbox is

  component basis_change is port (
    numIn : in std_logic_vector (7 downto 0);
    switch : in std_logic_vector (1 downto 0);
    numOut : out std_logic_vector (7 downto 0));
  end component basis_change;
                            
  component inverter is port (
    numIn : in std_logic_vector (7 downto 0);
    numOut : out std_logic_vector (7 downto 0));
  end component inverter;
  
  signal numNewBase, numInverted, numXor : std_logic_vector (7 downto 0);                      
  signal switchBase, affine : std_logic_vector (1 downto 0);
                      
begin
  switchBase <= "01" when inv = '0' else "00";
  affine <= "10" when inv = '0' else "11";
  numOut <= numXor xor x"63";   
  --port maps
  basis_change_forward : basis_change port map(
    numIn => numIn,
    switch => switchBase,
    numOut => numNewBase);
  basis_change_back : basis_change port map (
    numIn => numInverted,
    switch => affine,
    numOut => numXor);
  invert : inverter port map (
    numIn => numNewBase,
    numOut => numInverted);
end Behavioral;
