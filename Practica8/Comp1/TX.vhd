library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity TX is
   port(
      clk     : in  std_logic;
      dato    : in  std_logic_vector(7 downto 0);
      baud    : in  std_logic_vector(2 downto 0);
      inicio  : in  std_logic;
      led     : out std_logic;
      TX_WIRE : out std_logic);
end entity;

architecture behavioral OF TX IS
   signal pre   : integer RANGE 0 TO 5208 := 0;
   signal indice: integer RANGE 0 TO 9 := 0;
   signal buff  : std_logic_vector(9 DOWNTO 0);
   signal flag  : std_logic := '0';
   signal pre_val: integer RANGE 0 TO 41600 := 0;
   signal pulso : std_logic := '0';
   signal contador: integer RANGE 0 TO 49999999 := 0;
   signal previo : std_logic := '1';
   
begin
   -- No hay bit de paridad

   TX_ENVIA : process(clk)
      variable control : integer range 0 to 1 := 0;
   begin
      if rising_edge (clk) then
         if previo /= inicio and inicio = '0' then
            control := 1;
         end if;
      
         if (flag = '0' and control = 1) then
            flag <= '1';
            buff(0) <= '0'; -- Bit de inicio
            buff(9) <= '1'; -- Bit de parada
            buff(8 downto 1) <= dato;
         end if;
         
         if (flag = '1') then
            if (pre < pre_val) then
               pre <= pre + 1;
            else
               pre <= 0;
            end if;
            if (pre = pre_val/2) then
               TX_WIRE <= buff(indice); -- Manda digitos a un baud determinado
               if (indice < 9) then
                  indice <= indice + 1;
               else
                  flag <= '0';
                  indice <= 0;
                  control := 0;
               end if;
            end if;
         end if;
         previo <= inicio;
      end if;
   end process;
   
   led <= flag;
   
   with (baud) select
      pre_val <= 41600 when "000",  --  1200  bauds
                 20800 when "001",  --  2400  bauds
                 10400 when "010",  --  4800  bauds
                  5200 when "011",  --  9600  bauds
                  2600 when "100",  -- 19200  bauds
                  1300 when "101",  -- 38400  bauds
                   866 when "110",  -- 57600  bauds
                   432 when others; -- 115200 bauds

end architecture;