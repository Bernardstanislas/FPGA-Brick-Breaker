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
    type integerArray is array (0 to 206) of integer;
    type colorArray   is array (0 to 206) of std_logic_vector (23 downto 0);
    
    signal bricks_x        : integerArray := (others => 100);
    signal bricks_y        : integerArray := (others => 100);
    signal bricks_width    : integerArray;
    signal bricks_height   : integerArray;
    signal bricks_alive    : std_logic_vector (0 to 206) := (others => '1');
    signal bricks_pixelOut : colorArray;
    
    --------------------
    -- Ball signals --
    --------------------
    signal ball_x       : integer range 0 to 1900 := 960;
    signal ball_y       : integer range 0 to 1060 := 500;
    signal ball_deltaX  : integer range -10 to 10 := 10;
    signal ball_deltaY  : integer range -10 to 10 := 10;
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
        --------------------------------
        -- Auto generated coordinates --
        --------------------------------
        bricks_x(0) <= 60;
        bricks_y(0) <= 140;
        bricks_x(1) <= 60;
        bricks_y(1) <= 172;
        bricks_x(2) <= 60;
        bricks_y(2) <= 204;
        bricks_x(3) <= 60;
        bricks_y(3) <= 236;
        bricks_x(4) <= 60;
        bricks_y(4) <= 268;
        bricks_x(5) <= 60;
        bricks_y(5) <= 300;
        bricks_x(6) <= 60;
        bricks_y(6) <= 332;
        bricks_x(7) <= 60;
        bricks_y(7) <= 364;
        bricks_x(8) <= 60;
        bricks_y(8) <= 396;
        bricks_x(9) <= 60;
        bricks_y(9) <= 428;
        bricks_x(10) <= 60;
        bricks_y(10) <= 460;
        bricks_x(11) <= 60;
        bricks_y(11) <= 492;
        bricks_x(12) <= 60;
        bricks_y(12) <= 524;
        bricks_x(13) <= 60;
        bricks_y(13) <= 556;
        bricks_x(14) <= 60;
        bricks_y(14) <= 588;
        bricks_x(15) <= 60;
        bricks_y(15) <= 620;
        bricks_x(16) <= 60;
        bricks_y(16) <= 652;
        bricks_x(17) <= 60;
        bricks_y(17) <= 684;
        bricks_x(18) <= 60;
        bricks_y(18) <= 716;
        bricks_x(19) <= 60;
        bricks_y(19) <= 748;
        bricks_x(20) <= 60;
        bricks_y(20) <= 780;
        bricks_x(21) <= 60;
        bricks_y(21) <= 812;
        bricks_x(22) <= 60;
        bricks_y(22) <= 844;
        bricks_x(23) <= 60;
        bricks_y(23) <= 876;
        bricks_x(24) <= 60;
        bricks_y(24) <= 908;
        bricks_x(25) <= 117;
        bricks_y(25) <= 140;
        bricks_x(26) <= 117;
        bricks_y(26) <= 172;
        bricks_x(27) <= 117;
        bricks_y(27) <= 492;
        bricks_x(28) <= 117;
        bricks_y(28) <= 524;
        bricks_x(29) <= 174;
        bricks_y(29) <= 140;
        bricks_x(30) <= 174;
        bricks_y(30) <= 172;
        bricks_x(31) <= 174;
        bricks_y(31) <= 492;
        bricks_x(32) <= 174;
        bricks_y(32) <= 524;
        bricks_x(33) <= 231;
        bricks_y(33) <= 140;
        bricks_x(34) <= 231;
        bricks_y(34) <= 172;
        bricks_x(35) <= 231;
        bricks_y(35) <= 492;
        bricks_x(36) <= 231;
        bricks_y(36) <= 524;
        bricks_x(37) <= 288;
        bricks_y(37) <= 140;
        bricks_x(38) <= 288;
        bricks_y(38) <= 172;
        bricks_x(39) <= 345;
        bricks_y(39) <= 140;
        bricks_x(40) <= 345;
        bricks_y(40) <= 172;
        bricks_x(41) <= 402;
        bricks_y(41) <= 140;
        bricks_x(42) <= 402;
        bricks_y(42) <= 172;
        bricks_x(43) <= 526;
        bricks_y(43) <= 140;
        bricks_x(44) <= 526;
        bricks_y(44) <= 172;
        bricks_x(45) <= 526;
        bricks_y(45) <= 204;
        bricks_x(46) <= 526;
        bricks_y(46) <= 236;
        bricks_x(47) <= 526;
        bricks_y(47) <= 268;
        bricks_x(48) <= 526;
        bricks_y(48) <= 300;
        bricks_x(49) <= 526;
        bricks_y(49) <= 332;
        bricks_x(50) <= 526;
        bricks_y(50) <= 364;
        bricks_x(51) <= 526;
        bricks_y(51) <= 396;
        bricks_x(52) <= 526;
        bricks_y(52) <= 428;
        bricks_x(53) <= 526;
        bricks_y(53) <= 460;
        bricks_x(54) <= 526;
        bricks_y(54) <= 492;
        bricks_x(55) <= 526;
        bricks_y(55) <= 524;
        bricks_x(56) <= 526;
        bricks_y(56) <= 556;
        bricks_x(57) <= 526;
        bricks_y(57) <= 588;
        bricks_x(58) <= 526;
        bricks_y(58) <= 620;
        bricks_x(59) <= 526;
        bricks_y(59) <= 652;
        bricks_x(60) <= 526;
        bricks_y(60) <= 684;
        bricks_x(61) <= 526;
        bricks_y(61) <= 716;
        bricks_x(62) <= 526;
        bricks_y(62) <= 748;
        bricks_x(63) <= 526;
        bricks_y(63) <= 780;
        bricks_x(64) <= 526;
        bricks_y(64) <= 812;
        bricks_x(65) <= 526;
        bricks_y(65) <= 844;
        bricks_x(66) <= 526;
        bricks_y(66) <= 876;
        bricks_x(67) <= 526;
        bricks_y(67) <= 908;
        bricks_x(68) <= 583;
        bricks_y(68) <= 140;
        bricks_x(69) <= 583;
        bricks_y(69) <= 172;
        bricks_x(70) <= 583;
        bricks_y(70) <= 524;
        bricks_x(71) <= 583;
        bricks_y(71) <= 556;
        bricks_x(72) <= 640;
        bricks_y(72) <= 140;
        bricks_x(73) <= 640;
        bricks_y(73) <= 172;
        bricks_x(74) <= 640;
        bricks_y(74) <= 524;
        bricks_x(75) <= 640;
        bricks_y(75) <= 556;
        bricks_x(76) <= 697;
        bricks_y(76) <= 140;
        bricks_x(77) <= 697;
        bricks_y(77) <= 172;
        bricks_x(78) <= 697;
        bricks_y(78) <= 524;
        bricks_x(79) <= 697;
        bricks_y(79) <= 556;
        bricks_x(80) <= 754;
        bricks_y(80) <= 140;
        bricks_x(81) <= 754;
        bricks_y(81) <= 172;
        bricks_x(82) <= 754;
        bricks_y(82) <= 524;
        bricks_x(83) <= 754;
        bricks_y(83) <= 556;
        bricks_x(84) <= 811;
        bricks_y(84) <= 204;
        bricks_x(85) <= 811;
        bricks_y(85) <= 236;
        bricks_x(86) <= 811;
        bricks_y(86) <= 460;
        bricks_x(87) <= 811;
        bricks_y(87) <= 492;
        bricks_x(88) <= 868;
        bricks_y(88) <= 268;
        bricks_x(89) <= 868;
        bricks_y(89) <= 300;
        bricks_x(90) <= 868;
        bricks_y(90) <= 332;
        bricks_x(91) <= 868;
        bricks_y(91) <= 364;
        bricks_x(92) <= 868;
        bricks_y(92) <= 396;
        bricks_x(93) <= 868;
        bricks_y(93) <= 428;
        bricks_x(94) <= 992;
        bricks_y(94) <= 268;
        bricks_x(95) <= 992;
        bricks_y(95) <= 300;
        bricks_x(96) <= 992;
        bricks_y(96) <= 332;
        bricks_x(97) <= 992;
        bricks_y(97) <= 364;
        bricks_x(98) <= 992;
        bricks_y(98) <= 396;
        bricks_x(99) <= 992;
        bricks_y(99) <= 428;
        bricks_x(100) <= 992;
        bricks_y(100) <= 460;
        bricks_x(101) <= 992;
        bricks_y(101) <= 492;
        bricks_x(102) <= 992;
        bricks_y(102) <= 524;
        bricks_x(103) <= 992;
        bricks_y(103) <= 556;
        bricks_x(104) <= 992;
        bricks_y(104) <= 588;
        bricks_x(105) <= 992;
        bricks_y(105) <= 620;
        bricks_x(106) <= 992;
        bricks_y(106) <= 652;
        bricks_x(107) <= 992;
        bricks_y(107) <= 684;
        bricks_x(108) <= 992;
        bricks_y(108) <= 716;
        bricks_x(109) <= 992;
        bricks_y(109) <= 748;
        bricks_x(110) <= 992;
        bricks_y(110) <= 780;
        bricks_x(111) <= 1049;
        bricks_y(111) <= 204;
        bricks_x(112) <= 1049;
        bricks_y(112) <= 236;
        bricks_x(113) <= 1049;
        bricks_y(113) <= 812;
        bricks_x(114) <= 1049;
        bricks_y(114) <= 844;
        bricks_x(115) <= 1106;
        bricks_y(115) <= 140;
        bricks_x(116) <= 1106;
        bricks_y(116) <= 172;
        bricks_x(117) <= 1106;
        bricks_y(117) <= 876;
        bricks_x(118) <= 1106;
        bricks_y(118) <= 908;
        bricks_x(119) <= 1163;
        bricks_y(119) <= 140;
        bricks_x(120) <= 1163;
        bricks_y(120) <= 172;
        bricks_x(121) <= 1163;
        bricks_y(121) <= 716;
        bricks_x(122) <= 1163;
        bricks_y(122) <= 748;
        bricks_x(123) <= 1163;
        bricks_y(123) <= 876;
        bricks_x(124) <= 1163;
        bricks_y(124) <= 908;
        bricks_x(125) <= 1220;
        bricks_y(125) <= 140;
        bricks_x(126) <= 1220;
        bricks_y(126) <= 172;
        bricks_x(127) <= 1220;
        bricks_y(127) <= 716;
        bricks_x(128) <= 1220;
        bricks_y(128) <= 748;
        bricks_x(129) <= 1220;
        bricks_y(129) <= 780;
        bricks_x(130) <= 1220;
        bricks_y(130) <= 812;
        bricks_x(131) <= 1220;
        bricks_y(131) <= 844;
        bricks_x(132) <= 1277;
        bricks_y(132) <= 140;
        bricks_x(133) <= 1277;
        bricks_y(133) <= 172;
        bricks_x(134) <= 1277;
        bricks_y(134) <= 716;
        bricks_x(135) <= 1277;
        bricks_y(135) <= 748;
        bricks_x(136) <= 1334;
        bricks_y(136) <= 140;
        bricks_x(137) <= 1334;
        bricks_y(137) <= 172;
        bricks_x(138) <= 1334;
        bricks_y(138) <= 716;
        bricks_x(139) <= 1334;
        bricks_y(139) <= 748;
        bricks_x(140) <= 1334;
        bricks_y(140) <= 780;
        bricks_x(141) <= 1334;
        bricks_y(141) <= 812;
        bricks_x(142) <= 1334;
        bricks_y(142) <= 844;
        bricks_x(143) <= 1334;
        bricks_y(143) <= 876;
        bricks_x(144) <= 1334;
        bricks_y(144) <= 908;
        bricks_x(145) <= 1458;
        bricks_y(145) <= 268;
        bricks_x(146) <= 1458;
        bricks_y(146) <= 300;
        bricks_x(147) <= 1458;
        bricks_y(147) <= 332;
        bricks_x(148) <= 1458;
        bricks_y(148) <= 364;
        bricks_x(149) <= 1458;
        bricks_y(149) <= 396;
        bricks_x(150) <= 1458;
        bricks_y(150) <= 428;
        bricks_x(151) <= 1458;
        bricks_y(151) <= 460;
        bricks_x(152) <= 1458;
        bricks_y(152) <= 492;
        bricks_x(153) <= 1458;
        bricks_y(153) <= 524;
        bricks_x(154) <= 1458;
        bricks_y(154) <= 556;
        bricks_x(155) <= 1458;
        bricks_y(155) <= 588;
        bricks_x(156) <= 1458;
        bricks_y(156) <= 620;
        bricks_x(157) <= 1458;
        bricks_y(157) <= 652;
        bricks_x(158) <= 1458;
        bricks_y(158) <= 684;
        bricks_x(159) <= 1458;
        bricks_y(159) <= 716;
        bricks_x(160) <= 1458;
        bricks_y(160) <= 748;
        bricks_x(161) <= 1458;
        bricks_y(161) <= 780;
        bricks_x(162) <= 1458;
        bricks_y(162) <= 812;
        bricks_x(163) <= 1458;
        bricks_y(163) <= 844;
        bricks_x(164) <= 1458;
        bricks_y(164) <= 876;
        bricks_x(165) <= 1458;
        bricks_y(165) <= 908;
        bricks_x(166) <= 1515;
        bricks_y(166) <= 204;
        bricks_x(167) <= 1515;
        bricks_y(167) <= 236;
        bricks_x(168) <= 1515;
        bricks_y(168) <= 524;
        bricks_x(169) <= 1515;
        bricks_y(169) <= 556;
        bricks_x(170) <= 1572;
        bricks_y(170) <= 140;
        bricks_x(171) <= 1572;
        bricks_y(171) <= 172;
        bricks_x(172) <= 1572;
        bricks_y(172) <= 524;
        bricks_x(173) <= 1572;
        bricks_y(173) <= 556;
        bricks_x(174) <= 1629;
        bricks_y(174) <= 140;
        bricks_x(175) <= 1629;
        bricks_y(175) <= 172;
        bricks_x(176) <= 1629;
        bricks_y(176) <= 524;
        bricks_x(177) <= 1629;
        bricks_y(177) <= 556;
        bricks_x(178) <= 1686;
        bricks_y(178) <= 140;
        bricks_x(179) <= 1686;
        bricks_y(179) <= 172;
        bricks_x(180) <= 1686;
        bricks_y(180) <= 524;
        bricks_x(181) <= 1686;
        bricks_y(181) <= 556;
        bricks_x(182) <= 1743;
        bricks_y(182) <= 204;
        bricks_x(183) <= 1743;
        bricks_y(183) <= 236;
        bricks_x(184) <= 1743;
        bricks_y(184) <= 524;
        bricks_x(185) <= 1743;
        bricks_y(185) <= 556;
        bricks_x(186) <= 1800;
        bricks_y(186) <= 268;
        bricks_x(187) <= 1800;
        bricks_y(187) <= 300;
        bricks_x(188) <= 1800;
        bricks_y(188) <= 332;
        bricks_x(189) <= 1800;
        bricks_y(189) <= 364;
        bricks_x(190) <= 1800;
        bricks_y(190) <= 396;
        bricks_x(191) <= 1800;
        bricks_y(191) <= 428;
        bricks_x(192) <= 1800;
        bricks_y(192) <= 460;
        bricks_x(193) <= 1800;
        bricks_y(193) <= 492;
        bricks_x(194) <= 1800;
        bricks_y(194) <= 524;
        bricks_x(195) <= 1800;
        bricks_y(195) <= 556;
        bricks_x(196) <= 1800;
        bricks_y(196) <= 588;
        bricks_x(197) <= 1800;
        bricks_y(197) <= 620;
        bricks_x(198) <= 1800;
        bricks_y(198) <= 652;
        bricks_x(199) <= 1800;
        bricks_y(199) <= 684;
        bricks_x(200) <= 1800;
        bricks_y(200) <= 716;
        bricks_x(201) <= 1800;
        bricks_y(201) <= 748;
        bricks_x(202) <= 1800;
        bricks_y(202) <= 780;
        bricks_x(203) <= 1800;
        bricks_y(203) <= 812;
        bricks_x(204) <= 1800;
        bricks_y(204) <= 844;
        bricks_x(205) <= 1800;
        bricks_y(205) <= 876;
        bricks_x(206) <= 1800;
        bricks_y(206) <= 908;

    end process;
    
    ---------------------
    -- Generate bricks --
    ---------------------
    generated_bricks : for i in 0 to 206 generate
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
        for i in 0 to 206 loop
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
variable xSpeed : integer := 10;
variable ySpeed : integer := 10;
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
     
     -- Collisions with screen limits
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
     
     -- Collisions with bricks
     for i in 0 to 206 loop
        if ball_x + ball_width >= bricks_x(i) and ball_x <= bricks_x(i) + bricks_width(i) and bricks_alive(i) = '1' then -- collide vertically
            if ball_y + ball_height >= bricks_y(i) and ball_y + ball_height <= bricks_y(i) + ySpeed then -- collide from top
                ball_deltaY <= -ySpeed;
                ball_y <= bricks_y(i) - ball_height - 1;
                bricks_alive(i) <= '0';
            elsif ball_y >= bricks_y(i) + bricks_height(i) - ySpeed and ball_y <= bricks_y(i) + bricks_height(i) then -- collide from bottom
                ball_deltaY <= ySpeed;
                ball_y <= bricks_y(i) + bricks_height(i) + 1;
                bricks_alive(i) <= '0';
            end if;
        elsif ball_y + ball_height >= bricks_y(i) and ball_y <= bricks_y(i) + bricks_height(i) and bricks_alive(i) = '1' then -- collide horizontally
            if ball_x + ball_width >= bricks_x(i) and ball_x + ball_width <= bricks_x(i) + xSpeed then -- collide from left
                ball_deltaX <= -xSpeed;
                ball_x <= bricks_x(i) - ball_width - 1;
                bricks_alive(i) <= '0';
            elsif ball_x >= bricks_x(i) + bricks_width(i) - xSpeed and ball_x <= bricks_x(i) + bricks_width(i) then -- collide from right
                ball_deltaX <= xSpeed;
                ball_x <= bricks_x(i) + bricks_width(i) + 1;
                bricks_alive(i) <= '0';
            end if;
        end if;
     end loop;
  end if;
end process;
end Behavioral;