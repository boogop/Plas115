;▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
;▒  Plasma in 115 bytes by boogop
;▒  FASM source
;▒
;▒ Acknowledgements:
;▒ - wally/rage (literally who) for the sin generator
;▒  - might be the old swedish group from the amiga scene?
;▒  - used in argon by insomniac/matrix
;▒  - I have a lot of code from hornet archive and I've never
;▒    seen a generator like this one. I don't see any 386
;▒    instructions in it which would make it very old
;▒  - rbz (dbfinteractive.com) did some interesting analysis
;▒    of it and it's not a true sin generator, more a harmonic
;▒    oscillator from the days before FPU's
;▒
;▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
org 100h
use16

Start:
mov     al,13h              ; set mode 13
int     10h
push    0a000h              ; stick video segment in es
pop     es

;------- set palette ---------
xor     ax,ax
mov     dx, 3c9h            ; who needs 3c8h!
@redup:                     ; red-blue palette
out     dx,al               ; al will inc, ah will remain 0
xchg    al,ah               ; exchange ah-al so b & g get 0
out     dx,al
out     dx,al
xchg    al,ah               ; exchange back to increment al
inc     al                  ; first out in the loop sets r to al
cmp     al,127
jne     @redup
@bluedn:
xchg    al,ah               ; do the same for b
out     dx,al               ; setting r & g to 0
out     dx,al
xchg    al,ah
out     dx,al
dec     al                  ; blue decrements from 127
jnz     @bluedn

mov     cx,783Fh            ; harmonic oscillator by wally/rage
xor     si,si
sin1:
mov     ax,65497
imul    cx
add     si,dx
add     cx,si
mov     [bx],ch
sar     byte [bx],1
dec     bx
cmp     bx,16383
jne     sin1
mov     si,bx

@main:
xor     di,di               ; Reset vga position
mov     cx,[p_pos1]         ; stick position val into cx
@y_loop:
mov     dl,64
mov     ah,160              ; X counter. since we're using stosw
                            ; we only have to loop 320/2 times
@x_loop:
push    ax
mov     bl,dl               ; sin values are in si, movement in cx & dx
add     ax,[si+bx]
mov     bl,cl
add     ax,[si+bx]
mov     bl,ch
add     ax,[si+bx]
stosw                      ; stosw gives nice demo-y look
pop     ax
add     dx,0102h            ; add movement
dec     ah                  ; decrement the x counter
jnz     @x_loop             ; test for 0
add     cx,0102h            ; add movement
cmp     di,320*200          ; use di for the y_loop counter
jb      @y_loop             ; test for 0
inc     [p_pos1]
jmp     @main

p_pos1      dw 0

