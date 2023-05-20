LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY BLOCO_PRINCIPAL IS
	PORT( CLOCK_FPGA 	: IN STD_LOGIC;
	
			COMANDOS		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	
			DCD_UNIDADE_SEGUNDOS: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			DCD_DEZENA_SEGUNDOS: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			
			DCD_UNIDADE_MINUTOS: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			DCD_DEZENA_MINUTOS: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			
			DCD_UNIDADE_HORAS: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			DCD_DEZENA_HORAS: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
			);
END BLOCO_PRINCIPAL;

ARCHITECTURE LOGIC OF BLOCO_PRINCIPAL IS
--COMPONENTS
	COMPONENT BLOCO_CONTADOR59 IS
		PORT(
				CLK_IN : IN STD_LOGIC;
				FLAG_CONTAGEM_MAXIMA : OUT STD_LOGIC;
				SAIDA : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0)
				);
	END COMPONENT;
	
	COMPONENT BLOCO_CONTADOR23 IS
		PORT(
				CLK_IN : IN STD_LOGIC;
				SAIDA : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0)
				);
	END COMPONENT;
	
	COMPONENT DECODE_BCD_7SEG IS
	PORT(
			BCD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			OUT_7BIT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT SELETOR_FREQUENCIA IS
	PORT(
			CLK_IN : IN STD_LOGIC;
			CLK_ALT : IN STD_LOGIC;
			COMANDO : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			CLK_OUT : OUT STD_LOGIC
		);
	END COMPONENT;
	
--SIGNALS
	SIGNAL SAIDA_SEGUNDOS : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL SAIDA_MINUTOS  : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL SAIDA_HORAS 	 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL CLK_SEGUNDOS : STD_LOGIC;
	SIGNAL CLK_MINUTOS  : STD_LOGIC;
	SIGNAL CLK_HORAS    : STD_LOGIC;
	
	SIGNAL CLK_SEG2MIN  :STD_LOGIC;
	SIGNAL CLK_MIN2HOR  :STD_LOGIC;
	
	SIGNAL COMANDO_SEG : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL COMANDO_MIN : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL COMANDO_HOR : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
BEGIN

	MAQUINA_ESTADO_CONTROLE : PROCESS(COMANDOS)
	BEGIN
	
		CASE COMANDOS IS
			-- COMANDOS(3) BIT DE CONTROLE; 0 VELOCIDADE 1; 1 VELOCIDADE 2
			-- PRIORIDADE AO BIT MAIS SIGNIFICATIVO
			WHEN "0111" => -- FUNCIONAMENTO NORMAL 
				
				COMANDO_SEG <= "01";
				COMANDO_MIN <= "00";
				COMANDO_HOR <= "00";
				
			WHEN "0110" =>	-- CLOCK SEGUNDOS ACELERADO 2X
				COMANDO_SEG <= "10";
				COMANDO_MIN <= "00";
				COMANDO_HOR <= "00";
				
			WHEN "0101" => -- CLOCK MINUTOS ACELERADO 1X
				COMANDO_SEG <= "01";
				COMANDO_MIN <= "01";
				COMANDO_HOR <= "00";
			
			WHEN "0011" => -- CLOCK HORAS ACELERADO 1X
				COMANDO_SEG <= "01";
				COMANDO_MIN <= "00";
				COMANDO_HOR <= "01";
			
			WHEN "1111" => -- FUNCIONAMENTO NORMAL
				COMANDO_SEG <= "01";
				COMANDO_MIN <= "00";
				COMANDO_HOR <= "00";
				
			WHEN "1110" => -- CLOCK SEGUNDOS ACELERADO 2X
				COMANDO_SEG <= "10";
				COMANDO_MIN <= "00";
				COMANDO_HOR <= "00";
			
			WHEN "1101" => -- CLOCK MINUTOS ACELERADO 2X
				COMANDO_SEG <= "01";
				COMANDO_MIN <= "10";
				COMANDO_HOR <= "00";
			
			WHEN "1011" => -- CLOCK HORAS ACELERADO 2X
				COMANDO_SEG <= "01";
				COMANDO_MIN <= "00";
				COMANDO_HOR <= "10";
				
			WHEN OTHERS => 
				COMANDO_SEG <= "01";
				COMANDO_MIN <= "00";
				COMANDO_HOR <= "00";
				
		END CASE;
	END PROCESS MAQUINA_ESTADO_CONTROLE;
	
	

	FREQUENCIA_SEGUNDOS : SELETOR_FREQUENCIA PORT MAP(CLOCK_FPGA,'1'  			, 			 COMANDO_SEG, CLK_SEGUNDOS);
	FREQUENCIA_MINUTOS  : SELETOR_FREQUENCIA PORT MAP(CLOCK_FPGA,CLK_SEG2MIN   , 		    COMANDO_MIN, CLK_MINUTOS);
	FREQUENCIA_HORAS    : SELETOR_FREQUENCIA PORT MAP(CLOCK_FPGA,CLK_MIN2HOR   , 		    COMANDO_HOR, CLK_HORAS );
	
	
	CONTADOR_SEGUNDOS : BLOCO_CONTADOR59 PORT MAP(CLK_SEGUNDOS,CLK_SEG2MIN,SAIDA_SEGUNDOS);
	CONTADOR_MINUTOS  : BLOCO_CONTADOR59 PORT MAP(CLK_MINUTOS,CLK_MIN2HOR,SAIDA_MINUTOS);
	CONTADOR_HORAS 	: BLOCO_CONTADOR23 PORT MAP(CLK_HORAS,SAIDA_HORAS);
	
	DECODE_UNIDADE_SEGUNDOS	: DECODE_BCD_7SEG PORT MAP(SAIDA_SEGUNDOS(3 DOWNTO 0) ,DCD_UNIDADE_SEGUNDOS);
	DECODE_DEZENA_SEGUNDOS	: DECODE_BCD_7SEG PORT MAP(SAIDA_SEGUNDOS(7 DOWNTO 4) ,DCD_DEZENA_SEGUNDOS);
	
	DECODE_UNIDADE_MINUTOS	: DECODE_BCD_7SEG PORT MAP(SAIDA_MINUTOS(3 DOWNTO 0)  ,DCD_UNIDADE_MINUTOS);
	DECODE_DEZENA_MINUTOS	: DECODE_BCD_7SEG PORT MAP(SAIDA_MINUTOS(7 DOWNTO 4)  ,DCD_DEZENA_MINUTOS);
	
	DECODE_UNIDADE_HORAS		: DECODE_BCD_7SEG PORT MAP(SAIDA_HORAS(3 DOWNTO 0)	   ,DCD_UNIDADE_HORAS);
	DECODE_DEZENA_HORAS		: DECODE_BCD_7SEG PORT MAP(SAIDA_HORAS(7 DOWNTO 4)    ,DCD_DEZENA_HORAS);

END LOGIC;