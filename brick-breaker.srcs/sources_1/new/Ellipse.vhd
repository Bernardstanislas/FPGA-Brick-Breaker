library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Types;

entity Ellipse is
port (
	width		: 	in	integer;
	height		:	in 	integer;
	shapeColor	:	in 	color;

	graphics	:	out matrix
);
end Ellipse;

architecture Behavioral of Ellipse is
	signal outMatrix : matrix (0 to width, 0 to height) := (others => x"000000");
begin
    process
    begin
        for x in 0 to width loop
            for y in 0 to height loop
                outMatrix(i,j) <= color when ((x - width / 2) ** 2) / ((width / 2) ** 2) + ((y - height / 2) ** 2) / ((height / 2) ** 2) <= 1;
            end loop;
        end loop;
	end process;

	graphics <= outMatrix;
end Behavioral;