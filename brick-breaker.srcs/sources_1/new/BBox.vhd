library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BBox is
port (
    triggerSet  :   in  std_logic;

    setX        :   in  integer;
    setY        :   in  integer;
    getX        :   out integer;
    getY        :   out integer;
    
	setWidth	: 	in 	integer;
	setHeight 	: 	in 	integer;
	getWidth	:	out	integer;
	getHeight	:	out integer
);
end BBox;

architecture Behavioral of BBox is
	signal x 		: integer;
	signal y 	 	: integer;
	signal width 	: integer;
	signal height 	: integer;
begin
	getX <= x;
	getY <= y;
	getWidth <= width;
	getHeight <= height;

	process(triggerSet)
	begin
		if (rising_edge(triggerSet)) then
			x <= setX;
			y <= setY;
			width <= setWidth;
			height <= setHeight;
		end if;
	end process;
end Behavioral;