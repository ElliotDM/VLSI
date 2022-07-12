library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RegCorrDoble is
    port (
        clk : in  std_logic;
        sw  : in  std_logic;
        seg : out std_logic_vector(6 downto 0);	 
        dig : out std_logic_vector(3 downto 0)
    );
end RegCorrDoble;

architecture Behavioral of RegCorrDoble is
    signal segundo, rapido : std_logic;
    signal Q: std_logic_vector(3 downto 0) := "0000";
    signal D0, D1, D2, D3: std_logic_vector(6 downto 0);
    signal seleccion : std_logic_vector(1 downto 0);
    
begin
    Divisor : process(clk)
        variable cuenta : std_logic_vector(27 downto 0) := x"0000000";
    begin
        if rising_edge(clk) then
            if cuenta = x"48009E0" then
                cuenta := x"0000000";
            else
                cuenta := cuenta + 1;
            end if;
        end if;
        
        rapido <= cuenta(10);
        segundo <= cuenta(22);
    end process;
    
    Contador : process(segundo)
    begin
        if rising_edge(segundo) then
            Q <= Q + 1;
        end if;
    end process;
    
    Mensaje : process(Q, sw)
    begin
      if sw = '0' then
         case Q is
            when "0000" => D0 <= "0000110"; -- E
            when "0001" => D0 <= "0101011"; -- n
            when "0010" => D0 <= "1111111"; -- espacio
            when "0011" => D0 <= "1000111"; -- L
            when "0100" => D0 <= "0001000"; -- A
            when "0101" => D0 <= "1111111"; -- espacio
            when "0110" => D0 <= "1000000"; -- O
            when "0111" => D0 <= "1000111"; -- L
            when "1000" => D0 <= "0001000"; -- A
            when others => D0 <= "1111111";
         end case;
      else
         case Q is
            when "0000" => D0 <= "0110000"; -- 3
            when "0001" => D0 <= "1111001"; -- 1
            when "0010" => D0 <= "0000010"; -- 6
            when "0011" => D0 <= "1000000"; -- 0
            when "0100" => D0 <= "0010000"; -- 9
            when "0101" => D0 <= "0110000"; -- 3
            when "0110" => D0 <= "1000000"; -- 0
            when "0111" => D0 <= "0000010"; -- 6
            when "1000" => D0 <= "0011001"; -- 4
            when others => D0 <= "1111111";
         end case;
        end if;
    end process;
        
    FF1 : process(segundo)
    begin
        if rising_edge(segundo) then
            D1 <= D0;
        end if;
    end process;
    
    FF2 : process(segundo)
    begin
        if rising_edge(segundo) then
            D2 <= D1;
        end if;
    end process;
    
    FF3 : process(segundo)
    begin
        if rising_edge(segundo) then
            D3 <= D2;
        end if;
    end process;
        
    ContadorMux : process(rapido)
        variable cuenta: std_logic_vector(1 downto 0) := "00";
    
    begin
        if rising_edge(rapido) then
            cuenta := cuenta + 1;
        end if;
        
        seleccion <= cuenta;
    end process;
    
    Mux : process (seleccion) is
    begin
        if seleccion = "00" then
            seg <= D0;
        elsif seleccion = "01" then
            seg <= D1;
        elsif seleccion = "10" then
            seg <= D2;
        elsif seleccion = "11" then
            seg <= D3;
        end if;
    end process;
    
    SelectDisplay : process(seleccion)
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
end Behavioral;