library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Brick is
generic (
	brickWidth  : integer := 50;
	brickHeight : integer := 20;
	brickColor  : std_logic_vector := x"777777"
);
port (
	x 		    : in  integer;
	y 		    : in  integer;
	
	alive       : in  std_logic;
	
	width       : out integer;
	height	    : out integer;

	cursorX     : in  integer;
    cursorY     : in  integer;
    pixelOut    : out std_logic_vector
);
end Brick;

architecture Behavioral of Brick is
	component Rectangle is
	port (
        width    : in  integer;
        height   : in  integer;
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
    width <= brickWidth;
    height <= brickHeight;
    
	rectangle_inst : Rectangle port map(brickWidth, brickHeight, brickColor, x, y, alive, cursorX, cursorY, pixelOut);
end Behavioral;