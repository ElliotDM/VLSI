library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity sonicos is
   port (
      clk : in std_logic;
      sensor_eco : in std_logic; -- Echo
        
      sensor_disp: out STD_LOGIC; -- Trigger
      anodos:	out STD_LOGIC_VECTOR(3 downto 0);
      segmentos:	out STD_LOGIC_VECTOR(6 downto 0));
end sonicos;

architecture Behavioral of sonicos is
   signal cuenta: unsigned(16 downto 0) := (others => '0');
   signal centimetros: unsigned(15 downto 0) := (others => '0');
   signal centimetros_unid: unsigned(3 downto 0) := (others => '0');
   signal centimetros_dece: unsigned(3 downto 0) := (others => '0');
   signal sal_unid: unsigned(3 downto 0) := (others => '0');
   signal sal_dece: unsigned(3 downto 0) := (others => '0');
   signal digito: unsigned(3 downto 0) := (others => '0');
   signal eco_pasado: std_logic := '0';
   signal eco_sinc: 	 std_logic := '0';
   signal eco_nsinc:  std_logic := '0';
   signal espera: 	 std_logic:= '0';
   signal siete_seg_cuenta: unsigned(15 downto 0) := (others => '0');

begin
   anodos(1 downto 0) <= "11";
   
   siete_seg : process(clk)
   begin
      if rising_edge(clk) then
         if siete_seg_cuenta(siete_seg_cuenta'high) = '1' then
            digito <= sal_unid;
            anodos(3 downto 2) <= "01";
         else
            digito <= sal_dece;
            anodos(3 downto 2) <= "10";
         end if;
         
         siete_seg_cuenta <= siete_seg_cuenta +1;
      end if;
    end process;

   Trigger : process(clk)
   begin
   if rising_edge(clk) then
      if espera = '0' then
         if cuenta = 500 then -- Para el pulso de 10 microsegundos
            sensor_disp <= '0';
            espera <= '1';
            cuenta <= (others => '0');
         else
            sensor_disp <= '1';
            cuenta <= cuenta+1;
         end if;
            
         elsif eco_pasado = '0' and eco_sinc = '1' then -- Pone en cero todas las unidades
         -- Si en un tiempo pasado vale cero y ahora vale 1 hay un cambio en el sensor en el eco de subida
            cuenta <= (others => '0');
            centimetros <= (others => '0');
            centimetros_unid <= (others => '0');
            centimetros_dece <= (others => '0');
                
            elsif eco_pasado = '1' and eco_sinc = '0' then
                -- Detecta el flanco de bajada
                -- Decodificar unidades de los distancia en cm
                sal_unid <= centimetros_unid;
                sal_dece <= centimetros_dece;

            elsif cuenta = 2900-1 then
                --Contamos centimetros en BCD
                if centimetros_unid = 9 then
                    centimetros_unid <= (others => '0');
                    centimetros_dece <= centimetros_dece + 1;
                else
                    centimetros_unid <= centimetros_unid + 1;
                end if;
                
                centimetros <= centimetros + 1;
                cuenta<= (others => '0');
                if centimetros = 3448 then -- Cada 200ms hace una lectura 
                    espera <= '0';
                end if;
            else
                cuenta <= cuenta + 1;
            end if;

            -- Hay un retardo en el tiempo, la señal llega desfasada de un ciclo de reloj
            -- existe una historia de la señal
            eco_pasado <= eco_sinc;
            eco_sinc <= eco_nsinc;
            eco_nsinc <= sensor_eco;
        end if;
    end process;

    Decodificador : process(digito)
    begin
        if    digito = x"0" then segmentos <= "1000000";
        elsif digito = x"1" then segmentos <= "1111001";
        elsif digito = x"2" then segmentos <= "0100100";
        elsif digito = x"3" then segmentos <= "0110000";
        elsif digito = x"4" then segmentos <= "0011001";
        elsif digito = x"5" then segmentos <= "0010010";
        elsif digito = x"6" then segmentos <= "0000010";
        elsif digito = x"7" then segmentos <= "1111000";
        elsif digito = x"8" then segmentos <= "0000000";
        elsif digito = x"9" then segmentos <= "0010000";
        elsif digito = x"a" then segmentos <= "0001000";
        elsif digito = x"b" then segmentos <= "0000011";
        elsif digito = x"c" then segmentos <= "1000110";
        elsif digito = x"d" then segmentos <= "0100001";
        elsif digito = x"e" then segmentos <= "0000110";
        else
            segmentos <= "1110001";
        end if;
    end process;
end Behavioral;