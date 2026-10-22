#!/usr/bin/env bash
# ==============================================================================
# UNIVERSIDAD NACIONAL DE JUJUY (UNJu) - FACULTAD DE INGENIERÍA
# SISTEMAS OPERATIVOS II - CICLO LECTIVO 2026
# SUITE DE EVALUACIÓN AUTOMATIZADA — TRABAJO PRÁCTICO N° 5
# Estructura: 30 Pts Auditoría de Red en Consola + 70 Pts Laboratorio Web Interactivo
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
# Test Ejercicio 1 (30 pts): Diagnóstico de Red y Enrutamiento en Consola
# ------------------------------------------------------------------------------
test_ejercicio1() {
    echo -e "\n${BOLD}Verificando Ejercicio 1: Diagnóstico de red y enrutamiento (Consola)...${NC}"
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
        if ! grep -Eq "^IP_LOCAL:[[:space:]]+[^[:space:]]+" "$target"; then
            echo -e "  ${RED}✗ Falta una dirección en el campo 'IP_LOCAL'.${NC}"
            error=1
        fi
        if ! grep -iq "GATEWAY_DEFAULT" "$target"; then
            echo -e "  ${RED}✗ Falta el campo 'GATEWAY_DEFAULT' en '$target'.${NC}"
            error=1
        fi
        if ! grep -iq "TABLA DE ENRUTAMIENTO" "$target"; then
            echo -e "  ${RED}✗ Falta la sección de tabla de enrutamiento en '$target'.${NC}"
            error=1
        fi
        if ! grep -iq "SOCKETS EN ESCUCHA" "$target"; then
            echo -e "  ${RED}✗ Falta la sección de sockets en escucha en '$target'.${NC}"
            error=1
        fi
        if ! grep -iq "TEORIA_NOMBRADO_NODO" "$target"; then
            echo -e "  ${RED}✗ Falta la fundamentación 'TEORIA_NOMBRADO_NODO' en '$target'.${NC}"
            error=1
        fi
    fi

    if [ $error -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Ejercicio 1 completado correctamente (+30 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 30))
    else
        echo -e "  ${RED}✗ [FAIL] Ejercicio 1 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Módulo Web (70 pts): Autoevaluación Web y Autograder Python
# ------------------------------------------------------------------------------
test_modulo_web() {
    echo -e "\n${BOLD}Verificando Módulo Web Interactivo (respuestas_tp5.json)...${NC}"
    local target="soluciones/respuestas_tp5.json"

    if [ ! -f "$target" ]; then
        echo -e "  ${RED}✗ Falta el archivo '$target'.${NC}"
        echo -e "  ${YELLOW}ℹ Debe abrir 'web/index.html', resolver el laboratorio interactivo y mover el archivo descargado a 'soluciones/'.${NC}"
        echo -e "  ${RED}✗ [FAIL] Módulo Web no completado (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
        return
    fi

    if python3 autograder_tp5.py "$target" --rubric rubric_tp5.json > /dev/null 2>&1; then
        echo -e "  ${GREEN}✓ [PASS] Módulo Web validado al 100% con autograder_tp5.py (+70 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 70))
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
test_modulo_web

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
    echo -e "  ${RED}${BOLD}ESTADO: TP 5 INCOMPLETO — ${FALLOS} componente(s) requieren atención ⚠️${NC}"
    echo -e "${BLUE}================================================================${NC}"
    exit 1
fi
