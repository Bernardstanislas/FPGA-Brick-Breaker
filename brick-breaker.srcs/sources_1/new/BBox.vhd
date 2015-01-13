library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BBox is
port (
	clock		:	in  std_logic;
    triggerSet  :   in  std_logic;

    setX        :   in  integer;
    setY        :   in  integer;
    getX        :   out integer;
    getY        :   out integer;
    
	setWidth	: 	in 	integer;
	setHeight 	: 	in 	integer;
	getWidth	:	out	integer;
	getHeight	:	out integer;
	
	setAlive    :   in  std_logic;
	getAlive    :   out std_logic
);
end BBox;

architecture Behavioral of BBox is
	signal x 		: integer;
	signal y 	 	: integer;
	signal width 	: integer;
	signal height 	: integer;
	signal alive    : std_logic;
	
begin
	getX <= x;
	getY <= y;
	getWidth <= width;
	getHeight <= height;
	getAlive <= alive;
    
    process
    begin
        case triggerSet is
            when '1' =>
                x <= setX;
                y <= setY;
                width <= setWidth;
                height <= setHeight;
                alive <= setAlive;
            when '0' =>
                x <= x;
                y <= y;
                width <= width;
                height <= height;
                alive <= alive;
        end case;
    end process;
end Behavioral;