library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity TX_Comp2 is
   port(
      reloj : in std_logic;
      sw : in std_logic_vector(3 downto 0);
      l : out std_logic;
      tx : out std_logic
   );
end entity;

architecture behavioral OF TX_Comp2 IS
   component TX is
      port(
         clk     : in  std_logic;
         dato    : in  std_logic_vector(7 downto 0);
         baud    : in  std_logic_vector(2 downto 0);
         inicio  : in  std_logic;
         led     : out std_logic;
         TX_WIRE : out std_logic);
   end component;

   signal pulso : std_logic := '0';
   signal contador: integer range 0 to 49999999 := 0;
   signal i : integer range 0 to 4;
   signal conta : integer := 0;
   signal valor : integer := 70000;
   signal hex_val: std_logic_vector(7 downto 0) := (others => '0');
   signal dato : std_logic_vector(7 downto 0);
   
   signal dato_bin : std_logic;
   signal actual : std_logic_vector(7 downto 0) := X"00";
   signal inicio : std_logic;
   signal senial : std_logic := '0';
   
   
begin
   T: TX port map (reloj, actual, "011", senial, l, tx);
   
   TX_DIVISOR : process(reloj)
   begin
      if rising_edge (reloj) then
         contador <= contador + 1;
         if (contador < 350_000) then
            pulso <= '1';
         else
            pulso <= '0';
         end if;
      end if;
   end process;
   
   TX_PREPARA : process(reloj, pulso)
   begin
      if (pulso = '1') then
         if rising_edge(reloj) then
            if (conta = valor) then
               conta <= 0;
               senial <= '1';
               if (i = 0) then
                  actual <= X"0D"; -- "1101"
                  i <= i + 1;
               -- elsif (i = 5) then
               --    actual <= X"0A"; -- "1010"
               --    i <= 0;
               else
                  actual <= hex_val;
                  i <= i + 1;
               end if;
            else
               conta <= conta + 1;
               senial <= '0';
            end if;
         end if;
      end if;
   end process;
   
   dato_bin <= sw(i);
   
   with (dato_bin) select
      hex_val <= X"30" when '0',
                 X"31" when '1';
                 
end architecture;