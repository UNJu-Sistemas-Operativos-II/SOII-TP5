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
# NOTA PEDAGÓGICA:
# En la clase de apertura, el docente (Ing. Fabio Argañaraz) demostró el modelado
# de redes, topologías y comunicación por mensajes con el repositorio demo (TP05-demo).
# Para este trabajo práctico, debe adaptar los conceptos y técnicas explicados
# a los enunciados y parámetros específicos indicados a continuación.
# ==============================================================================

export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin

# ------------------------------------------------------------------------------
# EJERCICIO 1: Diagnóstico de Red, Interfaces y Enrutamiento en Linux (20 Pts)
# ------------------------------------------------------------------------------
# Consigna:
# 1. En un sistema distribuido, cada nodo autónomo debe auditar su conectividad
#    física y lógica con el resto de los procesadores de la red.
# 2. Cree el archivo 'soluciones/diagnostico_red_nodo.txt' conteniendo:
#    - El nombre del equipo local ('hostname') en la línea: "NODO_HOSTNAME: <hostname>"
#    - La interfaz de loopback con su IP fija: "INTERFAZ_LOOPBACK: 127.0.0.1"
#    - La interfaz de red activa principal en formato: "INTERFAZ_ACTIVA: <iface>"
#    - La dirección IPv4 de dicha interfaz en formato: "IP_LOCAL: <ip>"
#    - La puerta de enlace predeterminada (default gateway): "GATEWAY_DEFAULT: <gateway>"
#    - La verificación de resolución de nombres consultando '/etc/hosts', registrando
#      la línea correspondiente a localhost: "RESOLUCION_LOCAL: <linea_de_/etc/hosts>"
#    - La explicación conceptual de cómo se resuelven nombres en sistemas distribuidos
#      (nombrado por dirección física de máquina vs nombrado por ID de proceso)
#      bajo la etiqueta: "TEORIA_NOMBRADO_NODO: <explicacion>"
# ------------------------------------------------------------------------------
ejercicio1_diagnostico_red() {
    echo "Ejecutando Ejercicio 1: Diagnóstico de red, interfaces y enrutamiento..."
    mkdir -p soluciones
    # TODO: Escriba su solución debajo de esta línea:

}

# ------------------------------------------------------------------------------
# EJERCICIO 2: Modelado y Métricas de Topologías de Red para Clúster (20 Pts)
# ------------------------------------------------------------------------------
# Consigna:
# 1. Un clúster de cómputo distribuido está conformado por N = 6 nodos de procesamiento.
# 2. Genere el archivo 'soluciones/analisis_topologias.txt' con los cálculos teóricos
#    y análisis comparativo para las siguientes topologías:
#    a) Red Completamente Conectada:
#       - Enlaces físicos requeridos: L = N*(N-1)/2 = 6*(5)/2 = 15
#       - Diámetro de la red: 1 salto
#       - Etiqueta: "TOPOLOGIA_COMPLETA_ENLACES: 15"
#       - Etiqueta: "TOPOLOGIA_COMPLETA_DIAMETRO: 1"
#    b) Red en Anillo (Ring):
#       - Enlaces físicos requeridos: L = N = 6
#       - Diámetro de la red: N/2 = 3 saltos
#       - Etiqueta: "TOPOLOGIA_ANILLO_ENLACES: 6"
#       - Etiqueta: "TOPOLOGIA_ANILLO_DIAMETRO: 3"
#    c) Red en Estrella (Star):
#       - Enlaces físicos requeridos: L = N - 1 = 5
#       - Diámetro de la red: 2 saltos
#       - Etiqueta: "TOPOLOGIA_ESTRELLA_ENLACES: 5"
#       - Etiqueta: "TOPOLOGIA_ESTRELLA_DIAMETRO: 2"
# 3. Incluya el análisis comparativo según los tres criterios de cátedra (Diapositivas 15-18):
#    - Costo de Instalación (orden de complejidad de enlaces).
#    - Costo de Comunicación y Latencia (impacto del diámetro).
#    - Disponibilidad y Tolerancia a Fallos (identificando la presencia de SPOF en estrella).
# ------------------------------------------------------------------------------
ejercicio2_topologias_cluster() {
    echo "Ejecutando Ejercicio 2: Modelado de topologías de red (N=6)..."
    mkdir -p soluciones
    # TODO: Escriba su solución debajo de esta línea:

}

