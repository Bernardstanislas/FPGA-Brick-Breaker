library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity display_controller is
    Port ( clk   : in   STD_LOGIC;
           r     : out  STD_LOGIC_VECTOR (7 downto 0);
           g     : out  STD_LOGIC_VECTOR (7 downto 0);
           b     : out  STD_LOGIC_VECTOR (7 downto 0);
           de    : out  STD_LOGIC;
           vsync : out  STD_LOGIC := '0';
           hsync : out  STD_LOGIC := '0'
           );
end display_controller;

architecture Behavioral of display_controller is
    component ClockSlower
    port (
        Hin         : in    std_logic;
        Hout        : out   std_logic
    );
    end component;

    component Brick
    port (
        clock       : in    std_logic;
        triggerSet	: in    std_logic;

        setX        : in    integer;
        setY        : in    integer;
        getX        : out   integer;
        getY        : out   integer;

        setAlive    : in    std_logic;
        getAlive    : out   std_logic;

        getWidth    : out   integer;
        getHeight   : out   integer;
      
        cursorX     : in    integer;
        cursorY     : in    integer;
        pixelOut    : out   std_logic_vector
    );
    end component;
    
    component Ball
    port (
        clock           : in  std_logic;
        framerate       : in  std_logic;
        triggerSetPos   : in  std_logic;
        triggerSetDelta : in  std_logic;
    
        setX            : in  integer;
        setY            : in  integer;
        getX            : out integer;
        getY            : out integer;
  
        setDeltaX       : in  integer;
        setDeltaY       : in  integer;
        getDeltaX       : out integer;
        getDeltaY       : out integer;
      
        getWidth        : out integer;
        getHeight       : out integer;

        cursorX         : in integer;
        cursorY         : in integer;
        pixelOut        : out std_logic_vector
    );
    end component;


    -----------------------------
    -- HDMI management signals --
    -----------------------------
    signal   color       : std_logic_vector (23 downto 0);
    
    signal   hcounter    : unsigned(11 downto 0) := (others => '0');
    signal   vcounter    : unsigned(11 downto 0) := (others => '0');
    signal   cursorX     : integer := to_integer(hcounter);
    signal   cursorY     : integer := to_integer(vcounter);
    
    constant ZERO        : unsigned(11 downto 0) := (others => '0');
    signal   hVisible    : unsigned(11 downto 0);
    signal   hStartSync  : unsigned(11 downto 0);
    signal   hEndSync    : unsigned(11 downto 0);
    signal   hMax        : unsigned(11 downto 0);
    signal   hSyncActive : std_logic := '1';
    
    signal   vVisible    : unsigned(11 downto 0);
    signal   vStartSync  : unsigned(11 downto 0);
    signal   vEndSync    : unsigned(11 downto 0);
    signal   vMax        : unsigned(11 downto 0);
    signal   vSyncActive : std_logic := '1';
    
    
    ------------------------------------
    -- Handy predefined color signals --
    ------------------------------------
    constant C_BLACK      : std_logic_vector(23 downto 0) := x"000000";
    constant C_RED        : std_logic_vector(23 downto 0) := x"FF0000";
    constant C_GREEN      : std_logic_vector(23 downto 0) := x"00FF00";
    constant C_BLUE       : std_logic_vector(23 downto 0) := x"0000FF";
    constant C_WHITE      : std_logic_vector(23 downto 0) := x"FFFFFF";
    
    signal setAlive       : std_logic := '1';
    signal framerate      : std_logic;
    signal init           : std_logic := '0';

    --------------------
    -- Bricks signals --
    --------------------
    type bricks_coordinates is array (0 to 9) of integer;
    type bricks_colors is array (0 to 9) of std_logic_vector (23 downto 0);

    signal bricks_triggerSet : std_logic := '1';
    signal bricks_x          : bricks_coordinates := (others => 100);
    signal bricks_y          : bricks_coordinates := (others => 100);
    signal bricks_alive      : array (0 to 9) of std_logic;
    signal bricks_pixelOut   : bricks_colors := (others => x"000000");
    
    --------------------
    -- Ball signals --
    --------------------
    signal ball_triggerSetPos   : std_logic := '0';
    signal ball_triggerSetDelta : std_logic := '0';
    signal ball_setX             : integer := 960;
    signal ball_setY             : integer := 500;
    signal ball_setDeltaX        : integer := 5;
    signal ball_setDeltaY        : integer := 0;
    signal ball_deltaX           : integer;
    signal ball_deltaY           : integer;
    signal ball_x                : integer;
    signal ball_y                : integer;
    signal ball_width            : integer;
    signal ball_height           : integer;
    signal ball_pixelOut         : std_logic_vector (23 downto 0) := x"000000";    
    
