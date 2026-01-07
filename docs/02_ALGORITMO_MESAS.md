# ALGORITMO DE ASIGNACIÓN Y UNIÓN DE MESAS
## Sistema POS VARES

---

## 1. OBJETIVO DEL ALGORITMO

Diseñar un algoritmo inteligente que asigne mesas óptimas para grupos de cualquier tamaño, considerando:

1. **Cantidad de personas** solicitada
2. **Cercanía física** entre mesas
3. **Disponibilidad** en fecha/hora específica
4. **Menor impacto** en el resto del salón
5. **Minimizar cantidad** de mesas unidas

---

## 2. RESTRICCIONES Y REGLAS BASE

### 2.1 Reglas Fundamentales

- Cada mesa estándar tiene capacidad para **5 personas**
- Las mesas se unen **dinámicamente** (no hay mesas grandes fijas)
- Las uniones son **temporales** (solo para esa ocupación)
- Las mesas unidas deben estar **físicamente cercanas**
- Una mesa puede estar en uno de estos estados:
  - `LIBRE`: Disponible
  - `RESERVADA`: Asignada a reserva futura
  - `OCUPADA`: Cliente sentado
  - `UNIDA`: Parte de un grupo temporal

### 2.2 Capacidad y Uniones

| Personas | Mesas Necesarias | Estrategia |
|----------|------------------|------------|
| 1-5 | 1 mesa | Asignación directa |
| 6-10 | 2 mesas | Unión de 2 mesas cercanas |
| 11-15 | 3 mesas | Unión de 3 mesas cercanas |
| 16-20 | 4 mesas | Unión de 4 mesas cercanas |
| 21+ | 5+ mesas | Unión múltiple (casos especiales) |

---

## 3. MODELO DE DATOS

### 3.1 Estructura de Mesa

```javascript
Mesa {
  id: UUID,
  numero: Integer,
  zona: String,              // "Salón", "Barra", "Patio", "VIP"
  capacidad: Integer,        // Default: 5
  posicion_x: Float,         // Coordenada X en plano del salón
  posicion_y: Float,         // Coordenada Y en plano del salón
  estado: Enum,              // LIBRE, RESERVADA, OCUPADA, UNIDA
  mesa_principal_id: UUID,   // Si está unida, referencia a mesa principal
  activa: Boolean
}
```

### 3.2 Estructura de Reserva

```javascript
Reserva {
  id: UUID,
  cliente_id: UUID,
  cantidad_personas: Integer,
  fecha: Date,
  hora: Time,
  mesas_asignadas: Array<UUID>,
  estado: Enum,              // PENDIENTE, CONFIRMADA, CANCELADA, COMPLETADA
  notas: Text
}
```

---

## 4. ALGORITMO DE ASIGNACIÓN

### 4.1 Flujo General

```
ENTRADA:
  - cantidad_personas: Integer
  - fecha: Date
  - hora: Time
  - zona_preferida: String (opcional)

SALIDA:
  - mesas_asignadas: Array<Mesa>
  - es_union: Boolean
  - distancia_maxima: Float
```

### 4.2 Pseudocódigo Completo

