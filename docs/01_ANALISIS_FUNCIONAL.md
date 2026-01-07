# ANÁLISIS FUNCIONAL - SISTEMA POS VARES
## Sistema de Punto de Venta para Bares y Restaurantes

---

## 1. CONCEPTO FUNDAMENTAL

> **La COMANDA es el actor principal del sistema, pero no puede existir sin una MESA, y la disponibilidad de mesas depende de la DISTRIBUCIÓN FÍSICA DEL SALÓN y las RESERVAS.**

### Flujo Principal del Sistema
```
Distribución → Reserva → Mesa → Comanda → Cocina/Barra → Servicio → Pago → Cierre
```

---

## 2. ROLES DEL SISTEMA

### 2.1 SUPERUSUARIO (Dueño/Administrador General)

**Permisos Exclusivos:**

#### Gestión de Usuarios
- Crear usuarios (Mozos, Cocineros, Cajeros)
- Asignar y modificar roles
- Activar/desactivar usuarios
- Auditar todas las acciones del sistema

#### Gestión de Carta/Menú
- Crear, modificar y eliminar productos
- Gestionar categorías
- Definir precios
- Clasificar productos (comida/bebida)
- Controlar disponibilidad
- Configurar reglas de envío a cocina

#### Configuración del Salón
- Definir cantidad total de mesas
- Establecer distribución física (Salón, Barra, Patio, VIP)
- Configurar ubicación espacial (coordenadas/grilla)
- Definir capacidad de mesas

#### Gestión de Reservas Asistidas
- Crear reservas para clientes anónimos (vía teléfono)
- Asignar mesas manualmente
- Gestionar reservas especiales

### 2.2 MOZO

**Responsabilidades:**
- Abrir mesas
- Tomar pedidos
- Crear y gestionar comandas
- Servir bebidas
- Agregar ítems a comandas existentes
- Notificar cuando la comida está lista
- Ver estado de sus mesas asignadas

**Restricciones:**
- No puede ver precios en pantalla de cocina
- No puede acceder a caja
- No puede modificar usuarios
- No puede cambiar configuración del salón

### 2.3 COCINERO

**Responsabilidades:**
- Ver cola de pedidos en pantalla
- Cambiar estado de pedidos (Pendiente → En Progreso → Finalizado)
- Ver detalles de cada pedido (mesa, productos, observaciones)

**Restricciones:**
- No ve precios
- No ve información de bebidas
- No puede modificar pedidos
- Solo ve la parte de comida de las comandas

### 2.4 CAJERO

**Responsabilidades:**
- Procesar pagos
- Cerrar comandas
- Generar tickets/facturas
- Ver historial de ventas

**Restricciones:**
- No puede modificar comandas
- No puede gestionar mesas
- No puede modificar usuarios

### 2.5 CLIENTE (Registrado)

**Capacidades:**
- Visualizar mapa del salón
- Ver mesas disponibles
- Seleccionar cantidad de personas, fecha y horario
- Crear reservas
- Ver sus reservas activas

**Restricciones:**
- Solo ve disponibilidad
- No ve comandas ni pedidos
- No accede a información operativa

### 2.6 CLIENTE ANÓNIMO

**Características:**
- No tiene cuenta en el sistema
- No se loguea
- No interactúa directamente con el sistema
- Realiza reservas por teléfono

**Flujo:**
1. Cliente llama por teléfono
2. Superusuario crea reserva manualmente
3. Se carga: nombre de referencia, cantidad de personas, fecha, horario, mesa asignada
4. Al retirarse: el cliente anónimo desaparece del sistema
5. Solo quedan registros operativos y de ventas

---

## 3. GESTIÓN DE MESAS

### 3.1 Regla Base de Mesas

- Cada mesa estándar es para **5 personas**
- No existen mesas grandes fijas
- Las mesas se **unen dinámicamente**
- Las uniones son:
  - Automáticas
  - Temporales
  - Solo para esa reserva/ocupación

### 3.2 Estados de Mesa

1. **LIBRE**: Disponible para asignación
2. **RESERVADA**: Asignada a una reserva futura
3. **OCUPADA**: Cliente sentado, comanda activa
4. **UNIDA**: Parte de un grupo de mesas unidas temporalmente

### 3.3 Atributos de Mesa

