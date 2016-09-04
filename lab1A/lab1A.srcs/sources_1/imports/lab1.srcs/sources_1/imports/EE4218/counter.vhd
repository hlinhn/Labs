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
    
    component clock_divider is
    generic (CLK_SIZE : integer);
    port (clk : in std_logic;
          clk_div : out std_logic);
    end component;
    
    signal clk_btn : std_logic := '0';
    
    signal dirdeb, old_dir : std_logic := '0';    
    signal loaddeb : std_logic := '0';    
    signal modedeb, old_mode : std_logic := '0';    
    signal tickdeb, old_tick : std_logic := '0';
    
    signal clk_div, old_clk : std_logic := '0';

    constant CLK_SIZE : integer := 26;
    constant CLK_BTN_SIZE : integer := 16;
begin
    divider : clock_divider generic map (CLK_SIZE => CLK_SIZE)
    port map (clk => clk, clk_div => clk_div);
    divider_btn : clock_divider generic map (CLK_SIZE => CLK_BTN_SIZE)
    port map (clk => clk, clk_div => clk_btn);
    
    dir_deb : debouncer generic map (N => 4)
    port map (clk => clk_btn, btn => dir, outsig => dirdeb);
    load_deb : debouncer generic map (N => 4)
    port map (clk => clk_btn, btn => load, outsig => loaddeb);
    mode_deb : debouncer generic map (N => 4)
    port map (clk => clk_btn, btn => mode, outsig => modedeb);
    tick_deb : debouncer generic map (N => 4)
    port map (clk => clk_btn, btn => tick, outsig => tickdeb);           
    
    process (clk_btn, loaddeb, num)
    variable direction : std_logic := '0';
    variable mode_auto : std_logic := '1';
    variable mode_changed, dir_changed : std_logic := '0';
    variable temp : std_logic_vector(3 downto 0) := "0000";
    begin
        if loaddeb = '1' then
            temp := num;
        elsif (clk_btn'event and clk_btn = '1') then
            if modedeb = '1' and old_mode = '0' then
                mode_changed := '1';
            end if;
            if dirdeb = '1' and old_dir = '0' then
                dir_changed := '1';
            end if;
            
            if mode_auto = '1' then                    
                if clk_div = '1' and old_clk = '0' then            
                    if mode_changed = '1' then
                        mode_auto := not mode_auto;
                        mode_changed := '0';
                    end if;
                                        
                    if dir_changed = '1' then
                        direction := not direction;
                        dir_changed := '0';
                    end if;
                                        
                    if direction = '0' then 
                        temp := std_logic_vector(unsigned(temp) + 1);
                    else
                        temp := std_logic_vector(unsigned(temp) - 1);
                    end if;
                end if;
                           
            else                
                if mode_changed = '1' then
                    mode_auto := not mode_auto;
                    mode_changed := '0';
                end if;
                
                if dir_changed = '1' then
                    direction := not direction;
                    dir_changed := '0';
                end if;
                
                if tickdeb = '1' and old_tick = '0' then
                    if direction = '0' then
                        temp := std_logic_vector(unsigned(temp) + 1);
                    else
                        temp := std_logic_vector(unsigned(temp) - 1);
                    end if;
                end if;     
            end if;
            old_clk <= clk_div;                    
            old_mode <= modedeb;
            old_dir <= dirdeb;
            old_tick <= tickdeb;
        end if; 
        count <= temp;        
    end process;
end Behavioral;
