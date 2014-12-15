library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Types is
	subtype color is std_logic_vector (23 downto 0);
	type matrix is array (integer range <>, integer range <>) of color;
end Types;