```
Mesa {
  id: UUID
  numero: Integer
  zona: String (Salón, Barra, Patio, VIP)
  capacidad: Integer (default: 5)
  posicion_x: Float
  posicion_y: Float
  estado: Enum (LIBRE, RESERVADA, OCUPADA, UNIDA)
  mesa_principal_id: UUID (si está unida)
  activa: Boolean
  fecha_creacion: DateTime
  fecha_modificacion: DateTime
}
```

---

## 4. SISTEMA DE RESERVAS

### 4.1 Tipos de Reserva

#### Reserva Estándar (Cliente Registrado)
```
Reserva {
  id: UUID
  cliente_id: UUID
  cantidad_personas: Integer
  fecha: Date
  hora: Time
  mesas_asignadas: Array<UUID>
  estado: Enum (PENDIENTE, CONFIRMADA, CANCELADA, COMPLETADA)
  notas: Text
  fecha_creacion: DateTime
}
```

#### Reserva Asistida (Cliente Anónimo)
```
ReservaAnonima {
  id: UUID
  nombre_referencia: String
  telefono: String (opcional)
  cantidad_personas: Integer
  fecha: Date
  hora: Time
  mesas_asignadas: Array<UUID>
  estado: Enum (PENDIENTE, CONFIRMADA, CANCELADA, COMPLETADA)
  notas: Text
  creado_por: UUID (Superusuario)
  fecha_creacion: DateTime
}
```

### 4.2 Flujo de Reserva

1. **Solicitud**: Cliente o Superusuario inicia reserva
2. **Validación**: Sistema verifica disponibilidad
3. **Asignación Automática**: Algoritmo selecciona mesas óptimas
4. **Confirmación**: Mesas pasan a estado RESERVADA
5. **Notificación**: Cliente recibe confirmación
6. **Check-in**: Al llegar, mozo abre la mesa
7. **Liberación**: Al finalizar, mesas vuelven a LIBRE

---

## 5. SISTEMA DE COMANDAS

### 5.1 Estructura de Comanda

```
Comanda {
  id: UUID
  mesa_id: UUID
  mozo_id: UUID
  fecha_apertura: DateTime
  fecha_cierre: DateTime
  estado: Enum (ABIERTA, EN_PROGRESO, SERVIDA, PAGADA, CERRADA)
  subtotal: Decimal
  propina: Decimal
  total: Decimal
  items: Array<ItemComanda>
}

ItemComanda {
  id: UUID
  comanda_id: UUID
  producto_id: UUID
  cantidad: Integer
  precio_unitario: Decimal
  observaciones: Text
  tipo: Enum (COMIDA, BEBIDA)
  estado: Enum (PENDIENTE, EN_COCINA, LISTO, SERVIDO)
  fecha_pedido: DateTime
  fecha_servido: DateTime
}
```

### 5.2 Reglas de Comanda

1. **No puede existir comanda sin mesa**
2. Una mesa solo puede tener una comanda activa a la vez
3. La comanda se divide automáticamente en:
   - **Bebidas**: Gestionadas por mozo/barra
   - **Comidas**: Enviadas a cocina
4. El mozo puede agregar ítems en cualquier momento
5. Todo queda dentro de la misma comanda
6. La comanda solo se cierra cuando se paga

### 5.3 Estados de Comanda

1. **ABIERTA**: Mesa ocupada, sin pedidos aún
2. **EN_PROGRESO**: Pedidos enviados a cocina
3. **SERVIDA**: Todos los ítems servidos
4. **PAGADA**: Cliente pagó, esperando cierre
5. **CERRADA**: Finalizada, mesa liberada

---

## 6. FLUJO OPERATIVO COMPLETO

### 6.1 Apertura de Mesa

```
1. Cliente llega (con o sin reserva)
2. Mozo verifica disponibilidad
3. Mozo asigna mesa(s)
4. Sistema crea comanda activa
5. Mesa pasa a estado OCUPADA
```

### 6.2 Toma de Pedido

```
1. Mozo entrega carta impresa
2. Cliente elige productos
3. Mozo carga pedido en app:
   - Selecciona productos
   - Define cantidades
   - Agrega observaciones
4. Sistema clasifica automáticamente:
   - Comida → Cola de cocina
   - Bebida → Gestión de mozo
```

### 6.3 Procesamiento en Cocina

