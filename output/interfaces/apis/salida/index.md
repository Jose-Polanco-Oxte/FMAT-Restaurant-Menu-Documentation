[Índice general](../../index.md)

# Interfaces HTTP de salida

**Esta revisión no requiere ninguna llamada HTTP de Menu a otros microservicios.** No se especifican endpoints de Orders, Inventory o Cocina. Por tanto, no hay body, autorización HTTP ni respuesta de salida que completar artificialmente.

Menu emite necesidades y solicitudes de reevaluación a Inventory por mensajería y consume evaluaciones. Publica cambios de catálogo para consumidores autorizados. La resolución se devuelve como respuesta a E-16. Estos son los [contratos de salida por mensajes](../../eventos/index.md), con payload, canal, autorización y resultado esperado.

La lectura HTTP E-18 es de entrada a Menu para recuperar sus definiciones publicadas. No consulta el inventario. El endpoint síncrono E-16 también es de entrada y es el contrato de resolución usado por Orders, no una dependencia HTTP de Menu hacia Orders.

Verificar existencia/unidades de referencias Inventory durante administración no se convierte en nueva llamada síncrona: se valida formato local, y una definición sin evaluación positiva no es elegible. Un catálogo replicado de artículos/unidades requeriría un contrato adicional acordado con Inventory; no se inventa en esta revisión. La caída detectada o el vencimiento de evaluaciones impiden disponibilidad positiva sin depender de una API de salud externa.
