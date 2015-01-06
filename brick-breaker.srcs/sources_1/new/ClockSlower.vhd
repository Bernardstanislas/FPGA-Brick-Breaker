library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockSlower is
    Port ( Hin : in STD_LOGIC;
           Hout : out STD_LOGIC);
end ClockSlower;

architecture Behavioral of ClockSlower is
    signal Hout_internal : STD_LOGIC;
begin
    Hout <= Hout_internal;
    process(Hin, Hout_internal)
        variable ratio : integer := 10000000;
        variable count : integer := 0;
    begin
        if(rising_edge(Hin)) then
            if(count <= ratio/2) then
                Hout_internal <= '1';
                count := count + 1;
            elsif(count < ratio) then
                Hout_internal <= '0';
                count := count + 1;
            else
                count := 0;
            end if;
        end if;
    end process;
end Behavioral;
