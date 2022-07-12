library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
 
entity Servomotor is
   port (
      clk  : in std_logic;
      Pini : in std_logic;
      Pfin : in std_logic;
      Inc  : in std_logic;
      Dec  : in std_logic;
      control : out std_logic);
end Servomotor;

architecture Behavioral of Servomotor is
   component Divisor is
      port(
         clk : in std_logic;
         div_clk : out std_logic);
   end component;

   component PWM is
      port(
         clk : in std_logic;
         D   : in std_logic_vector(7 downto 0);
         S   : out std_logic);
   end component;

   signal reloj : std_logic;
   signal ancho : std_logic_vector(7 downto 0) := X"0F";

begin
   U1: Divisor port map (clk, reloj);
   U2: PWM port map (reloj, ancho, control);

   process(reloj, Pini, Pfin, Inc, Dec)
      variable valor : std_logic_vector(7 downto 0) := X"0F";
      variable cuenta : integer range 0 to 1023 := 0;

   begin
      if reloj = '1' and reloj'event then
         if cuenta > 0 then
               cuenta := cuenta -1;
         else
               if Pini = '1' then
                  valor := X"0D";
               elsif Pfin = '1' then
                  valor := X"18";
               elsif Inc = '1' and valor < X"18" then
                  valor := valor + 1;
               elsif Dec = '1' and valor > X"0D" then
                  valor := valor - 1;
               end if;
               
               cuenta := 1023;
               ancho <= valor;
         end if;
      end if;
   end process;
end Behavioral;