library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity RegCorrimiento is
	port(reloj : in std_logic;
		  seg : out std_logic_vector(6 downto 0);	 
		  dig : out std_logic_vector(3 downto 0));
end entity RegCorrimiento;

architecture Behavioral of RegCorrimiento is
	signal segundo, rapido : std_logic;
	signal Q : std_logic_vector(3 downto 0) := "0000";
	signal display0, display1, display2, display3: std_logic_vector(6 downto 0);
	signal seleccion : std_logic_vector(1 downto 0) := "00";
	
	begin
		Divisor : process(reloj)
			variable cuenta : std_logic_vector(27 downto 0) := x"0000000";
			
			begin
				if rising_edge(reloj) then
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
		
		-- Mensaje
		
		with Q select
			display0 <= "0000110" when "0000", -- E
							"0101011" when "0001", -- n
							"1111111" when "0010", -- espacio
							"1000111" when "0011", -- L
							"0001000" when "0100", -- A
							"1111111" when "0101", -- espacio
							"1000000" when "0110", -- O
							"1000111" when "0111", -- L
							"0001000" when "1000", -- A
							"1111111" when others;
		
		FF1 : process(segundo)
			begin
				if rising_edge(segundo) then
					display1 <= display0;
				end if;
			end process;
		
		FF2 : process(segundo)
			begin
				if rising_edge(segundo) then
					display2 <= display1;
				end if;
			end process;
		
		FF3 : process(segundo)
			begin
				if rising_edge(segundo) then
					display3 <= display2;
				end if;
			end process;
			
		contador_mux : process(rapido)
			variable cuenta: std_logic_vector(1 downto 0) := "00";
			
			begin
				if rising_edge(rapido) then
					cuenta := cuenta + 1;
				end if;
				
				seleccion <= cuenta;
			end process;
					 
		mux4disp : process(seleccion)
			begin
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
				
				case seleccion is
					when "00" => 
						Seg <= display0;
					when "01" => 
						Seg <= display1;
					when "10" => 
						Seg <= display2;
					when others => 
						Seg <= display3;
				end case;
			end process;
		
end Behavioral;