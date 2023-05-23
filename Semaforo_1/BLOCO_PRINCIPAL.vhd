LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY BLOCO_PRINCIPAL IS 
PORT(
		CLOCK_IN : IN STD_LOGIC;
		
		MONITOR_SINAL_CLKO_RED : OUT STD_LOGIC;
		
		MONITOR_SINAL_FINAL_RED : OUT STD_LOGIC;
		
		MONITOR_IF_RED : OUT STD_LOGIC;
		 
		SAIDA_R  : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
		SAIDA_G  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		
		
		);
END BLOCO_PRINCIPAL;

ARCHITECTURE LOGICA OF BLOCO_PRINCIPAL IS
--COMPONENTS

COMPONENT CONVERSOR_1KHZ IS
PORT(
		CLK_I : IN STD_LOGIC;
		CLK_O : OUT STD_LOGIC
);
END COMPONENT;

COMPONENT TEMPORIZADOR IS
PORT (
		CLK_I : IN STD_LOGIC;
		TEMPO : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- EM SEGUNDOS
		N_BITS : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- ATE 32 BITS
		CHIP_SELECT : IN STD_LOGIC;
		SINAL_FINAL : OUT STD_LOGIC;
		CLK_O : OUT STD_LOGIC
);
END COMPONENT;

-- SIGNALS

SIGNAL SINAL_CLKO_CONVERSOR : STD_LOGIC;

SIGNAL SINAL_FINAL_RED : STD_LOGIC;
SIGNAL SINAL_CLKO_RED  : STD_LOGIC;

SIGNAL BITS_RED : STD_LOGIC_VECTOR(17 DOWNTO 0):= "111111111111111111";
SIGNAL BITS_GREEN : STD_LOGIC_VECTOR(7 DOWNTO 0):= "00000000";

SIGNAL MONITOR_IF : STD_LOGIC:= '0';

BEGIN

CONVERSOR : CONVERSOR_1KHZ PORT MAP(CLOCK_IN,SINAL_CLKO_CONVERSOR);

MONITOR_SINAL_CLKO_RED <= SINAL_CLKO_RED;

MONITOR_SINAL_FINAL_RED <= SINAL_FINAL_RED;

TEMPORIZADOR_RED : TEMPORIZADOR PORT MAP(	
														SINAL_CLKO_CONVERSOR,
														"01000", -- 6  = 00110
														"10010", -- 18 = 10010
														'1',
														SINAL_FINAL_RED,
														SINAL_CLKO_RED
														);

														
PROCESS(SINAL_CLKO_RED)

BEGIN
	IF(SINAL_CLKO_RED'EVENT AND SINAL_CLKO_RED = '0') THEN
		IF (BITS_RED = "000000000000000000") THEN
			BITS_RED <= "111111111111111111";
		END IF;
		IF (BITS_RED = "000000000000000001") THEN
			MONITOR_IF <= '1';
			BITS_RED <= "000000000000000000";
		END IF;
		IF (BITS_RED > "000000000000000000") THEN
			BITS_RED <= STD_LOGIC_VECTOR( UNSIGNED(BITS_RED) / "000000000000000010");
		END IF;
		

	END IF;


END PROCESS;
MONITOR_IF_RED <= MONITOR_IF;
SAIDA_R <= BITS_RED;												
END LOGICA;
