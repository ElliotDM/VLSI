library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PWM is
   port (
      reloj : in  std_logic;
          D : in  std_logic_vector(7 downto 0);
          S : out std_logic
   );
end PWM;

architecture Behavioral of pwm is
begin
   process(reloj)													
      variable cuenta : integer range 0 to 255 := 0; 
   begin
      if reloj = '1' and reloj'event then
         cuenta := (cuenta + 1) mod 256;

         if cuenta < D then 
            S <= '1';
         else 
            S <= '0';
         end if;
      end if;
  end process;
end Behavioral; 