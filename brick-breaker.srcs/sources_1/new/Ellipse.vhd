library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Ellipse is
port (
    radius     :   in  integer;
    shapeColor :   in  std_logic_vector;

    X          :   in  integer;
    Y          :   in  integer;  
    
    alive      :   in  std_logic;
    
    cursorX    :   in  integer;
    cursorY    :   in  integer;
    pixelOut   :   out std_logic_vector 
);
end Ellipse;

architecture Behavioral of Ellipse is
begin
    --pixelOut <= shapeColor when ( ((cursorX-(X+width / 2))**2) * (height**2) + ((cursorY-(Y+height / 2))**2)*(width**2) <= (width**2)* (height**2) ) and alive = '1'
    --            else x"000000";
    pixelOut <= shapeColor when (cursorX >= X - radius and cursorX <= X + radius and cursorY >= Y - radius and cursorY <= Y + radius) and alive = '1'
                    else x"000000"; 
end Behavioral;