library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity divisor is
   port (
      clk : in std_logic;
      div_clk : out std_logic);
end divisor;

architecture Behavioral of divisor is
begin
   process (clk)
      constant N : integer := 11; -- N : Valor que define el indice del divisor
      variable cuenta: std_logic_vector (27 downto 0) := X"0000000";
   begin
      if rising_edge (clk) then
         cuenta := cuenta + 1;
      end if;

      div_clk <= cuenta (N);
   end process;
end Behavioral;