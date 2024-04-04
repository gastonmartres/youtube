# Vim Commands Cheat Sheet

## Modo Normal
- **Navegación Básica**: `h` (izquierda), `j` (abajo), `k` (arriba), `l` (derecha)
- **Buscar**: `/` para buscar hacia adelante, `?` para buscar hacia atrás
- **Abrir y Guardar Archivos**: `:e <archivo>` para abrir, `:w` para guardar
- **Copiar (yank) y Pegar**: `yy` para copiar una línea, `p` para pegar después del cursor

## Modo de Inserción
- `i` entra al Modo de Inserción antes del cursor.
- `I` inserta al inicio de la línea.
- `a` inserta después del cursor.
- `A` inserta al final de la línea.
- `o` abre una nueva línea debajo del cursor y entra en Modo de Inserción.
- `O` abre una nueva línea arriba del cursor y entra en Modo de Inserción.

## Modo Visual
- `v` para selección de caracteres.
- `V` para selección de líneas completas.
- `Ctrl+v` para selección de bloques.

## Modo de Comando
- `:w` para guardar cambios.
- `:q` para salir de Vim.
- `:s/palabra/nueva_palabra/g` para reemplazar en una línea.
- `:%s/palabra/nueva_palabra/g` para reemplazar en todo el documento.

## Deshacer y Rehacer
- `u` para deshacer.
- `Ctrl+r` para rehacer.

## Cortar, Copiar, y Pegar
- `dd` para cortar una línea.
- `yy` para copiar una línea.
- `p` para pegar después del cursor.

## Buscar y Reemplazar
- `:s/palabra/nueva_palabra/g` para reemplazar todas las instancias en una línea.
- `:%s/palabra/nueva_palabra/g` para reemplazar todas las instancias en todo el documento.
