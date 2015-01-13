library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Ball is
generic (
    radius    : integer          := 20;
	ballColor : std_logic_vector := x"FF0000"
);
port (
    framerate : in    std_logic;
    
	x         : in integer;
	y 	      : in integer;
      
	width     : out   integer;
	height    : out   integer;

	cursorX   : in    integer;
	cursorY   : in    integer;
	pixelOut  : out   std_logic_vector
);
end Ball;

architecture Behavioral of Ball is
	component Ellipse is
	port (
        radius   : in  integer;
        color    : in  std_logic_vector;
    
        x        : in  integer;
        y        : in  integer;  
        
        alive    : in  std_logic;
        
        cursorX  : in  integer;
        cursorY  : in  integer;
        pixelOut : out std_logic_vector 
    );
	end component;
    signal alive : std_logic := '1';
begin
    width  <= radius;
    height <= radius;
    
	ellipse_inst : Ellipse port map(radius, ballColor, x, y, alive, cursorX, cursorY, pixelOut);
end Behavioral;