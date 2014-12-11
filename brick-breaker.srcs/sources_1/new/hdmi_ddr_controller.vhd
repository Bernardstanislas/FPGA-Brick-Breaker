----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2014 11:13:49
-- Design Name: 
-- Module Name: hdmi_ddr_controller - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity hdmi_ddr_controller is
    Port ( clk      : in  STD_LOGIC;
           clk90    : in  STD_LOGIC;
           y        : in  STD_LOGIC_VECTOR (7 downto 0);
           c        : in  STD_LOGIC_VECTOR (7 downto 0);
           hsync_in : in  STD_LOGIC;
           vsync_in : in  STD_LOGIC;
           de_in    : in  STD_LOGIC;
           
           hdmi_clk      : out   STD_LOGIC;
           hdmi_hsync    : out   STD_LOGIC;
           hdmi_vsync    : out   STD_LOGIC;
           hdmi_d        : out   STD_LOGIC_VECTOR (15 downto 0);
           hdmi_de       : out   STD_LOGIC;
           hdmi_scl      : out   STD_LOGIC;
           hdmi_sda      : inout STD_LOGIC);
end hdmi_ddr_controller;

architecture Behavioral of hdmi_ddr_controller is
   COMPONENT i2c_controller
   PORT(
      clk    : IN std_logic;
      resend : IN std_logic;    
      siod   : INOUT std_logic;      
      sioc   : OUT std_logic
   );
   END COMPONENT;
begin
    clk_proc: process(clk)
   begin
      if rising_edge(clk) then
         hdmi_vsync <= vsync_in;
         hdmi_hsync <= hsync_in;
      end if;
   end process;

ODDR_hdmi_clk : ODDR 
   generic map(DDR_CLK_EDGE => "SAME_EDGE", INIT => '0',SRTYPE => "SYNC") 
   port map (C => clk90, Q => hdmi_clk,  D1 => '1', D2 => '0', CE => '1', R => '0', S => '0');

ODDR_hdmi_de : ODDR 
   generic map(DDR_CLK_EDGE => "SAME_EDGE", INIT => '0',SRTYPE => "SYNC") 
   port map (C => clk, Q => hdmi_de,  D1 => de_in, D2 => de_in, CE => '1', R => '0', S => '0');

ddr_gen: for i in 0 to 7 generate
   begin
   ODDR_hdmi_d : ODDR 
     generic map(DDR_CLK_EDGE => "SAME_EDGE", INIT => '0',SRTYPE => "SYNC") 
     port map (C => clk, Q => hdmi_d(i+8),  D1 => y(i), D2 => c(i), CE => '1', R => '0', S => '0');
   end generate;
   hdmi_d(7 downto 0) <= "00000000";

-----------------------------------------------------------------------   
-- This sends the configuration register values to the HDMI transmitter
-----------------------------------------------------------------------   
i_i2c_controller: i2c_controller PORT MAP(
      clk => clk,
      resend => '0',
      sioc => hdmi_scl,
      siod => hdmi_sda
   );

end Behavioral;
