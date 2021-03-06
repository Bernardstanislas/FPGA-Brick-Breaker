library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Ellipse is
port (
    radius   : in  integer;
    color    : in  std_logic_vector;

    x        : in  integer;
    y        : in  integer;  
    
    alive    : in  std_logic;
    
    cursorX  : in  integer;
    cursorY  : in  integer;
    pixelOut : out std_logic_vector 
);
end Ellipse;

architecture Behavioral of Ellipse is
begin
    pixelOut <= color when (cursorX >= x and cursorX <= x + radius and cursorY >= y and cursorY <= y + radius) and alive = '1'
                    else x"000000"; 
end Behavioral;