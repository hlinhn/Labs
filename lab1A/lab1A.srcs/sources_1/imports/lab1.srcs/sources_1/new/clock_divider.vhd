----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/02/2016 07:23:43 PM
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

entity clock_divider is
    generic (CLK_SIZE : integer);
    Port ( clk : in STD_LOGIC;
           clk_div : out STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is

begin
    process (clk)
    variable count : std_logic_vector(CLK_SIZE downto 0) := (others => '0');
    begin
        if clk'event and clk = '1' then
            count := std_logic_vector(unsigned(count) + 1);
        end if;
        clk_div <= count(CLK_SIZE);
    end process;
end Behavioral;