# ------------------------------------------------------------------------------
# EJERCICIO 3: Simulación de Llamada a Procedimiento Remoto (RPC) (20 Pts)
# ------------------------------------------------------------------------------
# Consigna:
# 1. En sistemas distribuidos no existe memoria compartida; por lo tanto, la invocación
#    de funciones entre nodos remotos se realiza mediante paso de mensajes empaquetados (RPC).
# 2. Simule la ejecución de una llamada RPC para invocar el procedimiento remoto 'CALC_SUM'
#    con los parámetros '45' y '55'.
# 3. Genere el archivo 'soluciones/simulacion_rpc.txt' registrando el flujo paso a paso:
#    - Procedimiento solicitado: "PROCEDIMIENTO_SOLICITADO: CALC_SUM"
#    - Parámetros de entrada: "PARAMETROS_ENTRADA: 45 55"
#    - Etapa 1: Client Stub (Marshaling / serialización de parámetros en mensaje de red):
#      "CLIENT_STUB_MARSHAL: RPC_REQ:CALC_SUM:45:55"
#    - Etapa 2: Transmisión por el medio de red simulado:
#      "RED_TRANSMISION_PACKET: ENVIADO_A_TRAVES_DEL_CANAL"
#    - Etapa 3: Server Stub (Unmarshaling / deserialización en nodo servidor):
#      "SERVER_STUB_UNMARSHAL: RECIBIDO_Y_DESEMPAQUETADO"
#    - Etapa 4: Ejecución en el servidor y respuesta:
#      "RPC_RESULTADO: 100"
#    - Fundamentación teórica de cátedra (Tanenbaum - Cap. 2):
#      "FUNDAMENTO_TEORICO_MENSAJES: En sistemas distribuidos no existe memoria compartida..."
#      explicando por qué no se pueden pasar punteros de memoria y la función de los Stubs.
# ------------------------------------------------------------------------------
ejercicio3_simulacion_rpc() {
    echo "Ejecutando Ejercicio 3: Simulación de llamada RPC..."
    mkdir -p soluciones
    # TODO: Escriba su solución debajo de esta línea:

}

# ------------------------------------------------------------------------------
# EJERCICIO 4: Grupo Jerárquico y Balanceo de Carga Round-Robin (20 Pts)
# ------------------------------------------------------------------------------
# Consigna:
# 1. En un Grupo Jerárquico (Diapositivas 33 a 35), un proceso coordinador centralizado
#    recibe tareas y las distribuye entre los procesos trabajadores (workers).
# 2. Simule un clúster con 3 trabajadores: 'WORKER_A', 'WORKER_B', 'WORKER_C'.
# 3. El coordinador recibe 6 tareas: 'JOB_1', 'JOB_2', 'JOB_3', 'JOB_4', 'JOB_5', 'JOB_6'.
# 4. Aplique la política de balanceo Round-Robin asignando secuencialmente cada tarea:
#    - JOB_1 -> WORKER_A
#    - JOB_2 -> WORKER_B
#    - JOB_3 -> WORKER_C
#    - JOB_4 -> WORKER_A
#    - JOB_5 -> WORKER_B
#    - JOB_6 -> WORKER_C
# 5. Genere el archivo 'soluciones/balanceo_grupo.txt' con:
#    - Detalle de asignación de cada uno de los 6 jobs.
#    - Conteo de tareas por trabajador:
#      "WORKER_A_TAREAS: 2"
#      "WORKER_B_TAREAS: 2"
#      "WORKER_C_TAREAS: 2"
#    - Análisis de la vulnerabilidad crítica del grupo jerárquico frente al grupo compañero
#      bajo la etiqueta: "ANALISIS_SPOF_COORDINADOR: <explicacion>"
#      explicando por qué el coordinador es un Punto Único de Fallo (Single Point of Failure).
# ------------------------------------------------------------------------------
ejercicio4_balanceo_grupo() {
    echo "Ejecutando Ejercicio 4: Grupo Jerárquico y Balanceo Round-Robin..."
    mkdir -p soluciones
    # TODO: Escriba su solución debajo de esta línea:

}
