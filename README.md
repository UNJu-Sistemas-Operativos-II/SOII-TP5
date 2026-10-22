# Trabajo Práctico N° 5: Estructura de los Sistemas Distribuidos

> **Universidad Nacional de Jujuy (UNJu)**  
> **Facultad de Ingeniería — Departamento de Informática**  
> **Cátedra:** Sistemas Operativos II — Ciclo Lectivo 2026  
> **Equipo Docente:** Ing. María Fernanda Vázquez (Titular) | Ing. Fabio Damián Argañaraz Azua (JTP)  
> **Plataformas:** WSL2 (Ubuntu 24.04) | GitHub Classroom | Classmoji  
> **Modalidad:** Individual / Autoevaluativo con Autograding Criptográfico  

---

## 🎯 Objetivos de la Actividad

1. **Comprender la Arquitectura de los Sistemas Distribuidos:** Asimilar la definición fundamental de Tanenbaum (hardware autónomo vs software unificado como única computadora) y la diferenciación esencial entre Sistemas Operativos de Red (SOR) y Sistemas Operativos Distribuidos (SOD).
2. **Auditar Interfaces, Puertos y Enrutamiento en Linux:** Reconocer las herramientas nativas del sistema operativo (`ip`, `ss`, `route`, `/etc/hosts`) para resolver identidades de nodos y sockets en la red.
3. **Modelar Topologías de Red y Métricas de Interconexión:** Calcular el número de enlaces físicos ($L$), el diámetro de red y evaluar el costo de instalación, costo de comunicación y tolerancia a fallos en redes completamente conectadas, en anillo y en estrella.
4. **Dominar el Ciclo de Vida de Llamadas RPC (Remote Procedure Call):** Comprender por qué la ausencia de memoria compartida exige la comunicación mediante paso de mensajes y el rol fundamental del empaquetado (marshaling) y desempaquetado (unmarshaling) en los Stubs de cliente y servidor.
5. **Analizar la Comunicación en Grupo y el Balanceo de Carga:** Identificar las características de grupos abiertos vs cerrados y comparar grupos simétricos (compañeros/peer) frente a grupos jerárquicos (maestro-trabajador / coordinador-workers) evaluando el riesgo de Punto Único de Fallo (SPOF).
6. **Autoevaluación Local y en CI:** Probar la solución localmente con `./test.sh` y `autograder_tp5.py` (rúbrica con valores SHA-256 y salt de cátedra) antes de realizar `git push` a GitHub Classroom.

---

## 👨‍🏫 Demostración Docente vs. Tu Asignación

En la clase inaugural, el docente (Ing. Fabio Argañaraz) proyectó una sesión de Live-Coding con el repositorio **`TP05-demo`**.  
Para este trabajo práctico, debes **adaptar los principios explicados** a los requerimientos específicos de tu enunciado:

| Componente | Demostración en Clase (`TP05-demo`) | Lo que debes resolver en tu TP (`TP05`) |
| :--- | :--- | :--- |
| **Ejercicio 1** | Diagnóstico de red del servidor docente, socket bindings y rutas en `soluciones_demo/diagnostico_servidor_red.txt`. | Diagnóstico de interfaz activa, IP, gateway, resolución en `/etc/hosts` y teoría de nombrado en `soluciones/diagnostico_red_nodo.txt`. |
| **Ejercicio 2** | Modelado de topologías de red para un clúster docente de $N=8$ nodos ($L_{comp}=28, L_{anillo}=8, L_{est}=7$). | Modelado de topologías para un clúster de $N=6$ nodos ($L_{comp}=15, L_{anillo}=6, L_{est}=5$) en `soluciones/analisis_topologias.txt`. |
| **Ejercicio 3** | Simulación RPC de función de hash token en `soluciones_demo/simulacion_rpc_demo.txt`. | Simulación RPC de función de suma (`CALC_SUM:45:55 -> 100`) y fundamentación de mensajes en `soluciones/simulacion_rpc.txt`. |
| **Ejercicio 4** | Simulación de Grupo Compañero (Peer) simétrico de 4 nodos sin SPOF en `soluciones_demo/grupo_companero_demo.txt`. | Simulación de Grupo Jerárquico con coordinador repartiendo 6 jobs a 3 workers (Round-Robin) y análisis de SPOF en `soluciones/balanceo_grupo.txt`. |
| **Ejercicio 5** | Módulo web evaluado con `autograder_tp5_demo.py` y `rubric_tp5_demo.json`. | Módulo web evaluado con `autograder_tp5.py` y `rubric_tp5.json` (hashes SHA-256 + salt de cátedra). |

