# Dashboard Data Center

Proyecto de prueba técnica construido con **Ruby on Rails 7** que
consolida información de **ClickUp** y **Stripe** en un solo dashboard.

El objetivo del proyecto es demostrar:

- Integración con APIs externas
- Arquitectura limpia usando **Service Objects**
- Transformación y filtrado de datos
- Manejo seguro de errores de APIs
- Separación de responsabilidades en una aplicación Rails

---

# Stack Tecnológico

- Ruby 3.x
- Rails 7
- PostgreSQL
- Hotwire (Turbo + Stimulus)
- Faraday (cliente HTTP para ClickUp)
- Stripe Ruby SDK

---

# Funcionalidades

## Widget de Tareas (ClickUp)

Muestra tareas provenientes de una lista de ClickUp.

Información mostrada:

- Nombre de la tarea
- Estado
- Asignado
- Fecha de vencimiento

Filtros disponibles:

- Overdue (tareas vencidas)
- Due Today (tareas que vencen hoy)
- Assigned to Me
- Filtrar por estado

Comportamiento adicional:

- Manejo de errores de API sin romper el dashboard
- Ignora tareas sin fecha de vencimiento cuando es necesario
- Conversión de timestamps de ClickUp a objetos de tiempo de Rails

---

## Widget de Ingresos (Stripe)

Muestra pagos recientes provenientes de Stripe.

Información mostrada:

- Monto del pago
- Fecha del pago
- Estado
- Descripción

Filtros disponibles:

- Rango de fechas
- Estado del pago (succeeded / pending / failed)

Métricas calculadas:

- Total de ingresos
- Cantidad de transacciones
- Promedio por transacción

---

# Arquitectura

El proyecto sigue una arquitectura basada en **Service Objects** para
mantener los controladores limpios.

Controller ↓ Services ↓ APIs externas

Ejemplo:

DashboardController ↓ ClickupService / StripeService ↓ ClickUp API /
Stripe API

Responsabilidades:

Controllers → manejar requests HTTP\
Services → comunicarse con APIs y transformar datos\
Views → renderizar la interfaz

---

# Variables de Entorno

El proyecto requiere un archivo `.env` en la raíz del proyecto.

Crear un archivo llamado:

.env

con las siguientes variables:

CLICKUP_API_TOKEN= CLICKUP_API_URL= CLICKUP_LIST_ID= STRIPE_SECRET_KEY=

---

# Configuración de ClickUp

1.  Inicia sesión en ClickUp.
2.  Haz clic en tu **avatar (esquina inferior izquierda)**.
3.  Ve a:

Settings → Apps → Generate API Token

4.  Copia el token generado y colócalo en:

CLICKUP_API_TOKEN

---

## ClickUp API URL

Utiliza la URL base:

https://api.clickup.com/api/v2

y agrégala a:

CLICKUP_API_URL

---

## Obtener el LIST ID

La aplicación obtiene tareas desde una lista específica de ClickUp.

Para obtener el **List ID**:

1.  Abre la lista en ClickUp.
2.  Observa la URL.

Ejemplo:

https://app.clickup.com/t/123456789
o
https://app.clickup.com/(team_id)/v/li/123456789

El identificador numérico corresponde a la lista.

Colócalo en:

CLICKUP_LIST_ID

---

# Configuración de Stripe

1.  Crear una cuenta en:

https://dashboard.stripe.com

2.  Ir al dashboard de Stripe.

3.  Navegar a:

Developers → API Keys

4.  Copiar la **Secret Key**.

Ejemplo:

sk_test_xxxxxxxxxxxxxxxxx

Agregarla en:

STRIPE_SECRET_KEY

---

# Ejecutar el Proyecto

Instalar dependencias:

bundle install

Iniciar el servidor:

rails s

Abrir el navegador en:

http://localhost:3000

---

# Notas

Los **tests automatizados no fueron implementados** debido a
limitaciones de tiempo durante la prueba técnica.

Con más tiempo se agregarían:

- Tests para Service Objects
- Tests de integración de APIs
- Tests de lógica de filtros

---

# Mejoras Futuras

- Agregar tests automatizados
- Mejorar la interfaz visual
- Paginación de resultados
- Mejor manejo de errores en UI

---

# Autor

David Castro
