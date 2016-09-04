----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/27/2016 06:06:38 AM
-- Design Name: 
-- Module Name: test_debouncer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_debouncer is
end test_debouncer;

architecture Behavioral of test_debouncer is
    component debouncer is
    generic (N: integer);
    port (clk : in std_logic;
          btn : in std_logic;
          outsig : out std_logic
          );
    end component;
    
    signal clk, btn, outsig: std_logic := '0';
    constant clk_period :time := 100 ns;
begin
    uut: debouncer generic map (N => 2)
    port map (
    clk => clk,
    btn => btn,
    outsig => outsig
    );
    
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;
    
    stim_process: process
    -- the debouncer 
    -- 1. rejects pulse shorter than or equal to (2^(N - 1) + 1) clock cycle
    -- 2. accepts (almost) all pulses that are longer
    -- however, the position of the pulse (wrt the clock edge) also matters -- which is quite unfortunate
    -- as it is not possible to tell if a pulse of length between (2^(N - 1) + 1) and (2^(N - 1) + 2)
    -- would be registered.
    begin
        btn <= '0';
        wait for clk_period / 2;
        btn <= '1';
        wait for clk_period / 2;
        btn <= '0';
        wait for clk_period / 4;
        btn <= '1';
        wait for clk_period / 4;
        
        btn <= '0';
        wait for clk_period * 2;
        btn <= '1';
        wait for clk_period * 3.5;
        btn <= '0';
        wait for clk_period * 10;
        btn <= '1';
        wait for clk_period * 4;
        btn <= '0';
        wait for clk_period * 3.7;
        btn <= '1';
        wait for clk_period * 2.5;
        btn <= '0';
        wait for clk_period * 2.5;
        btn <= '1';
        wait for clk_period * 4;
        btn <= '0';
        wait;     
    end process;
            
end Behavioral;
