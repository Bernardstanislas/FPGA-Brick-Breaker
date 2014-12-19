library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Paddle is
Generic (
    width   :   integer := 200;
    height  :   integer := 25;
    color   :   std_logic_vector := x"00FF00"
);
Port ( 
    framerate   : in STD_LOGIC;
    triggerSet  : in STD_LOGIC;
    
    moveleft    : in STD_LOGIC;
    moveRight   : in STD_LOGIC;
    
    getX        : out STD_LOGIC;
    getY        : out STD_LOGIC;
    
    getWidth    : out STD_LOGIC;
    getHeight   : out STD_LOGIC
);
end Paddle;

architecture Behavioral of Paddle is
    component PushButton is
    Port (
        CLK   : in STD_LOGIC;
        INPUT : in STD_LOGIC;
        OUTPUT: out STD_LOGIC
    );
    end component;

    component BBox is
	port (
		triggerSet	:	in 	std_logic;

		setX 		: 	in 	integer;
		setY 		: 	in 	integer;
		getX		: 	out integer;
		getY		: 	out	integer;
		
		setWidth	: 	in 	integer;
        setHeight   :   in  integer;
		getWidth	:	out	integer;
		getHeight	:	out integer;
		
	    setAlive   :   in std_logic;
        getAlive   :   out std_logic
	);
	end component;

	component Rectangle is
	generic (
        width      :   integer;
        height     :   integer;
        shapeColor :   std_logic_vector
    );
    port (
        X          :   in  integer;
        Y          :   in  integer;  
        
        alive      :   in  std_logic;
        
        cursorX    :   in  integer;
        cursorY    :   in  integer;
        pixelOut   :   out std_logic_vector 
    );
	end component;
	
	signal setX    : integer;
	signal setY    : integer;
	signal x       : integer;
    signal y       : integer;
   
begin
    -- TO DO : add buttons dans do logic move

    bbox_inst 		:	BBox port map(triggerSet, setX, setY, x, y, width, height, getWidth, getHeight, '1');
	rectangle_inst	:	Rectangle  generic map(width, height, brickColor) 
	                               port map(x, y, '1', cursorX, cursorY, pixelOut);

end Behavioral;
