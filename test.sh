#!/usr/bin/env bash
# ==============================================================================
# UNIVERSIDAD NACIONAL DE JUJUY (UNJu) - FACULTAD DE INGENIERÍA
# SISTEMAS OPERATIVOS II - CICLO LECTIVO 2026
# SUITE DE EVALUACIÓN AUTOMATIZADA — TRABAJO PRÁCTICO N° 5
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

PUNTAJE_TOTAL=0
MAX_PUNTAJE=100
FALLOS=0

export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin

imprimir_banner() {
    echo -e "${BLUE}================================================================${NC}"
    echo -e "${BOLD}     UNJu — SISTEMAS OPERATIVOS II — EVALUACIÓN AUTOMÁTICA TP 5   ${NC}"
    echo -e "${BLUE}================================================================${NC}"
}

if [ ! -f "ejercicios.sh" ]; then
    echo -e "${RED}[ERROR CRÍTICO] No se encontró el archivo 'ejercicios.sh'.${NC}"
    exit 1
fi

source ./ejercicios.sh
mkdir -p soluciones

# ------------------------------------------------------------------------------
# Test Ejercicio 1 (20 pts): Diagnóstico de Red y Enrutamiento
# ------------------------------------------------------------------------------
test_ejercicio1() {
    echo -e "\n${BOLD}Verificando Ejercicio 1: Diagnóstico de red y enrutamiento...${NC}"
    ejercicio1_diagnostico_red > /dev/null 2>&1
    local error=0
    local target="soluciones/diagnostico_red_nodo.txt"

    if [ ! -f "$target" ] || [ ! -s "$target" ]; then
        echo -e "  ${RED}✗ Falta el archivo '$target' o está vacío.${NC}"
        error=1
    else
        if ! grep -iq "NODO_HOSTNAME" "$target"; then
            echo -e "  ${RED}✗ Falta el campo 'NODO_HOSTNAME' en '$target'.${NC}"
            error=1
        fi
        if ! grep -iq "INTERFAZ_LOOPBACK" "$target"; then
            echo -e "  ${RED}✗ Falta el campo 'INTERFAZ_LOOPBACK' en '$target'.${NC}"
            error=1
        fi
        if ! grep -iq "INTERFAZ_ACTIVA" "$target"; then
            echo -e "  ${RED}✗ Falta el campo 'INTERFAZ_ACTIVA' en '$target'.${NC}"
            error=1
        fi
        if ! grep -iq "GATEWAY_DEFAULT" "$target"; then
            echo -e "  ${RED}✗ Falta el campo 'GATEWAY_DEFAULT' en '$target'.${NC}"
            error=1
        fi
        if ! grep -iq "RESOLUCION_LOCAL" "$target"; then
            echo -e "  ${RED}✗ Falta la verificación de 'RESOLUCION_LOCAL' en '$target'.${NC}"
            error=1
        fi
        if ! grep -iq "TEORIA_NOMBRADO_NODO" "$target"; then
            echo -e "  ${RED}✗ Falta la fundamentación 'TEORIA_NOMBRADO_NODO' en '$target'.${NC}"
            error=1
        fi
    fi

    if [ $error -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Ejercicio 1 completado correctamente (+20 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Ejercicio 1 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Ejercicio 2 (20 pts): Topologías de Red para Clúster (N = 6)
# ------------------------------------------------------------------------------
test_ejercicio2() {
    echo -e "\n${BOLD}Verificando Ejercicio 2: Modelado de topologías de red (N=6)...${NC}"
    ejercicio2_topologias_cluster > /dev/null 2>&1
    local error=0
    local target="soluciones/analisis_topologias.txt"

    if [ ! -f "$target" ] || [ ! -s "$target" ]; then
        echo -e "  ${RED}✗ Falta el archivo '$target' o está vacío.${NC}"
        error=1
    else
        if ! grep -q "TOPOLOGIA_COMPLETA_ENLACES: 15" "$target"; then
            echo -e "  ${RED}✗ Enlaces erróneos para red completa N=6 (debe ser 15).${NC}"
            error=1
        fi
        if ! grep -q "TOPOLOGIA_ANILLO_ENLACES: 6" "$target"; then
            echo -e "  ${RED}✗ Enlaces erróneos para red anillo N=6 (debe ser 6).${NC}"
            error=1
        fi
        if ! grep -q "TOPOLOGIA_ESTRELLA_ENLACES: 5" "$target"; then
            echo -e "  ${RED}✗ Enlaces erróneos para red estrella N=6 (debe ser 5).${NC}"
            error=1
        fi
        if ! grep -iq "DISPONIBILIDAD" "$target" && ! grep -iq "TOLERANCIA A FALLOS" "$target"; then
            echo -e "  ${RED}✗ Falta el análisis de disponibilidad o tolerancia a fallos en '$target'.${NC}"
            error=1
        fi
    fi

    if [ $error -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Ejercicio 2 completado correctamente (+20 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Ejercicio 2 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Ejercicio 3 (20 pts): Simulación de Llamada RPC
# ------------------------------------------------------------------------------
test_ejercicio3() {
    echo -e "\n${BOLD}Verificando Ejercicio 3: Simulación de llamada RPC...${NC}"
    ejercicio3_simulacion_rpc > /dev/null 2>&1
    local error=0
    local target="soluciones/simulacion_rpc.txt"

    if [ ! -f "$target" ] || [ ! -s "$target" ]; then
        echo -e "  ${RED}✗ Falta el archivo '$target' o está vacío.${NC}"
        error=1
    else
        if ! grep -iq "CLIENT_STUB_MARSHAL" "$target"; then
            echo -e "  ${RED}✗ Falta la etapa 'CLIENT_STUB_MARSHAL' en '$target'.${NC}"
            error=1
        fi
        if ! grep -iq "SERVER_STUB_UNMARSHAL" "$target"; then
            echo -e "  ${RED}✗ Falta la etapa 'SERVER_STUB_UNMARSHAL' en '$target'.${NC}"
            error=1
        fi
        if ! grep -q "RPC_RESULTADO: 100" "$target"; then
            echo -e "  ${RED}✗ Resultado RPC erróneo en '$target' (debe ser 'RPC_RESULTADO: 100').${NC}"
            error=1
        fi
        if ! grep -iq "FUNDAMENTO_TEORICO_MENSAJES" "$target"; then
            echo -e "  ${RED}✗ Falta 'FUNDAMENTO_TEORICO_MENSAJES' en '$target'.${NC}"
            error=1
        fi
    fi

    if [ $error -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Ejercicio 3 completado correctamente (+20 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Ejercicio 3 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Ejercicio 4 (20 pts): Grupo Jerárquico y Balanceo Round-Robin
# ------------------------------------------------------------------------------
test_ejercicio4() {
    echo -e "\n${BOLD}Verificando Ejercicio 4: Grupo Jerárquico y Balanceo Round-Robin...${NC}"
    ejercicio4_balanceo_grupo > /dev/null 2>&1
    local error=0
    local target="soluciones/balanceo_grupo.txt"

    if [ ! -f "$target" ] || [ ! -s "$target" ]; then
        echo -e "  ${RED}✗ Falta el archivo '$target' o está vacío.${NC}"
        error=1
    else
        if ! grep -q "WORKER_A_TAREAS: 2" "$target"; then
            echo -e "  ${RED}✗ Conteo erróneo de tareas para WORKER_A en '$target'.${NC}"
            error=1
        fi
        if ! grep -q "WORKER_B_TAREAS: 2" "$target"; then
            echo -e "  ${RED}✗ Conteo erróneo de tareas para WORKER_B en '$target'.${NC}"
            error=1
        fi
        if ! grep -q "WORKER_C_TAREAS: 2" "$target"; then
            echo -e "  ${RED}✗ Conteo erróneo de tareas para WORKER_C en '$target'.${NC}"
            error=1
        fi
        if ! grep -iq "ANALISIS_SPOF_COORDINADOR" "$target"; then
            echo -e "  ${RED}✗ Falta el análisis de 'ANALISIS_SPOF_COORDINADOR' en '$target'.${NC}"
            error=1
        fi
    fi

    if [ $error -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Ejercicio 4 completado correctamente (+20 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Ejercicio 4 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Ejercicio 5 (20 pts): Autoevaluación Web y Autograder Python
# ------------------------------------------------------------------------------
test_ejercicio5() {
    echo -e "\n${BOLD}Verificando Ejercicio 5: Autoevaluación Web (respuestas_tp5.json)...${NC}"
    local target="soluciones/respuestas_tp5.json"

    if [ ! -f "$target" ]; then
        echo -e "  ${RED}✗ Falta el archivo '$target'.${NC}"
        echo -e "  ${YELLOW}ℹ Debe abrir 'web/index.html', resolver las actividades y mover el archivo descargado a 'soluciones/'.${NC}"
        echo -e "  ${RED}✗ [FAIL] Ejercicio 5 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
        return
    fi

    if python3 autograder_tp5.py "$target" --rubric rubric_tp5.json > /dev/null 2>&1; then
        echo -e "  ${GREEN}✓ [PASS] Módulo Web validado con autograder_tp5.py (+20 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 20))
    else
        echo -e "  ${RED}✗ [FAIL] autograder_tp5.py reportó discrepancias o puntaje incompleto (+0 Pts)${NC}"
        echo -e "  ${YELLOW}ℹ Ejecute 'python3 autograder_tp5.py $target' para ver detalles y capítulos a repasar.${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Ejecución Principal de la Suite
# ------------------------------------------------------------------------------
imprimir_banner

test_ejercicio1
test_ejercicio2
test_ejercicio3
test_ejercicio4
test_ejercicio5

echo -e "\n${BLUE}================================================================${NC}"
echo -e "${BOLD}                       RESUMEN DE CALIFICACIÓN                  ${NC}"
echo -e "${BLUE}================================================================${NC}"
porcentaje=$((PUNTAJE_TOTAL * 100 / MAX_PUNTAJE))

if [ $PUNTAJE_TOTAL -eq 100 ]; then
    echo -e "  ${GREEN}${BOLD}PUNTAJE FINAL: ${PUNTAJE_TOTAL} / ${MAX_PUNTAJE} Pts (${porcentaje}%)${NC}"
    echo -e "  ${GREEN}${BOLD}ESTADO: ¡FELICITACIONES! TP 5 COMPLETADO EXITOSAMENTE ✅${NC}"
    echo -e "${BLUE}================================================================${NC}"
    exit 0
else
    echo -e "  ${YELLOW}${BOLD}PUNTAJE FINAL: ${PUNTAJE_TOTAL} / ${MAX_PUNTAJE} Pts (${porcentaje}%)${NC}"
    echo -e "  ${RED}${BOLD}ESTADO: TP 5 INCOMPLETO — ${FALLOS} ejercicio(s) requieren atención ⚠️${NC}"
    echo -e "${BLUE}================================================================${NC}"
    exit 1
fi