```python
FUNCIÓN asignar_mesas(cantidad_personas, fecha, hora, zona_preferida = null):
    
    # Paso 1: Calcular cantidad de mesas necesarias
    mesas_necesarias = CEILING(cantidad_personas / 5)
    
    # Paso 2: Obtener mesas disponibles
    mesas_disponibles = obtener_mesas_disponibles(fecha, hora, zona_preferida)
    
    SI mesas_disponibles.length < mesas_necesarias:
        RETORNAR error("No hay suficientes mesas disponibles")
    FIN SI
    
    # Paso 3: Si solo necesita 1 mesa, asignación directa
    SI mesas_necesarias == 1:
        mesa_optima = seleccionar_mesa_individual(mesas_disponibles, zona_preferida)
        RETORNAR {
            mesas: [mesa_optima],
            es_union: false,
            distancia_maxima: 0
        }
    FIN SI
    
    # Paso 4: Para múltiples mesas, buscar el mejor grupo
    mejor_grupo = null
    menor_distancia = INFINITO
    
    PARA CADA combinacion EN generar_combinaciones(mesas_disponibles, mesas_necesarias):
        distancia_total = calcular_distancia_grupo(combinacion)
        
        SI distancia_total < menor_distancia:
            menor_distancia = distancia_total
            mejor_grupo = combinacion
        FIN SI
    FIN PARA
    
    # Paso 5: Validar que las mesas estén suficientemente cerca
    SI menor_distancia > DISTANCIA_MAXIMA_PERMITIDA:
        RETORNAR error("No hay mesas suficientemente cercanas")
    FIN SI
    
    # Paso 6: Retornar grupo óptimo
    RETORNAR {
        mesas: mejor_grupo,
        es_union: true,
        distancia_maxima: menor_distancia
    }
FIN FUNCIÓN


FUNCIÓN obtener_mesas_disponibles(fecha, hora, zona = null):
    mesas = consultar_todas_mesas()
    
    SI zona != null:
        mesas = filtrar_por_zona(mesas, zona)
    FIN SI
    
    # Filtrar mesas que no estén reservadas u ocupadas en ese horario
    mesas_libres = []
    
    PARA CADA mesa EN mesas:
        SI NOT tiene_reserva(mesa, fecha, hora) AND mesa.estado == "LIBRE":
            mesas_libres.agregar(mesa)
        FIN SI
    FIN PARA
    
    RETORNAR mesas_libres
FIN FUNCIÓN


FUNCIÓN seleccionar_mesa_individual(mesas, zona_preferida):
    # Priorizar mesas en zona preferida
    SI zona_preferida != null:
        mesas_zona = filtrar_por_zona(mesas, zona_preferida)
        SI mesas_zona.length > 0:
            RETORNAR mesas_zona[0]
        FIN SI
    FIN SI
    
    # Si no hay preferencia o no hay en esa zona, retornar la primera disponible
    RETORNAR mesas[0]
FIN FUNCIÓN


FUNCIÓN generar_combinaciones(mesas, cantidad):
    # Genera todas las combinaciones posibles de 'cantidad' mesas
    # Usa algoritmo de combinaciones (C(n,k))
    combinaciones = []
    
    FUNCIÓN recursiva(inicio, combo_actual):
        SI combo_actual.length == cantidad:
            combinaciones.agregar(combo_actual.copiar())
            RETORNAR
        FIN SI
        
        PARA i DESDE inicio HASTA mesas.length:
            combo_actual.agregar(mesas[i])
            recursiva(i + 1, combo_actual)
            combo_actual.eliminar_ultimo()
        FIN PARA
    FIN FUNCIÓN
    
    recursiva(0, [])
    RETORNAR combinaciones
FIN FUNCIÓN


FUNCIÓN calcular_distancia_grupo(mesas):
    # Calcula la distancia total entre todas las mesas del grupo
    # Usa la suma de distancias euclidianas entre pares
    
    distancia_total = 0
    
    PARA i DESDE 0 HASTA mesas.length - 1:
        PARA j DESDE i + 1 HASTA mesas.length:
            distancia = distancia_euclidiana(mesas[i], mesas[j])
            distancia_total += distancia
        FIN PARA
    FIN PARA
    
    RETORNAR distancia_total
FIN FUNCIÓN


FUNCIÓN distancia_euclidiana(mesa1, mesa2):
    dx = mesa1.posicion_x - mesa2.posicion_x
    dy = mesa1.posicion_y - mesa2.posicion_y
    RETORNAR SQRT(dx * dx + dy * dy)
FIN FUNCIÓN


FUNCIÓN tiene_reserva(mesa, fecha, hora):
    reservas = consultar_reservas(mesa.id, fecha)
    
    PARA CADA reserva EN reservas:
        # Considerar un margen de 2 horas para cada reserva
        hora_inicio = reserva.hora
        hora_fin = reserva.hora + 2 horas
        
        SI hora >= hora_inicio AND hora < hora_fin:
            RETORNAR true
        FIN SI
    FIN PARA
    
    RETORNAR false
FIN FUNCIÓN
```

---

## 5. ESTRATEGIAS DE OPTIMIZACIÓN

### 5.1 Criterios de Priorización

