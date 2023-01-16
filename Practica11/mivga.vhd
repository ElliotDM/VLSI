library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mivga is
   generic(
      constant h_pulse : integer := 96;
      constant h_bp : integer := 48;
      constant h_pixels : integer := 640;
      constant h_fp : integer := 16;
      constant v_pulse : integer := 2;
      constant v_bp : integer := 33;
      constant v_pixels : integer := 480;
      constant v_fp : integer := 10);
      
   port ( 
      clk50MHz: in std_logic;	
      red: out std_logic_vector (3 downto 0);    --al monitor
      green: out std_logic_vector (3 downto 0);
      blue: out std_logic_vector (3 downto 0);
      h_sync: out std_logic;
      v_sync: out std_logic;
      dipsw: in std_logic_vector(3 downto 0); --numeros para decodificador
      a,b,c,d,e,f,g: out std_logic);
end entity mivga;

architecture behavioral of mivga is
   -- VGA SEÑALES
   constant h_period : integer := h_pulse + h_bp + h_pixels + h_fp;
   constant v_period : integer := v_pulse + v_bp + v_pixels + v_fp;  
   signal column :     integer range 0 to h_period -1 := 0;
   signal row :        integer range 0 to v_period -1 := 0;
   signal reloj_pixel: std_logic := '0';
   signal display_ena: std_logic := '0';

   constant cero:   std_logic_vector(6 downto 0) := "0111111"; --gfedcba
   constant uno:    std_logic_vector(6 downto 0) := "0000110";
   constant dos:    std_logic_vector(6 downto 0) := "1011011";
   constant tres:   std_logic_vector(6 downto 0) := "1001111";
   constant cuatro: std_logic_vector(6 downto 0) := "1100110";
   constant cinco:  std_logic_vector(6 downto 0) := "1101101";
   constant seis:   std_logic_vector(6 downto 0) := "1111101";
   constant siete:  std_logic_vector(6 downto 0) := "0000111";
   constant ocho:   std_logic_vector(6 downto 0) := "1111111";
   constant nueve:  std_logic_vector(6 downto 0) := "1110011"; 
   constant r1: std_logic_vector(3 downto 0) := (others => '1');
   constant r0: std_logic_vector(3 downto 0) := (others => '0');
   constant g1: std_logic_vector(3 downto 0) := (others => '1');
   constant g0: std_logic_vector(3 downto 0) := (others => '0');
   constant b1: std_logic_vector(3 downto 0) := (others => '1');
   constant b0: std_logic_vector(3 downto 0) := (others => '0');
   -- variable a,b,c,d,e,f: std_logic;
   signal conectornum: std_logic_vector(6 downto 0); -- Conexion del decodificador con image_gen 
   
   component sincroniaVGA is
      port ( 
      clk50MHz : in std_logic;
      renglon  : out integer RANGE 0 TO 799;
      columna  : out integer RANGE 0 TO 524; 
      h_sync   : out std_logic;
      v_sync   : out std_logic;
      display_ena: out std_logic 
      );
   end component;
   
