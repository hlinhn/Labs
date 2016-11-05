----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2016 09:13:07 PM
-- Design Name: 
-- Module Name: basis_change - Behavioral
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

entity basis_change is
    Port ( numIn : in STD_LOGIC_VECTOR (7 downto 0);
           switch : in STD_LOGIC_VECTOR (1 downto 0);
           numOut : out STD_LOGIC_VECTOR (7 downto 0));
end basis_change;

architecture Behavioral of basis_change is
--    type uint8 is array (7 downto 0) of std_logic;
    type mat is array (7 downto 0) of std_logic_vector (7 downto 0);
    signal to_mul : mat; 
begin
    to_mul <= ("00010010", "11101011", "11101101", "01000010",
                "01111110", "10110010", "00100010", "00000100") when switch = "00" else
              ("11100111", "01110001", "01100011", "11100001",
                "10011011", "00000001", "01100001", "01001111") when switch = "01" else
              ("00101000", "10001000", "01000001", "10101000", 
                "11111000", "01101101", "00110010", "01010010") when switch = "10" else
              ("10010000", "01010011", "01010000", "01001011",
                "11010000", "10100100", "00011001", "01110011");
                    
     process (to_mul, numIn)
        variable temp : mat;
        variable temp_bit : std_logic_vector (7 downto 0) := (others => '0');
        variable out_bit : std_logic_vector (7 downto 0) := (others => '0');
        variable temp_i : std_logic := '0';
     begin         
        for i in 7 downto 0 loop
            temp(i) := to_mul(i) and numIn;
            temp_bit := temp(i);
            temp_i := '0';
            for j in 7 downto 0 loop
                out_bit(i) := temp_i xor temp_bit(j);
                temp_i := out_bit(i);
            end loop;
        end loop;   
    numOut <= out_bit;
    end process;                
end Behavioral;