El algoritmo prioriza en este orden:

1. **Minimizar distancia total** entre mesas unidas
2. **Preferir mesas contiguas** (distancia < 2 metros)
3. **Evitar fragmentación** del salón
4. **Respetar zona preferida** del cliente
5. **Balancear ocupación** entre zonas

### 5.2 Distancias Referenciales

```
DISTANCIA_CONTIGUA = 2.0 metros       // Mesas pegadas o muy cercanas
DISTANCIA_CERCANA = 4.0 metros        // Mesas en la misma área
DISTANCIA_MAXIMA_PERMITIDA = 8.0 metros  // Límite para considerar unión viable
```

### 5.3 Heurísticas Adicionales

#### Para grupos pequeños (1-5 personas):
- Priorizar mesas individuales en zona solicitada
- Si no hay en zona preferida, buscar en zonas adyacentes
- Evitar asignar mesas grandes si hay individuales disponibles

#### Para grupos medianos (6-10 personas):
- Buscar 2 mesas contiguas
- Si no hay contiguas, buscar 2 mesas en radio de 4 metros
- Priorizar mesas en la misma zona

#### Para grupos grandes (11+ personas):
- Buscar cluster de mesas en área específica
- Considerar reservar zona completa si es necesario
- Notificar al Superusuario para coordinación especial

---

## 6. ALGORITMO DE UNIÓN DE MESAS

### 6.1 Proceso de Unión

```python
FUNCIÓN unir_mesas(mesas_grupo, reserva_id):
    # Paso 1: Seleccionar mesa principal (la primera del grupo)
    mesa_principal = mesas_grupo[0]
    
    # Paso 2: Marcar mesa principal como OCUPADA
    mesa_principal.estado = "OCUPADA"
    mesa_principal.reserva_id = reserva_id
    
    # Paso 3: Marcar resto de mesas como UNIDAS
    PARA CADA mesa EN mesas_grupo[1:]:
        mesa.estado = "UNIDA"
        mesa.mesa_principal_id = mesa_principal.id
        mesa.reserva_id = reserva_id
    FIN PARA
    
    # Paso 4: Registrar unión en tabla de auditoría
    registrar_union(mesa_principal.id, mesas_grupo, reserva_id)
    
    RETORNAR mesa_principal.id
FIN FUNCIÓN
```

### 6.2 Proceso de Separación

```python
FUNCIÓN separar_mesas(mesa_principal_id):
    # Paso 1: Obtener todas las mesas unidas
    mesas_unidas = consultar_mesas_unidas(mesa_principal_id)
    
    # Paso 2: Liberar mesa principal
    mesa_principal = obtener_mesa(mesa_principal_id)
    mesa_principal.estado = "LIBRE"
    mesa_principal.reserva_id = null
    
    # Paso 3: Liberar mesas unidas
    PARA CADA mesa EN mesas_unidas:
        mesa.estado = "LIBRE"
        mesa.mesa_principal_id = null
        mesa.reserva_id = null
    FIN PARA
    
    # Paso 4: Registrar separación en auditoría
    registrar_separacion(mesa_principal_id, mesas_unidas)
FIN FUNCIÓN
```

---

## 7. COMPLEJIDAD DEL ALGORITMO

### 7.1 Análisis de Complejidad

**Para asignación de mesa individual:**
- Tiempo: `O(n)` donde n = cantidad de mesas disponibles
- Espacio: `O(1)`

**Para asignación con unión de mesas:**
- Tiempo: `O(C(n,k) * k²)` donde:
  - n = cantidad de mesas disponibles
  - k = cantidad de mesas necesarias
  - C(n,k) = combinaciones de n elementos tomados de k en k
- Espacio: `O(C(n,k))`

**Caso promedio:**
- Para un salón con 30 mesas y grupos de hasta 4 mesas:
- `C(30,4) = 27,405` combinaciones posibles
- Con optimizaciones (poda por distancia), se reduce a ~1,000 evaluaciones

### 7.2 Optimizaciones Implementadas