```
1. Pedido llega a pantalla de cocina
2. Cocinero ve:
   - Mesa
   - Productos
   - Observaciones
   - Orden cronológico
3. Cocinero cambia estado:
   - PENDIENTE → EN_PROGRESO
4. Al terminar:
   - EN_PROGRESO → FINALIZADO
5. Sistema notifica al mozo
```

### 6.4 Servicio

```
1. Mozo recibe notificación
2. Mozo retira comida de cocina
3. Mozo sirve en mesa
4. Mozo marca ítem como SERVIDO
```

### 6.5 Gestión de Bebidas

```
1. Bebidas no van a cocina
2. Mozo gestiona directamente
3. Puede agregar bebidas en cualquier momento
4. Todo queda en la misma comanda
```

### 6.6 Pago y Cierre

```
1. Cliente solicita cuenta
2. Mozo solicita cierre de comanda
3. Sistema calcula total
4. Cajero procesa pago
5. Sistema genera ticket/factura
6. Comanda pasa a CERRADA
7. Mesa vuelve a LIBRE
8. Si era mesa unida, se separa automáticamente
```

---

## 7. PANTALLA DE COCINA

### 7.1 Visualización

**Información Mostrada:**
- Cola de pedidos en orden cronológico
- Número de mesa
- Productos solicitados
- Cantidad
- Observaciones especiales
- Estado actual

**Información NO Mostrada:**
- Precios
- Información del cliente
- Bebidas
- Datos de pago

### 7.2 Interacción

**Acciones del Cocinero:**
- Ver lista completa de pedidos pendientes
- Seleccionar pedido para trabajar
- Cambiar estado a "En Progreso"
- Marcar como "Finalizado" al terminar
- Ver tiempo transcurrido desde el pedido

**Notificaciones:**
- Nuevo pedido (sonido/visual)
- Pedido urgente (más de X minutos)
- Pedido con observaciones especiales

---

## 8. AUDITORÍA Y TRAZABILIDAD

### 8.1 Eventos Auditados

Todos los eventos críticos quedan registrados:

```
AuditoriaEvento {
  id: UUID
  usuario_id: UUID
  tipo_evento: String
  entidad_afectada: String
  entidad_id: UUID
  datos_anteriores: JSON
  datos_nuevos: JSON
  ip_address: String
  timestamp: DateTime
}
```

**Eventos Registrados:**
- Creación/modificación de usuarios
- Cambios en configuración de salón
- Apertura/cierre de mesas
- Creación/modificación de comandas
- Cambios de estado en cocina
- Pagos procesados
- Reservas creadas/canceladas

---

## 9. REGLAS DE NEGOCIO CRÍTICAS

### 9.1 Integridad de Datos

1. **No puede existir comanda sin mesa**
2. **Una mesa solo puede tener una comanda activa**
3. **Las mesas unidas deben estar físicamente cercanas**
4. **Las reservas no pueden solaparse en la misma mesa**
5. **Un usuario solo puede tener un rol activo**

### 9.2 Seguridad

1. **Solo el Superusuario puede crear usuarios**
2. **Solo el Superusuario puede modificar la carta**
3. **Solo el Superusuario puede cambiar la configuración del salón**
4. **Los mozos solo ven sus mesas asignadas**
5. **Los cocineros no ven información financiera**
6. **Los cajeros no pueden modificar comandas**

### 9.3 Operativas

1. **Las mesas se unen automáticamente según algoritmo**
2. **Las uniones son temporales (solo para esa ocupación)**
3. **Al cerrar la comanda, las mesas se separan automáticamente**
4. **Las bebidas no pasan por cocina**
5. **Los pedidos se procesan en orden cronológico**
6. **No se puede cerrar una comanda con ítems pendientes en cocina**

---

## 10. CASOS DE USO DETALLADOS

### CU-01: Crear Reserva (Cliente Registrado)

**Actor:** Cliente  
**Precondición:** Cliente autenticado  
**Flujo Principal:**
1. Cliente accede al mapa del salón
2. Cliente selecciona fecha y hora
3. Cliente indica cantidad de personas
4. Sistema muestra mesas disponibles
5. Sistema ejecuta algoritmo de asignación
6. Sistema muestra mesas propuestas
7. Cliente confirma reserva
8. Sistema marca mesas como RESERVADAS
9. Sistema envía confirmación

**Flujo Alternativo:**
- 4a. No hay disponibilidad → Sistema sugiere horarios alternativos
- 7a. Cliente cancela → Sistema libera mesas

