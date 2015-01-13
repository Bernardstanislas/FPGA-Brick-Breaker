library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Ball is
generic (
    radius      :   integer            :=  10;
	ballColor   :   std_logic_vector   :=  x"FF00FF"
);
port (
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
    signal iTriggerSetPos :   std_logic; -- Equals 1 with external triggerSetPos = 1 or just after an internal movement
    signal iSetX          :   integer; -- Represents the position to set, either set externally or by the framerate process
    signal iSetY          :   integer;
	
begin
    getX        <=  X;
    getY        <=  Y;
    getDeltaX   <=  deltaX;
    getDeltaY   <=  deltaY;
    
    iTriggerSetPos <= triggerSetPos;
    
    iSetX <= setX when triggerSetPos = '1' else iSetX;                                     
    iSetY <= setY when triggerSetPos = '1' else iSetY;
    
    deltaX <= setDeltaX when triggerSetDelta = '1' else deltaX;
    deltaY <= setDeltaY when triggerSetDelta = '1' else deltaY;
    
	bbox_inst      :   BBox port map(iTriggerSetPos, iSetX, iSetY, X, Y, radius, radius, getWidth, getHeight, '1');
	ellipse_inst   :   Ellipse port map(radius, ballColor, X, Y, '1', cursorX, cursorY, pixelOut);
end Behavioral;