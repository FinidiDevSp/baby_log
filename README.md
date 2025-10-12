# Baby Log

Baby Log es una aplicación Flutter enfocada en registrar eventos diarios del bebé como tomas de biberón y cambios de pañal.

## Estado actual

- La ficha del bebé se persiste en una base de datos local SQLite gestionada con [Drift](https://drift.simonbinder.eu/).
- Las tomas de biberón y los cambios de pañal ahora se persisten en SQLite y se restauran automáticamente cuando se vuelve a abrir la aplicación.

## Próximos pasos sugeridos

1. Permitir editar y eliminar tomas o cambios de pañal desde la línea de tiempo diaria.
2. Añadir pruebas de integración que garanticen que los registros se mantienen entre sesiones.
3. Documentar la estrategia de sincronización o exportación en caso de que se agregue soporte multi-dispositivo.

