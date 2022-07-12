library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Timer is
   port (
      clk   : in  std_logic;
      start : in  std_logic;
      Tms   : in  std_logic_vector(19 downto 0);
      p     : out std_logic
   );
end Timer;

architecture rtl of Timer is
   signal clk1ms : std_logic;
   signal previo : std_logic := '0';
   constant fclk : integer := 50_000_000; -- Frecuencia de 50 MHz 

begin
   Relojms : process(clk)
      variable cuenta : integer := 0;
   begin
      if rising_edge(clk) then
         if cuenta >= fclk/1000-1 then
            cuenta := 0;
            clk1ms <= '1';
         else
            cuenta := cuenta + 1;
            clk1ms <= '0';
         end if;
      end if;
   end process;
   
   Timerms : process(clk1ms, start)
      variable cuenta  : std_logic_vector(19 downto 0) := x"00000";
      variable contado : bit := '0';
   begin
      if rising_edge(clk1ms) then
         if contado = '0' then
            if start /= previo and start = '1' then
               cuenta := x"00000";
               contado := '1';
               p <= '1';
            else
               p <= '0';
            end if;
         else
            cuenta := cuenta + 1;
            if cuenta < Tms then
               p <= '1';
            else
               p <= '0';
               contado := '0';
            end if;
         end if;
         
         previo <= start;
      end if;
   end process;
end rtl;