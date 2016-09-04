----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/27/2016 05:02:07 AM
-- Design Name: 
-- Module Name: debouncer - Behavioral
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

entity debouncer is
    generic (N: integer);
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           outsig : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
    signal count : std_logic_vector(N - 1 downto 0) := (others => '0');    
    
begin
    samp : process (clk)
    variable lastsig : std_logic := '0';
    begin
        if clk'event and clk = '1' then
            if lastsig /= btn then
                count <= (others => '0');
            elsif count(N - 1) = '0' then
                count <= std_logic_vector(unsigned(count) + 1);
            else
               	outsig <= btn;
            end if;
            lastsig := btn;
        end if;
        
                       --with this, occasional dip in the signal is not recorded either 
                       --for example user lets go of the button for a short while - shorter
                       --than the time it takes to stabilize - then presses again, no 0 is
                       --recorded - is it the intended behavior, or '1' is supposed to be
                       --treated differently?       
    end process;            
end Behavioral;
