library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RX2 is
   port (
      clk : in std_logic;
      RX_WIRE : in std_logic;
      leds : out std_logic_vector(3 downto 0);
      bandera : out std_logic := '1';
      T : out std_logic;
      MOT : out std_logic_vector(3 downto 0));
end entity;

architecture behavioral of RX2 is
   component RX is
      port (
         clk : in std_logic;
         RX_WIRE : in std_logic;
         baud : in std_logic_vector(2 downto 0);
         dato : out std_logic_vector(7 downto 0);
         bandera : out std_logic := '1');
   end component;
   
   component MotPasos is
      port (
         clk : in std_logic;
         rst : in std_logic;
         UD  : in std_logic;
         FH  : in std_logic_vector(1 downto 0);

         led : out std_logic_vector(3 downto 0);
         MOT : out std_logic_vector(3 downto 0)     
      );
   end component;
   
   signal dato : std_logic_vector(7 downto 0);
   signal direccion : std_logic;
   signal rst : std_logic := '0';
   signal aux : std_logic := '0';
   
begin
   R : RX port map(clk, RX_WIRE, "011", dato, bandera);
   M : MotPasos port map(clk, rst, direccion, "10", leds, MOT);
   
   seleccion : process(clk, dato)
   begin
      if rising_edge(clk) then
         if dato = "01000100" then    -- D
            direccion <= '1';
            rst <= '1';
         elsif dato = "01001001" then -- I
            direccion <= '0';
            rst <= '1';
         elsif dato = "01000001" then -- A
            rst <= '0';
         elsif dato = "01010100" then -- T
            aux <= not(aux);
            T <= aux;
         end if;
      end if;
   end process;
end architecture;