---

## 📂 Estructura del Repositorio

```text
TP05/
├── .github/
│   └── workflows/
│       └── classroom.yml          # Workflow de evaluación automática en CI (GitHub Actions)
├── soluciones/
│   ├── .gitkeep
│   └── respuestas_tp5.json.template # Plantilla de referencia para la entrega web
├── web/                           # Módulo Web Interactivo (Simulador RPC, Topologías, Drag & Drop)
│   ├── index.html                 # Aplicación web interactiva para navegador
│   ├── styles.css                 # Estilos modo oscuro con Glassmorphism
│   └── app.js                     # Motor de eventos, Drag & Drop y exportador JSON
├── ejercicios.sh                  # Plantilla con las funciones prácticas de consola en Linux (TODOs)
├── test.sh                        # Suite de pruebas automatizadas (/100 Pts)
├── autograder_tp5.py              # Evaluador en Python 3 con clave criptográfica
├── rubric_tp5.json                # Rúbrica pública con hashes SHA-256 y salt
├── CHEATSHEET.md                  # Guía rápida de comandos de red y sistemas distribuidos
├── .gitattributes                 # Normalización de saltos de línea LF (Unix)
├── .gitignore                     # Exclusiones de archivos temporales y claves master
└── README.md                      # Enunciado y guía paso a paso
```

> **Nota de distribución:** `rubric_tp5_master.json` y
> `soluciones/respuestas_tp5.json` son materiales privados o generados por cada
> estudiante. No deben formar parte del repositorio distribuido. El primero está
> excluido mediante `.gitignore` y el segundo se genera al completar la
> actividad web.

---

## 🚀 Guía Metodológica Paso a Paso: Comandos, Salidas y Explicación Pedagógica

```mermaid
flowchart TD
    A["1. Clonar Repo del Alumno"] --> B["2. Explorar y Resolver ejercicios.sh"]
    A --> C["3. Abrir web/index.html en Navegador"]
    C --> D["4. Exportar soluciones/respuestas_tp5.json"]
    B --> E["5. Ejecutar ./test.sh en terminal WSL2"]
    D --> E
    E -->|Falla algún test o autograder (0-80 Pts)| B
    E -->|100/100 Pts ✅| F["6. git commit & git push"]
    F --> G["7. Aprobación en GitHub Actions y Classmoji 🏆"]
```

---

### 💻 Paso 1: Práctica de Consola en `ejercicios.sh` (Detalle por Ejercicio)

Para cada ejercicio, ejecute los comandos en su terminal de **Ubuntu (WSL2)**, observe la salida y comprenda el significado técnico antes de plasmar la solución en [`ejercicios.sh`](./ejercicios.sh):

---

#### 🔹 Ejercicio 1: Diagnóstico de Red, Interfaces y Enrutamiento en Linux (20 Pts)

* **Propósito Pedagógico:** En un sistema distribuido los procesadores son autónomos e independientes. Para comunicarse necesitan resolver nombres en dos capas: identificar el **host físico** (dirección IP) e identificar el **proceso destino** (puerto/socket).

1. **Obtener el nombre del nodo (`hostname`):**
   ```bash
   hostname
   ```
   * **Qué muestra:**
     ```text
     unju-nodo-distribuido
     ```
   * **Explicación para los alumnos:** Representa el identificador simbólico local asignado a este equipo en el espacio de nombres del kernel (`UTS namespace`).

2. **Inspeccionar interfaces de red activas (`ip addr`):**
   ```bash
   ip -brief addr show
   ```
   * **Qué muestra:**
     ```text
     lo               UNKNOWN        127.0.0.1/8 ::1/128 
     eth0             UP             172.28.140.85/20 fe80::215:5dff:fe60:715b/64
     ```
   * **Explicación para los alumnos:**
     * `lo` (**Loopback** / `127.0.0.1`): Interfaz virtual interna del kernel. El tráfico nunca sale a la placa física ni a la red exterior; permite que procesos en el mismo host se comuniquen por sockets TCP/UDP con latencia casi nula.
     * `eth0` (o `wlan0`): Interfaz de red conectada a la subred LAN o adaptador virtual de WSL2. El flag `UP` indica que el enlace está activo y `172.28.140.85/20` es la dirección IPv4 asignada junto con su máscara de subred (prefijo de 20 bits).

