----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 02:51:03 PM
-- Design Name: 
-- Module Name: colmix_test - Behavioral
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

entity colmix_test is
end colmix_test;

architecture Behavioral of colmix_test is
    component col_mix port (
        colIn : in STD_LOGIC_VECTOR (31 downto 0);
        colOut : out STD_LOGIC_VECTOR (31 downto 0));
        end component;
    signal colIn, colOut : std_logic_vector (31 downto 0);    
begin
    uut : col_mix port map (
        colIn => colIn,
        colOut => colOut);
        
    simu_proc : process
        begin
        colIn <= x"00010203";
        wait for 100ns;
        colIn <= x"04050607";
        wait for 100ns;
        colIn <= x"08090a0b";
        wait for 100ns;
        colIn <= x"0c0d0e0f";
        wait for 100ns;
        colIn <= x"10111213";
        wait;    
    end process;
end Behavioral;
