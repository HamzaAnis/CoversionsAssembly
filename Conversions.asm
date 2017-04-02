.model small
	.386
.stack 200h
.data
NUMSTR		BYTE "00000000000128"
part1 db "PART 1",10,13,'$'
part2 db "PART 2",10,13,'$'
part3 db "PART 3",10,13,'$'

part3_1 db "1024d",'$'
part3_2 db "0ABCDEF98h",'$'
part3_3 db "Hello Students",'$'

msg db "Number in base ",'$'
msg1 db "Hex number of ",'$'
msg2 db " is: ",'$'

strout db 16 dup (0)
num dd 1024
base dd 5
ENDL DB 10,13,'$'		
tohex dw 0

.code
mov ax,@data
mov ds,ax


main proc 


call PreLab1
call PreLab2
call PreLab3





mov ah,4ch
int 21h
main endp


;//////////////////////////////////////////////////////////////////////////////////
			PreLab1 proc
			;This is for part 1
					mov ah,09h
					lea dx,part1
					int 21h
					;Part2
					mov eax,num
					CALL number_to_base

					mov eax,num
					mov base,7
					call number_to_base

					mov eax,num
					mov base,9
					call number_to_base

					mov eax,num
					mov base,10
					call number_to_base

					mov eax,num
					mov base,12
					call number_to_base

					mov eax,num
					mov base,14
					call number_to_base

			ret
			PreLab1 endp
					;for new line
					
;//////////////////////////////////////////////////////////////////////////////////

			number_to_base proc
					mov ecx,base

					xor bx,bx
					lea si,strout

					mov bx,LENGTHOF NUMSTR	

					convert:
					mov edx,0
					div ecx

					push dx

					dec bx

					test bx,bx
					jnz convert



					mov cx,LENGTHOF NUMSTR
					storevaluefromstack:
					pop ax
					add al,48
					mov [si],al
					inc si

					loop storevaluefromstack

					;adding a terminator at the end
					mov al, 24h
					mov [si], al


					;doisplaying message
					mov ah,09h
					lea dx,msg
					int 21h

					mov eax,base
					call doubledigit

					mov ah,09h
					lea dx,msg2
					int 21h


					mov ah,09h
					lea dx,strout
					int 21h
					;;Part 2

					mov ah,09h
					lea dx,endl
					int 21h

			ret
			number_to_base endp




;//////////////////////////////////////////////////////////////////////////////////
			;This is for part 2	
			PreLab2 proc
				    mov ah,09h
					lea dx,endl
					int 21h

					mov ah,09h
					lea dx,part2
					int 21h

					mov tohex,'0'
					call character_to_hex

					mov tohex,'9'
					call character_to_hex

					mov tohex,'.'
					call character_to_hex

					mov tohex,'A'
					call character_to_hex

					mov tohex,'Z'
					call character_to_hex

					mov tohex,'a'
					call character_to_hex	

					mov tohex,'z'
					call character_to_hex
		
			ret
			PreLab2 endp
;//////////////////////////////////////////////////////////////////////////////////
			;for part 2
			character_to_hex proc
					mov ah,09h
					lea dx,msg1
					int 21h

					mov ah,02h
					mov dx,tohex
					int 21h

					mov ah,09h
					lea dx,msg2
					int 21h

						mov ax,tohex
					    mov cx, 0   
					    mov bx, 16
					calc:     
					    mov dx, 0   
					    div bx

					    push dx

					    add cx, 1
					    cmp ax, 0   
					    jne calc      
					display:
					    pop dx
					    add dl, 30h

					    cmp dl, '9'
						jbe skip
						add dl, 7 ; bump up to 'A' - 'F'
						skip:

					    mov ah, 02h
					    int 21h


					    loop    display

					mov ah,09h
					lea dx,endl
					int 21h

					ret
			character_to_hex endp




;//////////////////////////////////////////////////////////////////////////////////
PreLab3 proc

					mov ah,09h
					lea dx,endl
					int 21h

					mov ah,09h
					lea dx,part3
					int 21h

					lea si,part3_1
					mov cx,LENGTHOF part3_1
					sub cx,1
					call string_To_hex

					lea si,part3_2
					mov cx,LENGTHOF part3_2
					sub cx,1
					call string_To_hex

					lea si,part3_3
					mov cx,LENGTHOF part3_3
					sub cx,1
					call string_To_hex



ret
PreLab3 endp

;//////////////////////////////////////////////////////////////////////////////////
string_To_hex proc
mov ah,09h
lea dx,msg1  ;hex number of
int 21h

mov ah,09h ;string
mov dx,si
int 21h

mov ah,09h
lea dx,msg2  ;is
int 21h


stringHex:

mov ax,[si]
mov ah,0 ;clearing the upper part
mov tohex,ax
call str_hex
inc si
loop stringHex


mov ah,09h
lea dx,endl
int 21h

ret
string_To_hex endp

str_hex proc
push cx ; to save the value of cx
push si
					
						mov ax,tohex
					    mov cx, 0   
					    mov bx, 16
					calc:     
					    mov dx, 0   
					    div bx

					    push dx

					    add cx, 1
					    cmp ax, 0   
					    jne calc      
					display:
					    pop dx
					    add dl, 30h

					    cmp dl, '9'
						jbe skip
						add dl, 7 ; bump up to 'A' - 'F'
						skip:

					    mov ah, 02h
					    int 21h


					    loop    display

					    mov ah,02h
					    mov dl,' '
					    int 21h

pop si
pop cx
					ret
			str_hex endp

;//////////////////////////////////////////////////////////////////////////////////

;a proc to dispay the digit more than 1 decimal place
doubledigit proc


	  mov cx,0

	  mov dx,0

	  mov bx,10d

		loop1:
			mov dx,0	;ax: Quotient

			div bx	        
		
			push dx		;dx: Remainder

			inc cx
			cmp ax,0	;if ax!=0 then

			jnz loop1	;Loop will be repeated

		loop2:
			mov ah,02
			pop dx
		
		
			add dl,48
			int 21h

			dec cx

			cmp cx,0	;if cx!=0 then
			jnz loop2	;Loop will be repeated
ret 
doubledigit endp



end