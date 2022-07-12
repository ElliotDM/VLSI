library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity AlarmaDigital is
   port(
      clk : in  std_logic;
       dig : out std_logic_vector(3 downto 0);
       seg : out std_logic_vector(6 downto 0));
end AlarmaDigital;

architecture behavioral of AlarmaDigital is
   signal segundo  : std_logic;
   signal rapido   : std_logic;

   signal flag_ud  : std_logic;
   signal flag_dec : std_logic;
   signal flag_hrs : std_logic;

   signal unidades : std_logic;
   signal decenas  : std_logic;
   signal reset    : std_logic;
   
   signal alarma_min_ud  : std_logic;
   signal alarma_min_dec : std_logic;
   signal alarma_hrs_ud  : std_logic;
   signal alarma_hrs_dec : std_logic;
   
   signal detener : std_logic := '0';

   signal min_ud  : std_logic_vector(3 downto 0);
   signal min_dec : std_logic_vector(3 downto 0);
   signal hrs_ud  : std_logic_vector(3 downto 0);
   signal hrs_dec : std_logic_vector(3 downto 0);

   signal segmentos : std_logic_vector(3 downto 0);
   signal seleccion : std_logic_vector(1 downto 0);

begin
   
   Divisor : process(clk)
      variable cuenta : std_logic_vector(27 downto 0) := x"0000000";
   begin
      if rising_edge(clk) then
         if cuenta = x"48009E0" then
            cuenta := x"0000000";
         else
            cuenta := cuenta + 1;
         end if;
      end if;
      
      segundo <= cuenta(22);
      rapido <= cuenta(10);		
   end process;
      
   Unidades_min : process(segundo, detener)
      variable cuenta : std_logic_vector(3 downto 0) := "0000";
   begin
      if rising_edge(segundo) then
         if detener = '1' then
            cuenta := "0000";
         else
            if cuenta = "1001" then
               cuenta := "0000";
               flag_ud <= '1';
            else
               cuenta := cuenta + 1;
               flag_ud <= '0';
            end if;
         end if;
      end if;
      
      min_ud <= cuenta;
      alarma_min_ud <= not cuenta(0);
   end process;
      
   Decenas_min : process(flag_ud, detener)
      variable cuenta : std_logic_vector(3 downto 0) := "0000";
   begin
      if rising_edge(flag_ud) then
         if detener = '1' then
            cuenta := "0010";
         else
            if cuenta = "0101" then
               cuenta := "0000";
               flag_dec <= '1';
            else
               cuenta := cuenta + 1;
               flag_dec <= '0';
            end if;
         end if;
      end if;
   
      min_dec <= cuenta;
      alarma_min_dec <= cuenta(1);
   end process;

   Unidades_hrs : process(flag_dec, reset, detener)
      variable cuenta : std_logic_vector(3 downto 0) := "0000";
   begin
      if rising_edge(flag_dec) then
         if detener = '1' then
            cuenta := "0100";
         else
            if cuenta = "1001" then
               cuenta := "0000";
               flag_hrs <= '1';
            else
               cuenta := cuenta + 1;
               flag_hrs <= '0';
            end if;
         end if;
      end if;
      
      if reset = '1' then
         cuenta := "0000";
      end if;
      
      hrs_ud <= cuenta;
      unidades <= cuenta(2);
      alarma_hrs_ud <= cuenta(1);
   end process;

   Decenas_hrs : process(flag_hrs, reset, detener)
      variable cuenta : std_logic_vector(3 downto 0) := "0000";
   begin
      if rising_edge(flag_hrs) then
         if detener = '1' then
            cuenta := "0000";
         else
            if cuenta = "0010" then
               cuenta := "0000";
            else
               cuenta := cuenta + 1;
            end if;
         end if;
      end if;
         
      if reset = '1' then
         cuenta := "0000";
      end if;
      
      hrs_dec <= cuenta;
      decenas <= cuenta(1);
      alarma_hrs_dec <= not cuenta(0);
   end process;
      
   Reinicio : process(unidades, decenas)
   begin
      reset <= (unidades and decenas);
   end process;
      
   Alarma : process(alarma_min_ud, alarma_min_dec, alarma_hrs_ud, alarma_hrs_dec)
   begin
      detener <= (alarma_min_ud and alarma_min_dec and alarma_hrs_ud and alarma_hrs_dec);
   end process;
      
   Contador_mux : process(rapido)
      variable cuenta : std_logic_vector(1 downto 0) := "00";
   begin
      if rising_edge(rapido) then
         cuenta := cuenta + 1;
      end if;
      
      seleccion <= cuenta;
   end process;
   
   Mux_disp : process(seleccion)
   begin
      if seleccion = "00" then
         segmentos <= min_ud;
      elsif seleccion = "01" then
         segmentos <= min_dec;
      elsif seleccion = "10" then
         segmentos <= hrs_ud;
      elsif seleccion = "11" then
         segmentos <= hrs_dec;	
      end if;

      case seleccion is
         when "00" => 
            dig <= "1110";
         when "01" => 
            dig <= "1101";
         when "10" => 
            dig <= "1011";
         when others => 
            dig <= "0111";	
      end case;
   end process;
      
   -- Decodificador
   with segmentos select
      seg <= "1000000" when "0000", -- 0
         "1111001" when "0001", -- 1
         "0100100" when "0010", -- 2
         "0110000" when "0011", -- 3
         "0011001" when "0100", -- 4
         "0010010" when "0101", -- 5
         "0000010" when "0110", -- 6
         "1111000" when "0111", -- 7
         "0000000" when "1000", -- 8
         "0010000" when "1001", -- 9
         "1000000" when others;
   
end behavioral;