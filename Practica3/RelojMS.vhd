library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RelojMS is
   port (
      clk   : in  std_logic;
      Tms   : in  std_logic_vector(3 downto 0);
      reloj : out std_logic);
end RelojMS;

architecture Behavioral of RelojMS is
   signal clk1ms : std_logic;
   constant fclk : integer := 50_000_000; -- Frecuencia de 50 MHz

begin
   -- Reloj de 1ms
   process(clk)
      variable cuenta : integer := 0;
   begin
      if rising_edge(clk) then
         if cuenta >= fclk/10-1 then -- cuenta >= 4_999_999
            cuenta := 0;
            clk1ms <= '1';
         else
            cuenta := cuenta + 1;
            clk1ms <= '0';
         end if;
      end if;
   end process;

   -- Reloj con periodo T ms
   process(clk1ms)
      variable tiempo : std_logic_vector(3 downto 0) := "0000";
   begin
      if rising_edge(clk1ms) then
         if tiempo >= Tms-1 then
            tiempo := "0000";
            reloj <= '1';
         else
            tiempo := tiempo + 1;
            reloj <= '0';
         end if;
      end if;
   end process;
end Behavioral;