library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RGB is
   port (
      clk : in std_logic;
      
      ledRojo : out std_logic;
      ledVerde : out std_logic;
      ledAzul : out std_logic);
end RGB;

architecture Behavioral of RGB is
   component Divisor is
      generic (N : integer := 24);

      port (
         clk : in std_logic;
         div_clk : out std_logic);
   end component;

   component PWM is
      port(
         reloj : in std_logic;
             D : in std_logic_vector(7 downto 0);
             S : out std_logic);
   end component; 

   signal relojPWM   : std_logic;
   signal relojCiclo : std_logic;

   signal a1 : std_logic_vector(7 downto 0) := x"00";
   signal a2 : std_logic_vector(7 downto 0) := x"00";
   signal a3 : std_logic_vector(7 downto 0) := x"00";

begin
   D1 : divisor generic map (10) port map (clk, relojPWM);
   D2 : divisor generic map (23) port map (clk, relojCiclo);

   P1 : PWM port map (relojPWM, a1, ledRojo);
   P2 : PWM port map (relojPWM, a2, ledVerde);
   P3 : PWM port map (relojPWM, a3, ledAzul);

   process (relojCiclo)
      variable cuenta : integer range 0 to 35 := 0;
   begin
      if relojCiclo = '1' and relojCiclo'event then
         if cuenta = 0 then
            a1 <= x"00";
            a2 <= x"FF"; -- violeta
            a3 <= x"00";
         elsif cuenta = 5 then
            a1 <= x"FF";
            a2 <= x"FF"; -- azul
            a3 <= x"00";
         elsif cuenta = 10 then
			   a1 <= x"FF";
            a2 <= x"00"; -- cian
            a3 <= x"00";  
         elsif cuenta = 15 then
            a1 <= x"FF";
            a2 <= x"00"; -- verde
            a3 <= x"FF";
         elsif cuenta = 20 then
            a1 <= x"FF";
            a2 <= x"00"; -- amarillo
            a3 <= x"00";
         elsif cuenta = 25 then  
				a1 <= x"00";
            a2 <= x"7F"; -- naranja
            a3 <= x"FF";
         elsif cuenta = 30 then
            a1 <= X"00";
            a2 <= X"FF"; -- rojo
            a3 <= X"FF";
         end if;
         
         cuenta := cuenta + 1;

         if cuenta = 35	then
            cuenta := 0;
         end if;
      end if;
   end process;
end architecture;