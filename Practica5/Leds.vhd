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
      led4 : out std_logic);
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
	signal a3 : std_logic_vector(7 downto 0) := x"60";
	signal a4 : std_logic_vector(7 downto 0) := x"F8";

begin
   D1 : divisor generic map (10) port map (clk, relojPWM);
   D2 : divisor generic map (23) port map (clk, relojCiclo);
   
   P1 : PWM port map (relojPWM, a1, led1);
   P2 : PWM port map (relojPWM, a2, led2);
   P3 : PWM port map (relojPWM, a3, led3);
   P4 : PWM port map (relojPWM, a4, led4);

   process (relojCiclo)
   begin
      if relojCiclo = '1' and relojCiclo'event then
			a1 <= not a4;
			a2 <= not a1;
			a3 <= not a2;
			a4 <= not a3;
      end if;
   end process;
end architecture;