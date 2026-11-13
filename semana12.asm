
; ------------------------------------------------
; Laboratorio 12 - Parte 1
; Pintar un caracter en color
; ------------------------------------------------

extrn GetStdHandle: proc
extrn SetConsoleCursorPosition: proc
extrn SetConsoleTextAttribute: proc
extrn WriteConsoleA: proc
extrn FillConsoleOutputCharacterA: proc
extrn FillConsoleOutputAttribute: proc
extrn ExitProcess: proc

.data
    hConsole    dq 0
    caracter    db 'X', 0
    escritos    dq 0
    coord       dw 10, 5

    leidos      dd 0
    homeCoord   dd 0
    numCeldas   dd 2000

.code
main proc
    sub rsp, 38h

    ; Obtener el identificador de consola
    mov rcx, -11
    call GetStdHandle
    mov [hConsole], rax
    mov rbx, rax

    ; Limpiar pantalla
    mov rcx, rbx
    mov rdx, 20h
    mov r8d, [numCeldas]
    mov r9d, [homeCoord]
    lea rax, leidos
    mov qword ptr [rsp + 20h], rax
    call FillConsoleOutputCharacterA

    ; Restaurar colores
    mov rcx, rbx
    mov rdx, 07h
    mov r8d, [numCeldas]
    mov r9d, [homeCoord]
    lea rax, leidos
    mov qword ptr [rsp + 20h], rax
    call FillConsoleOutputAttribute

    ; Posicionar cursor en X=10, Y=5
    mov rcx, rbx
    mov rdx, 0008001Ah
    call SetConsoleCursorPosition

    ; Fondo azul y texto amarillo
    mov rcx, rbx
    mov rdx, 2Ch
    call SetConsoleTextAttribute

    ; Escribir X
    mov rcx, rbx
    lea rdx, caracter
    mov r8d, 1
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; Finalizar programa
    xor ecx, ecx
    call ExitProcess

main endp
end