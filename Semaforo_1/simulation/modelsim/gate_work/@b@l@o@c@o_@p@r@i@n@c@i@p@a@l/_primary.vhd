library verilog;
use verilog.vl_types.all;
entity BLOCO_PRINCIPAL is
    port(
        CLOCK_IN        : in     vl_logic;
        TESTE_SINAL_FINAL_RED: out    vl_logic;
        TESTE_SINAL_FINAL_GREEN: out    vl_logic;
        TESTE_SINAL_CLKO_RED: out    vl_logic;
        TESTE_SINAL_CLKO_GREEN: out    vl_logic;
        TESTE_SINALTESTE_1SR: out    vl_logic;
        TESTE_SINALTESTE_1SG: out    vl_logic;
        SAIDA_R         : out    vl_logic_vector(17 downto 0);
        SAIDA_G         : out    vl_logic_vector(7 downto 0)
    );
end BLOCO_PRINCIPAL;
