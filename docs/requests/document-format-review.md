# Corrección sintáctica y de formato de spec.md

## Objetivo

Realizar una revisión exclusivamente sintáctica y de formato sobre `/docs/md/spec.md`, sin alterar decisiones funcionales ni arquitectónicas.

## Tarea

Revisar:

- jerarquía de encabezados Markdown;
- listas;
- tablas;
- bloques de código;
- enlaces internos;
- Mermaid;
- expresiones matemáticas;
- caracteres escapados incorrectamente;
- formato inconsistente de nombres técnicos.

Corregir especialmente las expresiones asociadas a:

- `ModifierGroup.maxSelections`;
- `ComboSlot.maxSelections`.

Actualmente existen expresiones LaTeX mal formadas similares a:

```text
\ge \text{min\_selections}
```

Para invariantes simples de atributos, preferir una representación técnica legible como:

```text
0 <= minSelections <= maxSelections
```

en lugar de utilizar LaTeX innecesariamente.

Utilizar LaTeX únicamente cuando realmente mejore la legibilidad.

## Consistencia de nombres

Comprobar que entidades y atributos conserven exactamente su nomenclatura canónica, por ejemplo:

```text
MenuItem
MenuItemVariant
ModifierGroup
ModifierOption
ComboConfiguration
ComboSlot
ComboOption
minSelections
maxSelections
maxQuantity
availableMaxQuantity
```

No cambiar nombres de dominio por razones puramente estilísticas.

## Restricciones

No modificar:

- significado de requisitos;
- modelo de dominio;
- decisiones arquitectónicas;
- numeración de requisitos;
- contratos;
- reglas de negocio.

Resultado

Actualizar `/docs/md/spec.md`.
