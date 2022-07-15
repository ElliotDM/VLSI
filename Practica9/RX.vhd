library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RX is
   port (
      clk : in std_logic;
      RX_WIRE : in std_logic;
      leds : out std_logic_vector(7 downto 0));
end RX;

architecture behavioral of RX is
   signal buff : std_logic_vector(9 downto 0);
   signal flag : std_logic := '0';
   signal pre : integer range 0 to 5208 := 0;
   signal indice : integer range 0 to 9 := 0;
   signal pre_val : integer range 0 to 41_600;
   signal baud : std_logic_vector(2 downto 0);

begin
   RX_DATO : process(clk)
   begin
      if (clk'event and clk = '1') then
         if (flag = '0' and RX_WIRE = '0') then
            flag <= '1';
            indice <= 0;
            pre <= 0;
         end if;     
         if (flag = '1') then
            buff(indice) <= RX_WIRE;
            if (pre < pre_val) then
               pre <= pre + 1;
            else
               pre <= 0;
            end if;
            if (pre = pre_val/2) then
               if (indice < 9) then
                  indice <= indice + 1;
               else
                  if (buff(0) = '0' and buff(9) = '1') then
                     leds <= buff(8 downto 0);
                  else
                     leds <= "00000000"
                  end if;
                  flag <= 0;
               end if;
            end if;
         end if; 
      end if;
   end process;

   baud <= "011";

   with (baud) select
      pre_val <= 41600 when "000",
                 20800 when "001",
                 10400 when "010",
                  5200 when "011",
                  2600 when "100",
                  1300 when "101",
                   866 when "110",
                   432 when others;
   
end architecture;