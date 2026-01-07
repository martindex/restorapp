# MANUAL DE USUARIO - SISTEMA VARES POS
## Guía Completa por Rol

---

## 📋 ÍNDICE

1. [Introducción](#1-introducción)
2. [Acceso al Sistema](#2-acceso-al-sistema)
3. [Manual para Superusuario](#3-manual-para-superusuario)
4. [Manual para Mozo](#4-manual-para-mozo)
5. [Manual para Cocinero](#5-manual-para-cocinero)
6. [Manual para Cajero](#6-manual-para-cajero)
7. [Manual para Cliente](#7-manual-para-cliente)
8. [Preguntas Frecuentes](#8-preguntas-frecuentes)
9. [Resolución de Problemas](#9-resolución-de-problemas)

---

## 1. INTRODUCCIÓN

### 1.1 ¿Qué es VARES POS?

VARES POS es un sistema integral de punto de venta diseñado específicamente para bares y restaurantes. Gestiona todo el flujo operativo desde la reserva de mesas hasta el pago final, pasando por la toma de pedidos y la gestión de cocina.

### 1.2 Características Principales

✅ **Gestión Inteligente de Mesas:** Asignación automática y unión dinámica  
✅ **Reservas Online y Telefónicas:** Para clientes registrados y anónimos  
✅ **Sistema de Comandas:** Gestión completa de pedidos  
✅ **Pantalla de Cocina:** Cola de pedidos en tiempo real  
✅ **Notificaciones Instantáneas:** Actualizaciones en tiempo real  
✅ **Procesamiento de Pagos:** Múltiples métodos de pago  
✅ **Auditoría Completa:** Registro de todas las operaciones  

### 1.3 Requisitos del Sistema

**Para usar el sistema necesitas:**
- Navegador web moderno (Chrome, Firefox, Safari, Edge)
- Conexión a internet estable
- Credenciales de acceso proporcionadas por el administrador

**Dispositivos compatibles:**
- 💻 Computadora de escritorio
- 💻 Laptop
- 📱 Tablet
- 📱 Smartphone

---

## 2. ACCESO AL SISTEMA

### 2.1 Inicio de Sesión

1. Abre tu navegador web
2. Ingresa la URL: `http://tu-dominio.com` o `http://localhost:3000` (desarrollo)
3. Verás la pantalla de login

**Pantalla de Login:**
```
┌─────────────────────────────────┐
│                                 │
│        🍽️ VARES POS            │
│                                 │
│   Email:    [____________]      │
│   Password: [____________]      │
│                                 │
│        [  INICIAR SESIÓN  ]     │
│                                 │
│   ¿Olvidaste tu contraseña?     │
│                                 │
└─────────────────────────────────┘
```

4. Ingresa tu email y contraseña
5. Haz clic en "INICIAR SESIÓN"

### 2.2 Primera Vez

Si es tu primera vez en el sistema:

1. Recibirás un email con:
   - Tu email de acceso
   - Contraseña temporal
2. Inicia sesión con esas credenciales
3. El sistema te pedirá cambiar la contraseña
4. Crea una contraseña segura:
   - Mínimo 8 caracteres
   - Al menos una mayúscula
   - Al menos un número
   - Al menos un carácter especial

### 2.3 Cerrar Sesión

Para cerrar sesión de forma segura:

1. Haz clic en tu nombre (esquina superior derecha)
2. Selecciona "Cerrar Sesión"
3. Confirma la acción

---

## 3. MANUAL PARA SUPERUSUARIO

### 3.1 Dashboard Principal

Al iniciar sesión, verás el dashboard con:

```
┌────────────────────────────────────────────────────┐
│  VARES POS                    👤 Admin  [Salir]    │
├────────────────────────────────────────────────────┤
│  📊 Dashboard                                       │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │ Mesas    │  │ Reservas │  │ Ventas   │        │
│  │ Ocupadas │  │ Hoy      │  │ Hoy      │        │
│  │   15/30  │  │    8     │  │ $45,230  │        │
│  └──────────┘  └──────────┘  └──────────┘        │
│                                                     │
│  📈 Gráfico de ocupación                           │
│  [Gráfico de barras]                               │
│                                                     │
└────────────────────────────────────────────────────┘
```

### 3.2 Gestión de Usuarios

#### 3.2.1 Crear Usuario

1. Ve a **Menú → Usuarios**
2. Haz clic en **"+ Nuevo Usuario"**
3. Completa el formulario:
   - **Nombre completo:** Nombre y apellido
   - **Email:** Email único para login
   - **Rol:** Selecciona (Mozo, Cocinero, Cajero)
   - **Contraseña temporal:** Mínimo 8 caracteres
4. Haz clic en **"Crear Usuario"**
5. El sistema enviará las credenciales al email

#### 3.2.2 Editar Usuario

1. Ve a **Menú → Usuarios**
2. Busca el usuario en la lista
3. Haz clic en el ícono de editar ✏️
4. Modifica los campos necesarios
5. Haz clic en **"Guardar Cambios"**

#### 3.2.3 Desactivar Usuario

1. Ve a **Menú → Usuarios**
2. Busca el usuario en la lista
3. Haz clic en el interruptor de estado
4. Confirma la acción
5. El usuario no podrá iniciar sesión

### 3.3 Configuración del Salón

#### 3.3.1 Crear Zonas

1. Ve a **Menú → Configuración → Zonas**
2. Haz clic en **"+ Nueva Zona"**
3. Ingresa:
   - **Nombre:** Ej: "Salón Principal", "Terraza"
   - **Descripción:** Descripción breve
4. Haz clic en **"Crear Zona"**

#### 3.3.2 Crear Mesas

1. Ve a **Menú → Mesas**
2. Haz clic en **"+ Nueva Mesa"**
3. Completa:
   - **Número:** Número identificador (1, 2, 3...)
   - **Zona:** Selecciona la zona
   - **Capacidad:** Personas (default: 5)
   - **Posición X:** Coordenada horizontal
   - **Posición Y:** Coordenada vertical
4. Haz clic en **"Crear Mesa"**

**Tip:** Usa el mapa visual para posicionar las mesas arrastrándolas.

#### 3.3.3 Configurar Distribución

1. Ve a **Menú → Mesas → Vista de Mapa**
2. Arrastra las mesas a su posición real
3. Usa la grilla como referencia
4. Haz clic en **"Guardar Distribución"**

### 3.4 Gestión de Productos

#### 3.4.1 Crear Categoría

1. Ve a **Menú → Productos → Categorías**
2. Haz clic en **"+ Nueva Categoría"**
3. Ingresa:
   - **Nombre:** Ej: "Entradas", "Bebidas"
   - **Tipo:** Comida o Bebida
   - **Descripción:** Opcional
4. Haz clic en **"Crear Categoría"**

#### 3.4.2 Crear Producto

1. Ve a **Menú → Productos**
2. Haz clic en **"+ Nuevo Producto"**
3. Completa:
   - **Nombre:** Nombre del producto
   - **Descripción:** Descripción detallada
   - **Categoría:** Selecciona categoría
   - **Precio:** Precio en pesos
   - **Tipo:** Comida o Bebida
   - **Imagen:** Sube una foto (opcional)
4. Haz clic en **"Crear Producto"**

#### 3.4.3 Modificar Precio

1. Ve a **Menú → Productos**
2. Busca el producto
3. Haz clic en el ícono de editar ✏️
4. Modifica el precio
5. Haz clic en **"Guardar"**

**Importante:** El cambio de precio NO afecta comandas ya abiertas.

#### 3.4.4 Marcar Producto No Disponible

1. Ve a **Menú → Productos**
2. Busca el producto
3. Haz clic en el interruptor de disponibilidad
4. El producto no aparecerá en la carta para nuevos pedidos

### 3.5 Reservas Asistidas (Cliente Anónimo)

#### 3.5.1 Crear Reserva Telefónica

**Escenario:** Cliente llama para reservar

1. Ve a **Menú → Reservas**
2. Haz clic en **"+ Reserva Asistida"**
3. Completa:
   - **Nombre de referencia:** Nombre del cliente
   - **Teléfono:** Número de contacto (opcional)
   - **Cantidad de personas:** Número de comensales
   - **Fecha:** Fecha de la reserva
   - **Hora:** Hora de llegada
   - **Notas:** Observaciones especiales
4. Haz clic en **"Buscar Mesas Disponibles"**
5. El sistema mostrará las mesas sugeridas
6. Revisa la asignación
7. Haz clic en **"Confirmar Reserva"**
8. Comunica al cliente:
   - Número de reserva
   - Mesas asignadas
   - Hora de llegada

#### 3.5.2 Ejemplo Práctico

```
Cliente llama: "Hola, quiero reservar para 8 personas 
               el sábado a las 21:00"

Tú ingresas:
- Nombre: "Martínez"
- Teléfono: "11-2345-6789"
- Personas: 8
- Fecha: Sábado 10/01/2026
- Hora: 21:00
- Notas: "Cumpleaños, traen torta"

Sistema asigna: Mesas 5 y 6 (unidas)

Tú comunicas: "Perfecto Sr. Martínez, tiene reservado 
               para 8 personas el sábado 10 a las 21hs.
               Mesas 5 y 6. Número de reserva: #R-1234"
```

### 3.6 Reportes y Auditoría

#### 3.6.1 Ver Ventas del Día

1. Ve a **Menú → Reportes → Ventas**
2. Selecciona **"Hoy"**
3. Verás:
   - Total vendido
   - Cantidad de comandas
   - Ticket promedio
   - Método de pago más usado

#### 3.6.2 Ver Auditoría

1. Ve a **Menú → Auditoría**
2. Filtra por:
   - Fecha
   - Usuario
   - Tipo de evento
3. Verás todas las acciones registradas

---

## 4. MANUAL PARA MOZO

### 4.1 Dashboard del Mozo

Al iniciar sesión verás:

```
┌────────────────────────────────────────────────────┐
│  VARES POS                    👤 Juan  [Salir]     │
├────────────────────────────────────────────────────┤
│  🍽️ Mis Mesas                                      │
│                                                     │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐          │
│  │ M-5  │  │ M-8  │  │ M-12 │  │ M-15 │          │
│  │ 🟢   │  │ 🔴   │  │ 🟡   │  │ 🟢   │          │
│  │ Libre│  │Ocup. │  │Reser.│  │ Libre│          │
│  └──────┘  └──────┘  └──────┘  └──────┘          │
│                                                     │
│  🟢 Libre    🔴 Ocupada    🟡 Reservada            │
│                                                     │
└────────────────────────────────────────────────────┘
```

### 4.2 Abrir Mesa

#### 4.2.1 Sin Reserva

**Escenario:** Cliente llega sin reserva

1. Ve a **Mis Mesas**
2. Selecciona una mesa libre (🟢)
3. Haz clic en **"Abrir Mesa"**
4. Confirma la cantidad de personas
5. La mesa cambia a estado Ocupada (🔴)
6. Se crea una comanda automáticamente

#### 4.2.2 Con Reserva

**Escenario:** Cliente llega con reserva

1. Ve a **Reservas del Día**
2. Busca la reserva por nombre o número
3. Haz clic en **"Cliente Llegó"**
4. Verifica la identidad del cliente
5. Haz clic en **"Confirmar y Abrir Mesa"**
6. Las mesas asignadas se abren automáticamente

### 4.3 Tomar Pedido

#### 4.3.1 Proceso Completo

1. Entrega la carta impresa al cliente
2. Cuando el cliente esté listo, abre la app
3. Ve a **Mis Mesas**
4. Selecciona la mesa ocupada
5. Haz clic en **"Tomar Pedido"**
6. Verás la carta digital con categorías
7. Para cada producto:
   - Selecciona el producto
   - Indica cantidad
   - Agrega observaciones si es necesario
   - Haz clic en **"Agregar"**
8. Revisa el pedido completo
9. Confirma con el cliente
10. Haz clic en **"Enviar a Cocina"**

#### 4.3.2 Ejemplo Práctico

```
Cliente pide:
- 2 hamburguesas completas
- 1 hamburguesa sin cebolla
- 3 cervezas
- 1 gaseosa

Tú cargas:
1. Hamburguesa Completa
   Cantidad: 2
   Observaciones: -
   
2. Hamburguesa Completa
   Cantidad: 1
   Observaciones: "SIN CEBOLLA"
   
3. Cerveza Quilmes
   Cantidad: 3
   Observaciones: -
   
4. Coca Cola
   Cantidad: 1
   Observaciones: -

[Enviar a Cocina]
```

**Resultado:**
- Las hamburguesas van a cocina
- Las bebidas quedan en tu gestión

### 4.4 Agregar Ítems a Comanda Existente

**Escenario:** Cliente pide algo más

1. Ve a **Mis Mesas**
2. Selecciona la mesa
3. Verás la comanda activa
4. Haz clic en **"Agregar Ítems"**
5. Selecciona los nuevos productos
6. Haz clic en **"Agregar a Comanda"**
7. Los nuevos ítems se envían a cocina

### 4.5 Servir Pedido

#### 4.5.1 Notificación de Pedido Listo

Cuando cocina termina un pedido:
- Recibes una notificación 🔔
- Aparece en **"Pedidos Listos"**

#### 4.5.2 Servir

1. Ve a **Pedidos Listos**
2. Verás el número de mesa y productos
3. Ve a cocina y retira el pedido
4. Verifica que esté completo
5. Sirve en la mesa
6. En la app, marca como **"Servido"**

### 4.6 Gestionar Bebidas

Las bebidas NO van a cocina:

1. Cuando tomas un pedido con bebidas
2. Las bebidas quedan en tu lista de pendientes
3. Ve a **Mis Pendientes**
4. Prepara o solicita las bebidas
5. Sírvelas en la mesa
6. Marca como **"Servido"**

### 4.7 Solicitar Cierre de Mesa

Cuando el cliente pide la cuenta:

1. Ve a **Mis Mesas**
2. Selecciona la mesa
3. Verifica que todo esté servido
4. Haz clic en **"Solicitar Cierre"**
5. El cajero recibirá la solicitud
6. Espera a que el cajero procese el pago
7. La mesa se liberará automáticamente

---

## 5. MANUAL PARA COCINERO

### 5.1 Pantalla de Cocina

La pantalla de cocina es una vista simplificada en modo TV:

```
┌────────────────────────────────────────────────────┐
│  🍳 COLA DE COCINA                    15:45        │
├────────────────────────────────────────────────────┤
│                                                     │
│  ┌─────────────────────┐  ┌─────────────────────┐ │
│  │ MESA 5   ⏱️ 5 min   │  │ MESA 12  ⏱️ 12 min  │ │
│  │ ⚪ PENDIENTE         │  │ 🟡 EN PROGRESO      │ │
│  │                     │  │                     │ │
│  │ • Hamburguesa x2    │  │ • Milanesa Napoli   │ │
│  │ • Hamburguesa x1    │  │ • Papas Fritas      │ │
│  │   ⚠️ SIN CEBOLLA    │  │                     │ │
│  │                     │  │                     │ │
│  │ [TOMAR PEDIDO]      │  │ [FINALIZAR]         │ │
│  └─────────────────────┘  └─────────────────────┘ │
│                                                     │
│  ┌─────────────────────┐                          │
│  │ MESA 8   ⏱️ 8 min   │                          │
│  │ ⚪ PENDIENTE         │                          │
│  │                     │                          │
│  │ • Pizza Muzza       │                          │
│  │ • Empanadas x6      │                          │
│  │                     │                          │
│  │ [TOMAR PEDIDO]      │                          │
│  └─────────────────────┘                          │
│                                                     │
└────────────────────────────────────────────────────┘
```

### 5.2 Tomar Pedido

Cuando llega un pedido nuevo:

1. Aparece en la pantalla con estado ⚪ PENDIENTE
2. Muestra:
   - Número de mesa
   - Tiempo transcurrido
   - Lista de productos
   - Observaciones (si las hay)
3. Cuando estés listo para prepararlo:
   - Haz clic en **"TOMAR PEDIDO"**
   - El estado cambia a 🟡 EN PROGRESO

### 5.3 Preparar Pedido

1. Lee cuidadosamente las observaciones
2. Prepara los platos según el pedido
3. Verifica que todo esté correcto
4. Cuando termines, haz clic en **"FINALIZAR"**
5. El mozo recibirá una notificación automática

### 5.4 Pedidos Urgentes

Si un pedido lleva más de 15 minutos:
- Se resalta en color rojo 🔴
- Aparece el ícono ⚠️ URGENTE
- Prioriza estos pedidos

### 5.5 Observaciones Importantes

**Ejemplos de observaciones:**
- "SIN CEBOLLA"
- "BIEN COCIDO"
- "POCO SAL"
- "ALÉRGICO A MANÍ"
- "VEGETARIANO"

**⚠️ IMPORTANTE:** Lee SIEMPRE las observaciones antes de cocinar.

---

## 6. MANUAL PARA CAJERO

### 6.1 Dashboard del Cajero

```
┌────────────────────────────────────────────────────┐
│  VARES POS                    👤 María  [Salir]    │
├────────────────────────────────────────────────────┤
│  💰 Caja                                            │
│                                                     │
│  📊 Resumen del Día                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │ Ventas   │  │ Comandas │  │ Ticket   │        │
│  │ $45,230  │  │    23    │  │ Promedio │        │
│  │          │  │          │  │  $1,966  │        │
│  └──────────┘  └──────────┘  └──────────┘        │
│                                                     │
│  🔔 Pendientes de Pago                             │
│  • Mesa 5  - $3,450                                │
│  • Mesa 12 - $5,200                                │
│                                                     │
└────────────────────────────────────────────────────┘
```

### 6.2 Procesar Pago

#### 6.2.1 Flujo Completo

1. Recibes solicitud de cierre del mozo
2. Ve a **Pendientes de Pago**
3. Selecciona la mesa
4. Verás el detalle de la comanda:
   - Lista de productos
   - Cantidades
   - Precios
   - Subtotal
5. Pregunta al cliente el método de pago
6. Selecciona el método:
   - 💵 Efectivo
   - 💳 Tarjeta de Débito
   - 💳 Tarjeta de Crédito
   - 📱 Transferencia
   - 📱 QR
7. Ingresa el monto (si es efectivo)
8. Pregunta si desea agregar propina
9. Ingresa propina (opcional)
10. Verifica el total
11. Haz clic en **"Procesar Pago"**
12. El sistema genera el ticket
13. Imprime o envía el ticket al cliente
14. La comanda se cierra automáticamente
15. La mesa se libera

#### 6.2.2 Ejemplo Práctico

```
Mesa 5 solicita cuenta

Detalle:
- Hamburguesa Completa x2    $2,400
- Hamburguesa Completa x1    $1,200
- Cerveza Quilmes x3         $1,800
- Coca Cola x1               $  500
                    ─────────────────
                    Subtotal: $5,900

Cliente: "Pago con tarjeta de débito"

Tú:
1. Seleccionas "Tarjeta de Débito"
2. Preguntas: "¿Desea agregar propina?"
3. Cliente: "Sí, 10%"
4. Ingresas propina: $590
5. Total: $6,490
6. Procesas el pago
7. Imprimes ticket
8. Entregas al cliente

Sistema cierra la comanda y libera Mesa 5
```

### 6.3 Propina

La propina es opcional:

1. El sistema sugiere 10% por defecto
2. Puedes modificar el porcentaje
3. O ingresar un monto fijo
4. El cliente puede rechazar la propina

### 6.4 Ticket/Factura

El ticket incluye:
- Fecha y hora
- Número de comanda
- Mesa
- Mozo
- Detalle de productos
- Subtotal
- Propina
- Total
- Método de pago

### 6.5 Reportes de Caja

#### 6.5.1 Cierre de Caja Diario

Al final del día:

1. Ve a **Reportes → Cierre de Caja**
2. Selecciona la fecha
3. Verás:
   - Total en efectivo
   - Total en tarjeta
   - Total en transferencias
   - Cantidad de comandas
   - Ticket promedio
4. Haz clic en **"Generar Reporte"**
5. Imprime o exporta el reporte

---

## 7. MANUAL PARA CLIENTE

### 7.1 Crear Cuenta

1. Ve a la página web del restaurante
2. Haz clic en **"Reservar Mesa"**
3. Si no tienes cuenta, haz clic en **"Registrarse"**
4. Completa:
   - Nombre completo
   - Email
   - Teléfono
   - Contraseña
5. Haz clic en **"Crear Cuenta"**
6. Recibirás un email de confirmación
7. Haz clic en el enlace para activar tu cuenta

### 7.2 Hacer una Reserva

#### 7.2.1 Proceso Completo

1. Inicia sesión en la web
2. Haz clic en **"Reservar Mesa"**
3. Completa:
   - **Cantidad de personas:** Número de comensales
   - **Fecha:** Día de la reserva
   - **Hora:** Hora de llegada
   - **Zona preferida:** Salón, Patio, VIP (opcional)
4. Haz clic en **"Buscar Disponibilidad"**
5. El sistema mostrará:
   - Mesas disponibles
   - Ubicación en el mapa
   - Si son mesas unidas (para grupos grandes)
6. Revisa la asignación
7. Agrega notas especiales (opcional):
   - "Cumpleaños"
   - "Aniversario"
   - "Traemos torta"
8. Haz clic en **"Confirmar Reserva"**
9. Recibirás un email de confirmación con:
   - Número de reserva
   - Fecha y hora
   - Mesas asignadas
   - Código QR (para mostrar al llegar)

#### 7.2.2 Ejemplo

```
Quieres reservar para 6 personas el sábado a las 20:00

1. Seleccionas:
   - Personas: 6
   - Fecha: Sábado 10/01/2026
   - Hora: 20:00
   - Zona: Patio

2. Sistema muestra:
   "Mesas disponibles: 15 y 16 (unidas)
    Ubicación: Patio, cerca de la ventana"

3. Confirmas la reserva

4. Recibes email:
   "Reserva confirmada #R-5678
    Sábado 10/01 a las 20:00hs
    Mesas 15 y 16 - Patio
    Para 6 personas
    
    Código QR: [QR CODE]
    
    Por favor llega 10 minutos antes."
```

### 7.3 Ver Mis Reservas

1. Inicia sesión
2. Ve a **"Mis Reservas"**
3. Verás todas tus reservas:
   - Próximas
   - Pasadas
   - Canceladas
4. Para cada reserva puedes:
   - Ver detalles
   - Modificar (hasta 24hs antes)
   - Cancelar (hasta 24hs antes)

### 7.4 Cancelar Reserva

1. Ve a **"Mis Reservas"**
2. Selecciona la reserva
3. Haz clic en **"Cancelar Reserva"**
4. Confirma la cancelación
5. Recibirás un email de confirmación

**Importante:** Solo puedes cancelar hasta 24 horas antes.

### 7.5 Modificar Reserva

1. Ve a **"Mis Reservas"**
2. Selecciona la reserva
3. Haz clic en **"Modificar"**
4. Cambia la fecha, hora o cantidad de personas
5. El sistema verificará disponibilidad
6. Confirma los cambios

**Importante:** Solo puedes modificar hasta 24 horas antes.

---

## 8. PREGUNTAS FRECUENTES

### 8.1 Generales

**P: ¿Qué hago si olvidé mi contraseña?**  
R: En la pantalla de login, haz clic en "¿Olvidaste tu contraseña?". Ingresa tu email y recibirás instrucciones para restablecerla.

**P: ¿Puedo usar el sistema desde mi celular?**  
R: Sí, el sistema es responsive y funciona en cualquier dispositivo con navegador web.

**P: ¿Necesito instalar algo?**  
R: No, solo necesitas un navegador web moderno y conexión a internet.

### 8.2 Para Mozos

**P: ¿Qué hago si me equivoco al tomar un pedido?**  
R: Puedes editar o eliminar ítems de la comanda antes de enviarla a cocina. Una vez enviada, debes solicitar ayuda al Superusuario.

**P: ¿Cómo sé si un pedido está listo en cocina?**  
R: Recibirás una notificación automática en la app cuando el pedido esté listo.

**P: ¿Puedo abrir varias mesas al mismo tiempo?**  
R: Sí, puedes gestionar múltiples mesas simultáneamente.

### 8.3 Para Cocineros

**P: ¿Qué hago si falta un ingrediente?**  
R: Cambia el estado del pedido a "Pendiente" y notifica inmediatamente al Superusuario.

**P: ¿Puedo ver los precios de los productos?**  
R: No, la pantalla de cocina no muestra precios por diseño.

**P: ¿Qué significa el color rojo en un pedido?**  
R: Indica que el pedido lleva más de 15 minutos y debe ser priorizado.

### 8.4 Para Cajeros

**P: ¿Qué hago si el cliente quiere dividir la cuenta?**  
R: Actualmente el sistema no soporta división de cuenta. Debes calcular manualmente y procesar pagos separados.

**P: ¿Puedo cancelar un pago ya procesado?**  
R: No, una vez procesado el pago no se puede cancelar. Debes solicitar ayuda al Superusuario.

**P: ¿Cómo imprimo el ticket?**  
R: El sistema enviará automáticamente a la impresora configurada. Si no funciona, puedes exportar como PDF.

### 8.5 Para Clientes

**P: ¿Puedo reservar para el mismo día?**  
R: Sí, siempre que haya disponibilidad.

**P: ¿Hasta cuándo puedo cancelar mi reserva?**  
R: Hasta 24 horas antes de la fecha reservada.

**P: ¿Qué pasa si llego tarde?**  
R: Las reservas tienen una tolerancia de 15 minutos. Después de ese tiempo, la mesa puede ser reasignada.

---

## 9. RESOLUCIÓN DE PROBLEMAS

### 9.1 No Puedo Iniciar Sesión

**Problema:** Email o contraseña incorrectos

**Solución:**
1. Verifica que el email esté escrito correctamente
2. Verifica que Caps Lock esté desactivado
3. Intenta restablecer la contraseña
4. Si el problema persiste, contacta al administrador

### 9.2 La Página No Carga

**Problema:** Pantalla en blanco o error de conexión

**Solución:**
1. Verifica tu conexión a internet
2. Recarga la página (F5 o Ctrl+R)
3. Limpia la caché del navegador
4. Intenta con otro navegador
5. Contacta a soporte técnico

### 9.3 No Recibo Notificaciones

**Problema:** No llegan notificaciones de pedidos listos

**Solución:**
1. Verifica que las notificaciones estén habilitadas en tu navegador
2. Recarga la página
3. Cierra sesión y vuelve a iniciar
4. Contacta a soporte técnico

### 9.4 Error al Procesar Pago

**Problema:** El pago no se procesa correctamente

**Solución:**
1. Verifica que todos los ítems estén servidos
2. Verifica que el monto sea correcto
3. Intenta nuevamente
4. Si el error persiste, contacta al Superusuario
5. NO cierres la comanda manualmente

### 9.5 Mesa No Se Libera

**Problema:** La mesa sigue ocupada después de cerrar la comanda

**Solución:**
1. Verifica que el pago esté procesado
2. Verifica que la comanda esté cerrada
3. Recarga la página
4. Si el problema persiste, contacta al Superusuario

### 9.6 Pedido No Llega a Cocina

**Problema:** El pedido no aparece en la pantalla de cocina

**Solución:**
1. Verifica que hayas hecho clic en "Enviar a Cocina"
2. Verifica que los productos sean de tipo "Comida" (las bebidas no van a cocina)
3. Recarga la pantalla de cocina
4. Si el problema persiste, contacta a soporte técnico

---

## 10. CONTACTO Y SOPORTE

### 10.1 Soporte Técnico

**Email:** soporte@vares.com  
**Teléfono:** +54 11 1234-5678  
**Horario:** Lunes a Viernes 9:00 - 18:00

### 10.2 Soporte Urgente

Para problemas críticos durante el servicio:

**Teléfono de Emergencia:** +54 11 9876-5432  
**Disponible:** 24/7

### 10.3 Capacitación

Si necesitas capacitación adicional:

**Email:** capacitacion@vares.com  
**Solicita:** Sesión de capacitación personalizada

---

## 11. GLOSARIO

- **Comanda:** Orden de pedido asociada a una mesa
- **Mesa Unida:** Conjunto de mesas agrupadas temporalmente para un grupo grande
- **Cliente Anónimo:** Cliente sin cuenta que reserva por teléfono
- **Zona:** Área física del local (Salón, Barra, Patio, VIP)
- **Ítem:** Producto individual dentro de una comanda
- **Estado:** Situación actual de una mesa, comanda o pedido
- **Ticket:** Comprobante de pago impreso o digital

---

## 12. ATAJOS DE TECLADO

### 12.1 Generales

- `Ctrl + S` - Guardar
- `Esc` - Cerrar modal
- `F5` - Recargar página
- `Ctrl + F` - Buscar

### 12.2 Navegación

- `Alt + 1` - Dashboard
- `Alt + 2` - Mesas
- `Alt + 3` - Reservas
- `Alt + 4` - Comandas

---

**Documento creado por:** Sistema VARES  
**Versión:** 1.0  
**Fecha:** 2026-01-03  
**Última actualización:** 2026-01-03

---

**¿Necesitas ayuda adicional?**  
Contacta a soporte: soporte@vares.com
