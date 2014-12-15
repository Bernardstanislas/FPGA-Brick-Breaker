library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Types.all;

entity Rectangle is
port (
	width		: 	in	integer;
	height		:	in 	integer;
	shapeColor	:	in 	color;

	graphics	:	out matrix
);
end Rectangle;

architecture Behavioral of Rectangle is
begin
	process
    begin
        for x in 0 to width loop
            for y in 0 to height loop
                graphics(x,y) <= shapeColor;
            end loop;
        end loop;
	end process;
end Behavioral;