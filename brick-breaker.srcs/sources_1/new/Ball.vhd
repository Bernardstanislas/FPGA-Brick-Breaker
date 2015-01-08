library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Ball is
generic (
    radius      :   integer            :=  10;
	ballColor   :   std_logic_vector   :=  x"FF0000"
);
port (
    clock           : in  std_logic;
    framerate       : in  std_logic;
	triggerSetPos   : in  std_logic;
	triggerSetDelta : in  std_logic;
    
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
        clock       :   in  std_logic;
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
	port (
		radius     :   in integer;
        shapeColor :   in std_logic_vector;

        X          :   in  integer;
        Y          :   in  integer;  
        
        alive      :   in  std_logic;
        
        cursorX    :   in  integer;
        cursorY    :   in  integer;
        pixelOut   :   out std_logic_vector 
    );
	end component;
	
	signal X              :   integer;
	signal Y              :   integer;
    signal deltaX         :   integer;
    signal deltaY         :   integer;

    -- We're using a bunch of intermediate signals for the position because we can also set the position internally (the ball moves by itself)
	signal iX             :   integer; -- Represents the set position, before being moved
    signal iY             :   integer;
    signal iTriggerSetPos :   std_logic; -- Equals 1 with external triggerSetPos = 1 or just after an internal movement
    signal iSetX          :   integer; -- Represents the position to set, either set externally or by the framerate process
    signal iSetY          :   integer;
	
begin
    getX        <=  X;
    getY        <=  Y;
    getDeltaX   <=  deltaX;
    getDeltaY   <=  deltaY;
    
    -- Main ball process
    process (clock)
    begin
        if (triggerSetPos = '1' and triggerSetDelta = '1') then
            iTriggerSetPos <= '1';
            iSetX <= setX; -- Override
            iSetY <= setY; -- Override
            deltaX <= setDeltaX; -- Override
            deltaY <= setDeltaY; -- Override
            X <= iX;
            Y <= iY;

        -- First of all, we check if the game asked to reset the ball
        elsif (triggerSetPos = '1') then
            iTriggerSetPos <= '1';
            iSetX <= setX; -- Override
            iSetY <= setY; -- Override
            deltaX <= deltaX;
            deltaY <= deltaY;
            X <= iX;
            Y <= iY;

        -- Then, we check if the ball collided with anything
        elsif (triggerSetDelta = '1') then
            iTriggerSetPos <= '0';
            iSetX <= iSetX;
            iSetY <= iSetY;
            deltaX <= setDeltaX; -- Override
            deltaY <= setDeltaY; -- Override
            X <= iX;
            Y <= iY;

        -- Then, we move the ball if we're at a frame time
        elsif (framerate = '1') then
           iTriggerSetPos <= '1';
           iSetX <= iX + deltaX; -- Override
           iSetY <= iY + deltaY; -- Override
           deltaX <= deltaX;
           deltaY <= deltaY;
           X <= iX + deltaX; -- Override
           Y <= iY + deltaY; -- Override
        
        -- And when nothing happens, we keep everything like it was, and we put the trigger back to 0    
        else
           iTriggerSetPos <= '0';
           iSetX <= iSetX;
           iSetY <= iSetY;
           deltaX <= deltaX;
           deltaY <= deltaY;
           X <= iX;
           Y <= iY;
        end if;
    end process;
    
	bbox_inst      :   BBox port map(clock, iTriggerSetPos, iSetX, iSetY, iX, iY, radius, radius, getWidth, getHeight, '1');
	ellipse_inst   :   Ellipse port map(radius, ballColor, X, Y, '1', cursorX, cursorY, pixelOut);
end Behavioral;