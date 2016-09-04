----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2016 01:39:12 AM
-- Design Name: 
-- Module Name: simple_counter - Behavioral
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

entity simple_counter is
    generic (N: integer);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           clear : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (N downto 0));
end simple_counter;

architecture Behavioral of simple_counter is
begin
    process (clk)
    variable temp : STD_LOGIC_VECTOR (N downto 0) := (others => '0');
    begin
        if clk'event and clk = '1' then
            if en = '1' then
                temp := std_logic_vector(unsigned(temp) + 1);
            end if;
            
            if clear = '1' then
                temp := (others => '0');
            end if;
            count <= temp;
        end if;
    end process;    
end Behavioral;
