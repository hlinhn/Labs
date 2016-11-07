----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 07:15:55 PM
-- Design Name: 
-- Module Name: transformer - Behavioral
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

entity transformer is
    Port ( numIn : in STD_LOGIC_VECTOR (127 downto 0);
           roundNum : in STD_LOGIC_VECTOR (3 downto 0);
           key : in STD_LOGIC_VECTOR (127 downto 0);
           numOut : out STD_LOGIC_VECTOR (127 downto 0));
end transformer;

architecture Behavioral of transformer is
    component shift_sub is port (
               numIns : in STD_LOGIC_VECTOR (127 downto 0);
               numOuts : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    component col_mix is port (
               colIn : in STD_LOGIC_VECTOR (31 downto 0);
               colOut : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    signal addR, mixCol, shiftIn, shiftOut : std_logic_vector (127 downto 0);
begin
    addR <= numIn xor key;
    shiftIn <= addR when roundNum = "0000" else mixCol;
    numOut <= addR when roundNum = "1010" else shiftOut;
    mixs : 
    for i in 0 to 3 generate
        mixbox : col_mix port map (
            colIn => addR(127 - i * 32 downto 96 - i * 32),
            colOut => mixCol(127 - i * 32 downto 96 - i * 32));
    end generate;        
    shifts : shift_sub port map (
        numIns => shiftIn,
        numOuts => shiftOut);
end Behavioral;
