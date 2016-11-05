----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2016 11:38:33 PM
-- Design Name: 
-- Module Name: inverter_test - Behavioral
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

entity inverter_test is
end inverter_test;

architecture Behavioral of inverter_test is
    component inverter is port (
        numIn : in STD_LOGIC_VECTOR (7 downto 0);
        numOut : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
 
    signal numIn, numOut : std_logic_vector (7 downto 0);
    constant clk_p : time := 100 ns; 
begin
    uut : inverter port map (
        numIn => numIn,
        numOut => numOut);
        
    simu_proc : process
        begin
            numIn <= x"00";
            wait for clk_p;
            numIn <= x"01";
            wait for clk_p;
            numIn <= x"02";
            wait for clk_p;
            numIn <= x"03";
            wait for clk_p;
            numIn <= x"04";
            wait for clk_p;
            numIn <= x"05";
            wait for clk_p;
            numIn <= x"06";
            wait for clk_p;
            numIn <= x"07";
            wait for clk_p;
            numIn <= x"08";
            wait for clk_p;
            numIn <= x"09";
            wait for clk_p;
            numIn <= x"0a";
            wait for clk_p;
            numIn <= x"0b";
            wait for clk_p;
            numIn <= x"0c";
            wait for clk_p;
            numIn <= x"0d";
            wait for clk_p;
            numIn <= x"0e";
            wait for clk_p;
            numIn <= x"0f";                                    
            wait;
        end process;

end Behavioral;
