----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 03:46:41 PM
-- Design Name: 
-- Module Name: shift_sub - Behavioral
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

entity shift_sub is
    Port ( numIns : in STD_LOGIC_VECTOR (127 downto 0);
           numOuts : out STD_LOGIC_VECTOR (127 downto 0));
end shift_sub;

architecture Behavioral of shift_sub is
    
    component sbox is port (
        numIn : in std_logic_vector (7 downto 0);
        inv : in std_logic;
        numOut : out std_logic_vector (7 downto 0));
        end component;
        
    type table is array (natural range 0 to 15) of std_logic_vector (7 downto 0);
    subtype small_int is integer range 0 to 15;
    type lut is array (natural range 0 to 15) of small_int; 
    signal switched : table;    
    signal lutable : lut := (0, 13, 10, 7, 4, 1, 14, 11,
                                8, 5, 2, 15, 12, 9, 6, 3); 
begin
    sboxes : 
    for i in 0 to 15 generate
        box : sbox port map (
            numIn => numIns(127 - i * 8 downto 120 - i * 8),
            inv => '1',
            numOut => switched(i));
    end generate;
    
    assign:
    for i in 0 to 15 generate
        numOuts(127 - i * 8 downto 120 - i * 8) <= switched(lutable(i));
    end generate;            

end Behavioral;
