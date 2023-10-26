ENTITY LCD_DRIVER1 IS
	GENERIC (clk_divider: INTEGER := 100000); -- 50MHz to 500Hz
	PORT(
			clk, rst: IN BIT;
			RS, RW: OUT BIT;
			E: BUFFER BIT;
			DB: OUT BIT_VECTOR(7 DOWNTO 0)
			);
END LCD_DRIVER1;

ARCHITECTURE logic OF LCD_DRIVER1 IS
	-- todos os states deve ser usados, caso contrario um erro é acionado.
	TYPE state IS (FunctionSet1, 	FunctionSet2, 	FunctionSet3,
						FunctionSet4, 	ClearDisplay, 	DisplayControl,
						EntryMode, 		WriteData1, 	WriteData2, 
						WriteData3, 	WriteData4,		WriteData5,
						WriteData6, 	WriteData7,		WriteData8,
						WriteData9, 	WriteData10,	WriteData11,
						WriteData12,   WriteData13,	WriteData14,
						WriteData15,	WriteData16, 	WriteData17,
						downLine,		 			ReturnHome);
	SIGNAL pr_state, nx_state: state;
	
BEGIN

	PROCESS(clk)
		VARIABLE count: INTEGER RANGE 0 TO clk_divider;
	BEGIN
		IF(clk'EVENT AND clk='1') THEN
			count := count +1;
			IF(count=clk_divider) THEN	
				E <= NOT E;
				count := 0;
			END IF;
		END IF;
	END PROCESS;
	----- Lower section of FSM: --------------------
	PROCESS(E)
	BEGIN
		IF (E'EVENT AND E='1') THEN
			IF(rst='1') THEN
				pr_state <= FunctionSet1;
			ELSE
				pr_state <= nx_state;
			END IF;
		END IF;	
	END PROCESS;
	----- Upper section of FSM: --------------------
	PROCESS(pr_state)
	BEGIN
		CASE pr_state IS
			WHEN FunctionSet1 =>
				RS <= '0'; RW <= '0';
				DB <= "00111000";
				nx_state <= FunctionSet2;
			WHEN FunctionSet2 =>
				RS <= '0'; RW <= '0';
				DB <= "00111000";
				nx_state <= FunctionSet3;
			WHEN FunctionSet3 =>
				RS <= '0'; RW <= '0';
				DB <= "00111000";
				nx_state <= FunctionSet4;
			WHEN FunctionSet4 =>
				RS <= '0'; RW <= '0';
				DB <= "00111000";
				nx_state <= ClearDisplay;
			WHEN ClearDisplay =>
				RS <= '0'; RW <= '0';
				DB <= "00000001";
				nx_state <= DisplayControl;
			WHEN DisplayControl =>
				RS <= '0'; RW <= '0';
				DB <= "00001100";
				nx_state <= EntryMode;
			WHEN EntryMode =>
				RS <= '0'; RW <= '0';
				DB <= "00000110";
				nx_state <= WriteData1;
			WHEN WriteData1 =>
				-- deixar apenas um estado writedata e deslocar os valores de DB para exibir FPGA-IFPB
				RS <= '1'; RW <= '0';
				DB <= "01000110"; --'F'
				nx_state <= WriteData2;
			WHEN WriteData2 =>
				RS <= '1'; RW <= '0';
				DB <= "01010000"; --'P'
				nx_state <= WriteData3;
			WHEN WriteData3 =>
				RS <= '1'; RW <= '0';
				DB <= "01000111"; --'G'
				nx_state <= WriteData4;
			WHEN WriteData4 =>
				RS <= '1'; RW <= '0';
				DB <= "01000001"; --'A'
				nx_state <= WriteData5;
			WHEN WriteData5 =>
				RS <= '1'; RW <= '0';
				DB <= "10110000"; --'-'
				nx_state <= WriteData6;
			WHEN WriteData6 =>
				RS <= '1'; RW <= '0';
				DB <= "01000101"; --'E'
				nx_state <= WriteData7;
			WHEN WriteData7 =>
				RS <= '1'; RW <= '0';
				DB <= "01000101"; --'E'
				nx_state <= WriteData8;
			WHEN WriteData8 =>
				RS <= '1'; RW <= '0';
				DB <= "10110000"; --'-'
				nx_state <= WriteData9;
			WHEN WriteData9 =>
				RS <= '1'; RW <= '0';
				DB <= "01001001"; --'I'
				nx_state <= WriteData10;
			WHEN WriteData10 =>
				RS <= '1'; RW <= '0';
				DB <= "01000110"; --'F'
				nx_state <= WriteData11;
			WHEN WriteData11 =>
				RS <= '1'; RW <= '0';
				DB <= "01010000"; --'P'
				nx_state <= WriteData12;
			WHEN WriteData12 =>
				RS <= '1'; RW <= '0';
				DB <= "01000010"; --'B'
				nx_state <= downLine;
				
			WHEN downLine =>
				RS <= '0'; RW <= '0';
				DB <= "11000000"; --'linha de baixo'
				nx_state <= WriteData13;
			WHEN WriteData13 =>
				RS <= '1'; RW <= '0';
				DB <= "00110010"; --'2'
				nx_state <= WriteData14;
			WHEN WriteData14 =>
				RS <= '1'; RW <= '0';
				DB <= "00110000"; --'0'
				nx_state <= WriteData15;
			WHEN WriteData15 =>
				RS <= '1'; RW <= '0';
				DB <= "00110010"; --'2'
				nx_state <= WriteData16;
			WHEN WriteData16 =>
				RS <= '1'; RW <= '0';
				DB <= "00110011"; --'3'
				nx_state <= WriteData17;	
			WHEN WriteData17 =>
				RS <= '1'; RW <= '0';
				DB <= "00100001"; --'!'
				nx_state <= ReturnHome;
			WHEN ReturnHome =>
				RS <= '0'; RW <= '0';
				DB <= "10000000";
				nx_state <= WriteData1;
		END CASE;
	END PROCESS;
END logic;
	
