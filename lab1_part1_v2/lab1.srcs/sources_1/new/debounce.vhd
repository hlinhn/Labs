----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.08.2016 19:47:38
-- Design Name: 
-- Module Name: debounce - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
    Port ( press : in STD_LOGIC;
           refined_press : out STD_LOGIC;
           clk : in STD_LOGIC;
           clk_slow : in STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    signal count: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if(clk'event and clk='1') then
            if(clk_slow = '1') then
                if (press = '1') then
                    if(count /= 10) then
                        count <= count + 1;
                    end if;
                else
                    count <= (others=>'0');
                end if;
        
                if (count = 10) then
                    refined_press <= '1';
                else
                    refined_press <= '0';
                end if;
            end if;
        end if;
    end process;
end Behavioral;
