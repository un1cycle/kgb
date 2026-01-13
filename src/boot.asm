org 0x7C00
bits 16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    

    mov [dap_num_sectors], word 127 
    mov [dap_offset], word 0x7E00 
    mov [dap_segment], word 0x0000
    mov dword [dap_lba], 1          
    mov dword [dap_lba+4], 0     

    mov si, dap
    mov ah, 0x42
    mov dl, 0x80   
    int 0x13
    jc disk_error
index:
    dw 4
looper:
    add dword [dap_lba], 127
    mov cx, 127
    dec cx
    adv:
        add word [dap_offset], 512
        dec cx
        jnz adv
    mov word [dap_num_sectors], 127
    int 0x13
    jc disk_error
    sub word [idx_53479354], 1
    cmp word [idx_53479354], 0
    jne looper 




    jmp 0x0000:0x7E00 


disk_error:
    hlt

dap:
dap_size:       db 0x10
dap_reserved:   db 0
dap_num_sectors: dw 0
dap_offset:     dw 0
dap_segment:    dw 0
dap_lba:        dq 0

times 510-($-$$) db 0
dw 0xAA55