3. **Consultar la tabla de enrutamiento y la puerta de enlace (`ip route`):**
   ```bash
   ip route show default
   ```
   * **Qué muestra:**
     ```text
     default via 172.28.128.1 dev eth0 proto kernel onlink
     ```
   * **Explicación para los alumnos:**
     * `default via 172.28.128.1`: Indica que cualquier paquete cuyo destino no pertenezca a la red local será reenviado al **Default Gateway** (`172.28.128.1`). El router o switch de capa 3 se encargará de encaminarlo hacia otros nodos o hacia Internet.
     * `dev eth0`: Especifica la interfaz de salida física/virtual utilizada para alcanzar dicha pasarela.

4. **Verificar resolución estática de nombres (`cat /etc/hosts`):**
   ```bash
   grep "localhost" /etc/hosts
   ```
   * **Qué muestra:**
     ```text
     127.0.0.1       localhost
     ```
   * **Explicación para los alumnos:** Muestra la resolución estática gobernada por el archivo `/etc/hosts` (gestionado mediante `nsswitch.conf`). Permite traducir el nombre `localhost` a la dirección IPv4 `127.0.0.1` de forma inmediata sin emitir consultas recursivas a servidores DNS externos.

5. **Monitorear sockets en escucha (`ss -tuln`):**
   ```bash
   ss -tuln
   ```
   * **Qué muestra:**
     ```text
     Netid  State   Recv-Q  Send-Q   Local Address:Port   Peer Address:Port
     tcp    LISTEN  0       128            0.0.0.0:22               0.0.0.0:*
     tcp    LISTEN  0       511          127.0.0.1:3306             0.0.0.0:*
     ```
   * **Explicación para los alumnos:**
     * `State LISTEN`: El proceso ejecutó la llamada al sistema `listen()` y está a la espera de peticiones de conexión entrantes (`SYN`).
     * `Local Address:Port`: `0.0.0.0:22` indica que el servicio (ej. SSH) acepta conexiones en el puerto 22 desde cualquier interfaz de red del equipo. En cambio, `127.0.0.1:3306` restringe el acceso únicamente a procesos locales.

* **Estructura esperada en `soluciones/diagnostico_red_nodo.txt`:**
  El script debe generar este archivo conteniendo las etiquetas requeridas:
  ```text
  NODO_HOSTNAME: <nombre_del_equipo>
  INTERFAZ_LOOPBACK: 127.0.0.1
  INTERFAZ_ACTIVA: <ej: eth0>
  IP_LOCAL: <ej: 172.28.140.85>
  GATEWAY_DEFAULT: <ej: 172.28.128.1>
  RESOLUCION_LOCAL: 127.0.0.1 localhost
  TEORIA_NOMBRADO_NODO: En sistemas distribuidos, la ausencia de memoria compartida exige resolver nombres en dos capas: dirección IP para identificar el host en la red y puerto/socket o ID global para identificar el proceso destino.
  ```

---

#### 🔹 Ejercicio 2: Modelado y Métricas de Topologías de Red (Clúster N = 6) (20 Pts)

* **Propósito Pedagógico:** Evaluar trade-offs de diseño entre costo de instalación (cantidad de enlaces físicos $L$), costo de comunicación (diámetro y latencia) y tolerancia a fallos/disponibilidad ante caídas de nodos o enlaces.

1. **Topología Completamente Conectada (Full Mesh):**
   * **Fórmula de enlaces:** $L = \frac{N(N-1)}{2} = \frac{6 \times 5}{2} = 15$ enlaces.
   * **Diámetro:** $1$ salto (enlace directo punto a punto entre cualquier par de nodos).
   * **Explicación para los alumnos:** Ofrece la menor latencia posible y máxima tolerancia a particiones (soporta hasta $N-2$ fallos de enlace por nodo sin perder conectividad). Sin embargo, su costo de cableado e interfaces escala cuadráticamente ($O(N^2)$), siendo inviable para redes extensas.

2. **Topología en Anillo (Ring):**
   * **Fórmula de enlaces:** $L = N = 6$ enlaces.
   * **Diámetro:** $\lfloor N/2 \rfloor = \lfloor 6/2 \rfloor = 3$ saltos.
   * **Explicación para los alumnos:** Cada nodo se conecta exclusivamente con dos vecinos adyacentes. El costo de instalación es bajo y lineal ($O(N)$), pero un paquete puede tardar hasta 3 saltos en llegar al extremo opuesto. Si el anillo es bidireccional, soporta el corte de 1 enlace sin desconectar el sistema.

