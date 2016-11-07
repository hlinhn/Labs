----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 12:57:16 PM
-- Design Name: 
-- Module Name: col_mix - Behavioral
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

entity col_mix is
    Port ( colIn : in STD_LOGIC_VECTOR (31 downto 0);
           colOut : out STD_LOGIC_VECTOR (31 downto 0));
end col_mix;

architecture Behavioral of col_mix is
    type table is array (natural range 0 to 3) of std_logic_vector (31 downto 0);
    signal lu : table;
    signal temp1, temp2, temp3, temp4 : std_logic_vector(7 downto 0);
    component mul_decr port (
        numIn : in std_logic_vector (7 downto 0);
        numsOut : out std_logic_vector (31 downto 0));
    end component;    
begin        
    muls: 
    for i in 0 to 3 generate 
        mulx : mul_decr port map (
            numIn => colIn (31 - i * 8 downto 24 - i * 8),
            numsOut => lu(i));
    end generate muls;             
     
    temp1 <= lu(0)(31 downto 24) xor lu(2)(23 downto 16) xor lu(1)(15 downto 8) xor lu(3)(7 downto 0);
    temp2 <= lu(1)(31 downto 24) xor lu(3)(23 downto 16) xor lu(2)(15 downto 8) xor lu(0)(7 downto 0);
    temp3 <= lu(2)(31 downto 24) xor lu(0)(23 downto 16) xor lu(3)(15 downto 8) xor lu(1)(7 downto 0);
    temp4 <= lu(3)(31 downto 24) xor lu(1)(23 downto 16) xor lu(0)(15 downto 8) xor lu(2)(7 downto 0);
    
    colOut(31 downto 24) <= temp1;
    colOut(23 downto 16) <= temp2;
    colOut(15 downto 8) <= temp3;
    colOut(7 downto 0) <= temp4;


end Behavioral;
