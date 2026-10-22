#!/usr/bin/env bash
# ==============================================================================
# UNIVERSIDAD NACIONAL DE JUJUY (UNJu) - FACULTAD DE INGENIERÍA
# SISTEMAS OPERATIVOS II - CICLO LECTIVO 2026
# TRABAJO PRÁCTICO N° 5: Estructura de los Sistemas Distribuidos
# ==============================================================================
# Nombre del Alumno: 
# Legajo (L.U.): 
# Usuario de GitHub: 
# ==============================================================================
# ESTRUCTURA DE EVALUACIÓN:
# 1. Consola Linux (30 Pts): Auditoría de Red, Interfaces y Enrutamiento.
# 2. Módulo Web Interactivo (70 Pts): Topologías, Simulador RPC, Grupos y Teoría.
# ==============================================================================

export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin

# ------------------------------------------------------------------------------
# EJERCICIO 1: Diagnóstico de Red, Interfaces y Enrutamiento en Linux (30 Pts)
# ------------------------------------------------------------------------------
# Consigna:
# 1. En un sistema distribuido, cada nodo autónomo debe auditar su conectividad
#    física y lógica con el resto de los procesadores de la red.
# 2. Cree el archivo 'soluciones/diagnostico_red_nodo.txt' conteniendo:
#    - El nombre del equipo local ('hostname') en la línea: "NODO_HOSTNAME: <hostname>"
#    - La interfaz de loopback con su IP: "INTERFAZ_LOOPBACK: <ip_loopback>"
#    - La interfaz de red activa principal en formato: "INTERFAZ_ACTIVA: <iface>"
#    - La dirección IPv4 de dicha interfaz en formato: "IP_LOCAL: <ip>"
#    - La puerta de enlace predeterminada (default gateway): "GATEWAY_DEFAULT: <gateway>"
#    - La tabla de enrutamiento del kernel bajo el encabezado: "--- TABLA DE ENRUTAMIENTO DEL KERNEL ---"
#    - La lista de sockets en modo LISTEN bajo el encabezado: "--- SOCKETS EN ESCUCHA (MODO LISTEN) ---"
#    - La explicación conceptual de cómo se resuelven nombres en sistemas distribuidos
#      (nombrado por dirección física de máquina vs nombrado por ID de proceso)
#      bajo la etiqueta: "TEORIA_NOMBRADO_NODO: <explicacion>"
# ------------------------------------------------------------------------------
ejercicio1_diagnostico_red() {
    echo "Ejecutando Ejercicio 1: Diagnóstico de red, interfaces y enrutamiento..."
    mkdir -p soluciones
    # TODO: Escriba su solución debajo de esta línea:

}

# Ejecutar automáticamente si se invoca directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ejercicio1_diagnostico_red
fi
