library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Types.all;

entity Ball is
generic (
	ballColor  :   color := x"FF0000"
);
port (
    framerate  :   in  std_logic;
	setTrigger :   in  std_logic;
    
    setDeltaX  :   in  integer;
    setDeltaY  :   in  integer;
    
	setX       :   in  integer;
	setY 	   :   in  integer;
	setWidth   :   in  integer;
	setHeight  :   in  integer;
	
	getDeltaX  :   out integer;
	getDeltaY  :   out integer;
	
	getX       :   out integer;
	getY       :   out integer;
	getWidth   :   out integer;
	getHeight  :   out integer;

	getGraphics:   out matrix
);
end Ball;

architecture Behavioral of Ball is
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
	
	signal x       :   integer;
	signal y       :   integer;
	signal width   :   integer;
	signal height  :   integer;
	signal deltaX  :   integer;
	signal deltaY  :   integer;
	
begin
    getX        <=  x;
    getY        <=  y;
    getWidth    <=  width;
    getHeight   <=  height;
    getDeltaX   <=  deltaX;
    getDeltaY   <=  deltaY;
    
    process(setTrigger)
    begin
        if (rising_edge(setTrigger)) then
            deltaX <= setDeltaX;
            deltaY <= setDeltaY;
        end if;
    end process;
    
    process(framerate)
    begin
        if (rising_edge(framerate)) then
            x <= x + deltaX;
            y <= y + deltaY;
        end if;
    end process;
    
	bbox_inst      :   BBox    port map(setTrigger, setX, setY, setWidth, setHeight, x, y, width, height);
	ellipse_inst   :   Ellipse port map(width, height, ballColor, getGraphics);
end Behavioral;