1. **Poda por distancia**: Descartar combinaciones donde alguna mesa esté a más de 8 metros
2. **Poda por zona**: Si hay preferencia de zona, evaluar solo mesas de esa zona primero
3. **Caché de distancias**: Pre-calcular matriz de distancias entre todas las mesas
4. **Límite de combinaciones**: Para grupos muy grandes (>15 personas), usar algoritmo greedy en lugar de fuerza bruta

---

## 8. EJEMPLOS PRÁCTICOS

### Ejemplo 1: Grupo de 3 personas

```
ENTRADA:
  cantidad_personas = 3
  fecha = 2026-01-10
  hora = 20:00
  zona_preferida = "Salón"

PROCESO:
  1. mesas_necesarias = CEILING(3/5) = 1
  2. Buscar mesas disponibles en "Salón"
  3. Encontradas: Mesa #5, Mesa #12, Mesa #18
  4. Asignar Mesa #5 (primera disponible)

SALIDA:
  {
    mesas: [Mesa #5],
    es_union: false,
    distancia_maxima: 0
  }
```

### Ejemplo 2: Grupo de 8 personas

```
ENTRADA:
  cantidad_personas = 8
  fecha = 2026-01-10
  hora = 20:00
  zona_preferida = "Patio"

PROCESO:
  1. mesas_necesarias = CEILING(8/5) = 2
  2. Buscar mesas disponibles en "Patio"
  3. Encontradas: Mesa #20, Mesa #21, Mesa #22, Mesa #23
  4. Evaluar combinaciones:
     - (Mesa #20, Mesa #21): distancia = 1.5m ✓
     - (Mesa #20, Mesa #22): distancia = 3.2m
     - (Mesa #20, Mesa #23): distancia = 5.8m
     - (Mesa #21, Mesa #22): distancia = 2.8m
     - (Mesa #21, Mesa #23): distancia = 4.5m
     - (Mesa #22, Mesa #23): distancia = 2.1m
  5. Mejor opción: (Mesa #20, Mesa #21) con distancia 1.5m

SALIDA:
  {
    mesas: [Mesa #20, Mesa #21],
    es_union: true,
    distancia_maxima: 1.5
  }
```

### Ejemplo 3: Grupo de 18 personas

```
ENTRADA:
  cantidad_personas = 18
  fecha = 2026-01-15
  hora = 21:00
  zona_preferida = "VIP"

PROCESO:
  1. mesas_necesarias = CEILING(18/5) = 4
  2. Buscar mesas disponibles en "VIP"
  3. Encontradas: 6 mesas disponibles
  4. Evaluar combinaciones de 4 mesas
  5. Aplicar poda por distancia (descartar si alguna mesa > 8m)
  6. Mejor grupo encontrado:
     - Mesa #30 (principal)
     - Mesa #31 (distancia: 1.8m)
     - Mesa #32 (distancia: 2.5m)
     - Mesa #33 (distancia: 3.1m)
  7. Distancia total del grupo: 7.4m ✓

SALIDA:
  {
    mesas: [Mesa #30, Mesa #31, Mesa #32, Mesa #33],
    es_union: true,
    distancia_maxima: 7.4
  }
```

---

## 9. CASOS ESPECIALES

### 9.1 No hay mesas suficientemente cercanas

```python
SI menor_distancia > DISTANCIA_MAXIMA_PERMITIDA:
    # Opción 1: Sugerir horarios alternativos
    horarios_alternativos = buscar_horarios_disponibles(fecha, cantidad_personas)
    
    # Opción 2: Sugerir dividir el grupo
    SI cantidad_personas > 10:
        sugerir_division_grupo()
    FIN SI
    
    # Opción 3: Notificar al Superusuario
    notificar_superusuario(reserva_especial)
FIN SI
```

### 9.2 Grupo muy grande (>20 personas)

```python
SI cantidad_personas > 20:
    # Estrategia especial: Reservar zona completa
    zonas_disponibles = verificar_zonas_completas(fecha, hora)
    
    SI zonas_disponibles.length > 0:
        reservar_zona_completa(zonas_disponibles[0])
    SINO:
        # Requiere intervención del Superusuario
        crear_reserva_especial(cantidad_personas, fecha, hora)
    FIN SI
FIN SI
```

