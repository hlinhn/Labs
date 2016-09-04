----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/30/2016 03:06:40 PM
-- Design Name: 
-- Module Name: atc - Behavioral
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

entity atc is
    Port ( clk : in STD_LOGIC;
           plane : in STD_LOGIC_VECTOR (2 downto 0);
           req : in STD_LOGIC;
           acc : out STD_LOGIC_VECTOR (1 downto 0));
end atc;

architecture Behavioral of atc is
    TYPE State_type is (busy, idle, heavy_busy);
    signal state : STATE_TYPE := idle;
    TYPE Plane_type is (light, heavy);
    signal type_plane : Plane_type;
        
    component debouncer is 
    generic (N: integer);
    port (clk : in std_logic;
          btn : in std_logic;
          outsig : out std_logic
          );
    end component;
        
    component simple_counter is
    generic (N: integer);
    port (clk : in std_logic;
          en : in std_logic;
          clear : in std_logic;
          count : out std_logic_vector (N downto 0));
    end component;
    
    component clock_divider is
    generic (CLK_SIZE : integer);
    port (clk : in std_logic;
          clk_div : out std_logic);
    end component;
    
    signal clk_div, old_clk : std_logic := '0';
    signal clk_btn : std_logic := '0';

    signal req_deb : std_logic;
    signal old_req : std_logic := '0';
    
    signal prev_plane : Plane_type;
    
    signal en_busy : std_logic := '0';
    signal clr_busy : std_logic := '0';
    signal cnt_busy : std_logic_vector (1 downto 0);
    signal en_heavy : std_logic := '0';
    signal clr_heavy : std_logic := '0';
    signal cnt_heavy : std_logic_vector (3 downto 0);
    
    constant CLK_SIZE : integer := 26; 
    constant BTN_TIME : integer := 16;
begin
    debounce_req : debouncer generic map (N => 4)
    port map (clk => clk_btn, btn => req, outsig => req_deb);
    
    divider : clock_divider generic map (CLK_SIZE => CLK_SIZE)
    port map (clk => clk, clk_div => clk_div);
    
    divider_2 : clock_divider generic map (CLK_SIZE => BTN_TIME)
    port map (clk => clk, clk_div => clk_btn);
    
    type_plane <= heavy when plane = "001" or plane = "011" or plane = "111" else
                  light;                  
                  
    counter_busy : simple_counter generic map (N => 1)
    port map (clk => clk_div, en => en_busy, clear => clr_busy, count => cnt_busy);                            
    counter_heavy : simple_counter generic map (N => 3)
    port map (clk => clk_div, en => en_heavy, clear => clr_heavy, count => cnt_heavy);
    
    proc_req : process (clk_btn)
    variable req_avail : std_logic := '0';
    begin
        if clk_btn'event and clk_btn = '1' then
            if req_deb = '1' and old_req = '0' then
                req_avail := '1';
            end if;
            old_req <= req_deb;
            if clk_div = '1' and old_clk = '0' then                                    
                case state is
                    when idle =>
                        if req_avail = '1' then
                            acc <= "01"; --granted
                            state <= busy; --switch to display
                            prev_plane <= type_plane; --record the plane that took off
                            en_busy <= '1'; --start the counter
                            clr_busy <= '0';
                        else
                            acc <= "00";
                            state <= idle;
                        end if;
                    when busy =>
                        if unsigned(cnt_busy) < 2 then
                            state <= busy; --display for 3 seconds
                        else
                            en_busy <= '0'; --stop the counter
                            clr_busy <= '1';
                            acc <= "00";
                            if prev_plane = light then
                                state <= idle; --can accept any request
                            else --cannot accept all requests
                                if unsigned(cnt_heavy) < 9 then --have not passed the safe time
                                    state <= heavy_busy;
                                    en_heavy <= '1'; --continue counting
                                    clr_heavy <= '0';
                                else --have passed the safe time from last takeoff
                                    state <= idle;
                                    clr_heavy <= '1';
                                    en_heavy <= '0';
                                end if;
                            end if;
                        end if;                        
                    when heavy_busy =>
                        if unsigned(cnt_heavy) < 9 then
                            state <= heavy_busy;
                        else
                            en_heavy <= '0';
                            clr_heavy <= '1';
                            state <= idle;
                        end if;    
                        
                        if req_avail = '1' then
                            if type_plane = heavy then
                                acc <= "01"; --granted
                                state <= busy; --switch to display
                                en_heavy <= '0'; --restart the counter
                                clr_heavy <= '1';
                                prev_plane <= heavy;
                                en_busy <= '1';
                                clr_busy <= '0';
                            else
                                acc <= "10"; --denied, do not update prev_plane
                                state <= busy; --switch to display
                                en_busy <= '1';
                                clr_busy <= '0';
                            end if;
                        else
                            acc <= "00";                       
                        end if;               
                end case;
                req_avail := '0';
            end if;
            old_clk <= clk_div;
        end if;
    end process;

end Behavioral;
