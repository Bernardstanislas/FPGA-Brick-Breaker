----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2014 10:59:22
-- Design Name: 
-- Module Name: display_controller - Behavioral
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

entity display_controller is
    Port ( clk   : in   STD_LOGIC;
           r     : out  STD_LOGIC_VECTOR (7 downto 0);
           g     : out  STD_LOGIC_VECTOR (7 downto 0);
           b     : out  STD_LOGIC_VECTOR (7 downto 0);
           de    : out  STD_LOGIC;
           vsync : out  STD_LOGIC := '0';
           hsync : out  STD_LOGIC := '0');
end display_controller;

architecture Behavioral of display_controller is
    signal color         : STD_LOGIC_VECTOR (23 downto 0);
   
   signal   hcounter    : unsigned(11 downto 0) := (others => '0');
   signal   vcounter    : unsigned(11 downto 0) := (others => '0');
   
   constant ZERO        : unsigned(11 downto 0) := (others => '0');
   signal   hVisible    : unsigned(11 downto 0);
   signal   hStartSync  : unsigned(11 downto 0);
   signal   hEndSync    : unsigned(11 downto 0);
   signal   hMax        : unsigned(11 downto 0);
   signal   hSyncActive : std_logic := '1';
   
   signal   vVisible    : unsigned(11 downto 0);
   signal   vStartSync  : unsigned(11 downto 0);
   signal   vEndSync    : unsigned(11 downto 0);
   signal   vMax        : unsigned(11 downto 0);
   signal   vSyncActive : std_logic := '1';
   
   constant C_BLACK      : std_logic_vector(23 downto 0) := x"000000";
   constant C_RED        : std_logic_vector(23 downto 0) := x"FF0000";
   constant C_GREEN      : std_logic_vector(23 downto 0) := x"00FF00";
   constant C_BLUE       : std_logic_vector(23 downto 0) := x"0000FF";
   constant C_WHITE      : std_logic_vector(23 downto 0) := x"FFFFFF";
   
   
begin
    -- Set the video mode to 1920x1080x60Hz (150MHz pixel clock needed)
   hVisible    <= ZERO + 1920;
   hStartSync  <= ZERO + 1920+88;
   hEndSync    <= ZERO + 1920+88+44;
   hMax        <= ZERO + 1920+88+44+148-1;
   vSyncActive <= '1';

   vVisible    <= ZERO + 1080;
   vStartSync  <= ZERO + 1080+4;
   vEndSync    <= ZERO + 1080+4+5;
   vMax        <= ZERO + 1080+4+5+36-1;
   hSyncActive <= '1';

color_proc: process(hcounter,vcounter)
    begin
        for i in 0 to 11 loop
            color(i+10) <= hcounter(i);
        end loop;
end process;

clk_process: process (clk)
   begin
      if rising_edge(clk) then 

         if vcounter >= vVisible or hcounter >= hVisible then 
            r <= (others => '0');
            g <= (others => '0');
            b <= (others => '0');
            de <= '0';
         else
            R  <= color(23 downto 16);
            G  <= color(15 downto  8);
            B  <= color( 7 downto  0);
            de <= '1';
         end if;
              
         -- Generate the sync Pulses
         if vcounter = vStartSync then 
            vSync <= vSyncActive;
         elsif vCounter = vEndSync then
            vSync <= not(vSyncActive);
         end if;

         if hcounter = hStartSync then 
            hSync <= hSyncActive;
         elsif hCounter = hEndSync then
            hSync <= not(hSyncActive);
         end if;

            -- Advance the position counters
         IF hCounter = hMax  THEN
            -- starting a new line
            hCounter <= (others => '0');
            IF vCounter = vMax THEN
               vCounter <= (others => '0');
            ELSE
               vCounter <= vCounter + 1;
            END IF;
         ELSE
            hCounter <= hCounter + 1;
         end if;
      end if;
end process;

end Behavioral;
