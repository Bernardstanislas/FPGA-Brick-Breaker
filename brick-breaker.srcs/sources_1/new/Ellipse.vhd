library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ellipse is
generic (
	width      :   integer := 20;
	height	   :   integer := 20;
	shapeColor :   std_logic_vector := x"FF0000"
);
port (
    X          :   in  integer;
    Y          :   in  integer;  
    
    alive      :   in std_logic;
    
    cursorX    :   in  integer;
    cursorY    :   in  integer;
    pixelOut   :   out std_logic_vector 
);
end Ellipse;

architecture Behavioral of Ellipse is
begin
    --pixelOut <= shapeColor when ( ((cursorX-(X+width / 2))**2) * (height**2) + ((cursorY-(Y+height / 2))**2)*(width**2) <= (width**2)* (height**2) ) and alive = '1'
    --            else x"000000";
    pixelOut <= shapeColor when (cursorX >= X and cursorX <= X + width and cursorY >= Y and cursorY <= Y + height) and alive = '1'
                    else x"000000"; 
end Behavioral;