### CU-02: Crear Reserva Asistida (Cliente Anónimo)

**Actor:** Superusuario  
**Precondición:** Superusuario autenticado  
**Flujo Principal:**
1. Cliente llama por teléfono
2. Superusuario accede a módulo de reservas
3. Superusuario ingresa:
   - Nombre de referencia
   - Cantidad de personas
   - Fecha y hora
   - Teléfono (opcional)
4. Sistema ejecuta algoritmo de asignación
5. Sistema muestra mesas propuestas
6. Superusuario confirma y asigna
7. Sistema marca mesas como RESERVADAS
8. Superusuario comunica confirmación al cliente

### CU-03: Abrir Mesa y Comanda

**Actor:** Mozo  
**Precondición:** Mozo autenticado, mesa disponible  
**Flujo Principal:**
1. Cliente llega al local
2. Mozo verifica reserva (si existe)
3. Mozo selecciona mesa(s) en la app
4. Sistema valida disponibilidad
5. Sistema crea comanda nueva
6. Sistema marca mesa como OCUPADA
7. Mozo entrega carta al cliente

**Flujo Alternativo:**
- 4a. Mesa reservada → Mozo verifica identidad del cliente
- 4b. Mesa ocupada → Sistema sugiere mesas alternativas

### CU-04: Tomar Pedido

**Actor:** Mozo  
**Precondición:** Mesa abierta, comanda activa  
**Flujo Principal:**
1. Cliente elige productos de la carta
2. Mozo accede a comanda activa
3. Mozo agrega productos:
   - Selecciona producto
   - Define cantidad
   - Agrega observaciones
4. Mozo revisa pedido con cliente
5. Mozo confirma pedido
6. Sistema clasifica automáticamente:
   - Comida → Envía a cola de cocina
   - Bebida → Queda en gestión de mozo
7. Sistema actualiza estado de comanda

### CU-05: Procesar Pedido en Cocina

**Actor:** Cocinero  
**Precondición:** Cocinero autenticado, pedidos en cola  
**Flujo Principal:**
1. Cocinero ve pantalla de cocina
2. Sistema muestra pedidos en orden cronológico
3. Cocinero selecciona siguiente pedido
4. Cocinero cambia estado a "En Progreso"
5. Cocinero prepara los platos
6. Cocinero marca pedido como "Finalizado"
7. Sistema notifica al mozo

**Flujo Alternativo:**
- 3a. Pedido urgente (>15 min) → Sistema resalta visualmente
- 6a. Falta ingrediente → Cocinero notifica a Superusuario

### CU-06: Servir Comida

**Actor:** Mozo  
**Precondición:** Pedido finalizado en cocina  
**Flujo Principal:**
1. Mozo recibe notificación
2. Mozo retira comida de cocina
3. Mozo verifica pedido con ticket
4. Mozo sirve en mesa correspondiente
5. Mozo marca ítems como "Servidos"
6. Sistema actualiza estado de comanda

### CU-07: Agregar Ítems a Comanda Existente

**Actor:** Mozo  
**Precondición:** Comanda activa  
**Flujo Principal:**
1. Cliente solicita productos adicionales
2. Mozo accede a comanda activa
3. Mozo agrega nuevos ítems
4. Sistema clasifica (comida/bebida)
5. Si es comida → Envía a cocina
6. Sistema actualiza totales

### CU-08: Procesar Pago y Cerrar Comanda

**Actor:** Cajero  
**Precondición:** Todos los ítems servidos  
**Flujo Principal:**
1. Cliente solicita cuenta
2. Mozo solicita cierre de comanda
3. Sistema valida que todos los ítems estén servidos
4. Sistema calcula total (subtotal + propina)
5. Cajero procesa pago
6. Sistema genera ticket/factura
7. Sistema marca comanda como CERRADA
8. Sistema libera mesa(s)
9. Si era mesa unida → Sistema separa automáticamente

**Flujo Alternativo:**
- 3a. Hay ítems pendientes → Sistema no permite cierre
- 5a. Pago rechazado → Cajero intenta método alternativo

### CU-09: Gestionar Usuarios (Superusuario)

**Actor:** Superusuario  
**Precondición:** Superusuario autenticado  
**Flujo Principal:**
1. Superusuario accede a módulo de usuarios
2. Superusuario selecciona "Crear Usuario"
3. Superusuario ingresa:
   - Nombre completo
   - Email
   - Rol (Mozo, Cocinero, Cajero)
   - Contraseña temporal
