library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PushButton is
Port (
    CLK   : in STD_LOGIC;
    INPUT : in STD_LOGIC;
    OUTPUT: out STD_LOGIC
);
end PushButton;

architecture Behavioral of PushButton is
    signal iOutput : STD_LOGIC := '0';
    signal previous_State : STD_LOGIC := '0';
    signal bounces : integer := 0;
    signal max_bounces : integer := 1000000;
begin
    OUTPUT <= iOutput;
    process(CLK)
        begin
            if CLK'event and CLK = '1' then
                if bounces < max_bounces and bounces > 0 then
                    bounces <= bounces + 1;
                end if;
                if bounces = 0 or bounces = max_bounces then
                    if previous_State /= INPUT then
                        iOutput <= INPUT;
                        bounces <= 1;
                    end if;
                    previous_state <= INPUT;
                end if;
            end if;
    end process;

end Behavioral;