library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity contador is
   generic(
      constant h_pulse  : integer := 96;
      constant h_bp     : integer := 48;
      constant h_pixels : integer := 640;
      constant h_fp     : integer := 16;
      constant v_pulse  : integer := 2;
      constant v_bp     : integer := 33;
      constant v_pixels : integer := 480;
      constant v_fp     : integer := 10);
      
   port(
      clk50MHz : in std_logic;
      red      : out std_logic_vector (3 downto 0);
      green    : out std_logic_vector (3 downto 0);
      blue     : out std_logic_vector (3 downto 0);
      h_sync   : out std_logic;
      v_sync   : out std_logic);
end entity contador;

architecture behavioral of contador is
   -- Contador
   signal segundo : std_logic;
   signal rapido  : std_logic;
   signal n       : std_logic; 
   signal e       : std_logic;
   signal Qum     : std_logic_vector(4 downto 0);

   -- VGA
   constant h_period  : integer := h_pulse + h_bp + h_pixels + h_fp;
   constant v_period  : integer := v_pulse + v_bp + v_pixels + v_fp;  
   signal column      : integer range 0 to h_period -1 := 0;
   signal row         : integer range 0 to v_period -1 := 0;
   signal reloj_pixel : std_logic := '0';
   signal display_ena : std_logic := '0';

   constant cero       : std_logic_vector(4 downto 0) := "00000";
   constant uno        : std_logic_vector(4 downto 0) := "00001";
   constant dos        : std_logic_vector(4 downto 0) := "00010";
   constant tres       : std_logic_vector(4 downto 0) := "00011";
   constant cuatro     : std_logic_vector(4 downto 0) := "00100";
   constant cinco      : std_logic_vector(4 downto 0) := "00101";
   constant seis       : std_logic_vector(4 downto 0) := "00110";
   constant siete      : std_logic_vector(4 downto 0) := "00111";
   constant ocho       : std_logic_vector(4 downto 0) := "01000";
   constant nueve      : std_logic_vector(4 downto 0) := "01001";
   constant diez       : std_logic_vector(4 downto 0) := "01010";
   constant once       : std_logic_vector(4 downto 0) := "01011";
   constant doce       : std_logic_vector(4 downto 0) := "01100";
   constant trece      : std_logic_vector(4 downto 0) := "01101";
   constant catorce    : std_logic_vector(4 downto 0) := "01110";
   constant quince     : std_logic_vector(4 downto 0) := "01111";
   constant dieciseis  : std_logic_vector(4 downto 0) := "10000";
   constant diecisiete : std_logic_vector(4 downto 0) := "10001";
   constant dieciocho  : std_logic_vector(4 downto 0) := "10010";
   constant diecinueve : std_logic_vector(4 downto 0) := "10011";
   constant veinte     : std_logic_vector(4 downto 0) := "10100";

   constant r1 : std_logic_vector(3 downto 0) := (others => '1');
   constant r0 : std_logic_vector(3 downto 0) := (others => '0');
   constant g1 : std_logic_vector(3 downto 0) := (others => '1');
   constant g0 : std_logic_vector(3 downto 0) := (others => '0');
   constant b1 : std_logic_vector(3 downto 0) := (others => '1');
   constant b0 : std_logic_vector(3 downto 0) := (others => '0');

   signal conectornum : std_logic_vector(4 downto 0);

   component sincroniaVGA is
      port ( 
         clk50MHz    : in std_logic;
         renglon     : out integer range 0 to 799;
         columna     : out integer range 0 to 524; 
         h_sync      : out std_logic;
         v_sync      : out std_logic;
         display_ena : out std_logic 
      );
   end component;

begin
   DIVISOR : process(clk50MHz)
      variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
   begin
      if rising_edge (clk50MHz) then
         cuenta := cuenta + 1;
      end if;
      segundo <= cuenta(24);
   end process;
   
   UNIDADES : process (segundo)
      variable cuenta: std_logic_vector(4 downto 0) := "00000";
   begin 
      if rising_edge (segundo) then 
         if cuenta = "10100" then
            cuenta :="00000";
            N <= '1'; 
         else 
            cuenta := cuenta + 1;
            N <= '0';
         end if;
      end if;
      Qum <= cuenta;
   end process;
   
   U1 : sincroniaVGA port map(clk50MHz, row, column, h_sync, v_sync, display_ena);

   DRAW7SEG : process(display_ena, row, column, conectornum)
   begin
      if(display_ena='1') then
         case conectornum is
            when cero =>
               if ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
               
            when uno => 
               if ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if; 
            
            when dos=> 
               if ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if; 
            
            when tres =>
               if ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else -- fondo
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
             
            when cuatro =>
               if ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
             
            when cinco =>
               if ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
             
            when seis =>
               if ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
             
            when siete =>
               if ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;

            when ocho =>
               if ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
             
            when nueve =>
               if ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
            
            when diez =>
               if ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                     green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');	  
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
            
            when once =>
               if ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then 
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if; 
                
            when doce =>
               if ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then  
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else 
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
              
            when trece =>
               if ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
            
            when catorce =>
               if ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
               
            when quince =>
               if ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
            
            when dieciseis =>
               if ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
               
            when diecisiete =>
               if ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
            
            when dieciocho =>
               if ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then 
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
               
            when diecinueve =>
               if ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then  
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then 
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 240 and row < 250) 
                  and (column > 170 and column < 200)) then 
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
            
            when veinte =>
               if ((row > 200 and row < 210) 
                  and (column > 110 and column < 140)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 140 and column < 150)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 110 and column < 140)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 100 and column < 110)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 240 and row < 250) 
                  and (column > 110 and column < 140)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 200 and row < 210) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 250 and row < 280) 
                  and (column > 200 and column < 210)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 280 and row < 290) 
                  and (column > 170 and column < 200)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 250 and row < 280) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '1');
               elsif ((row > 210 and row < 240) 
                  and (column > 160 and column < 170)) then
                  red   <= (others => '1');
                  green <= (others => '1');
                  blue  <= (others => '0');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
            
            when others=>
               if ((row > 300 and row < 350) 
                  and (column > 350 and column < 400)) then
                  red   <= (others => '1');
                  green <= (others => '0');
                  blue  <= (others => '0');
               elsif ((row > 300 and row <350) 
                  and (column > 450 and column < 500)) then
                  red   <= (others => '0');
                  green <= (others => '1');
                  blue  <= (others => '0');
               elsif ((row > 300 and row <350) 
                  and (column > 550 and column < 600)) then
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '1');
               else
                  red   <= (others => '0');
                  green <= (others => '0');
                  blue  <= (others => '0');
               end if;
          end case;
      end if;
   end process DRAW7SEG;

   -- Decodificador para los numeros
   with Qum select conectornum <=
      "00000" when "00000",
      "00001" when "00001",
      "00010" when "00010",
      "00011" when "00011",
      "00100" when "00100",
      "00101" when "00101",
      "00110" when "00110",
      "00111" when "00111",
      "01000" when "01000",
      "01001" when "01001",
      "01010" when "01010",
      "01011" when "01011",
      "01100" when "01100",
      "01101" when "01101",
      "01110" when "01110",
      "01111" when "01111",
      "10000" when "10000",
      "10001" when "10001",
      "10010" when "10010",
      "10011" when "10011",
      "10100" when "10100",
      "00000" when others;
end behavioral;