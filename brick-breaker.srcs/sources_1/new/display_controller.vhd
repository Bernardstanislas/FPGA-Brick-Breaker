----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2014 10:59:22
-- Design Name: 
-- Module Name: display_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


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
           hsync : out  STD_LOGIC := '0');
end display_controller;

architecture Behavioral of display_controller is
    component Brick
    port (
        triggerSet	: in    std_logic;
        setX        : in    integer;
        setY        : in    integer;
        cursorX     : in    integer;
        cursorY     : in    integer;
        setAlive    : in    std_logic;
        getAlive    : out   std_logic;
        getX        : out   integer;
        getY        : out   integer;
        getWidth    : out   integer;
        getHeight   : out   integer;
    
        pixelOut    : out   std_logic_vector (23 downto 0)
    );
    end component;
    
    component Ball
    port (
        framerate  :   in  std_logic;
        triggerSet :   in  std_logic;
        
        setX       :   in  integer;
        setY       :   in  integer;
        getX       :   out integer;
        getY       :   out integer;
        
        setDeltaX  :   in  integer;
        setDeltaY  :   in  integer;
        getDeltaX  :   out integer;
        getDeltaY  :   out integer;
          
        getWidth   :   out integer;
        getHeight  :   out integer;
    
        cursorX    :   in integer;
        cursorY    :   in integer;
        pixelOut   :   out std_logic_vector
    );
    end component;


    -----------------------------
    -- HDMI management signals --
    -----------------------------
    signal color         : STD_LOGIC_VECTOR (23 downto 0);
    
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
    
    signal setAlive : std_logic := '1';
    
    --------------------
    -- Bricks signals --
    --------------------
    type bricks_coordinates is array (0 to 9) of integer;
    type bricks_colors is array (0 to 9) of std_logic_vector (23 downto 0);
    signal triggerSet       : std_logic := '0';
    signal componentsSet : integer := 0;
    signal bricks_X         : bricks_coordinates := (others => 100);
    signal bricks_Y         : bricks_coordinates := (others => 100);
    signal bricks_pixelOut  : bricks_colors := (others => x"000000");
    
    --------------------
    -- Ball's signals --
    --------------------
    signal ball_X   : integer := 500;
    signal ball_Y   : integer := 500;
    signal ball_deltaX : integer := 10;
    signal ball_deltaY : integer := 0;
    signal ball_pixelOut    : std_logic_vector (23 downto 0) := x"000000";

    signal framerate : std_logic := '0';
    
    
begin
    --------------------------
    -- Init bricks' signals --
    --------------------------
    process
    begin
        for I in 0 to 9 loop
            bricks_X(I) <= 100 + 60*I;
        end loop;
    end process;
    
    ---------------------
    -- Generate bricks --
    ---------------------
    generated_bricks : for I in 0 to 9 generate
        brickx : Brick port map (triggerSet    => triggerSet,
                                  setX          => bricks_X(I),
                                  setY          => bricks_Y(I),
                                  setAlive      => setAlive,
                                  cursorX       => cursorX,
                                  cursorY       => cursorY,
                                  pixelOut      => bricks_pixelOut(I)
                                  );
    end generate generated_bricks;
    
    -------------------
    -- Generate ball --
    -------------------
    ballObject : Ball port map (framerate     => framerate,
                              triggerSet    => triggerSet,
                              setX          => ball_X,
                              setY          => ball_Y,
                              setDeltaX     => ball_deltaX,
                              setDeltaY     => ball_deltaY,
                              cursorX       => cursorX,
                              cursorY       => cursorY,
                              pixelOut      => ball_pixelOut
                              );

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
    variable framerateCounter : integer := 0;
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
         framerateCounter := framerateCounter + 1;
         if framerateCounter = 100000000 then
            framerateCounter := 0;
            framerate <= '1';
         else
            framerate <= '0';
         end if;
         if componentsSet = 0 then
            triggerSet <= '1';
            componentsSet <= 1;
        else
        triggerSet <= '0';
         end if;
     end if;
end process;

end Behavioral;