4. Sistema valida datos
5. Sistema crea usuario
6. Sistema envía credenciales al nuevo usuario

**Operaciones Adicionales:**
- Modificar rol de usuario
- Activar/desactivar usuario
- Resetear contraseña
- Ver auditoría de acciones del usuario

### CU-10: Gestionar Carta/Menú (Superusuario)

**Actor:** Superusuario  
**Precondición:** Superusuario autenticado  
**Flujo Principal:**
1. Superusuario accede a módulo de carta
2. Superusuario selecciona "Crear Producto"
3. Superusuario ingresa:
   - Nombre del producto
   - Descripción
   - Categoría
   - Precio
   - Tipo (Comida/Bebida)
   - Disponibilidad
   - Imagen (opcional)
4. Sistema valida datos
5. Sistema crea producto
6. Producto queda disponible para pedidos

**Operaciones Adicionales:**
- Modificar producto existente
- Cambiar precio
- Activar/desactivar producto
- Gestionar categorías
- Definir reglas de envío a cocina

---

## 11. MATRIZ DE PERMISOS

| Funcionalidad | Superusuario | Mozo | Cocinero | Cajero | Cliente |
|--------------|--------------|------|----------|--------|---------|
| Crear usuarios | ✅ | ❌ | ❌ | ❌ | ❌ |
| Gestionar carta | ✅ | ❌ | ❌ | ❌ | ❌ |
| Configurar salón | ✅ | ❌ | ❌ | ❌ | ❌ |
| Crear reserva asistida | ✅ | ❌ | ❌ | ❌ | ❌ |
| Crear reserva online | ❌ | ❌ | ❌ | ❌ | ✅ |
| Abrir mesa | ✅ | ✅ | ❌ | ❌ | ❌ |
| Tomar pedido | ✅ | ✅ | ❌ | ❌ | ❌ |
| Ver pantalla cocina | ✅ | ❌ | ✅ | ❌ | ❌ |
| Procesar pedido cocina | ✅ | ❌ | ✅ | ❌ | ❌ |
| Procesar pago | ✅ | ❌ | ❌ | ✅ | ❌ |
| Ver auditoría completa | ✅ | ❌ | ❌ | ❌ | ❌ |
| Ver mesas propias | ✅ | ✅ | ❌ | ❌ | ❌ |
| Ver disponibilidad | ✅ | ✅ | ❌ | ❌ | ✅ |

---

## 12. PRINCIPIOS DE DISEÑO

### 12.1 Usabilidad

> **El sistema se adapta a las personas, no las personas al sistema.**

- Interfaces intuitivas
- Flujos naturales
- Mínimos clics para operaciones frecuentes
- Feedback visual inmediato
- Diseño responsive (móvil, tablet, PC)

### 12.2 Confiabilidad

- Validaciones en tiempo real
- Prevención de errores
- Recuperación ante fallos
- Backups automáticos
- Auditoría completa

### 12.3 Performance

- Respuesta < 2 segundos en operaciones comunes
- Actualización en tiempo real de estados
- Optimización de consultas
- Caché inteligente

### 12.4 Escalabilidad

- Arquitectura modular
- Separación de responsabilidades
- Fácil adición de nuevas funcionalidades
- Soporte para múltiples locales (futuro)

---

## 13. GLOSARIO

- **Comanda**: Orden de pedido asociada a una mesa, contiene todos los ítems solicitados
- **Mesa Unida**: Conjunto de mesas físicamente cercanas que se agrupan temporalmente para atender a un grupo grande
- **Cliente Anónimo**: Cliente que no tiene cuenta en el sistema y realiza reservas por teléfono
- **Zona**: Área física del local (Salón, Barra, Patio, VIP)
- **Ítem de Comanda**: Producto individual dentro de una comanda (con cantidad y observaciones)
- **Estado de Mesa**: Situación actual de una mesa (Libre, Reservada, Ocupada, Unida)
- **Pantalla de Cocina**: Monitor/TV donde los cocineros ven la cola de pedidos
- **Auditoría**: Registro de todas las acciones críticas del sistema

---

**Documento creado por:** Sistema VARES  
**Versión:** 1.0  
**Fecha:** 2026-01-03
