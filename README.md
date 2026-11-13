# Laboratorio 12 - Ensamblador x64

## Datos de la práctica

**Tema:** Uso de funciones de la API de Windows para controlar la consola.  
**Archivos fuente:** `semana12.asm` y `semana12_anim.asm`.  
**Herramientas:** UASM64, GoLink y Windows.

## Objetivo

Desarrollar programas en ensamblador que permitan:

1. Mostrar un carácter con color en una posición específica de la consola.
2. Animar un carácter para que se desplace por la pantalla.
3. Utilizar funciones de la API de Windows: `GetStdHandle`, `SetConsoleCursorPosition`, `SetConsoleTextAttribute`, `WriteConsoleA` y `Sleep`.

## Parte 1. Pintar un carácter

**Archivo:** `semana12.asm`

El programa obtiene el identificador de salida de la consola, limpia la pantalla y restaura los atributos de color. Después posiciona el cursor en la columna 10 y fila 5, cambia el color a texto amarillo con fondo azul y escribe una `X`.

### Funciones utilizadas

- `GetStdHandle`: obtiene el identificador de la consola.
- `FillConsoleOutputCharacterA`: rellena la consola con espacios para limpiarla.
- `FillConsoleOutputAttribute`: restaura los atributos de color.
- `SetConsoleCursorPosition`: coloca el cursor en una coordenada.
- `SetConsoleTextAttribute`: cambia el color del texto y del fondo.
- `WriteConsoleA`: escribe el carácter en la consola.
- `ExitProcess`: termina el programa.

### Coordenadas y colores

La estructura `COORD` utiliza dos valores de 16 bits: X y Y. Para pasarla en un registro de 32 bits, X ocupa los 16 bits inferiores y Y los 16 bits superiores.

En el programa, X=10 y Y=5 se empaquetan como `0005000Ah`.

El atributo `1Eh` corresponde a texto amarillo intenso y fondo azul.

### Modificación realizada

Para comprobar el cambio de posición y color, se modificaron estos valores:

- Coordenada original: `0005000Ah` (X=10, Y=5).
- Coordenada modificada: `00080014h` (X=20, Y=8).
- Atributo original: `1Eh` (texto amarillo, fondo azul).
- Atributo modificado: `2Ch` (texto rojo claro, fondo verde).

Para probar la modificación, se cambia el valor en el código, se vuelve a ensamblar y enlazar, y se ejecuta el programa.

## Parte 2. Animación básica

**Archivo:** `semana12_anim.asm`

El programa muestra una `X` verde sobre fondo negro en la fila 10. La posición horizontal comienza en cero y aumenta una columna en cada repetición del ciclo.

Antes de dibujar la nueva posición, el programa borra la posición anterior escribiendo un espacio. La función `Sleep` introduce una pausa de 50 milisegundos entre movimientos. El ciclo termina al llegar al límite establecido en el código.

### Funciones y variables principales

- `pos_x`: almacena la posición horizontal del carácter.
- `pos_y`: almacena la fila donde se mueve el carácter.
- `SetConsoleCursorPosition`: mueve el cursor a la posición calculada.
- `WriteConsoleA`: escribe la X o un espacio para borrar la posición anterior.
- `Sleep`: controla la velocidad de la animación.
- `SetConsoleTextAttribute`: establece el texto verde sobre fondo negro.

### Modificaciones para comprobar el funcionamiento

Además de ejecutar la versión original de izquierda a derecha, se pueden realizar estas modificaciones:

1. **Cambiar la velocidad:** sustituir `mov rcx, 50` por `mov rcx, 100`. El movimiento será más lento.
2. **Cambiar el carácter:** sustituir `caracter db 'X', 0` por `caracter db '#', 0`.
3. **Cambiar la dirección:** iniciar `pos_x` en 70, borrar la posición anterior usando `inc rdx` en lugar de `dec rdx`, y después del retardo utilizar `dec word ptr [pos_x]` en lugar de `inc`. Cambiar la condición final por `cmp word ptr [pos_x], 0` y `jge anim_loop`.

Estas modificaciones se prueban por separado para identificar el efecto de cada cambio.

## Compilación y ejecución

Abrir la terminal en la carpeta donde se encuentran los archivos.

### Parte 1

```powershell
uasm64 -win64 semana12.asm
GoLink.exe semana12.obj kernel32.dll /fo semana12.exe /console /entry main
.\semana12.exe
```

### Parte 2

```powershell
uasm64 -win64 semana12_anim.asm
GoLink.exe semana12_anim.obj kernel32.dll /fo semana12_anim.exe /console /entry main
.\semana12_anim.exe
```


## Conclusión

En este laboratorio se practicó el uso de funciones de la API de Windows desde ensamblador x64 para controlar la consola. Se aprendió a posicionar el cursor, cambiar los atributos de color, escribir caracteres y controlar una animación mediante ciclos y retardos. También se comprobó que al modificar las coordenadas, los colores y la velocidad se puede cambiar el comportamiento de los programas.
