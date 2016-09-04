----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.08.2016 02:56:27
-- Design Name: 
-- Module Name: one_clk_cycle - Behavioral
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

entity one_clk_cycle is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           filtered_btn : out STD_LOGIC);
end one_clk_cycle;

architecture Behavioral of one_clk_cycle is

begin
process(clk)
variable cur : boolean:= false;
begin
if(clk'event and clk = '1') then
    if(btn = '1') then
        if(cur = false) then
        filtered_btn <= '1';
        cur := true;
        end if;
    else
        if(cur) then
        filtered_btn <='0';
        cur := false;
        end if;
    end if;
end if;
end process;
end Behavioral;