3. **Topología en Estrella (Star):**
   * **Fórmula de enlaces:** $L = N - 1 = 6 - 1 = 5$ enlaces.
   * **Diámetro:** $2$ saltos (desde un nodo periférico al conmutador central y de allí al destino).
   * **Explicación para los alumnos:** Costo de cableado mínimo y centralizado. Su gran debilidad es la existencia de un **Punto Único de Fallo (Single Point of Failure - SPOF)**: si el nodo coordinador o conmutador central colapsa, todo el clúster queda incomunicado.

* **Estructura esperada en `soluciones/analisis_topologias.txt`:**
  ```text
  CLUSTERS_NODOS: 6
  TOPOLOGIA_COMPLETA_ENLACES: 15
  TOPOLOGIA_COMPLETA_DIAMETRO: 1
  TOPOLOGIA_ANILLO_ENLACES: 6
  TOPOLOGIA_ANILLO_DIAMETRO: 3
  TOPOLOGIA_ESTRELLA_ENLACES: 5
  TOPOLOGIA_ESTRELLA_DIAMETRO: 2
  CRITERIO_COSTO_INSTALACION: La red completa requiere L=15 enlaces O(N^2), mientras que anillo y estrella requieren O(N) enlaces (6 y 5 respectivamente).
  CRITERIO_COSTO_COMUNICACION: La red completa tiene diametro optimo de 1 salto; estrella tiene diametro 2; anillo alcanza 3 saltos.
  CRITERIO_DISPONIBILIDAD_FALLOS: La red completa ofrece maxima disponibilidad. La red en estrella presenta un Punto Unico de Fallo (SPOF) critico en el nodo central.
  ```

---

#### 🔹 Ejercicio 3: Simulación de Llamada a Procedimiento Remoto (RPC) (20 Pts)

* **Propósito Pedagógico:** En un sistema distribuido **no existe memoria compartida**. Por ende, los programas no pueden invocar rutinas pasando punteros a variables en RAM. El paradigma RPC (*Remote Procedure Call*, propuesto por Birrell y Nelson y analizado por Tanenbaum) encapsula esta complejidad mediante **Stubs** (talones) en cliente y servidor que serializan la llamada a través de mensajes de red.

1. **Paso 1: Invocación en el Cliente y Marshaling:**
   * El proceso cliente invoca `calc_sum(45, 55)` como si fuera una función local ordinaria.
   * El **Client Stub** intercepta la llamada y empaqueta el nombre del procedimiento y los argumentos en un búfer o mensaje estructurado:
     ```text
     RPC_REQ:CALC_SUM:45:55
     ```
2. **Paso 2: Transmisión por el Canal de Red:**
   * El kernel local toma el datagrama y lo transmite mediante protocolos de transporte (TCP/UDP) a través de la red hacia el host servidor.
3. **Paso 3: Recepción y Unmarshaling en el Servidor:**
   * El kernel remoto entrega el paquete al **Server Stub**, quien deserializa los parámetros (`CALC_SUM`, `45`, `55`) y llama a la implementación física del procedimiento en el Servidor.
4. **Paso 4: Ejecución y Retorno:**
   * El servidor calcula $45 + 55 = 100$, empaqueta el resultado y lo transmite de regreso al cliente, donde el Client Stub lo devuelve a la aplicación llamadora.

* **Estructura esperada en `soluciones/simulacion_rpc.txt`:**
  ```text
  PROCEDIMIENTO_SOLICITADO: CALC_SUM
  PARAMETROS_ENTRADA: 45 55
  CLIENT_STUB_MARSHAL: RPC_REQ:CALC_SUM:45:55
  RED_TRANSMISION_PACKET: ENVIADO_A_TRAVES_DEL_CANAL
  SERVER_STUB_UNMARSHAL: RECIBIDO_Y_DESEMPAQUETADO
  RPC_RESULTADO: 100
  FUNDAMENTO_TEORICO_MENSAJES: En sistemas distribuidos no existe memoria compartida entre procesadores; por ello, la comunicacion se basa exclusivamente en paso de mensajes empaquetados mediante Stubs que serializan y deserializan argumentos.
  ```

---

