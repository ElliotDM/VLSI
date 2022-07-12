library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Mux4Disp is
    port (
        clk : in std_logic;
        D0, D1, D2, D3 : in std_logic_vector(6 downto 0);
        A : out std_logic_vector(3 downto 0);
        L : out std_logic_vector(6 downto 0)
    );
end Mux4Disp;

architecture behavioral of Mux4Disp is
    signal segundo : std_logic;
    signal seleccion : std_logic_vector(1 downto 0) := "00";

begin
    divisor: process(clk)
        variable cuenta: std_logic_vector(27 downto 0) := x"0000000";
    begin
        if rising_edge(clk) then
            if cuenta = x"48009E0" then
                cuenta := x"0000000";
            else
                cuenta := cuenta + 1;
            end if;
        end if;
        
        segundo <= cuenta(22);		
    end process;

    contador : process(segundo)
        variable cuenta: std_logic_vector(1 downto 0) := "00";
    begin
        if rising_edge(segundo) then
            cuenta := cuenta + 1;
        end if;
        
        seleccion <= cuenta;
    end process;
    
    Mux : process (seleccion) is
    begin
        if seleccion = "00" then
            L <= D0;
        elsif seleccion = "01" then
            L <= D1;
        elsif seleccion = "10" then
            L <= D2;
        elsif seleccion = "11" then
            L <= D3;
        end if;
    end process;

    SelectDisplay : process(seleccion)
    begin
        case seleccion is
            when "00" => 
                A <= "1110";
            when "01" => 
                A <= "1101";
            when "10" => 
                A <= "1011";
            when others => 
                A <= "0111";
        end case;
    end process;
end behavioral;