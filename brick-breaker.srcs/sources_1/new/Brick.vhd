library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Types.all;

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
	bbox_inst 		:	BBox port map(setTrigger, setX, setY, width, height, getX, getY, getWidth, getHeight);
	rectangle_inst	:	Rectangle port map(width, height, brickColor, getGraphics);
end Behavioral;