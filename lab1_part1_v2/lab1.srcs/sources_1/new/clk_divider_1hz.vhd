----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.08.2016 15:44:19
-- Design Name: 
-- Module Name: clock_divider - Behavioral
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

entity clock_divider_1hz is
    Port ( clk : in STD_LOGIC;
           clk_slow_1hz : out STD_LOGIC);
end clock_divider_1hz;

architecture Behavioral of clock_divider_1hz is
begin

process(clk)
variable clk_counter: STD_LOGIC_VECTOR(26 downto 0):= (others=>'0');
begin
    if(clk'event and clk='1') then
        clk_counter := std_logic_vector(unsigned(clk_counter) + 1); 
        if(clk_counter >= "101111101011110000100000000") then --samples every 1s. REAL
        --if(clk_counter >= "000000000011000011010100000") then --samples every 1s. TEST
            clk_slow_1hz<='1';
            clk_counter:=(others=>'0'); --reset counter.
            else
            clk_slow_1hz<='0';
        end if;
    end if;
end process;


end Behavioral;
