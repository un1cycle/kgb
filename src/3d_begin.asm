pusha

line:
mov eax, 0 ; x1
mov ebx, 0 ; y1
mov ecx, 80 ; x2
mov edx, 80 ; y2

mov edi, edx
sub edx, ebx
mov esi, ecx
sub esi, eax

idiv edi, esi ; integer slope in edi
mov esi, ebx
push ecx
mov ecx, edi
imul ecx, eax
sub esi, ecx ; integer y-intercept in esi
pop ecx

; rectangle should be from x1 -> x1 + 1
; y1 -> y1 + (y1 * slope + y-int)
