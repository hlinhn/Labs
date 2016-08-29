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
    Port ( clk : in STD_LOGIC;
           dir : in STD_LOGIC;
           load : in STD_LOGIC;
           mode : in STD_LOGIC;
           tick : in STD_LOGIC;
           num : in STD_LOGIC_VECTOR (3 downto 0);
           count : out STD_LOGIC_VECTOR (3 downto 0));
end counter;

architecture Behavioral of counter is
    component debouncer is
    generic (N: integer);
    port (clk : in std_logic;
          btn : in std_logic;
          outsig : out std_logic
          );
    end component;
    
    signal dirdeb : std_logic := '0';
    signal old_dir : std_logic := '0';
    signal direction_changed : std_logic := '0';
    
    signal loaddeb : std_logic := '0';
    
    signal modedeb : std_logic := '0';
    signal old_mode : std_logic := '0';
    signal mode_changed : std_logic := '1';
    
    signal tickdeb : std_logic := '0';
    signal old_tick : std_logic := '0';
    signal tick_changed : std_logic := '0';
    
    signal clk_div : std_logic := '0';
    signal temp : std_logic_vector(3 downto 0) := "0000";

    constant CLK_SIZE : integer := 2;
begin
    dir_deb : debouncer generic map (N => 1)
    port map (clk => clk, btn => dir, outsig => dirdeb);
    load_deb : debouncer generic map (N => 1)
    port map (clk => clk, btn => load, outsig => loaddeb);
    mode_deb : debouncer generic map (N => 1)
    port map (clk => clk, btn => mode, outsig => modedeb);
    tick_deb : debouncer generic map (N => 1)
    port map (clk => clk, btn => tick, outsig => tickdeb);
    
    direction_changed <= dirdeb xor old_dir;
    mode_changed <= modedeb xor old_mode;
    tick_changed <= tickdeb xor old_tick;
    
    div_clk : process (clk)
    variable count : std_logic_vector (CLK_SIZE downto 0) := (others => '0');
    begin
        if clk'event and clk = '1' then
            count := std_logic_vector(unsigned(count) + 1);
        end if;
        clk_div <= count(CLK_SIZE);
    end process;
    
    process (clk_div, loaddeb, num, tick)
    variable direction : std_logic := '0';
    variable mode_auto : std_logic := '1';
    variable tick_now : std_logic := '0';
    
    begin
        if loaddeb = '1' then
            temp <= num;
        elsif (clk_div'event and clk_div = '1') then
            old_dir <= dirdeb;
            old_mode <= modedeb;
            old_tick <= tickdeb;
            
            if mode_changed = '1' and modedeb = '1' then
                mode_auto := not mode_auto;
            end if;
            
            if direction_changed = '1' and dirdeb = '1' then
                direction := not direction;
            end if;
            
            if tick_changed = '1' and tickdeb = '1' then
                tick_now := '1';
            else
                tick_now := '0';
            end if;
                    
            if mode_auto = '1' then                
                if direction = '0' then 
                    temp <= std_logic_vector(unsigned(temp) + 1);
                else
                    temp <= std_logic_vector(unsigned(temp) - 1);
                end if;
            else
                if tick_now = '1' then
                    if direction = '0' then
                        temp <= std_logic_vector(unsigned(temp) + 1);
                    else
                        temp <= std_logic_vector(unsigned(temp) - 1);
                    end if;
                end if;     
            end if;                    
        end if;         
    end process;
    count <= temp;            
end Behavioral;
