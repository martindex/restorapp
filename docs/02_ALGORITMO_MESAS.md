# ALGORITMO DE DISEÑO VISUAL Y ASIGNACIÓN DE MESAS (GRILLA 2D)
## Sistema POS VARES - Versión 2.0

---

## 1. OBJETIVO DEL ANÁLISIS

Evolucionar el sistema de gestión de mesas hacia un modelo de **Diseño Visual de Salón basado en Grilla**, permitiendo a los propietarios modelar físicamente su restaurante y automatizar la disposición de mobiliario según la demanda.

### Objetivos Clave:
1. **Modelado Espacial**: Representar el salón como una matriz de celdas bidimensional.
2. **Capacidad Dinámica**: Calcular espacios basados en reglas de unión física y pérdida de lugares por contacto.
3. **Flujo Inverso**: Automatizar el dibujo de mesas basado en la capacidad requerida.
4. **Validación de Adyacencia**: Restringir uniones a mesas físicamente contiguas, evitando saltos abstractos.

---

## 2. MODELO DE GRILLA Y CELDAS

El salón se define como una grilla de `N x M` celdas, donde cada celda representa una unidad de superficie (aprox. 80x80 cm).

### 2.1 Tipos de Celdas
Cada celda tiene un tipo que define su comportamiento y restricciones:

| Tipo de Celda | Joinable | Bloqueante | Descripción |
|---------------|----------|------------|-------------|
| `VACÍO` | No | No | Pasillo o espacio de circulación. |
| `MESA` | **Sí** | Sí | Unidad básica de mobiliario. |
| `ESCENARIO` | No | Sí | Área fija de eventos. No permite mesas ni paso. |
| `BARRA` | No | Sí | Área de servicio. |
| `BAÑO` | No | Sí | Paredes y acceso a sanitarios. |
| `COCINA` | No | Sí | Límite físico con el área de producción. |
| `COLUMNA` | No | Sí | Obstáculo estructural inamovible. |
| `OTROS` | No | Sí | Decoración fija, fuentes, etc. |

### 2.2 Atributos de Celda
```javascript
Celda {
  fila: Integer,
  columna: Integer,
  tipo: Enum, // VACIO, MESA, ESCENARIO, etc.
  entidad_id: UUID, // ID de la Mesa u objeto que ocupa la celda
  bloqueada: Boolean // Si impide la unión de mesas a través de ella
}
```

---

## 3. REGLAS DE NEGOCIO Y CAPACIDAD

### 3.1 La Unidad de Mesa
- **Dimensiones**: 1 celda (80x80 cm).
- **Capacidad Base**: 4 personas (1 por lado).

### 3.2 Regla de Unión Física
Las mesas solo pueden unirse si son **ADYACENTES** (comparten un borde).
- Adyacencia válida: Norte, Sur, Este, Oeste.
- Adyacencia inválida: Diagonales.

### 3.3 El Algoritmo de Capacidad (Pérdida por Unión)
Por cada unión física entre dos mesas, se pierden **2 lugares** de capacidad (los lados que quedan pegados).

**Fórmula de Capacidad Total:**
`Capacidad = (N_Mesas * 4) - (N_Uniones * 2)`

**Ejemplos Lineales:**
- **1 Mesa**: (1*4) - (0*2) = **4 personas**
- **2 Mesas**: (2*4) - (1*2) = **6 personas**
- **3 Mesas**: (3*4) - (2*2) = **8 personas**
- **4 Mesas (en línea)**: (4*4) - (3*2) = **10 personas**
- **4 Mesas (en bloque 2x2)**: (4*4) - (4*2) = **8 personas**
  *(Nota: En bloque 2x2 hay 4 uniones internas, optimiza espacio pero sacrifica 2 sillas adicionales vs lineal)*

---

## 4. MODELO DE DATOS EVOLUCIONADO

### 4.1 Mesa (Entidad Base)
Representa la unidad física en la grilla.
```javascript
Mesa {
  id: UUID,
  numero: Integer,
  celda: {fila, columna},
  sillas_configuradas: Integer (1-4),
  estado: Enum, // DISPONIBLE, OCUPADA, RESERVADA, BLOQUEADA
  mesa_compuesta_id: UUID? // Referencia a un grupo
}
```

### 4.2 MesaCompuesta (Mesa Virtual)
Entidad lógica que agrupa múltiples unidades de mesa para un servicio.
```javascript
MesaCompuesta {
  id: UUID,
  mesas_ids: List<UUID>,
  capacidad_calculada: Integer,
  forma: Enum, // LINEAL_H, LINEAL_V, BLOQUE, PERSONALIZADA
  orden_id: UUID? // Referencia a la comanda activa
}
```

---

## 5. FLUJO INVERSO: AUTO-DIBUJO DE MESAS

Cuando el usuario solicita "Mesa para X personas", el sistema debe proponer la ubicación.

### 5.1 Cálculo de Necesidad
1. `N_mesas_necesarias = CEIL((X - 2) / 2)` (Para X > 4)
2. Si `X <= 4`, `N_mesas = 1`.

