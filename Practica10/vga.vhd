library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
   generic (
      constant h_pulse : integer := 96;
      constant h_bp : integer := 48;
      constant h_pixeles : integer := 640;
      constant h_fp : integer := 16;
      constant v_pulse : integer := 2;
      constant v_bp : integer := 33;
      constant v_pixeles : integer := 480;
      constant v_fp : integer := 10);

   port (
      clk50Mhz : in std_logic;
      red    : out std_logic;
      green  : out std_logic;
      blue   : out std_logic;
      hsync : out std_logic;
      vsync : out std_logic);
end vga;

architecture behavioral of vga is

   constant h_period : integer := h_pulse + h_bp + h_pixeles + h_fp;
   constant v_period : integer := v_pulse + v_bp + v_pixeles + v_fp;
   signal h_count : integer range 0 to h_period-1 := 0;
   signal v_count : integer range 0 to v_period-1 := 0;
   signal column : integer range 0 to h_period -1 := 0;
   signal row : integer range 0 to v_period -1 := 0;
   signal display_ena : std_logic := '0';
   signal reloj_pixel : std_logic := '0';

begin
   relojpixel : process(clk50Mhz)
   begin
      if rising_edge(clk50Mhz) then
         reloj_pixel <= not reloj_pixel;
      end if;
   end process;

   contadores : process(reloj_pixel)
   begin
      if rising_edge(reloj_pixel) then
         if h_count < (h_period-1) then
            h_count <= h_count+1;
         else
            h_count <= 0;
            if v_count < (v_period-1) then
               v_count <= v_count+1;
            else
               v_count <= 0;
            end if;
         end if;
      end if;
   end process;

   senial_hsync : process(reloj_pixel)
   begin
      if rising_edge(reloj_pixel) then
         if (h_count > (h_pixeles + h_fp) and
               h_count < (h_pixeles + h_fp + h_pulse)) then
            hsync <= '0';
         else
            hsync <= '1';
         end if;
      end if;
   end process;

   senial_vsync : process(reloj_pixel)
   begin
      if rising_edge(reloj_pixel) then
         if (v_count > (v_pixeles + v_fp) and
               v_count < (v_pixeles + v_fp + v_pulse)) then
            vsync <= '0';
         else
            vsync <= '1';
         end if;
      end if;
   end process;

   coords_pixel : process(reloj_pixel)
   begin
      if rising_edge(reloj_pixel) then
         if (h_count < h_pixeles) then
            column <= h_count;
         end if;
         if (v_count < v_pixeles) then
            row <= v_count;
         end if;
      end if;
   end process;

   generador_imagen : process(display_ena, row, column)
   begin
      if display_ena = '1' then
         if ((row > 300 and row < 350) and 
               (column > 350 and column < 400)) then
            red <= '1';
            green <= '0';
            blue <= '0';
         elsif ((row > 300 and row < 350) and 
               (column > 450 and column < 500)) then
            red <= '0';
            green <= '1';
            blue <= '0';
         elsif ((row > 300 and row < 350) and 
               (column > 550 and column < 600)) then
            red <= '0';
            green <= '0';
            blue <= '1';
         else
            red <= '0';
            green <= '0';
            blue <= '0';
         end if;
      else
         red <= '0';
         green <= '0';
         blue <= '0';
      end if;
   end process;

   display_enable : process(reloj_pixel)
   begin
      if rising_edge(reloj_pixel) then
         if ((h_count < h_pixeles and 
               v_count < v_pixeles)) then
            display_ena <= '1';
         else
            display_ena <= '0';
         end if;
      end if;
   end process;

end architecture;