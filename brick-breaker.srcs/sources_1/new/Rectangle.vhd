library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Types;

entity Rectangle is
port (
	width		: 	in	integer;
	height		:	in 	integer;
	shapeColor	:	in 	color;

	graphics	:	out matrix
);
end Rectangle;

architecture Behavioral of Rectangle is
	signal outMatrix : matrix (0 to width, 0 to height) := (others => color);
begin
	graphics <= outMatrix;
end Behavioral;