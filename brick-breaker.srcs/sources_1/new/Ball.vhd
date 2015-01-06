library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Ball is
generic (
	width 	   :   integer := 20;
	height 	   :   integer := 20;
	ballColor  :   std_logic_vector := x"FF0000"
);
port (
    framerate  :   in  std_logic;
	triggerSetPos :   in  std_logic;
	triggerSetDelta :   in  std_logic;
    
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
	
	signal X       :   integer;
	signal Y       :   integer;
	signal iX       :   integer;
    signal iY       :   integer;
    signal iTriggerSet : std_logic := '0';
    signal iSetX : integer;
    signal iSetY : integer;
	signal deltaX  :   integer;
	signal deltaY  :   integer;
	
begin
    getX        <=  X;
    getY        <=  Y;
    getDeltaX   <=  deltaX;
    getDeltaY   <=  deltaY;
    
    process (triggerSetDelta, triggerSetPos, framerate)
    begin
        if (triggerSetPos = '1') then
            deltaX <= deltaX;
            deltaY <= deltaY;
            iSetX <= setX;
            iSetY <= setY;
            iTriggerSet <= '1';
            X <= iX;
            Y <= iY;
        elsif (triggerSetDelta = '1') then
            X <= iX;
            iSetX <= iSetX;
            Y <= iY;
            iSetY <= iSetY;
            iTriggerSet <= '0';
            deltaX <= setDeltaX;
            deltaY <= setDeltaY;
        elsif (framerate = '1') then
            X <= iX + deltaX;
            iSetX <= iX + deltaX;
            Y <= iY + deltaY;
            iSetY <= iY + deltaY;
            iTriggerSet <= '1';
            deltaX <= deltaX;
            deltaY <= deltaY;
        else
            iTriggerSet <= '0';
            iSetX <= iSetX;
            iSetY <= iSetY;
            deltaX <= deltaX;
            deltaY <= deltaY;
            X <= iX;
            Y <= iY;
        end if;
    end process;
    
	bbox_inst      :   BBox port map(iTriggerSet, iSetX, iSetY, iX, iY, width, height, getWidth, getHeight, '1');
	ellipse_inst   :   Ellipse generic map(width, height, ballColor) 
                               port map(X, Y, '1', cursorX, cursorY, pixelOut);
end Behavioral;