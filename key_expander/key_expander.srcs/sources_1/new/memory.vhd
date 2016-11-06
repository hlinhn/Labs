----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 09:02:00 AM
-- Design Name: 
-- Module Name: memory - Behavioral
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

entity memory is
    generic (N: integer;
             DL : integer);
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (N - 1 downto 0);
           dataIn : in STD_LOGIC_VECTOR (DL - 1 downto 0);
           dataOut : out STD_LOGIC_VECTOR (DL - 1 downto 0));
end memory;

architecture Behavioral of memory is
    type memory is array (0 to (2**N - 1)) of std_logic_vector(DL - 1 downto 0);
    signal mem : memory;
    
begin
    rProc: process (clk)
    begin
        if clk'event and clk = '1' then
            if we = '1' then
                dataOut <= dataIn;
            else
                dataOut <= mem(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;        
    
    wProc: process (clk)
    begin
        if clk'event and clk = '1' then
            if we = '1' then
                mem(to_integer(unsigned(addr))) <= dataIn;
            end if;
        end if;
    end process;
            
end Behavioral;

