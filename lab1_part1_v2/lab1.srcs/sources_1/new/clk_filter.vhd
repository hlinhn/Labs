----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.08.2016 13:59:26
-- Design Name: 
-- Module Name: clk_filter - Behavioral
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

entity clk_filter is
    Port ( btn : in STD_LOGIC;
            clk : in STD_LOGIC;
           filtered_btn : out STD_LOGIC);
end clk_filter;

architecture Behavioral of clk_filter is
    component d_flip_flop
    Port ( 
        clk : in  STD_LOGIC;
        D : in  STD_LOGIC;
        Q : out  STD_LOGIC
    );
    end component;
    signal q1d2, q2: std_logic:='0';

begin
    DFF1 : d_flip_flop port map (
        D => btn,
        Q => q1d2,
        clk => clk
    );
    DFF2 : d_flip_flop port map (
            D => q1d2,
            Q => q2,
            clk => clk
        );
    filtered_btn <= q1d2 and (not q2);
end Behavioral;
