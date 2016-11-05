----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2016 09:54:08 PM
-- Design Name: 
-- Module Name: converter_test - Behavioral
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

entity converter_test is
end converter_test;

architecture Behavioral of converter_test is
    component basis_change is port (
        numIn : in STD_LOGIC_VECTOR (7 downto 0);
        switch : in STD_LOGIC_VECTOR (1 downto 0);
        numOut : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal numIn, numOut : std_logic_vector (7 downto 0);
    signal switch : std_logic_vector (1 downto 0);
    constant clk_p : time := 100 ns; 
begin
    uut : basis_change port map (
        numIn => numIn,
        switch => switch,
        numOut => numOut);

    simu_proc : process
        begin
            numIn <= x"18";
            switch <= "00";
            wait for clk_p;
            switch <= "01";
            wait for clk_p;
            numIn <= x"02";
            switch <= "00";
            wait for clk_p;
            numIn <= x"03";
            wait for clk_p;
            numIn <= x"04";
            wait;
        end process;
        
end Behavioral;
