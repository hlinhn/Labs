----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/02/2016 07:06:57 PM
-- Design Name: 
-- Module Name: single_pulser - Behavioral
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

entity single_pulser is
    Port ( clk : in STD_LOGIC;
           sig_in : in STD_LOGIC;
           hold : in STD_LOGIC;
           slow_clk : in STD_LOGIC;
           sig_out : out STD_LOGIC);
end single_pulser;
   
architecture Behavioral of single_pulser is
    signal old_sig, old_clk, sig_hold : std_logic := '0';    
begin
    process (clk)
    variable sig_temp : std_logic := '0';
    begin
        if clk'event and clk = '1' then
            if sig_in = '1' then
                sig_hold <= '1';
            else 
                if hold = '0' then
                    sig_hold <= '0';
                end if;
            end if;
            
            if sig_hold = '1' and old_sig = '0' then
                sig_temp := '1';
            else
                sig_temp := '0';
            end if;
            
            if hold = '0' then
                old_sig <= sig_hold;
            else
                if slow_clk = '1' and old_clk = '0' then
                    old_sig <= sig_hold;
                    sig_hold <= sig_in;
                end if;    
            end if;                
            old_clk <= slow_clk;
            sig_out <= sig_temp;
        end if;
    end process;

end Behavioral;
