library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MuxDec4disp is
   port(
      clk : in  std_logic;
      dig : out std_logic_vector(3 downto 0);
      seg : out std_logic_vector(6 downto 0));
end MuxDec4disp;

architecture behavioral of MuxDec4disp is
   signal rapido: std_logic;
   signal salida, D0, D1, D2, D3:  std_logic_vector(3 downto 0);
   signal seleccion:  std_logic_vector(1 downto 0);

begin
   Contador: process(clk)
      variable cuenta: std_logic_vector(1 downto 0) := "00";   
   begin
      if rising_edge(clk) then
         cuenta := cuenta + 1;
      end if;
      
      seleccion <= cuenta;
   end process;
   
   Mux: process(seleccion)
   begin
      if seleccion = "00" then
         salida <= D0;
      elsif seleccion = "01" then
         salida <= D1;
      elsif seleccion = "10" then
         salida <= D2;
      elsif seleccion = "11" then
         salida <= D3;
      end if;
   end process;
   
   Seledisplay: process(seleccion)
   begin
      case seleccion is
         when "00" =>
            dig <= "1110";
         when "01" =>
            dig <= "1101";
         when "10" =>
            dig <= "1011";
         when others =>
            dig <= "0111";
      end case;
   end process;
   
   -- Decodificador   
   with salida select
      seg <= "1000000" when "0000",
         "1111001" when "0001",
         "0100100" when "0010",
         "0110000" when "0011",
         "0011001" when "0100",
         "0010010" when "0101",
         "0000010" when "0110",
         "1111000" when "0111",
         "0000000" when "1000",
         "0010000" when "1001",
         "1000000" when others;
           
end behavioral;