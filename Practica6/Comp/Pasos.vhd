library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Pasos is
   port (
      clk : in std_logic;
      MOT : out std_logic_vector(3 downto 0));
end Pasos;

architecture Behavioral of Pasos is
   component divisor is 
      generic (N : integer := 24);

      port (
         clk : in std_logic;
         div_clk : out std_logic);
   end component;
   
   component MotPasos is
      port (
         clk : in  std_logic;
         rst : in  std_logic;
         UD  : in  std_logic;
         FH  : in  std_logic_vector(1 downto 0);
         MOT : out std_logic_vector(3 downto 0));
   end component;
   
   signal avanza : std_logic := '1';
   signal rstM   : std_logic := '0';
   signal FH     : std_logic_vector(1 downto 0) := "01";
   signal dir    : std_logic := '0';
   signal reloj  : std_logic;
   
begin
   D : divisor generic map(17) port map(clk,reloj);
   P : MotPasos port map(avanza, rstM, dir, FH, MOT);
   
   process (reloj)
      variable control : integer := 0;
      variable direccion : std_logic := '1';
      variable sigue : std_logic := '1';
   begin
      if reloj'event and reloj = '1' then
         if control < 2000 then
            sigue := not sigue;
            control := control +1;
         else
            rstM <= '1';
            control := 0;
         end if;
      end if;
      avanza <= sigue;
      dir <= direccion;
   end process;
end Behavioral;