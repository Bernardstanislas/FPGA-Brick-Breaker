library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Ball is
generic (
    radius    : integer          := 10;
	ballColor : std_logic_vector := x"FF0000"
);
port (
    framerate : in    std_logic;
    
	x         : in integer;
	y 	      : in integer;
	
	deltaX    : in    integer;
    deltaY    : in    integer;
      
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

begin
    width  <= 2 * radius;
    height <= 2 * radius;
    
    --x <= x + deltaX when framerate = '1' else y;
    --y <= y + deltaY when framerate = '1' else y;
    
	ellipse_inst : Ellipse port map(radius, ballColor, x, y, '1', cursorX, cursorY, pixelOut);
end Behavioral;