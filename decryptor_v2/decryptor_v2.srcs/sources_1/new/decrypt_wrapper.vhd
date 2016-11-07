----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2016 12:35:14 AM
-- Design Name: 
-- Module Name: decrypt_wrapper - Behavioral
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

entity decrypt_wrapper is
    Port ( clk : in STD_LOGIC;
           load_key : in STD_LOGIC;
           endData : in STD_LOGIC;
           numIn : in STD_LOGIC_VECTOR (31 downto 0);
           ready : out STD_LOGIC;
           numOut : out STD_LOGIC_VECTOR (31 downto 0));
end decrypt_wrapper;

architecture Behavioral of decrypt_wrapper is
    component decryptor is 
        Port ( clk : in STD_LOGIC;
               mode : in STD_LOGIC_VECTOR (1 downto 0);
               mes : in STD_LOGIC_VECTOR (127 downto 0);
               readReady : out STD_LOGIC;
               dataReady : out STD_LOGIC;
               mesOut : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    signal readReady, dataReady, old_load, en, firstLoad : std_logic;
    signal key, mes, mesOut : std_logic_vector (127 downto 0);
    signal count, countOut, mode : std_logic_vector (1 downto 0) := "00";
    
--    signal holdDataOut, holdDataIn : std_logic_vector (127 downto 0);
    
    signal en_read, en_write : std_logic := '0';
    type STATE_TYPE is (idle, keyIn, dataIn, dataOut);
    signal state : STATE_TYPE;
                  
begin    
    process (clk)
    variable holdDataIn, holdDataOut : std_logic_vector (127 downto 0);
    begin
        if clk'event and clk = '1' then
            ready <= dataReady;                        
            case state is 
            when idle =>
                mode <= "00";
                if load_key = '1' then 
                    state <= keyIn;
                    count <= "01";
                    en_read <= '1';
                    countOut <= "00";
                    holdDataIn(127 downto 96) := numIn;
                else
                    state <= idle;
                end if;
                                    
            when keyIn =>
                if en_read = '1' then    
                    count <= std_logic_vector(unsigned(count) + 1);                               
                    if count = "11" then 
                        mode <= "01";
                        en_read <= '0';
                    end if;
                end if;    

                if readReady = '1' then
                    state <= dataIn;
                    count <= "01";
                    en_read <= '1';
                    holdDataIn(127 downto 96) := numIn;
                    firstLoad <= '0';                    
                else
                    state <= keyIn;
                end if;
                                        
            when dataIn =>
                if en_read = '1' and firstLoad = '0' then
                    count <= std_logic_vector(unsigned(count) + 1);                               
                    if count = "11" then
                        mode <= "10";
                        firstLoad <= '1';
                    end if;
                end if;
                
                if en_read = '1' and firstLoad = '1' then
                    count <= std_logic_vector(unsigned(count) + 1);                                           
                end if;
                
                if en_write = '1' then
                    countOut <= std_logic_vector(unsigned(countOut) + 1);                               
                end if;
                        
                if en_write = '0' and dataReady = '1' then
                    holdDataOut := mesOut;
                    countOut <= "00";
                    en_write <= '1';
                    numOut <= holdDataOut(127 downto 96);
                end if;
                                            
                if endData = '1' then
                    state <= dataOut;
                    mode <= "11";
                    en_read <= '0';
                else
                    state <= dataIn;
                end if;
                 
            when dataOut =>
                if dataReady = '0' then
                    en_write <= '0'; 
                    state <= idle;
                    mode <= "00";
                else
                    state <= dataOut;
                end if;

                if en_write = '1' then
                    countOut <= std_logic_vector(unsigned(countOut) + 1);                               
                end if;
                
            end case;
            
            if en_read = '1' then    
                if count = "00" then
                    holdDataIn(127 downto 96) := numIn;
                end if;    
                if count = "01" then
                    holdDataIn(95 downto 64) := numIn;
                end if;    
                if count = "10" then
                    holdDataIn(63 downto 32) := numIn;
                end if;    
                if count = "11" then 
                    holdDataIn(31 downto 0) := numIn;
                    mes <= holdDataIn;                     
                end if;  
            end if;                  
            
            if en_write = '1' then
                case countOut is
                when "00" =>
                    holdDataOut := mesOut; 
                    numOut <= holdDataOut(127 downto 96);                                                   
                when "01" => numOut <= holdDataOut(95 downto 64);
                when "10" => numOut <= holdDataOut(63 downto 32);
                when others => numOut <= holdDataOut(31 downto 0);
                end case;    
            end if;                                                                                                   
        end if;        
    end process;
    
    dec : decryptor port map (
        clk => clk,
        mode => mode,
        mes => mes,
        readReady => readReady,
        dataReady => dataReady,
        mesOut => mesOut);

end Behavioral;
