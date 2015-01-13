library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

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
        x           : in  integer;
        y           : in  integer;
        
        alive       : in  std_logic;
        
        width       : out integer;
        height      : out integer;
    
        cursorX     : in  integer;
        cursorY     : in  integer;
        pixelOut    : out std_logic_vector
    );
    end component;
    
    component Ball
    port (
        framerate : in    std_logic;
        
        x         : in integer;
        y         : in integer;
          
        width     : out   integer;
        height    : out   integer;
    
        cursorX   : in    integer;
        cursorY   : in    integer;
        pixelOut  : out   std_logic_vector
    );
    end component;

    -----------------------------
    -- HDMI management signals --
    -----------------------------
    signal   color       : std_logic_vector (23 downto 0);
    
    signal   hcounter    : unsigned(11 downto 0) := (others => '0');
    signal   vcounter    : unsigned(11 downto 0) := (others => '0');
    signal   cursorX     : integer := conv_integer(hcounter);
    signal   cursorY     : integer := conv_integer(vcounter);
    
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
    
    signal framerate      : std_logic;
    signal init           : std_logic := '0';

    --------------------
    -- Bricks signals --
    --------------------
    type integerArray is array (0 to 9) of integer;
    type colorArray   is array (0 to 9) of std_logic_vector (23 downto 0);
    
    signal bricks_x        : integerArray := (others => 100);
    signal bricks_y        : integerArray := (others => 100);
    signal bricks_width    : integerArray;
    signal bricks_height   : integerArray;
    signal bricks_alive    : std_logic_vector (0 to 9) := "1111111111";
    signal bricks_pixelOut : colorArray;
    
    --------------------
    -- Ball signals --
    --------------------
    signal ball_x       : integer range 0 to 1900 := 960;
    signal ball_y       : integer range 0 to 1060 := 500;
    signal ball_deltaX  : integer range -10 to 10 := 5;
    signal ball_deltaY  : integer range -10 to 10 := 2;
    signal ball_width   : integer;
    signal ball_height  : integer;
    signal ball_pixelOut: std_logic_vector (23 downto 0);    
begin    
    framerate_generator : ClockSlower port map (clk, framerate);
    --------------------------
    -- Init bricks' signals --
    --------------------------
    process
    begin
        for i in 0 to 9 loop
            bricks_x(i) <= 100 + 60 * i;
        end loop;
    end process;
    
    ---------------------
    -- Generate bricks --
    ---------------------
    generated_bricks : for i in 0 to 9 generate
        brickX : Brick port map (bricks_x(i), bricks_y(i), bricks_alive(i), bricks_width(i), bricks_height(i), cursorX, cursorY, bricks_pixelOut(i));
    end generate generated_bricks;
    
    -------------------
    -- Generate ball --
    -------------------
    ballX : Ball port map (framerate, ball_x, ball_y, ball_width, ball_height, cursorX, cursorY, ball_pixelOut); 
    
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
        for i in 0 to 9 loop
            if (bricks_pixelOut(i) /= x"000000") then
                color <= bricks_pixelOut(i);
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
variable xSpeed : integer := 5;
variable ySpeed : integer := 2;
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
         if framerate = '1' then
             ball_x <= ball_x + ball_deltaX;
             ball_y <= ball_y + ball_deltaY;
         end if;
         
         if (ball_x <= 50) then
            ball_deltaX <= xSpeed;
            ball_x <= 51;
         elsif (ball_x >= 1850) then
            ball_deltaX <= -xSpeed;
            ball_x <= 1849;
         elsif (ball_y <= 50) then
            ball_deltaY <= ySpeed;
            ball_y <= 51;
         elsif (ball_y >= 1010) then
            ball_deltaY <= -ySpeed;
            ball_y <= 1009;
         end if;
     end if;
end process;
 end Behavioral;