### 5.2 Algoritmo de Búsqueda Espacial (Pseudocódigo)
```python
FUNCIÓN buscar_espacio_para_grupo(capacidad_requerida):
    n_objetivo = calcular_n_mesas(capacidad_requerida)
    
    # 1. Buscar clusters de celdas VACÍAS contiguas
    opciones = []
    PARA CADA celda_libre EN grilla.obtener_vacias():
        # Intentar expansión Horizontal
        linea_h = buscar_contiguos(celda_libre, n_objetivo, "HORIZONTAL")
        SI linea_h.valida: opciones.agregar(linea_h)
        
        # Intentar expansión Vertical
        linea_v = buscar_contiguos(celda_libre, n_objetivo, "VERTICAL")
        SI linea_v.valida: opciones.agregar(linea_v)
        
    # 2. Score de opciones
    # Priorizar cercanía a otras mesas ocupadas o centro del salón
    mejor_opcion = evaluar_mejor_score(opciones)
    
    RETORNAR mejor_opcion
FIN FUNCIÓN
```

---

## 6. DIAGRAMAS DE DISEÑO (ASCII)

### 6.1 Grilla con Elementos Fijos
`.` = Vacío, `B` = Baño, `K` = Cocina, `C` = Columna, `S` = Escenario, `X` = Barra.

```text
    0 1 2 3 4 5 6 7 8 9
  0 [K][K][K][K][K][K][.][B][B]
  1 [K][K][K][K][K][K][.][B][B]
  2 [.][.][.][.][.][.][.][.][.]
  3 [.][M][.][M][.][M][.][C][.]
  4 [X][.][.][.][.][.][.][.][.]
  5 [X][.][M][.][M][.][.][.][.]
  6 [X][.][.][.][.][.][S][S][S]
  7 [X][.][M][.][M][.][S][S][S]
```

### 6.2 Unión de Mesas (Capacidad 8)
Tres mesas contiguas en fila 3, columnas 1, 2 y 3.
`[M]` = Mesa individual, `[U]` = Unión.

```text
   Sin unir (Capacidad 4 c/u):
   (Col 1) [M]  (Col 2) [.]  (Col 3) [M]
   
   Unidas (Capacidad 8 total):
   (Col 1) [M1] <U> [M2] <U> [M3]
   
   Cálculo: (3 mesas * 4) - (2 uniones * 2) = 12 - 4 = 8 plazas.
```

---

## 7. VALIDACIONES E INTERDEPENDENCIAS

### 7.1 Bloqueo de Uniones
Una unión falla si en el camino físico hay un elemento bloqueante:
- **Caso**: Intento de unir Mesa A y Mesa B separadas por una `COLUMNA`.
- **Resultado**: `ERROR: Unión físicamente imposible`.

### 7.2 Validación de Continuidad
Para que una `MesaCompuesta` sea válida, debe existir un camino de adyacencia entre **todas** sus mesas integrantes.
- Si se quita una mesa del "medio" de una fila, la `MesaCompuesta` debe dividirse automáticamente en dos nuevas entidades.

### 7.3 Casos de Uso Críticos
1. **El Banquete**: Unir 10 mesas en forma de "U" o "L".
   - El sistema debe calcular las uniones en cada esquina.
   - En una esquina (L), una mesa tiene 2 uniones, perdiendo 4 lugares, pero ganando conectividad.
2. **La Separación Forzada**: Un cliente en una mesa unida decide irse antes que el resto.
   - Si la mesa es un "extremo", se libera sin afectar al resto.
   - Si la mesa es "interna", el sistema alerta que el grupo quedará fragmentado.

---

## 8. PSEUDOCÓDIGO DEL ALGORITMO DE UNIÓN

```python
FUNCIÓN validar_y_unir(lista_mesas):
    SI lista_mesas.longitud < 2: RETORNAR Error("Mínimo 2 mesas")
    
    uniones_detectadas = 0
    visitadas = set()
    cola = [lista_mesas[0]]
    
    # BFS para verificar que todas están conectadas
    MIENTRAS cola:
        actual = cola.pop(0)
        visitadas.add(actual)
        
        PARA CADA vecino EN obtener_adyacentes_en_grilla(actual):
            SI vecino EN lista_mesas AND vecino NOT IN visitadas:
                uniones_detectadas += 1
                cola.append(vecino)
                
    SI visitadas.longitud != lista_mesas.longitud:
        RETORNAR Error("Las mesas no forman un bloque contiguo")
        
    capacidad = (lista_mesas.longitud * 4) - (uniones_detectadas * 2)
    
    RETORNAR MesaCompuesta(mesas=lista_mesas, capacidad=capacidad)
```

---

## 9. CONCLUSIÓN DEL DISEÑO

Este modelo de grilla transforma el salón de una lista de objetos en un **entorno espacial reactivo**. Al centralizar la lógica en la adyacencia de la grilla, el sistema garantiza que cualquier configuración propuesta por el algoritmo de auto-dibujo sea físicamente realizable en el restaurante, optimizando el uso del metro cuadrado y mejorando la precisión en la gestión de reservas para grandes grupos.
