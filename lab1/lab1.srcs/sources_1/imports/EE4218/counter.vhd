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
    
    component single_pulser is
    port (clk : in std_logic;
          sig_in : in std_logic;
          hold : in std_logic;
          slow_clk : in std_logic;
          sig_out : out std_logic);
    end component;
    
    signal clk_btn : std_logic := '0';
    
    signal dirdeb, dir_fin : std_logic := '0';    
    signal loaddeb, load_fin : std_logic := '0';    
    signal modedeb, mode_fin : std_logic := '0';    
    signal tickdeb, tick_fin : std_logic := '0';
    
    signal dir_hold, mode_hold, load_hold, tick_hold : std_logic;
    
    signal clk_div, old_clk : std_logic := '0';
    signal temp : std_logic_vector(3 downto 0) := "0000";

    constant CLK_SIZE : integer := 4;
    constant CLK_BTN_SIZE : integer := 2;
begin
    divider : clock_divider generic map (CLK_SIZE => CLK_SIZE)
    port map (clk => clk, clk_div => clk_div);
    divider_btn : clock_divider generic map (CLK_SIZE => CLK_BTN_SIZE)
    port map (clk => clk, clk_div => clk_btn);
    
    dir_deb : debouncer generic map (N => 1)
    port map (clk => clk_btn, btn => dir, outsig => dirdeb);
    load_deb : debouncer generic map (N => 1)
    port map (clk => clk_btn, btn => load, outsig => loaddeb);
    mode_deb : debouncer generic map (N => 1)
    port map (clk => clk_btn, btn => mode, outsig => modedeb);
    tick_deb : debouncer generic map (N => 1)
    port map (clk => clk_btn, btn => tick, outsig => tickdeb);
    
    tick_hold <= '0';
    
    pulser_dir : single_pulser 
    port map (clk => clk_btn, sig_in => dirdeb, hold => dir_hold, slow_clk => clk_div, sig_out => dir_fin);
    pulse_load : single_pulser 
    port map (clk => clk_btn, sig_in => loaddeb, hold => load_hold, slow_clk => clk_div, sig_out => load_fin);
    pulse_mode : single_pulser
    port map (clk => clk_btn, sig_in => modedeb, hold => mode_hold, slow_clk => clk_div, sig_out => mode_fin);
    pulse_tick : single_pulser
    port map (clk => clk_btn, sig_in => tickdeb, hold => tick_hold, slow_clk => clk_div, sig_out => tick_fin);    
     
--    direction_changed <= dirdeb xor old_dir;
--    mode_changed <= modedeb xor old_mode;
--    tick_changed <= tickdeb xor old_tick;    
    
    process (clk_btn, loaddeb, num)
    variable direction : std_logic := '0';
    variable mode_auto : std_logic := '1';
    
    begin
        if load_fin = '1' then
            temp <= num;
        elsif (clk_btn'event and clk_btn = '1') then
            if mode_auto = '1' then
                dir_hold <= '1';
                mode_hold <= '1';
                load_hold <= '1';
                if clk_div = '1' and old_clk = '0' then            
                    if mode_fin = '1' then
                        mode_auto := not mode_auto;
                    end if;
                    
                    if dir_fin = '1' then
                        direction := not direction;
                    end if;
                                        
                    if direction = '0' then 
                        temp <= std_logic_vector(unsigned(temp) + 1);
                    else
                        temp <= std_logic_vector(unsigned(temp) - 1);
                    end if;
                end if;
                           
            else
                dir_hold <= '0';
                mode_hold <= '0';
                load_hold <= '0';
                
                if mode_fin = '1' then
                    mode_auto := not mode_auto;
                end if;
                
                if dir_fin = '1' then
                    direction := not direction;
                end if;
                
                if tick_fin = '1' then
                    if direction = '0' then
                        temp <= std_logic_vector(unsigned(temp) + 1);
                    else
                        temp <= std_logic_vector(unsigned(temp) - 1);
                    end if;
                end if;     
            end if;
            old_clk <= clk_div;                    
        end if;         
    end process;
    count <= temp;            
end Behavioral;
