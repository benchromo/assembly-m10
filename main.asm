; template to start a new project 
; 12/29/2017 Saad Biaz
INCLUDE c:\Irvine\Irvine\Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	prompt1 BYTE "Please enter a 32 bit in hexadecimal",0dh,0ah,0
	prompt2 BYTE "Please enter a string S",0dh,0ah,0
	prompt3 BYTE "Please enter a string of at most 256 decimal digits",0dh,0ah,0
	string1 BYTE 256 DUP (0)
	string2 BYTE 50 DUP (0)
	string3 BYTE 50 DUP (0)
	table BYTE 10 DUP (0)
	byteCount DWORD ?
	byteCount2 DWORD ?
	
.code
main proc
	call ex1
	call ex2
	call ex3
	invoke ExitProcess,0
	; Procedure for exercise 1
	; Intermediary Registers
	; ---EAX: store input from ReadHex, store m
	; ---EBX: store one of the input values
	; ---ECX: loop
	; ---EDX: contain offset of string for WriteString
	ex1 proc
		; save registers
		push eax
		push ebx
		push ecx
		push edx
		; 1) prompt
		mov edx,OFFSET prompt1
		call WriteString
		; 2) read 32 bit unsigned int N1
		call ReadHex
		mov ebx,eax
		; 3) prompt
		mov edx,OFFSET prompt1
		call WriteString
		; 4) read 32 bit N2
		call ReadHex
		; 5) compute m number of bits by which n1 and n2 differ
		xor ebx,eax
		mov eax,0
		mov ecx,20h
		myLoop: rcl ebx,1
		adc eax,0
		loop myLoop
		; 6) display in decimal m
		call WriteDec
		mov al,0Ah
		call WriteChar
		mov al,0Dh
		call WriteChar
		; restore registers
		pop edx
		pop ecx
		pop ebx
		pop eax
		ret
	ex1 endp
	; Procedure for ex 2
	; Intemediary Registers
	; ---EAX:bytecount input, WriteChar
	; ---EBX:contains table index for print
	; ---ECX:loop
	; ---EDX:offsets
	; ---ESI:offset of string
	; ---EDI:offset of table
	ex2 proc
		; save registers
		push eax
		push ebx
		push ecx
		push edx
		push esi
		push edi
		; 1) prompt
		mov edx,OFFSET prompt3
		call WriteString
		; 2) read the string S
		mov edx,OFFSET string1
		mov ecx,SIZEOF string1
		call ReadString
		mov byteCount,eax
		; 3) Build counting table of digits in string S
		mov esi,OFFSET string1
		mov ecx,byteCount
		myLoop: mov edi,OFFSET table
		mov al,[esi]	; mov digit from S to al
		sub al,30h				; convert ascii to value
		and eax,0FFh
		add edi,eax
		mov bl,[edi]
		inc bl
		mov [edi],bl
		inc esi
		loop myLoop
		; 4) Display table
		mov edi,OFFSET table
		mov bl,30h
		mov ecx,0Ah
		mov eax,0h
		displayLoop: mov al,bl
		call WriteChar
		mov al,28h
		call WriteChar
		mov al,[edi]
		call WriteDec
		mov al,29h
		call WriteChar
		mov al,20h
		call WriteChar
		inc edi
		inc bl
		loop displayLoop
		mov al,0Ah
		call WriteChar
		mov al,0Dh
		call WriteChar
		; restore registers
		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx
		pop eax
		ret
	ex2 endp
	; Procedure for exercise 3
	; Intermediary Registers
	; ---EAX:
	; ---EBX:
	; ---ECX:
	; ---EDX:
	; ---ESI:
	; ---EDI:
	ex3 proc
		; save registers
		push eax
		push ebx
		push ecx
		push edx
		push esi
		push edi
		; 1) prompt
		mov edx,OFFSET prompt2
		call WriteString
		; 2) read a string S
		mov edx,OFFSET string2
		mov ecx,SIZEOF string2
		call ReadString
		mov byteCount2,eax
		; 3) prompt
		mov edx,OFFSET prompt1
		call WriteString
		; 4) read 32 bit unsigned int N
		call ReadHex
		; 5) copy at most N characters from S onto new string T
		cmp eax,byteCount2
		jbe keepGoing
		mov eax,byteCount2
		keepGoing: cld
		mov esi,OFFSET string2
		mov edi,OFFSET string3
		mov ecx,eax
		rep movsb
		; 6) display string T
		mov edx,OFFSET string3
		call WriteString
		; restore registers
		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx
		pop eax
		ret
	ex3 endp
main endp
end main