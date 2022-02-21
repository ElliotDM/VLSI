library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity alarma_digital is
	Port(reloj : in std_logic;
		  dig  : out std_logic_vector(3 downto 0);
		  seg  : out std_logic_vector(6 downto 0));
end alarma_digital;

architecture behavioral of alarma_digital is
	signal segundo  : std_logic;
	signal rapido   : std_logic;

	signal flag_ud  : std_logic;
	signal flag_dec : std_logic;
	signal flag_hrs : std_logic;

	signal unidades : std_logic;
	signal decenas  : std_logic;
	signal reset    : std_logic;

	signal min_ud  : std_logic_vector(3 downto 0);
	signal min_dec : std_logic_vector(3 downto 0);
	signal hrs_ud  : std_logic_vector(3 downto 0);
	signal hrs_dec : std_logic_vector(3 downto 0);

	signal segmentos : std_logic_vector(3 downto 0);
	signal seleccion : std_logic_vector(1 downto 0);

	begin
		
		divisor : process(reloj)
			variable cuenta : std_logic_vector(27 downto 0) := x"0000000";
			
			begin
				if rising_edge(reloj) then
					if cuenta = x"48009E0" then
						cuenta := x"0000000";
					else
						cuenta := cuenta + 1;
					end if;
				end if;
				
				segundo <= cuenta(22);
				rapido <= cuenta(10);		
			end process;
			
		unidades_min : process(segundo)
			variable cuenta : std_logic_vector(3 downto 0) := "0000";
			
			begin
				if rising_edge(segundo) then
					if cuenta = "1001" then
						cuenta := "0000";
						flag_ud <= '1';
					else
						cuenta := cuenta + 1;
						flag_ud <= '0';
					end if;
				end if;
				
				min_ud <= cuenta;
			end process;
			
		decenas_min : process(flag_ud)
			variable cuenta : std_logic_vector(3 downto 0) := "0000";
		
			begin
				if rising_edge(flag_ud) then
					if cuenta = "0101" then
						cuenta := "0000";
						flag_dec <= '1';
					else
						cuenta := cuenta + 1;
						flag_dec <= '0';
					end if;
				end if;
			
				min_dec <= cuenta;
			end process;

		unidades_hrs : process(flag_dec, reset)
			variable cuenta : std_logic_vector(3 downto 0) := "0000";
		
			begin
				if rising_edge(flag_dec) then
					if cuenta = "1001" then
						cuenta := "0000";
						flag_hrs <= '1';
					else
						cuenta := cuenta + 1;
						flag_hrs <= '0';
					end if;
				end if;
				
				if reset = '1' then
					cuenta := "0000";
				end if;
				
				hrs_ud <= cuenta;
				unidades <= cuenta(2);
			end process;

		decenas_hrs : process(flag_hrs, reset)
			variable cuenta : std_logic_vector(3 downto 0) := "0000";
			
			begin
				if rising_edge(flag_hrs) then
					if cuenta = "0010" then
						cuenta := "0000";
					else
						cuenta := cuenta + 1;
					end if;
				end if;
				
				if reset = '1' then
					cuenta := "0000";
				end if;
				
				hrs_dec <= cuenta;
				decenas <= cuenta(1);
			end process;
			
		reinicio : process(unidades, decenas)
			begin
				reset <= (unidades and decenas);
			end process;
			
		contador_mux : process(rapido)
			variable cuenta : std_logic_vector(1 downto 0) := "00";
			
			begin
				if rising_edge(rapido) then
					cuenta := cuenta + 1;
				end if;
				
				seleccion <= cuenta;
			end process;
		
		mux_disp : process(seleccion)
			begin
				if seleccion = "00" then
					segmentos <= min_ud;
				elsif seleccion = "01" then
					segmentos <= min_dec;
				elsif seleccion = "10" then
					segmentos <= hrs_ud;
				elsif seleccion = "11" then
					segmentos <= hrs_dec;	
				end if;

				case seleccion is
					when "00" => 
						Dig <= "1110";
					when "01" => 
						Dig <= "1101";
					when "10" => 
						Dig <= "1011";
					when others => 
						Dig <= "0111";	
				end case;
			end process;
		
		with segmentos select
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
