----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/24/2016 10:42:11 AM
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           deb : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is

begin
    process (clk)
    variable counter : std_logic_vector(2 downto 0) := "000";
    variable reset, old_btn : std_logic := '0';
    variable temp : std_logic := '0';
    begin
        if clk'event and clk = '1' then
            if (old_btn xor btn) = '1' then
                reset := '1';
            else
                reset := '0';
            end if; 
            if reset = '1' then
                counter := "000";
            elsif counter(2) = '0' then
                counter := std_logic_vector(unsigned(counter) + 1);
            else
                counter := "000";
                
            end if;
        end if;
    end process;
end Behavioral;
