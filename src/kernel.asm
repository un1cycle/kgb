org 0x7e00
bits 16

kernel_init:
    mov ax, 0x4f02
    mov bx, 0x11f | 0x4000 
    int 0x10

    mov ax, 0x4f01
    mov cx, 0x11f
    mov di, mode_info
    int 0x10

    mov eax, [mode_info + 0x28]
    mov [lfb_addr], eax

    in al, 0x92
    or al, 2
    out 0x92, al

    lgdt [gdt_desc]
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:pm_start

bits 32
pm_start:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000

    mov esi, ap_mcs
    mov edi, 0x8000
    mov ecx, mcs_end - ap_mcs
    rep movsb

    mov eax, 0xFEE00300
    mov edx, 0x000C4500      
    mov [eax], edx

    mov ecx, 0x1000000
    .delay: loop .delay

    mov edx, 0x000C4608      
    mov [eax], edx

    jmp common_logic

bits 16
ap_mcs:
    cli
    xor ax, ax
    mov ds, ax
    lgdt [gdt_desc - kernel_init + 0x7e00] 
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:ap_pm_entry
ap_mcs_end:

[bits 32]
ap_pm_entry:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    
    mov eax, 0xFEE00020
    mov ebx, [eax]
    shr ebx, 24              
    mov eax, 0x1000
    mul ebx
    mov esp, 0x90000
    sub esp, eax
    jmp common_logic

common_logic:
    mov eax, 0xFEE00020
    mov ebx, [eax]
    shr ebx, 24

    cmp ebx, 22
    jne skip_pixel_placement

    mov edi, [lfb_addr]
    ; imul ebx, 10             
    add edi, ebx
    ; add edi, 1024 * 4 * 100  

    mov eax, 0x00FFFFFF      
    mov [edi], eax
    
    skip_pixel_placement:

    cli
    hlt
    jmp $

mcs_end:

section .data
align 4
lfb_addr:  dd 0
mode_info: times 256 db 0

align 8
gdt:
    dq 0x0000000000000000
    dq 0x00cf9a000000ffff 
    dq 0x00cf92000000ffff 
gdt_desc:
    dw gdt_desc - gdt - 1
    dd gdt