### 9.3 Preferencia de zona no disponible

```python
SI NOT hay_mesas_en_zona(zona_preferida):
    # Buscar en zonas adyacentes
    zonas_alternativas = obtener_zonas_adyacentes(zona_preferida)
    
    PARA CADA zona EN zonas_alternativas:
        mesas = obtener_mesas_disponibles(fecha, hora, zona)
        SI mesas.length >= mesas_necesarias:
            RETORNAR asignar_mesas_en_zona(mesas, zona)
        FIN SI
    FIN PARA
    
    # Si no hay en zonas adyacentes, buscar en cualquier zona
    RETORNAR asignar_mesas_en_cualquier_zona()
FIN SI
```

---

## 10. VISUALIZACIÓN DEL ALGORITMO

### 10.1 Representación del Salón

```
Plano del Salón (Vista Superior)
Escala: 1 unidad = 1 metro

    0   2   4   6   8   10  12  14  16  18  20 (X)
0   +---+---+---+---+---+---+---+---+---+---+
    |   | 1 |   | 2 |   | 3 |   | 4 |   | 5 |
2   +---+---+---+---+---+---+---+---+---+---+
    |   |   |   |   |   |   |   |   |   |   |
4   +---+---+---+---+---+---+---+---+---+---+
    | 6 |   | 7 |   | 8 |   | 9 |   |10 |   |
6   +---+---+---+---+---+---+---+---+---+---+
    |   |   |   |   |   |   |   |   |   |   |
8   +---+---+---+---+---+---+---+---+---+---+
    |11 |   |12 |   |13 |   |14 |   |15 |   |
10  +---+---+---+---+---+---+---+---+---+---+
(Y)

Ejemplo de unión para 8 personas:
- Mesa 1 (2, 1) + Mesa 2 (6, 1)
- Distancia: sqrt((6-2)² + (1-1)²) = 4.0m
- Estado: VIABLE (< 8m)
```

### 10.2 Matriz de Distancias (Ejemplo)

```
Matriz de distancias entre mesas (en metros):

      M1   M2   M3   M4   M5   M6   M7   M8
M1    0    4.0  8.0  12.0 16.0 4.5  8.5  12.5
M2    4.0  0    4.0  8.0  12.0 6.3  4.5  8.5
M3    8.0  4.0  0    4.0  8.0  9.4  6.3  4.5
M4    12.0 8.0  4.0  0    4.0  13.0 9.4  6.3
M5    16.0 12.0 8.0  4.0  0    16.5 13.0 9.4
M6    4.5  6.3  9.4  13.0 16.5 0    4.5  8.5
M7    8.5  4.5  6.3  9.4  13.0 4.5  0    4.5
M8    12.5 8.5  4.5  6.3  9.4  8.5  4.5  0

Mesas contiguas (distancia < 2m): Ninguna en este ejemplo
Mesas cercanas (distancia < 4m): M1-M2, M2-M3, M3-M4, M4-M5, M6-M7, M7-M8
```

---

## 11. IMPLEMENTACIÓN EN CÓDIGO (Referencia)

### 11.1 Estructura de Clases (Java)

