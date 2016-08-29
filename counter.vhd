----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/24/2016 09:04:59 AM
-- Design Name: 
-- Module Name: counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( clk : in STD_LOGIC;
           dir : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (3 downto 0));
end counter;

architecture Behavioral of counter is

begin
    process (clk)
    variable temp : std_logic_vector(3 downto 0) := "0000";
    variable direction : std_logic := '0';
    variable old_dir : std_logic := '0';
    begin
        if (clk'event and clk = '1') then
            if dir = '1' and old_dir = '0' then
                direction := not direction;
            end if;
            if direction = '0' then 
                temp := std_logic_vector(unsigned(temp) + 1);
            else
                temp := std_logic_vector(unsigned(temp) - 1);
            end if;
         end if;
         old_dir := dir;
         count <= temp;
    end process;            
end Behavioral;
