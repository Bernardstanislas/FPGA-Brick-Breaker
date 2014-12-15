library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Types;

entity Ball is
generic (
	ballColor	:	color := x"FF0000"
);
port (
	setTrigger	:	in 	std_logic;

	setX 		: 	in 	integer;
	setY 		: 	in 	integer;
	setWidth	:	in 	integer;
	setHeight	:	in  integer;
	getX		: 	out integer;
	getY		: 	out	integer;
	getWidth	:	out	integer;
	getHeight	:	out integer;

	getGraphics	:	out matrix
);
end Ball;

architecture Behavioral of Ball is
	signal x 		: integer;
	signal y 	 	: integer;
	signal width 	: integer;
	signal height 	: integer;
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

	component Ellipse is
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

	bbox       :   BBox    port map(setTrigger, setX, setY, setWidth, setHeight, x, y, width, height);
	ellipse    :   Ellipse port map(width, height, brickColor, graphics);
end Behavioral;