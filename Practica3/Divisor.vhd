library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Divisor is
   generic (N : integer := 24); -- N : Valor que define el indice del divisor

   port (
      clk     : in std_logic;
      div_clk : out std_logic);
end Divisor;

architecture Behavioral of Divisor is
begin
   process(clk)
      variable cuenta : std_logic_vector(27 downto 0) := x"0000000";
   begin
      if rising_edge(clk) then
         cuenta := cuenta + 1;
      end if;

      div_clk <= cuenta(N);
   end process;
end Behavioral;

-- Periodo de la salida en funcion del valor de N para un reloj de 50MHz
-- 27 - 5.37s      26 - 2.68s      25 - 1.34s      24 - 671ms      23 - 336ms
-- 22 - 168ms      21 - 83.9ms     20 - 41.9ms     19 - 21ms       18 - 10.5ms
-- 17 - 5.24ms     16 - 2.62ms     15 - 1.31ms     14 - 655us      13 - 328us
-- 12 - 164us      11 - 81.9us     10 - 41us        9 - 20.5us      8 - 10.2us