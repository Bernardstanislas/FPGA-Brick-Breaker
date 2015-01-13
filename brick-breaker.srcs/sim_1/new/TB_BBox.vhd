----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2015 11:38:17
-- Design Name: 
-- Module Name: TB_BBox - Behavioral
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

entity TB_BBox is
--  Port ( );
end TB_BBox;

architecture Behavioral of TB_BBox is
    component BBox is
    port (
        clock        :    in  std_logic;
        triggerSet  :   in  std_logic;
    
        setX        :   in  integer;
        setY        :   in  integer;
        getX        :   out integer;
        getY        :   out integer;
        
        setWidth    :     in     integer;
        setHeight     :     in     integer;
        getWidth    :    out    integer;
        getHeight    :    out integer;
        
        setAlive    :   in  std_logic;
        getAlive    :   out std_logic
    );
    end component;
    
    signal triggerSet : std_logic := '0';
    signal setX : integer := 500;
    signal setY : integer := 500;
    signal getX : integer := 0;
    signal getY : integer := 0;
    signal setWidth : integer := 30;
    signal setHeight : integer := 10;
    signal getWidth : integer := 0;
    signal getHeight : integer := 0;
    
    signal setAlive : std_logic := '1';
    signal getAlive : std_logic;

    signal CLK : std_logic := '0';
    constant CLK_period : time := 10 ns;
begin
    uut : BBox port map (clk, triggerSet, setX, setY, getX, getY, setWidth, setHeight, getWidth, getHeight, setAlive, getAlive);

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
        wait for CLK_period * 3;
        setX <= 666;
        setY <= 90;
        triggerSet <= '1';
        wait for CLK_period;
        triggerSet <= '0';
        wait;
    end process;

end Behavioral;
