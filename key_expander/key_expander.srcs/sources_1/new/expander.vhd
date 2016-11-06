----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 03:05:55 AM
-- Design Name: 
-- Module Name: expander - Behavioral
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

entity expander is
    Port ( clk : in STD_LOGIC;
           op : in STD_LOGIC;
           keyIn : in STD_LOGIC_VECTOR (127 downto 0);
           fin : out STD_LOGIC;
           keyNum : out STD_LOGIC_VECTOR (3 downto 0);
           keyOut : out STD_LOGIC_VECTOR (127 downto 0));
end expander;

architecture Behavioral of expander is
    component sbox is port (
        numIn : in std_logic_vector (7 downto 0);
        inv : in std_logic;
        numOut : out std_logic_vector (7 downto 0));
    end component;
    
    type keyMem is array (0 to 10) of std_logic_vector (7 downto 0);
    signal curKey : integer range 0 to 11 := 1;
    signal fst, snd, rd, fth : std_logic_vector (31 downto 0);
    signal imm, mfst, msnd, mrd, mfth : std_logic_vector (31 downto 0);
    signal subst, subnd, subrd, subth, const : std_logic_vector (7 downto 0);
    signal rcons : keyMem := 
                    (x"8d", x"01", x"02", x"04", x"08", x"10",
                        x"20", x"40", x"80", x"1b", x"36");       
begin
    keyOut(127 downto 96) <= mfst;
    keyOut(95 downto 64) <= msnd;
    keyOut(63 downto 32) <= mrd;
    keyOut(31 downto 0) <= mfth;    
    
    imm(31 downto 24) <= subnd xor const;
    imm(23 downto 16) <= subrd;
    imm(15 downto 8) <= subth;
    imm(7 downto 0) <= subst; 
    
    mfst <= keyIn(127 downto 96) when curKey = 0 else imm xor fst;
    msnd <= keyIn(95 downto 64) when curKey = 0 else mfst xor snd;
    mrd <= keyIn(63 downto 32) when curKey = 0 else msnd xor rd;
    mfth <= keyIn(31 downto 0) when curKey = 0 else mrd xor fth;
          
    sbox_fst : sbox port map (
        numIn => fth(31 downto 24),
        inv => '0',
        numOut => subst);
    sbox_snd : sbox port map (
        numIn => fth(23 downto 16),
        inv => '0',
        numOut => subnd);
    sbox_thrd : sbox port map (
        numIn => fth(15 downto 8),
        inv => '0',
        numOut => subrd);
    sboc_fth : sbox port map (
        numIn => fth(7 downto 0),
        inv => '0',
        numOut => subth);
                          
    process (clk)
    begin
        if clk'event and clk = '1' then
            if op = '1' then
                if curKey < 11 then
                    if curKey = 1 then
                        fst <= keyIn(127 downto 96);
                        snd <= keyIn(95 downto 64);
                        rd <= keyIn(63 downto 32);
                        fth <= keyIn(31 downto 0);
                    else 
                        fst <= mfst;
                        snd <= msnd;
                        rd <= mrd;
                        fth <= mfth;
                    end if;
                
                    keyNum <= std_logic_vector(to_unsigned(curKey, 4));
                    const <= rcons(curKey);                                
                    curKey <= curKey + 1;
                    fin <= '0';                    
                else
                    fin <= '1';
                end if;
            else 
                fin <= '0';
                curKey <= 1;    
            end if;
        end if;
    end process;                     
end Behavioral;
