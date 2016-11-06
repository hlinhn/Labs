----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 04:05:22 PM
-- Design Name: 
-- Module Name: shift_sub_test - Behavioral
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

entity shift_sub_test is
end shift_sub_test;

architecture Behavioral of shift_sub_test is
    component shift_sub is port (
        numIns : in STD_LOGIC_VECTOR (127 downto 0);
        numOuts : out STD_LOGIC_VECTOR (127 downto 0));
        end component;
    signal numIn, numOut : std_logic_vector (127 downto 0);    
begin
    uut : shift_sub port map (
        numIns => numIn,
        numOuts => numOut);
        
    simu_proc: process
    begin
        numIn <= x"000102030405060708090a0b0c0d0e0f";
        wait for 100ns;
        numIn <= x"101112131415161718191a1b1c1d1e1f";
        wait for 100ns;
        numIn <= x"9a939495969798f5f6f9fafbfcfff3f1";
        wait for 100ns;
        numIn <= x"12131415161f6f7f8f454647485a5c6d";
        wait;
    end process;       

end Behavioral;