begin    
    framerate_generator : ClockSlower port map (clk, framerate);
    --------------------------
    -- Init bricks' signals --
    --------------------------
    process
    begin
        for I in 0 to 9 loop
            bricks_x(I) <= 100 + 60*I;
        end loop;
    end process;
    
    ---------------------
    -- Generate bricks --
    ---------------------
    generated_bricks : for I in 0 to 9 generate
        brickx : Brick port map (clk, bricks_triggerSet, bricks_x(I), bricks_y(I), setAlive, bricks_alive(I), cursorX, cursorY, bricks_pixelOut(I));
    end generate generated_bricks;
    
    -------------------
    -- Generate ball --
    -------------------
    ballObject : Ball port map (clk, framerate, ball_triggerSetPos, ball_triggerSetDelta, ball_setX, ball_setY, ball_x, ball_y, ball_setDeltaX, ball_setDeltaY, ball_deltaX, ball_deltaY, ball_width, ball_height, cursorX, cursorY, ball_pixelOut);

    -- Set the video mode to 1920x1080x60Hz (150MHz pixel clock needed)
    hVisible    <= ZERO + 1920;
    hStartSync  <= ZERO + 1920+88;
    hEndSync    <= ZERO + 1920+88+44;
    hMax        <= ZERO + 1920+88+44+148-1;
    vSyncActive <= '1';
    
    vVisible    <= ZERO + 1080;
    vStartSync  <= ZERO + 1080+4;
    vEndSync    <= ZERO + 1080+4+5;
    vMax        <= ZERO + 1080+4+5+36-1;
    hSyncActive <= '1';

-------------------------------------------
-- COLOR PROCEDURE                       --
-- This is where we write pixels colors  --
-- by checking the curent pixel position --
-- and asking every component if they do --
-- have something to display there.      --
-------------------------------------------
color_proc: process(hcounter,vcounter)
    begin
        for I in 0 to 9 loop
            if (bricks_pixelOut(I) /= x"000000") then
                color <= bricks_pixelOut(I);
            end if;
        end loop;
        if (ball_pixelOut /= x"000000") then
            color <= ball_pixelOut;
        end if;
end process;


--------------------------------------
-- CLOCK PROCEDURE                  --
-- On every clock rising edge, it   --
-- increments the pixel cursor and  --
-- outputs the pixel color.         --
--------------------------------------
clk_process: process (clk)
   begin
      if rising_edge(clk) then 
         if vcounter >= vVisible or hcounter >= hVisible then 
            r <= (others => '0');
            g <= (others => '0');
            b <= (others => '0');
            de <= '0';
         else
            R  <= color(23 downto 16);
            G  <= color(15 downto  8);
            B  <= color( 7 downto  0);
            de <= '1';
         end if;
              
         -- Generate the sync Pulses
         if vcounter = vStartSync then 
            vSync <= vSyncActive;
         elsif vCounter = vEndSync then
            vSync <= not(vSyncActive);
         end if;

         if hcounter = hStartSync then 
            hSync <= hSyncActive;
         elsif hCounter = hEndSync then
            hSync <= not(hSyncActive);
         end if;

            -- Advance the position counters
         if hCounter = hMax  then
            -- starting a new line
            hCounter <= (others => '0');
            if vCounter = vMax then
               vCounter <= (others => '0');
            else
               vCounter <= vCounter + 1;
            end if;
         else
            hCounter <= hCounter + 1;
         end if;

         if init = '0' then
            init = '1';
        else
            bricks_triggerSet <= '0';
            ball_triggerSetPos <= '0';
            if (ball_x <= 0) then
                 ball_deltaX <= 5;
                 ball_triggerSetDelta <= '1';
             elsif (ball_x + ball_width >= 1920) then
                 ball_deltaX <= -5;
                 ball_triggerSetDelta <= '1';
             else
                 ball_triggerSetDelta <= '0';
             end if;
         end if;
         
     end if;
end process;

end Behavioral;
