.PAGE 'MON.CMD'
;
;
;    DISK MONITOR 2040 V1.0
;
;    THIS MONITOR ALLOWS YOU TO
; PEEK AND POKE THE DISK
;
;    MONITOR COMMANDS ARE :
;
; $R - READ T,S,D,B
; $W - WRITE T,S,D,B
; $G - GET DISK MEMORY IMAGE TO PET
; $P - PUT PET MEMORY IMAGE TO DISK
; $V - VIEW DISK MEMORY
; $: - MODIFY DISK MEMORY
; $> - DIRECT DISK COMMAND
; $T - TRACE FILE LINKS
; $I - INIT JOB HEADER
;
;
;  THIS ADDS ITSELF TO THE PET
;  MONITOR
;
;
START	LDA #<DSKMON
	STA ERRJMP      ; UPDATE PET MONITOR
	LDA #>DSKMON
	STA ERRJMP+1    ; INDIRECT ERROR
;
	BRK
; DISK MON 1.0   2/10/80
;
DSKMON	CMP #'$'        ;TEST IF '$'
	BEQ DSKMN
	JMP ERROR       ; BAD COMMAND
;
DSKMN	JSR RDOC        ; ENTRY FROM PET MONITOR ON A  '$' SYMBOL
;
	CMP #SPC        ; IGNORE SPACE
	BEQ DSKMN
;
DSK002	LDX #NUMCMD-1   ; COMMAND TABLE LOOKUP INDEX
DSK003	CMP CMDTBL,X
	BNE DSK004
;
	TXA
	ASL A           ; 2*INDEX FOR COMMAND JUMP ADDRESS
	TAX
;
	LDA JMPTBL+1,X
	PHA
	LDA JMPTBL,X    ; PUSH RETURN ADDRESS  AND THE RTS ON IT
	PHA
	RTS             ; OFF TO THE COMMAND
;
DSK004	DEX
	BPL DSK003
;
	JMP ERROR       ; BAD COMMAND PRINT '?
;
;
; COMMAND LIST
CMDTBL	.BYTE 'RWGPV:>ITFD'
; $R: READ
; $W: WRITE
; $G: GET
; $P: PUT
; $V: VIEW
; $:: ALTER DISK MEMORY
; $>: DIRECT DISK COMMAND
; $I: INIT JOB HEADER
; $T: TRACE FILE LINKS
; $F: FETCH SECTOR TO MEMORY
; $D: DUMP MEMORY TO DISK
;
;
JMPTBL	.WORD READ-1
	.WORD WRITE-1
	.WORD GET-1
	.WORD PUT-1
	.WORD VIEW-1
	.WORD ALTER-1
	.WORD WEDGE-1
	.WORD INIT-1
	.WORD TRACE-1
	.WORD FETCH-1
	.WORD DUMP-1
;
;
.END