#### 🔹 Ejercicio 4: Grupo Jerárquico y Balanceo de Carga Round-Robin (20 Pts)

* **Propósito Pedagógico:** En la comunicación grupal (uno a muchos), los grupos pueden ser simétricos (**Grupo Compañero / Peer**, donde todos son iguales y no hay SPOF) o centralizados (**Grupo Jerárquico**, con un coordinador y múltiples trabajadores).

1. **Dinámica del Coordinador:**
   * El coordinador recibe 6 trabajos (`JOB_1` a `JOB_6`) y los distribuye equitativamente aplicando la política **Round-Robin** (por turnos rotativos) entre 3 trabajadores concurrentes (`WORKER_A`, `WORKER_B`, `WORKER_C`).
2. **Secuencia de Asignaciones:**
   * $JOB_1 \rightarrow WORKER\_A$
   * $JOB_2 \rightarrow WORKER\_B$
   * $JOB_3 \rightarrow WORKER\_C$
   * $JOB_4 \rightarrow WORKER\_A$
   * $JOB_5 \rightarrow WORKER\_B$
   * $JOB_6 \rightarrow WORKER\_C$
3. **Balance de Carga Resultante:**
   * Cada worker procesa exactamente **2 tareas** ($6 / 3 = 2$).
4. **Discusión de Vulnerabilidad (SPOF):**
   * **Ventaja del Grupo Jerárquico:** Decisiones ágiles; el coordinador asigna tareas sin necesidad de consultas cruzadas ni votaciones entre los trabajadores.
   * **Desventaja Crítica:** El coordinador representa un **Punto Único de Fallo (SPOF)**. Si el coordinador colapsa, el grupo se detiene por completo a menos que se implemente un algoritmo de elección de líder (como Bully o Ring).

* **Estructura esperada en `soluciones/balanceo_grupo.txt`:**
  ```text
  COORDINADOR: ASIGNACION_ROUND_ROBIN
  TAREAS_TOTALES: 6
  ASIGNACION_JOB_1: WORKER_A
  ASIGNACION_JOB_2: WORKER_B
  ASIGNACION_JOB_3: WORKER_C
  ASIGNACION_JOB_4: WORKER_A
  ASIGNACION_JOB_5: WORKER_B
  ASIGNACION_JOB_6: WORKER_C
  WORKER_A_TAREAS: 2
  WORKER_B_TAREAS: 2
  WORKER_C_TAREAS: 2
  ANALISIS_SPOF_COORDINADOR: En un grupo jerarquico el coordinador centraliza las decisiones agilizando el despacho, pero constituye un Punto Unico de Fallo (SPOF); si el coordinador cae el grupo se detiene, a diferencia del grupo companero simetrico.
  ```

---

### 🌐 Paso 2: Resolver la Teoría y Simulador en `web/index.html` (20 Pts)

1. Abra [`web/index.html`](./web/index.html) en su navegador preferido (Chrome, Edge, Firefox, Brave).
2. Complete sus datos personales (Apellido y Nombre, Legajo L.U. y Usuario de GitHub).
3. Responda las **5 preguntas conceptuales** de Sistemas Distribuidos (Sección 1).
4. Configure los **6 switches segmentados** de clasificación binaria (SOR vs SOD, Abierto vs Cerrado, etc.) (Sección 2).
5. Interactúe con el **Simulador Visual de Invocación RPC** observando el desplazamiento interactivo del paquete y el cálculo de latencia RTT, y complete los 4 parámetros teóricos (Sección 3).
6. Ordene cronológicamente las **6 etapas del ciclo de vida RPC** en el tablero Drag & Drop (`CLIENT_CALL` $\rightarrow$ `CLIENT_STUB_MARSHAL` $\rightarrow$ `KERNEL_SEND_NET` $\rightarrow$ `KERNEL_RECV_NET` $\rightarrow$ `SERVER_STUB_UNMARSHAL` $\rightarrow$ `SERVER_EXEC_RETURN`) (Sección 4).
7. Configure las propiedades de principios de diseño y tolerancia a fallos (Sección 5).
8. Al alcanzar el **100% (25/25 ítems académicos)**, se disparará la animación de confetti 🎊. Haga clic en **`📥 Descargar respuestas_tp5.json`** y guarde el archivo en la carpeta `soluciones/` de este repositorio.

---

### 🧪 Paso 3: Ejecución y Validación de la Suite de Pruebas

