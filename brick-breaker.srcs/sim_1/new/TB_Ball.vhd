----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2015 14:42:42
-- Design Name: 
-- Module Name: TB_Ball - Behavioral
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

entity TB_Ball is
--  Port ( );
end TB_Ball;

architecture Behavioral of TB_Ball is
    component Ball is
    port (
        framerate  :   in  std_logic;
        triggerSet :   in  std_logic;
        
        setX       :   in  integer;
        setY       :   in  integer;
        getX       :   out integer;
        getY       :   out integer;
        
        setDeltaX  :   in  integer;
        setDeltaY  :   in  integer;
        getDeltaX  :   out integer;
        getDeltaY  :   out integer;
          
        getWidth   :   out integer;
        getHeight  :   out integer;
    
        cursorX    :   in integer;
        cursorY    :   in integer;
        pixelOut   :   out std_logic_vector
    );
    end component;
    
    signal framerate : std_logic := '0';
    signal triggerSet : std_logic := '0';
    signal setX : integer := 500;
    signal setY : integer := 500;
    signal getX : integer := 0;
    signal getY : integer := 0;
    signal setDeltaX : integer := 10;
    signal setDeltaY : integer := 10;
    signal getDeltaX : integer := 0;
    signal getDeltaY : integer := 0;
    signal getWidth : integer := 0;
    signal getHeight : integer := 0;
    signal cursorX : integer := 0;
    signal cursorY : integer := 0;
    signal pixelOut : std_logic_vector(23 downto 0);
    
    signal CLK : std_logic := '0';
    constant CLK_period : time := 10 ns;
begin
    uut : Ball port map (framerate, triggerSet, setX, setY, getX, getY, setDeltaX, setDeltaY, getDeltaX, getDeltaY, getWidth, getHeight, cursorX, cursorY, pixelOut);
    
    -- On génère une horloge de test
    CLK_process : process
            begin
                CLK <= '0';
                wait for CLK_period/2;
                CLK <= '1';
                wait for CLK_period/2;
    end process;
    
    stim_proc : process
    begin
        wait for CLK_period * 2;
        triggerSet <= '1';
        wait for CLK_period;
        triggerSet <= '0';
        cursorX <= 505;
        cursorY <= 505;
        wait for CLK_period * 3;
        cursorX <= 555;
        cursorY <= 555;
        wait for CLK_period * 3;
        framerate <= '1';
        wait for CLK_period;
        framerate <= '0';
        wait for CLK_period * 3;
        framerate <= '1';
        wait for CLK_period;
        framerate <= '0';
        wait;
    end process;
    
end Behavioral;
