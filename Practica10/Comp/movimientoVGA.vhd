library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity movimientoVGA is
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
      clk50MHz: in std_logic;
      red:    out std_logic;
      green:  out std_logic;
      blue:   out std_logic;
      h_sync: out std_logic;
      v_sync: out std_logic);
end entity movimientoVGA;

architecture behavioral of movimientoVGA is
   constant h_period : integer := h_pulse + h_bp + h_pixeles + h_fp;
   constant v_period : integer := v_pulse + v_bp + v_pixeles + v_fp;  
   signal column : integer range 0 to h_period -1 := 0;
   signal row : integer range 0 to v_period -1 := 0;
   signal reloj_pixel: std_logic := '0';
   signal display_ena: std_logic := '0';
   signal fondo : std_logic := '0';
   
   signal contador : integer range 0 to 5000000 := 0;
   signal posY  : integer := 300;
   signal posX : integer  := 550;
   constant size: integer := 50;
   
   component sincroniaVGA is
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
         h_sync   : out std_logic;
         v_sync   : out std_logic;
         display_ena: out std_logic := '0');
   end component;

begin
   relojpixel: process (clk50MHz) is
   begin
      if rising_edge(clk50MHz) then
         reloj_pixel <= not reloj_pixel;
      end if;
  end process;

   U1: sincroniaVGA port map(reloj_pixel, row, column, h_sync, v_sync, display_ena);

   generador_imagen: PROCESS(display_ena, row, column, posX, posY)
   begin
      if(display_ena = '1') then
         if ((row > posY and row < posY + size) and 
               (column> 350 and column< 350 + size )) then
            red <=  '1';
            green<= '0';
            blue<=  '0';
         elsif ((row > 300 and row < 300 + size) and 
               (column>450 and column<500)) then 
            red <=  '0';
            green<= '1';
            blue<=  '0';
         elsif ((row > 300 and row < 300 + size) and 
               (column>posX and column< posX + size)) then
            red <=  '0';
            green<= '0';
            blue<=  '1';
         else
            if fondo = '0' then 
               red <=  '0';
               green<= '1';
               blue <= '1';
            else 
               red <=  '1';
               green<= '0';
               blue <= '1';
            end if;
         end if;
      else       
      red<=   '0';
      green<= '0';
      blue<=  '0';
      end if;
   end process;

   movimiento: process(reloj_pixel)
   begin
   if(rising_edge(reloj_pixel)) then 
      contador <= contador + 1;
      if(contador >= 5000000) then
         contador <= 0;

         if (posY - 100) < 0 then 
            posY <= 480;
         else 
            posY <= posY - 100;
         end if;
      
         if (posX) > 640 then 
            posX <= 0;
            if fondo = '1' then 
               fondo <= '0';
               else
               fondo <= '1';
            end if;
         else 
            posX <= posX + 100;
         end if;
      end if;
   end if;
   end process;
end behavioral;