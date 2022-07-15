library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sincroniaVGA is
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
      reloj_pixel : in std_logic;
      renglon  : out integer range 0 to 799;
      columna  : out integer range 0 to 524; 
      h_sync: out std_logic;
      v_sync: out std_logic;
      display_ena : out std_logic := '0');
end entity sincroniaVGA;

architecture behavioral of sincroniaVGA is
   constant h_period : integer := h_pulse + h_bp + h_pixeles + h_fp;
   constant v_period : integer := v_pulse + v_bp + v_pixeles + v_fp;

   signal row	    : integer range 0 to v_period-1 := 0;
   signal column	 : integer range 0 to h_period-1 := 0;
   signal h_count  : integer range 0 to h_period-1 := 0;  
   signal v_count  : integer range 0 to v_period-1 := 0; 
   
begin
   contadores : process (reloj_pixel)
   begin
      if rising_edge(reloj_pixel) then
         if (h_count < (h_period-1)) then
            h_count <= h_count+1;
         else
            h_count <= 0;
            if (v_count < (v_period-1)) then
               v_count <= v_count+1;
            else
            v_count<=0;
            end if;
         end if;
      end if;
   end process;

   senial_hsync : process (reloj_pixel)
   begin
      if rising_edge(reloj_pixel) then
         if (h_count > (h_pixeles + h_fp) and
            h_count < (h_pixeles + h_fp + h_pulse)) then
               h_sync <= '0';
         else
            h_sync <= '1';
         end if;
      end if;
   end process;

   senial_vsync : process (reloj_pixel)
   begin
      if rising_edge(reloj_pixel) then
         if (v_count > (v_pixeles + v_fp) and 
            v_count < (v_pixeles + v_fp + v_pulse)) then
               v_sync <= '0';
         else
            v_sync <= '1';
         end if;
      end if;
   end process;

   coords_pixel: process(reloj_pixel)
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

   display_enable: process(reloj_pixel)
   begin
      if rising_edge(reloj_pixel) then
         if (h_count < h_pixeles and v_count < v_pixeles) then
            display_ena <= '1';
         else
            display_ena <= '0';
         end if;
      end if;
   end process;
   
   renglon <= row;
   columna <= column;
end behavioral;