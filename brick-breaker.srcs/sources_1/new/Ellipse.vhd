library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Types.all;

entity Ellipse is
port (
	width		: 	in	integer;
	height		:	in 	integer;
	shapeColor	:	in 	color;

	graphics	:	out matrix
);
end Ellipse;

architecture Behavioral of Ellipse is
begin
    process
    begin
        for x in 0 to width loop
            for y in 0 to height loop
                graphics(x,y) <= shapeColor ;
                   -- when ((x - width / 2) * (x - width / 2)) / ((width / 2) * (width / 2)) + ((y - height / 2) * (y - height / 2)) / ((height / 2) * (height / 2)) <= 1
                   -- else x"000000";
            end loop;
        end loop;
	end process;
end Behavioral;