En su terminal de **Ubuntu (WSL2)** o Linux nativo, otorgue permisos de ejecución y lance la suite:
```bash
chmod +x test.sh ejercicios.sh
./test.sh
```

#### A. Salida Inicial Esperada (Al clonar el repositorio, 0/100 Pts):
```text
================================================================
     UNJu — SISTEMAS OPERATIVOS II — EVALUACIÓN AUTOMÁTICA TP 5   
================================================================

Verificando Ejercicio 1: Diagnóstico de red y enrutamiento...
  ✗ Falta el archivo 'soluciones/diagnostico_red_nodo.txt' o está vacío.
  ✗ [FAIL] Ejercicio 1 falló (+0 Pts)

Verificando Ejercicio 2: Modelado de topologías de red (N=6)...
  ✗ Falta el archivo 'soluciones/analisis_topologias.txt' o está vacío.
  ✗ [FAIL] Ejercicio 2 falló (+0 Pts)

Verificando Ejercicio 3: Simulación de llamada RPC...
  ✗ Falta el archivo 'soluciones/simulacion_rpc.txt' o está vacío.
  ✗ [FAIL] Ejercicio 3 falló (+0 Pts)

Verificando Ejercicio 4: Grupo Jerárquico y Balanceo Round-Robin...
  ✗ Falta el archivo 'soluciones/balanceo_grupo.txt' o está vacío.
  ✗ [FAIL] Ejercicio 4 falló (+0 Pts)

Verificando Ejercicio 5: Autoevaluación Web (respuestas_tp5.json)...
  ✗ Falta el archivo 'soluciones/respuestas_tp5.json'.
  ℹ Debe abrir 'web/index.html', resolver las actividades y mover el archivo descargado a 'soluciones/'.
  ✗ [FAIL] Ejercicio 5 falló (+0 Pts)

================================================================
                       RESUMEN DE CALIFICACIÓN                  
================================================================
  PUNTAJE FINAL: 0 / 100 Pts (0%)
  ESTADO: TP 5 INCOMPLETO — 5 ejercicio(s) requieren atención ⚠️
================================================================
```

#### B. Autoevaluación Criptográfica con Python:
Para inspeccionar el resultado del módulo web sin ejecutar toda la suite de scripts, ejecute:
```bash
python3 autograder_tp5.py soluciones/respuestas_tp5.json --rubric rubric_tp5.json
```
* **Qué muestra:** Reporte desglosado por sección, confirmando cada ítem mediante hashes SHA-256 e indicando capítulos específicos de repaso en caso de discrepancias.

#### C. Salida Final Esperada (Aprobación al 100%):
```text
================================================================
     UNJu — SISTEMAS OPERATIVOS II — EVALUACIÓN AUTOMÁTICA TP 5   
================================================================

Verificando Ejercicio 1: Diagnóstico de red y enrutamiento...
  ✓ [PASS] Ejercicio 1 completado correctamente (+20 Pts)

Verificando Ejercicio 2: Modelado de topologías de red (N=6)...
  ✓ [PASS] Ejercicio 2 completado correctamente (+20 Pts)

Verificando Ejercicio 3: Simulación de llamada RPC...
  ✓ [PASS] Ejercicio 3 completado correctamente (+20 Pts)

Verificando Ejercicio 4: Grupo Jerárquico y Balanceo Round-Robin...
  ✓ [PASS] Ejercicio 4 completado correctamente (+20 Pts)

Verificando Ejercicio 5: Autoevaluación Web (respuestas_tp5.json)...
  ✓ [PASS] Módulo Web validado con autograder_tp5.py (+20 Pts)

================================================================
                       RESUMEN DE CALIFICACIÓN                  
================================================================
  PUNTAJE FINAL: 100 / 100 Pts (100%)
  ESTADO: ¡FELICITACIONES! TP 5 COMPLETADO EXITOSAMENTE ✅
================================================================
```

---

### 📤 Paso 4: Envío a GitHub Classroom y Classmoji

Una vez obtenido el puntaje máximo (**100 / 100 Puntos**), confirme sus cambios y envíelos al repositorio remoto:
```bash
git add .
git commit -m "Entrega Trabajo Practico 5 - Sistemas Distribuidos"
git push origin main
```
El flujo de CI en **GitHub Actions** ejecutará la misma suite de pruebas en un entorno Ubuntu limpio y actualizará su progreso automáticamente en **Classmoji** (`app.classmoji.io`).

