library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Types;

entity Brick is
generic (
	width 		:	integer := 50;
	height 		:	integer := 20;
	brickColor	:	color := x"444444"
);
port (
	setTrigger	:	in 	std_logic;

	setX 		: 	in 	integer;
	setY 		: 	in 	integer;

	getX		: 	out integer;
	getY		: 	out	integer;
	getWidth	:	out	integer;
	getHeight	:	out integer;

	getGraphics	:	out matrix
);
end Brick;

architecture Behavioral of Brick is
	signal x 		: integer;
	signal y 	 	: integer;
	signal graphics : matrix (0 to width, 0 to height);

	component BBox is
	port (
		setTrigger	:	in 	std_logic;

		setX 		: 	in 	integer;
		setY 		: 	in 	integer;
		setWidth	: 	in 	integer;
		setHeight 	: 	in 	integer;

		getX		: 	out integer;
		getY		: 	out	integer;
		getWidth	:	out	integer;
		getHeight	:	out integer
	);
	end component;

	component Rectangle is
	port (
		width		: 	in	integer;
		height		:	in 	integer;
		shapeColor	:	in 	color;

		graphics	:	out matrix
	);
	end component;
begin
	getX <= x;
	getY <= y;
	getWidth <= width;
	getHeight <= height;
	getGraphics <= graphics;

	bbox 		:	BBox port map(setTrigger, setX, setY, width, height, x, y, width, height);
	rectangle	:	Rectangle port map(width, height, brickColor, graphics);
end Behavioral;