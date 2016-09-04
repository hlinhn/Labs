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
    Port ( 
            clk : in STD_LOGIC;
            clk_slow_1hz: in STD_LOGIC;
            dir : in STD_LOGIC;
            mode: in STD_LOGIC; 
            en : in STD_LOGIC; -- high speed clk. 
            load : in STD_LOGIC;
            
            dip0 : in STD_LOGIC;
            dip1 : in STD_LOGIC; 
            dip2 : in STD_LOGIC;
            dip3 : in STD_LOGIC;
            tick: out STD_LOGIC;
            count : out STD_LOGIC_VECTOR (3 downto 0)
           );
end counter;

architecture Behavioral of counter is

begin
    process (clk,load)
    variable bool_count: boolean:=false;
    variable temp : std_logic_vector(3 downto 0) := "0000";
    
    begin
    
    if(load = '1') then
        temp := (dip0 & dip1 & dip2 & dip3);
    else
        if(clk'event and clk='1') then
            if(mode='1') then
                if(clk_slow_1hz = '1') then
                    bool_count := true;
                    
                end if;
            elsif(en = '1') then
                bool_count := true;
            end if; -- no else.
            
            if(bool_count=true) then
                bool_count:=false;
                if dir = '1' then 
                    temp := std_logic_vector(unsigned(temp) + 1);
                else
                    temp := std_logic_vector(unsigned(temp) - 1);
                end if;
            end if;
        end if;
    end if;
    count <= temp;
    end process;            
end Behavioral;
