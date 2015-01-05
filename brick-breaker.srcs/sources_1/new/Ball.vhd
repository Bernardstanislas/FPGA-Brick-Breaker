library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ball is
generic (
	width 	   :   integer := 20;
	height 	   :   integer := 20;
	ballColor  :   std_logic_vector := x"FF0000"
);
port (
    framerate  :   in  std_logic;
	triggerSet :   in  std_logic;
    
	setX       :   in  integer;
	setY 	   :   in  integer;
    getX       :   out integer;
    getY       :   out integer;
	
	setDeltaX  :   in  integer;
    setDeltaY  :   in  integer;
	getDeltaX  :   out integer;
	getDeltaY  :   out integer;
      
	getWidth   :   out integer;
	getHeight  :   out integer;

	cursorX    :   in integer;
	cursorY    :   in integer;
	pixelOut   :   out std_logic_vector
);
end Ball;

architecture Behavioral of Ball is
	component BBox is
	port (
        triggerSet  :   in  std_logic;

        setX        :   in  integer;
        setY        :   in  integer;
        getX        :   out integer;
        getY        :   out integer;
        
        setWidth    :   in  integer;
        setHeight   :   in  integer;
        getWidth    :   out integer;
        getHeight   :   out integer;
        
        setAlive    :   in  std_logic;
        getAlive    :   out std_logic
	);
	end component;

	component Ellipse is
	generic (
		width      :   integer := 20;
        height     :   integer := 20;
        shapeColor :   std_logic_vector := x"FF0000"
    );
    port (
        X          :   in  integer;
        Y          :   in  integer;  
        
        alive       :   in std_logic;
        
        cursorX    :   in  integer;
        cursorY    :   in  integer;
        pixelOut   :   out std_logic_vector 
    );
	end component;
	
	signal x       :   integer;
	signal y       :   integer;
	signal deltaX  :   integer;
	signal deltaY  :   integer;
	
begin
    getX        <=  x;
    getY        <=  y;
    getDeltaX   <=  deltaX;
    getDeltaY   <=  deltaY;
    
    process(triggerSet)
    begin
        if (rising_edge(triggerSet)) then
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
    
	bbox_inst      :   BBox port map(triggerSet, setX, setY, x, y, width, height, getWidth, getHeight, '1');
	ellipse_inst   :   Ellipse generic map(width, height, ballColor) 
                               port map(x, y, '1', cursorX, cursorY, pixelOut);
end Behavioral;