```java
public class MesaAsignador {
    
    private static final double DISTANCIA_MAXIMA = 8.0;
    private static final int CAPACIDAD_MESA = 5;
    
    public AsignacionResult asignarMesas(
        int cantidadPersonas,
        LocalDate fecha,
        LocalTime hora,
        String zonaPreferida
    ) {
        int mesasNecesarias = (int) Math.ceil((double) cantidadPersonas / CAPACIDAD_MESA);
        List<Mesa> mesasDisponibles = obtenerMesasDisponibles(fecha, hora, zonaPreferida);
        
        if (mesasDisponibles.size() < mesasNecesarias) {
            throw new NoHayMesasDisponiblesException();
        }
        
        if (mesasNecesarias == 1) {
            return asignarMesaIndividual(mesasDisponibles, zonaPreferida);
        }
        
        return buscarMejorGrupo(mesasDisponibles, mesasNecesarias);
    }
    
    private AsignacionResult buscarMejorGrupo(List<Mesa> mesas, int cantidad) {
        List<List<Mesa>> combinaciones = generarCombinaciones(mesas, cantidad);
        
        List<Mesa> mejorGrupo = null;
        double menorDistancia = Double.MAX_VALUE;
        
        for (List<Mesa> grupo : combinaciones) {
            double distancia = calcularDistanciaGrupo(grupo);
            
            if (distancia < menorDistancia) {
                menorDistancia = distancia;
                mejorGrupo = grupo;
            }
        }
        
        if (menorDistancia > DISTANCIA_MAXIMA) {
            throw new MesasNoSuficientementeCercanasException();
        }
        
        return new AsignacionResult(mejorGrupo, true, menorDistancia);
    }
    
    private double calcularDistanciaGrupo(List<Mesa> mesas) {
        double distanciaTotal = 0.0;
        
        for (int i = 0; i < mesas.size() - 1; i++) {
            for (int j = i + 1; j < mesas.size(); j++) {
                distanciaTotal += calcularDistanciaEuclidiana(mesas.get(i), mesas.get(j));
            }
        }
        
        return distanciaTotal;
    }
    
    private double calcularDistanciaEuclidiana(Mesa m1, Mesa m2) {
        double dx = m1.getPosicionX() - m2.getPosicionX();
        double dy = m1.getPosicionY() - m2.getPosicionY();
        return Math.sqrt(dx * dx + dy * dy);
    }
}
```

---

## 12. PRUEBAS Y VALIDACIÓN

### 12.1 Casos de Prueba

| ID | Personas | Mesas Esperadas | Resultado Esperado |
|----|----------|-----------------|-------------------|
| T1 | 3 | 1 | Asignación directa |
| T2 | 5 | 1 | Asignación directa |
| T3 | 6 | 2 | Unión de 2 mesas |
| T4 | 10 | 2 | Unión de 2 mesas |
| T5 | 12 | 3 | Unión de 3 mesas |
| T6 | 18 | 4 | Unión de 4 mesas |
| T7 | 25 | 5 | Unión de 5 mesas o zona completa |

### 12.2 Validaciones

```python
FUNCIÓN validar_asignacion(mesas_asignadas, cantidad_personas):
    # Validación 1: Capacidad suficiente
    capacidad_total = mesas_asignadas.length * 5
    ASSERT capacidad_total >= cantidad_personas
    
    # Validación 2: Todas las mesas están disponibles
    PARA CADA mesa EN mesas_asignadas:
        ASSERT mesa.estado == "LIBRE"
    FIN PARA
    
    # Validación 3: Distancias válidas (si es unión)
    SI mesas_asignadas.length > 1:
        distancia_maxima = calcular_distancia_grupo(mesas_asignadas)
        ASSERT distancia_maxima <= DISTANCIA_MAXIMA_PERMITIDA
    FIN SI
    
    # Validación 4: No hay solapamiento de reservas
    PARA CADA mesa EN mesas_asignadas:
        ASSERT NOT tiene_reserva(mesa, fecha, hora)
    FIN PARA
FIN FUNCIÓN
```

---

## 13. CONCLUSIONES

### 13.1 Ventajas del Algoritmo

✅ **Optimización automática**: Encuentra la mejor combinación de mesas  
✅ **Flexibilidad**: Se adapta a cualquier tamaño de grupo  
✅ **Eficiencia espacial**: Minimiza el impacto en el salón  
✅ **Escalabilidad**: Funciona con salones de cualquier tamaño  
✅ **Simplicidad operativa**: No requiere intervención manual en casos comunes  

### 13.2 Limitaciones

⚠️ **Complejidad computacional**: Para grupos muy grandes, puede ser lento  
⚠️ **Dependencia de geometría**: Requiere coordenadas precisas de las mesas  
⚠️ **Casos especiales**: Grupos >20 personas pueden requerir intervención manual  

### 13.3 Mejoras Futuras

- Implementar algoritmo A* para búsqueda más eficiente
- Considerar preferencias de clientes frecuentes
- Integrar con sistema de predicción de ocupación
- Optimizar para eventos especiales (reservas masivas)

---

**Documento creado por:** Sistema VARES  
**Versión:** 1.0  
**Fecha:** 2026-01-03
