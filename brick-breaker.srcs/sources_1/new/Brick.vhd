library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Brick is
generic (
	width 		:	integer := 50;
	height 		:	integer := 20;
	brickColor	:	std_logic_vector := x"777777"
);
port (
	triggerSet	:	in 	std_logic;

	setX 		: 	in 	integer;
	setY 		: 	in 	integer;
	getX		: 	out integer;
	getY		: 	out	integer;
	
	setAlive   :   in std_logic;
	getAlive   :   out std_logic;
	
	getWidth	:	out	integer;
	getHeight	:	out integer;

	cursorX     :   in  integer;
    cursorY     :   in  integer;
    pixelOut    :   out std_logic_vector
);
end Brick;

architecture Behavioral of Brick is
	component BBox is
	port (
		triggerSet	:	in 	std_logic;

		setX 		: 	in 	integer;
		setY 		: 	in 	integer;
		getX		: 	out integer;
		getY		: 	out	integer;
		
		setWidth	: 	in 	integer;
        setHeight   :   in  integer;
		getWidth	:	out	integer;
		getHeight	:	out integer;
		
	    setAlive   :   in std_logic;
        getAlive   :   out std_logic
	);
	end component;

	component Rectangle is
	generic (
        width      :   integer;
        height     :   integer;
        shapeColor :   std_logic_vector
    );
    port (
        X          :   in  integer;
        Y          :   in  integer;  
        
        alive       : in std_logic;
        
        cursorX    :   in  integer;
        cursorY    :   in  integer;
        pixelOut   :   out std_logic_vector 
    );
	end component;
	
	signal x : integer;
	signal y : integer;
	signal alive : std_logic;
begin
    getX <= x;
    getY <= y;
    getAlive <= alive;
    
	bbox_inst 		:	BBox port map(triggerSet, setX, setY, x, y, width, height, getWidth, getHeight, setAlive, alive);
	rectangle_inst	:	Rectangle  generic map(width, height, brickColor) 
	                               port map(x, y, alive, cursorX, cursorY, pixelOut);
end Behavioral;