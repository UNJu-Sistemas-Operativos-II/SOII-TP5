/**
 * ==============================================================================
 * SISTEMAS OPERATIVOS II - UNJu - FACULTAD DE INGENIERÍA (2026)
 * APLICACIÓN WEB INTERACTIVA — TRABAJO PRÁCTICO N° 5 (Sistemas Distribuidos)
 * ==============================================================================
 */

document.addEventListener('DOMContentLoaded', () => {
    const STORAGE_KEY = 'UNJU_SO2_TP5_STATE_V1';
    const TOTAL_ACADEMIC_ITEMS = 25;

    // Estado de la aplicación
    const state = {
        estudiante: {
            nombre: '',
            legajo: '',
            github: ''
        },
        seccion1_conceptos: {
            q1_definicion_sd: null,
            q2_sor_vs_sod: null,
            q3_migracion_procesos: null,
            q4_comunicacion_tanenbaum: null,
            q5_principio_transparencia: null
        },
        seccion2_switches: {
            sw1_tipo_sistema: null,
            sw2_origen_mensajes: null,
            sw3_estructura_grupo: null,
            sw4_conmutacion_red: null,
            sw5_resolucion_contienda: null,
            sw6_administracion_membresia: null
        },
        seccion3_laboratorio_rpc: {
            topologia_completa_enlaces: null,
            topologia_anillo_enlaces: null,
            topologia_estrella_diametro: null,
            rpc_mecanismo_comunicacion: null
        },
        seccion4_flujo_rpc: {
            orden_llamada_rpc: [null, null, null, null, null, null]
        },
        seccion5_principios_diseno: {
            principio_transparencia: null,
            principio_escalabilidad: null,
            vulnerabilidad_spof: null,
            direccionamiento_grupos: null
        }
    };

    let hasTriggeredConfetti = false;

    // Elementos DOM Principales
    const progressFill = document.getElementById('progress-fill');
    const progressLabel = document.getElementById('progress-label');
    const btnDownloadTop = document.getElementById('btn-download-json');
    const btnDownloadBottom = document.getElementById('btn-download-bottom');
    const btnThemeToggle = document.getElementById('btn-theme-toggle');
    const btnImport = document.getElementById('btn-import-json');
    const fileImportInput = document.getElementById('file-import-input');
    const btnReset = document.getElementById('btn-reset-form');
    const btnRunRpc = document.getElementById('btn-run-rpc-sim');
    const rpcLogMonitor = document.getElementById('rpc-log-monitor');

    // --------------------------------------------------------------------------
    // 1. Manejo del Tema Claro / Oscuro
    // --------------------------------------------------------------------------
    const currentTheme = localStorage.getItem('SO2_THEME') || 'dark';
    document.documentElement.setAttribute('data-theme', currentTheme);

    btnThemeToggle.addEventListener('click', () => {
        const theme = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('SO2_THEME', theme);
        showToast(`Tema cambiado a ${theme === 'dark' ? 'Oscuro' : 'Claro'}`);
    });

    // --------------------------------------------------------------------------
    // 2. Notificaciones Toast
    // --------------------------------------------------------------------------
    function showToast(message, icon = 'ℹ️') {
        const toast = document.getElementById('toast');
        const toastMsg = document.getElementById('toast-message');
        const toastIcon = document.getElementById('toast-icon');
        if (!toast) return;

        toastMsg.textContent = message;
        toastIcon.textContent = icon;
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3200);
    }

    // --------------------------------------------------------------------------
    // 3. Cálculo de Progreso Estricto Académico (Regla Anti-Inflación)
    // --------------------------------------------------------------------------
    function updateProgress() {
        let completed = 0;

        // Sección 1: 5 radio cards
        for (const key in state.seccion1_conceptos) {
            if (state.seccion1_conceptos[key]) completed++;
        }

        // Sección 2: 6 switches
        for (const key in state.seccion2_switches) {
            if (state.seccion2_switches[key]) completed++;
        }

        // Sección 3: 4 selects laboratorio
        for (const key in state.seccion3_laboratorio_rpc) {
            if (state.seccion3_laboratorio_rpc[key]) completed++;
        }

        // Sección 4: 6 slots Drag & Drop
        state.seccion4_flujo_rpc.orden_llamada_rpc.forEach(token => {
            if (token) completed++;
        });

        // Sección 5: 4 selects principios
        for (const key in state.seccion5_principios_diseno) {
            if (state.seccion5_principios_diseno[key]) completed++;
        }

        const pct = Math.round((completed / TOTAL_ACADEMIC_ITEMS) * 100);
        progressFill.style.width = `${pct}%`;
        progressLabel.textContent = `${pct}% (${completed}/${TOTAL_ACADEMIC_ITEMS})`;

        // Validación de habilitación de descarga
        const nombre = (document.getElementById('alumno-nombre')?.value || '').trim();
        const legajo = (document.getElementById('alumno-legajo')?.value || '').trim();
        const isReady = (completed === TOTAL_ACADEMIC_ITEMS) && (nombre.length > 0) && (legajo.length > 0);

        btnDownloadTop.disabled = !isReady;
        if (btnDownloadBottom) btnDownloadBottom.disabled = !isReady;

        if (pct === 100 && !hasTriggeredConfetti) {
            triggerConfetti();
            hasTriggeredConfetti = true;
            showToast('¡Felicitaciones! Has completado el 100% de las actividades.', '🏆');
        } else if (pct < 100) {
            hasTriggeredConfetti = false;
        }

        saveToLocalStorage();
    }

    function triggerConfetti() {
        if (typeof confetti === 'function') {
            confetti({
                particleCount: 100,
                spread: 70,
                origin: { y: 0.6 }
            });
        }
    }

    // --------------------------------------------------------------------------
    // 4. Datos del Estudiante
    // --------------------------------------------------------------------------
    const inputNombre = document.getElementById('alumno-nombre');
    const inputLegajo = document.getElementById('alumno-legajo');
    const inputGithub = document.getElementById('alumno-github');

    [inputNombre, inputLegajo, inputGithub].forEach(input => {
        if (input) {
            input.addEventListener('input', () => {
                state.estudiante.nombre = inputNombre.value;
                state.estudiante.legajo = inputLegajo.value;
                state.estudiante.github = inputGithub.value;
                updateProgress();
            });
        }
    });

    // --------------------------------------------------------------------------
    // 5. Sección 1: Radio Cards
    // --------------------------------------------------------------------------
    const radioBlocks = document.querySelectorAll('.question-block');
    radioBlocks.forEach(block => {
        const qid = block.getAttribute('data-qid');
        const radios = block.querySelectorAll('input[type="radio"]');

        radios.forEach(radio => {
            radio.addEventListener('change', () => {
                if (radio.checked) {
                    state.seccion1_conceptos[qid] = radio.value;
                    block.querySelectorAll('.radio-card').forEach(c => c.classList.remove('selected'));
                    radio.closest('.radio-card')?.classList.add('selected');
                    updateProgress();
                }
            });
        });
    });

    // --------------------------------------------------------------------------
    // 6. Sección 2: Switches Segmentados
    // --------------------------------------------------------------------------
    const switchItems = document.querySelectorAll('.switch-item');
    switchItems.forEach(item => {
        const swid = item.getAttribute('data-swid');
        const buttons = item.querySelectorAll('.segment-btn');

        buttons.forEach(btn => {
            btn.addEventListener('click', () => {
                buttons.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                state.seccion2_switches[swid] = btn.getAttribute('data-val');
                updateProgress();
            });
        });
    });

    // --------------------------------------------------------------------------
    // 7. Sección 3 y 5: Selects Normalizados
    // --------------------------------------------------------------------------
    const academicSelects = document.querySelectorAll('.select-academic');
    academicSelects.forEach(select => {
        const qid = select.getAttribute('data-qid');
        select.addEventListener('change', () => {
            const val = select.value || null;
            if (qid in state.seccion3_laboratorio_rpc) {
                state.seccion3_laboratorio_rpc[qid] = val;
            } else if (qid in state.seccion5_principios_diseno) {
                state.seccion5_principios_diseno[qid] = val;
            }
            updateProgress();
        });
    });

    // --------------------------------------------------------------------------
    // 8. Animación Interactiva del Ciclo RPC
    // --------------------------------------------------------------------------
    if (btnRunRpc) {
        btnRunRpc.addEventListener('click', () => {
            const nodes = ['node-client', 'node-cstub', 'node-net', 'node-sstub', 'node-server'];
            const logs = [
                '1/5 [CLIENTE] Aplicación invoca llamada remota calc_hash(token) vía Client Stub...',
                '2/5 [CLIENT STUB] Empaquetando parámetros en formato de mensaje de red (Marshaling)...',
                '3/5 [RED] Transmitiendo paquete por el canal TCP/IP. Medición RTT: 14 ms...',
                '4/5 [SERVER STUB] Recibiendo mensaje y desempaquetando parámetros (Unmarshaling)...',
                '5/5 [SERVIDOR] Procedimiento ejecutado con éxito. Enviando respuesta al cliente. ✅'
            ];

            btnRunRpc.disabled = true;
            let step = 0;

            function runStep() {
                nodes.forEach(id => document.getElementById(id)?.classList.remove('active'));
                if (step < nodes.length) {
                    const currentNode = document.getElementById(nodes[step]);
                    if (currentNode) currentNode.classList.add('active');
                    if (rpcLogMonitor) rpcLogMonitor.textContent = logs[step];
                    step++;
                    setTimeout(runStep, 700);
                } else {
                    nodes.forEach(id => document.getElementById(id)?.classList.remove('active'));
                    if (rpcLogMonitor) rpcLogMonitor.textContent = 'Ciclo RPC completado con éxito. Estado: RTT=14ms | OK';
                    btnRunRpc.disabled = false;
                }
            }

            runStep();
        });
    }

    // --------------------------------------------------------------------------
    // 9. Sección 4: Drag & Drop (SortableJS + Fallback)
    // --------------------------------------------------------------------------
    const actionBank = document.getElementById('action-bank');
    const dropzones = document.querySelectorAll('.slot-dropzone');

    function renderDndChip(token) {
        const bankChip = actionBank.querySelector(`[data-token="${token}"]`);
        const label = bankChip ? bankChip.innerHTML : token;

        const chip = document.createElement('div');
        chip.className = 'dnd-chip assigned';
        chip.setAttribute('data-token', token);
        chip.innerHTML = `${label} <button class="chip-remove" title="Quitar">✕</button>`;

        chip.querySelector('.chip-remove').addEventListener('click', (e) => {
            e.stopPropagation();
            removeChipFromSlot(chip);
        });

        return chip;
    }

    function removeChipFromSlot(chip) {
        const slot = chip.closest('.slot-dropzone');
        if (!slot) return;
        const slotIdx = parseInt(slot.getAttribute('data-slot'), 10);
        state.seccion4_flujo_rpc.orden_llamada_rpc[slotIdx] = null;
        chip.remove();
        syncBankVisibility();
        updateProgress();
    }

    function syncBankVisibility() {
        const assignedTokens = state.seccion4_flujo_rpc.orden_llamada_rpc.filter(Boolean);
        actionBank.querySelectorAll('.dnd-chip').forEach(chip => {
            const t = chip.getAttribute('data-token');
            if (assignedTokens.includes(t)) {
                chip.style.display = 'none';
            } else {
                chip.style.display = 'inline-flex';
            }
        });
    }

    function assignTokenToSlot(token, slotIdx) {
        if (slotIdx < 0 || slotIdx >= 6) return;
        const targetSlot = document.querySelector(`.slot-dropzone[data-slot="${slotIdx}"]`);
        if (!targetSlot) return;

        targetSlot.innerHTML = '';
        targetSlot.appendChild(renderDndChip(token));
        state.seccion4_flujo_rpc.orden_llamada_rpc[slotIdx] = token;
        syncBankVisibility();
        updateProgress();
    }

    // Inicializar SortableJS si está disponible
    if (typeof Sortable !== 'undefined' && actionBank) {
        Sortable.create(actionBank, {
            group: { name: 'rpc-flow', pull: 'clone', put: false },
            sort: false,
            animation: 150
        });

        dropzones.forEach(zone => {
            Sortable.create(zone, {
                group: 'rpc-flow',
                animation: 150,
                onAdd: function (evt) {
                    const item = evt.item;
                    const token = item.getAttribute('data-token');
                    const slotIdx = parseInt(zone.getAttribute('data-slot'), 10);
                    item.remove();
                    assignTokenToSlot(token, slotIdx);
                }
            });
        });
    }

    // Soporte Click-To-Assign (Alternativa táctil / accesible)
    actionBank.querySelectorAll('.dnd-chip').forEach(chip => {
        chip.addEventListener('click', () => {
            const token = chip.getAttribute('data-token');
            const firstEmptyIdx = state.seccion4_flujo_rpc.orden_llamada_rpc.findIndex(val => val === null);
            if (firstEmptyIdx !== -1) {
                assignTokenToSlot(token, firstEmptyIdx);
            } else {
                showToast('Todas las etapas están ocupadas. Remueva una para reemplazarla.', '⚠️');
            }
        });
    });

    // --------------------------------------------------------------------------
    // 10. Persistencia LocalStorage
    // --------------------------------------------------------------------------
    function saveToLocalStorage() {
        try {
            localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
        } catch (e) {
            console.error('Error al guardar en localStorage', e);
        }
    }

    function restoreFromState(saved) {
        if (!saved) return;

        // Estudiante
        if (saved.estudiante) {
            state.estudiante = { ...saved.estudiante };
            if (inputNombre) inputNombre.value = saved.estudiante.nombre || '';
            if (inputLegajo) inputLegajo.value = saved.estudiante.legajo || '';
            if (inputGithub) inputGithub.value = saved.estudiante.github || '';
        }

        // Sección 1
        if (saved.seccion1_conceptos) {
            state.seccion1_conceptos = { ...saved.seccion1_conceptos };
            for (const qid in saved.seccion1_conceptos) {
                const val = saved.seccion1_conceptos[qid];
                if (val) {
                    const radio = document.querySelector(`input[name="${qid}"][value="${val}"]`);
                    if (radio) {
                        radio.checked = true;
                        radio.closest('.radio-card')?.classList.add('selected');
                    }
                }
            }
        }

        // Sección 2
        if (saved.seccion2_switches) {
            state.seccion2_switches = { ...saved.seccion2_switches };
            for (const swid in saved.seccion2_switches) {
                const val = saved.seccion2_switches[swid];
                if (val) {
                    const btn = document.querySelector(`.switch-item[data-swid="${swid}"] .segment-btn[data-val="${val}"]`);
                    if (btn) {
                        btn.closest('.segment-control')?.querySelectorAll('.segment-btn').forEach(b => b.classList.remove('active'));
                        btn.classList.add('active');
                    }
                }
            }
        }

        // Sección 3
        if (saved.seccion3_laboratorio_rpc) {
            state.seccion3_laboratorio_rpc = { ...saved.seccion3_laboratorio_rpc };
            for (const qid in saved.seccion3_laboratorio_rpc) {
                const val = saved.seccion3_laboratorio_rpc[qid];
                if (val) {
                    const select = document.getElementById(qid);
                    if (select) select.value = val;
                }
            }
        }

        // Sección 4
        if (saved.seccion4_flujo_rpc && Array.isArray(saved.seccion4_flujo_rpc.orden_llamada_rpc)) {
            dropzones.forEach(z => z.innerHTML = '');
            saved.seccion4_flujo_rpc.orden_llamada_rpc.forEach((token, idx) => {
                if (token) assignTokenToSlot(token, idx);
            });
        }

        // Sección 5
        if (saved.seccion5_principios_diseno) {
            state.seccion5_principios_diseno = { ...saved.seccion5_principios_diseno };
            for (const qid in saved.seccion5_principios_diseno) {
                const val = saved.seccion5_principios_diseno[qid];
                if (val) {
                    const select = document.getElementById(qid);
                    if (select) select.value = val;
                }
            }
        }

        updateProgress();
    }

    // Cargar estado inicial
    try {
        const raw = localStorage.getItem(STORAGE_KEY);
        if (raw) {
            restoreFromState(JSON.parse(raw));
        }
    } catch (e) {
        console.error('Error al restaurar estado', e);
    }

    // --------------------------------------------------------------------------
    // 11. Exportar e Importar JSON
    // --------------------------------------------------------------------------
    function downloadJson() {
        const exportData = {
            estudiante: {
                nombre: (inputNombre.value || '').trim(),
                legajo: (inputLegajo.value || '').trim(),
                github: (inputGithub.value || '').trim()
            },
            tp_id: 'SOII-2026-TP5',
            seccion1_conceptos: state.seccion1_conceptos,
            seccion2_switches: state.seccion2_switches,
            seccion3_laboratorio_rpc: state.seccion3_laboratorio_rpc,
            seccion4_flujo_rpc: state.seccion4_flujo_rpc,
            seccion5_principios_diseno: state.seccion5_principios_diseno
        };

        const blob = new Blob([JSON.stringify(exportData, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'respuestas_tp5.json';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        showToast('Archivo respuestas_tp5.json generado exitosamente.', '📥');
    }

    btnDownloadTop.addEventListener('click', downloadJson);
    if (btnDownloadBottom) btnDownloadBottom.addEventListener('click', downloadJson);

    // Importación de archivo
    btnImport.addEventListener('click', () => fileImportInput.click());
    fileImportInput.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = (evt) => {
            try {
                const imported = JSON.parse(evt.target.result);
                restoreFromState(imported);
                showToast('Respuestas cargadas exitosamente desde archivo.', '📂');
            } catch (err) {
                showToast('Error: archivo JSON inválido.', '❌');
            }
        };
        reader.readAsText(file);
        fileImportInput.value = '';
    });

    // Reiniciar formulario
    btnReset.addEventListener('click', () => {
        if (confirm('¿Está seguro de reiniciar todas las respuestas? Se borrará el avance guardado.')) {
            localStorage.removeItem(STORAGE_KEY);
            window.location.reload();
        }
    });

    // Actualización inicial
    updateProgress();
});
