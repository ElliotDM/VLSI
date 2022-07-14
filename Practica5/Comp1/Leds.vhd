library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Leds is
   port (
      clk  : in  std_logic;
      led1 : out std_logic;
      led2 : out std_logic;
      led3 : out std_logic;
      led4 : out std_logic;
      led5 : out std_logic;
      led6 : out std_logic);
end Leds;

architecture Behavioral of Leds is
   component Divisor is
      generic (N : integer := 24);

      port (
         clk : in std_logic;
         div_clk : out std_logic);
   end component;

   component PWM is
      port(
         reloj : in  std_logic;
             D : in  std_logic_vector(7 downto 0);
             S : out std_logic);
   end component; 

   signal relojPWM   : std_logic;
   signal relojCiclo : std_logic;

	signal a1 : std_logic_vector(7 downto 0) := x"08";
	signal a2 : std_logic_vector(7 downto 0) := x"20";
	signal a3 : std_logic_vector(7 downto 0) := x"40";
	signal a4 : std_logic_vector(7 downto 0) := x"60";
	signal a5 : std_logic_vector(7 downto 0) := x"80";
	signal a6 : std_logic_vector(7 downto 0) := x"F8";

begin
   D1 : divisor generic map (10) port map (clk, relojPWM);
   D2 : divisor generic map (23) port map (clk, relojCiclo);
   
   P1 : PWM port map (relojPWM, a1, led1);
   P2 : PWM port map (relojPWM, a2, led2);
   P3 : PWM port map (relojPWM, a3, led3);
   P4 : PWM port map (relojPWM, a4, led4);
   P5 : PWM port map (relojPWM, a5, led5);
   P6 : PWM port map (relojPWM, a6, led6);

   process (relojCiclo)
      variable contador : integer range 0 to 11 := 0;
   begin
      if relojCiclo = '1' and relojCiclo'event then
			if contador = 11 then
            contador := 0;
			elsif contador = 1 then
            a5 <= a6;
            a6 <= x"F8";
         elsif contador = 2 then
            a4 <= a5;
            a5 <= a6;
            a6 <= x"80";
         elsif contador = 3 then
            a3 <= a4;
            a4 <= a5;
            a5 <= a6;
            a6 <= x"60";
         elsif contador = 4 then
            a2 <= a3;
            a3 <= a4;
            a4 <= a5;
            a5 <= a6;
            a6 <= x"40";
         elsif contador = 5 then
            a1 <= a2;
            a2 <= a3;
            a3 <= a4;
            a4 <= a5;
            a5 <= a6;
            a6 <= x"20";
         elsif contador = 6 then
            a2 <= a1;
            a1 <= x"F8";
         elsif contador = 7 then
            a3 <= a2;
            a2 <= a1;
            a1 <= x"80";
         elsif contador = 8 then
            a4 <= a3;
            a3 <= a2;
            a2 <= a1;
            a1 <= x"60";
         elsif contador = 9 then
            a5 <= a4;
            a4 <= a3;
            a3 <= a2;
            a2 <= a1;
            a1 <= x"40";
         elsif contador = 10 then
            a6 <= a5;
            a5 <= a4;
            a4 <= a3;
            a3 <= a2;
            a2 <= a1;
            a1 <= x"20";
         end if;

         contador := contador + 1;
      end if;
   end process;
end architecture;