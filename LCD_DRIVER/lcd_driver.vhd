ENTITY lcd_driver IS
	GENERIC (clk_divider: INTEGER := 100000); -- 50MHz to 500Hz
	PORT(
			clk, rst: IN BIT;
			RS, RW, LCD_BLON,LCD_ON: OUT BIT;
			E: BUFFER BIT;
			DB: OUT BIT_VECTOR(7 DOWNTO 0)
			);
END lcd_driver;

ARCHITECTURE logic OF lcd_driver IS
	TYPE state IS (FunctionSet1, 	FunctionSet2, 	FunctionSet3,
						FunctionSet4, 	ClearDisplay, 	DisplayControl,
						EntryMode, 		WriteData1, 	WriteData2, 
						WriteData3, 	WriteData4, 	ReturnHome);
	SIGNAL pr_state, nx_state: state;
	
BEGIN
	LCD_ON <= '1';
	LCD_BLON <= '1';
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
				RS <= '1'; RW <= '0';
				DB <= "01010110"; --'V'
				nx_state <= WriteData2;
			WHEN WriteData2 =>
				RS <= '1'; RW <= '0';
				DB <= "01001000"; --'H'
				nx_state <= WriteData3;
			WHEN WriteData3 =>
				RS <= '1'; RW <= '0';
				DB <= "01000100"; --'D'
				nx_state <= WriteData4;
			WHEN WriteData4 =>
				RS <= '1'; RW <= '0';
				DB <= "01001100"; --'L'
				nx_state <= ReturnHome;
			WHEN ReturnHome =>
				RS <= '0'; RW <= '0';
				DB <= "10000000";
				nx_state <= WriteData1;
		END CASE;
	END PROCESS;
END logic;
	