ENTITY lcd_driver IS
	GENERIC (clk_divider: INTEGER := 100000); -- 50MHz to 500Hz
	PORT(
			clk, rst: IN BIT;
			RS, RW: OUT BIT;
			E: BUFFER BIT;
			DB: OUT BIT_VECTOR(7 DOWNTO 0)
			);
END lcd_driver;

ARCHITECTURE logic OF lcd_driver IS
	TYPE state IS (FunctionSet1, 	FunctionSet2, 	FunctionSet3,
						FunctionSet4, 	ClearDisplay, 	DisplayControl,
						EntryMode, 		WriteData1, 	ReturnHome);
	SIGNAL pr_state, nx_state: state;
	
--	TYPE MEMORY IS ARRAY (0 TO 8) OF BIT_VECTOR(7 DOWNTO 0);
--	CONSTANT ROM: MEMORY:=(
--									"01000110",
--									"01010000",
--									"01000111",
--									"01000001",
--									"00101101",
--									"01001001",
--									"01000110",
--									"01010000",
--									"01000010",
--									"00100011");
--		CONSTANT ROM: MEMORY:=(
--									"01000110",
--									"01000110",
--									"01000110",
--									"01000110",
--									"01000110",
--									"01000110",
--									"01000110",
--									"01000110",
--									"01000110",
--									"01000110");
	
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
		VARIABLE ADDRESS : INTEGER RANGE 0 TO 8 := 0;
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
				CASE ADDRESS IS
					WHEN 0 =>
						DB <= "01000110";
						ADDRESS := 1;
						nx_state <= WriteData1;
					WHEN 1 =>
						DB <= "01010000";
						ADDRESS := 2;
						nx_state <= WriteData1;
					WHEN 2 =>
						DB <= "01000111";
						ADDRESS := 3;
						nx_state <= WriteData1;
					WHEN 3 =>
						DB <= "01000001";
						ADDRESS := 4;
						nx_state <= WriteData1;
					WHEN 4 =>
						DB <= "00101101";
						ADDRESS := 5;
						nx_state <= WriteData1;
					WHEN 5 =>
						DB <= "01001001";
						ADDRESS := 6;
						nx_state <= WriteData1;
					WHEN 6 =>
						DB <= "01000110";
						ADDRESS := 7;
						nx_state <= WriteData1;
					WHEN 7 =>
						DB <= "01010000";
						ADDRESS := 8;
						nx_state <= WriteData1;
					WHEN 8 =>
						DB <= "01000010";
						ADDRESS := 0;
						nx_state <= ReturnHome;
				END CASE;
			
			WHEN ReturnHome =>
				RS <= '0'; RW <= '0';
				DB <= "10000000";
				nx_state <= WriteData1;
		END CASE;
	END PROCESS;
END logic;
	