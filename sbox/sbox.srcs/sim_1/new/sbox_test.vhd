----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 12:46:41 AM
-- Design Name: 
-- Module Name: sbox_test - Behavioral
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

entity sbox_test is
end sbox_test;

architecture Behavioral of sbox_test is
    component sbox is port (
        numIn : in STD_LOGIC_VECTOR (7 downto 0);
        inv : in STD_LOGIC;
        numOut : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal numIn, numOut : std_logic_vector (7 downto 0);
    signal inv : std_logic;
    constant clk_p : time := 100 ns; 
begin
    uut : sbox port map (
        numIn => numIn,
        inv => inv,
        numOut => numOut);

    simu_proc : process
    begin
        inv <= '0';
        
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
