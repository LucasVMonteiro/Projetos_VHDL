LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- RECEBE CLOCK DE 1KHZ
-- CONTA ATE 32s
-- CONTA SEMPRE EM VALORES INTEIROS DE SEGUNDOS
-- É UM CONTADOR DE SEGUNDOS COM PRECISAO EM MILISSEGUNDOS
ENTITY TEMPORIZADOR IS
PORT (
		CLK_I : IN STD_LOGIC;
		TEMPO : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- EM SEGUNDOS
		N_BITS : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- ATE 32 BITS
		CHIP_SELECT : IN STD_LOGIC;
		SINAL_FINAL : OUT STD_LOGIC;
		CLK_O : OUT STD_LOGIC
);

END TEMPORIZADOR;

ARCHITECTURE LOGICA OF TEMPORIZADOR IS
 SIGNAL SINAL_CLK : STD_LOGIC := '1';
BEGIN

PROCESS(CLK_I)
	-- CONTADOR_BINARY PODE SER CONSIDERADO COMO CONTADOR DE SEGUNDOS
	-- CONTADOR_BINARY É UM VETOR BINARIO POIS É COMPARADO AO VALOR
	-- BINARIO DE ENTRADA DO MODULO, ISSO EVITA CONVERTER INT -> BIN
	VARIABLE CONTADOR_BINARY : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
	VARIABLE CONTADOR_INTEGER : INTEGER := 1;
	VARIABLE PERIODO_CONTAGEM : INTEGER := 1000*(TO_INTEGER(UNSIGNED(TEMPO))/TO_INTEGER(UNSIGNED(N_BITS));
	VARIABLE CONTADOR_PERIODO  : INTEGER := 1;
BEGIN
	
	IF( CLK_I'EVENT AND CLK_I = '0' AND CHIP_SELECT = '1') THEN
	SINAL_FINAL <= '0';
	CONTADOR_INTEGER := CONTADOR_INTEGER + 1;
	CONTADOR_PERIODO  := CONTADOR_PERIODO + 1;
		
		
		-- QUANDO CONTADOR_PERIODO ATINGE O PERIODO,
		-- ELE MANDA UM SINAL PARA DESLOCAR OS BITS
		IF ( CONTADOR_PERIODO >= PERIODO_CONTAGEM) THEN
			CONTADOR_PERIODO := 1;
			SINAL_CLK <= NOT SINAL_CLK;
		END IF;
		
		
		IF ( CONTADOR_INTEGER >= 1000) THEN -- QUANDO CONTAR 1000, SIGNIFICA QUE SE PASSOU 1s
			CONTADOR_INTEGER := 1;
			CONTADOR_BINARY := STD_LOGIC_VECTOR( UNSIGNED(CONTADOR_BINARY) + "00001");
			
			IF (CONTADOR_BINARY = TEMPO) THEN
			-- SE ATINGIR O TEMPO TOTAL
			-- ENVIAR SINAL PARA ACIONAR 
			-- O OUTRO TEMPORIZADOR
			SINAL_FINAL <= '1';
			CONTADOR_BINARY := "00000";
			
			
			END IF;
		
		END IF;
		
		
		
	
	END IF;

END PROCESS;

CLK_O <= SINAL_CLK;

END LOGICA;