begin

   U1: sincroniaVGA port map(clk50MHz, row, column, h_sync, v_sync, display_ena);

   DRAW7SEG: process(display_ena, row, column, conectornum)
   begin
      if(display_ena='1') then
         case conectornum is
            when cero=>
             if ((row > 200 and row < 210) and (column > 110 and column < 140)) then -- a
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '1');
             elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) then -- b
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) then -- c
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '0');
             elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) then -- d
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '1');
             elsif ((row > 250 and row < 280) and (column > 100 and column < 110)) then -- e
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '1');
             elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) then -- f
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '0');
             else -- fondo
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '0');
             end if;
               
            when uno=> 
             if ((row > 210 and row < 240) and (column > 140 and column < 150)) then --b  verde 
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) then --c  rojo
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '0');
             else                                                     --fondo 
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '0');
             end if; 
            
            when dos=> 
             if ((row > 200 and row < 210) and (column > 110 and column < 140)) then --a  azul  
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '1');
             elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) then --b  verde
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) then --d  blanco
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '1');
             elsif ((row > 250 and row < 280) and (column > 100 and column < 110)) then --e  cian 
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '1');
             elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) then --g  violeta
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '1');
             else                                                     --fondo 
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '0');
             end if; 
            
            when tres=>
             if ((row > 200 and row < 210) and (column > 110 and column < 140)) then -- a
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '1');
             elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) then -- b
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) then -- c
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '0');
             elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) then -- d
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '1');
             elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) then -- g
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '1');
             else -- fondo
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '0');
             end if;
            when cuatro=>
             if ((row > 210 and row < 240) and (column > 140 and column < 150)) then -- b
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) then -- c
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '0');
             elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) then -- f
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) then -- g
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '1');
             else -- fondo
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '0');
             end if;
            when cinco=>
             if ((row > 200 and row < 210) and (column > 110 and column < 140)) then -- a
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '1');
             elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) then -- c
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '0');
             elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) then -- d
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '1');
             elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) then -- f
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) then -- g
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '1');
             else -- fondo
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '0');
             end if;
            when seis=>
             if ((row > 200 and row < 210) and (column > 110 and column < 140)) then    -- a
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '1');
             elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) then -- c
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '0');
             elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) then -- d
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '1');
             elsif ((row > 250 and row < 280) and (column > 100 and column < 110)) then -- e
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '1');
             elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) then -- f
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) then -- g
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '1');
             else -- fondo
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '0');
             end if;
             
            when siete=>
             if ((row > 200 and row < 210) and (column > 110 and column < 140)) then -- a
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '1');
             elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) then -- b
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) then -- c
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '0');
             else -- fondo
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '0');
             end if;

            when ocho=>
             if ((row > 200 and row < 210) and (column > 110 and column < 140)) then -- a
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '1');
             elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) then -- b
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) then -- c
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '0');
             elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) then -- d
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '1');
             elsif ((row > 250 and row < 280) and (column > 100 and column < 110)) then -- e
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '1');
             elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) then -- f
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) then -- g
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '1');
             else -- fondo
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '0');
             end if;
             
            when nueve=>
             if ((row > 200 and row < 210) and (column > 110 and column < 140)) then --a  azul  
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '1');
             elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) then --b  verde
                 red   <= (others => '0');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) then --c  rojo
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '0');
             elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) then --f  amarillo 
                 red   <= (others => '1');
                 green <= (others => '1');
                 blue  <= (others => '0');
             elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) then --g  violeta
                 red   <= (others => '1');
                 green <= (others => '0');
                 blue  <= (others => '1');
             else                                                     --fondo 
                 red   <= (others => '0');
                 green <= (others => '0');
                 blue  <= (others => '0');
             end if;
            when others=>
               if ((row > 300 and row <350) and
                  (column>350 and column<400)) then
                     red <= (others => '1');
                     green<=(others => '0');
                  blue<=(others => '0');
               elsif ((row > 300 and row <350) and
                  (column>450 and column<500)) then
                     red <= (others => '0');
                     green<=(others => '1');
                     blue<=(others => '0');
               elsif ((row > 300 and row <350) and
                  (column>550 and column<600)) then
                     red <= (others => '0');
                     green<=(others => '0');
                     blue<=(others => '1');
               else
                  red <= (others => '0');
                  green <= (others => '0');
                  blue <= (others => '0');
               end if;
          end case;
      end if;
   end process DRAW7SEG;

   with dipsw select conectornum <=  --decodificador para los numeros 
    "0111111" when "0000",
    "0000110" when "0001",
    "1011011" when "0010",
    "1001111" when "0011",
    "1100110" when "0100",
    "1101101" when "0101",
    "1111101" when "0110",
    "0000111" when "0111",
    "1111111" when "1000",
    "1110011" when "1001",
    "0000000" when others;

end behavioral;