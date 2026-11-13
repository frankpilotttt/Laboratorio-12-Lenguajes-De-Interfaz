; ------------------------------------------------
; Laboratorio 12 - Parte 2
; Animacion basica de un caracter en consola
; ------------------------------------------------

extrn GetStdHandle: proc
extrn SetConsoleCursorPosition: proc
extrn SetConsoleTextAttribute: proc
extrn WriteConsoleA: proc
extrn FillConsoleOutputCharacterA: proc
extrn FillConsoleOutputAttribute: proc
extrn Sleep: proc
extrn ExitProcess: proc

.data
    hConsole    dq 0
    caracter    db 'X', 0
    espacio     db ' ', 0
    escritos    dq 0

    pos_x       dw 0
    pos_y       dw 10

    leidos      dd 0
    homeCoord   dd 0
    numCeldas   dd 2000

.code
main proc
    ; Reservar espacio para llamadas de Windows x64
    sub rsp, 38h

    ; Obtener el identificador de salida de la consola
    mov rcx, -11
    call GetStdHandle
    mov [hConsole], rax
    mov rbx, rax

    ; Limpiar pantalla con espacios
    mov rcx, rbx
    mov rdx, 20h
    mov r8d, [numCeldas]
    mov r9d, [homeCoord]
    lea rax, leidos
    mov qword ptr [rsp + 20h], rax
    call FillConsoleOutputCharacterA

    ; Restaurar colores predeterminados
    mov rcx, rbx
    mov rdx, 07h
    mov r8d, [numCeldas]
    mov r9d, [homeCoord]
    lea rax, leidos
    mov qword ptr [rsp + 20h], rax
    call FillConsoleOutputAttribute

    ; Fondo negro y texto verde
    mov rcx, rbx
    mov rdx, 0Ah
    call SetConsoleTextAttribute

    ; Posicion inicial: X=0, Y=10
    mov word ptr [pos_x], 0

anim_loop:
    ; Si X=0, no existe una posicion anterior que borrar
    cmp word ptr [pos_x], 0
    je pintar_caracter

    ; Borrar la posicion anterior escribiendo un espacio
    mov rcx, rbx
    movzx rdx, word ptr [pos_x]
    dec rdx
    movzx rax, word ptr [pos_y]
    shl rax, 16
    or rdx, rax
    call SetConsoleCursorPosition

    mov rcx, rbx
    lea rdx, espacio
    mov r8d, 1
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

pintar_caracter:
    ; Mover el cursor a la nueva posicion
    mov rcx, rbx
    movzx rdx, word ptr [pos_x]
    movzx rax, word ptr [pos_y]
    shl rax, 16
    or rdx, rax
    call SetConsoleCursorPosition

    ; Escribir la X
    mov rcx, rbx
    lea rdx, caracter
    mov r8d, 1
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; Esperar 50 milisegundos
    mov rcx, 150
    call Sleep

    ; Avanzar una columna y continuar hasta la columna 69
    inc word ptr [pos_x]
    cmp word ptr [pos_x], 70
    jl anim_loop

    ; Finalizar
    xor ecx, ecx
    call ExitProcess

main endp
end
