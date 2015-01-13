library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Rectangle is
port (
    width    : in  integer;
    height   : in  integer;
    color    : in  std_logic_vector;

    x        : in  integer;
    y        : in  integer;  
    
    alive    : in  std_logic;
    
    cursorX  : in  integer;
    cursorY  : in  integer;
    pixelOut : out std_logic_vector 
);
end Rectangle;

architecture Behavioral of Rectangle is
begin
    pixelOut <= shapeColor when (cursorX >= x and cursorX <= x + width and cursorY >= y and cursorY <= y + height) and alive = '1'
                else x"000000"; 
end Behavioral;