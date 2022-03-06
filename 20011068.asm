SSEG 	SEGMENT PARA STACK 'STACK'
	DW 32 DUP (?)
SSEG 	ENDS

DSEG	SEGMENT PARA 'DATA'
CR	EQU 13
LF	EQU 10
MENU1    DB CR, LF, 'MENU        AHMET AKIB GULTEKIN 20011068',0 
MENU2    DB CR, LF, '1.BIRDEN COK DEGER GIRMEK ICIN:',0
MENU3    DB CR, LF, '2.GORSELLESTIRME ICIN:',0
MENU4    DB CR, LF, '3.TEK DEGER GIRMEK ICIN:',0
GIRIS    DB CR, LF, 'DEGER GIRIN:',0

MSG1	DB CR, LF, 'sayiyi veriniz: ',0
MSG2	DB CR, LF, 'girilecek sayi miktari: ', 0
HATA	DB CR, LF, 'Dikkat !!! Sayi vermediniz yeniden giris yapiniz.!!!  ', 0
SATIR	DB CR, LF, '- ', 0
BOSLUK	DB  ' ', 0
NORM	DB CR, LF, 'DIZIDEKI DURUSU', 0
SIRALANMIS	DB CR, LF, 'SIRALANMIS HAL� ', 0 
DIZILINK	DB CR, LF, ' SAYI-SONRAKI SAYININ INDISI ', 0
HEADM 	DB CR, LF, 'ilk sayinin indisi= ', 0
DIZI    DW 100 DUP(?)
LINK    DW -1,100 DUP(0)
HEAD	DW ?
SAYI2	DW ? 
ONCEKI  DW ?
DSEG 	ENDS 

CSEG 	SEGMENT PARA 'CODE'          
	ASSUME CS:CSEG, DS:DSEG, SS:SSEG
ANA 	PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, DSEG 
        MOV DS, AX
        ;MENU KISMI
	    MOV AX, OFFSET MENU1
	    CALL PUT_STR
	    
	    MOV AX, OFFSET MENU2
	    CALL PUT_STR
	    
	    MOV AX, OFFSET MENU3
	    CALL PUT_STR
	    
	    MOV AX, OFFSET MENU4
	    CALL PUT_STR 
	    XOR SI, SI
	    
START:  ;TEKRARLANAN KISIM
	    
	    MOV AX, OFFSET GIRIS
	    CALL PUT_STR
	    CALL GETN
	    
	    CMP AX,1
	    JNE CNDT1
	    
	    MOV AX, OFFSET MSG2;BIRDEN FAZLA ELEMAN GIRILECEKSE
	    CALL PUT_STR 
	    CALL GETN
        MOV CX, AX
        LEA BX, DIZI
        
        JMP HLPR
        
CNDT3:
        LEA BX, DIZI;BIR DEGER GIRILECEKSE
        MOV CX, 1
        JMP HLPR
CNDT1:  
        CMP AX,3
	    JE CNDT3
	    
	    CMP AX,2;GORSELLESTIRILECEKSE
	    JNE ENDHLPR
	    JMP L4
	    
ENDHLPR: JMP SON
HLPR:
        
        
L1:	;DEGERLER ALINIP SIRALANACAK

        PUSH AX
        PUSH BX
        MOV AX, OFFSET MSG1
        CALL PUT_STR
        CALL GETN
        POP BX;BX GENELLIKLE DIZININ ADRESI OLACAK
        MOV DX, AX;DX GENELLIKLE ALINAN DEGER OLACAK
        MOV [BX+SI],DX
        POP AX	        
     
        CMP SI,0                             
        JNE SIFD;ILK DEGER ALINIYORSA           
                                                          
        MOV AX,BX                          
        ;MOV HEAD, AX
        MOV HEAD, SI
        JMP SF ;SF L1'IN SONRAKI DONGUSUNE GECIRIR           
SIFD:            
        
        PUSH BX  ;HEAD DEGER� DEGISECEKSE
        MOV BX, HEAD
        MOV AX,DIZI[BX];AX HEADIN GOSTERDIGI DEGER
        POP BX
        CMP AX,DX  
        JL BYK1
        
        PUSH CX             
        MOV CX,BX                                    
        ADD CX,SI;CX=BX+SI

        MOV AX, HEAD
        MOV HEAD, SI
        MOV LINK[SI], AX 
        POP CX 
        
        JMP SF
        
BYK1:
        PUSH CX;UST DONGU ICIN CX SAKLANDI
        PUSH SI;UST DONGU ICIN SI SAKLANDI
        MOV CX, SI;SI= YENI ALINAN DEGERIN INDISI
        SHR CX,1
        MOV AX,SI;AX =YENI ALINAN DEGERIN INDISI
        XOR SI,SI
        MOV DI, HEAD
L2:     
         
        PUSH CX;DONGU BOZULMASIN D�YE SAKLANDI
        MOV CX,DI;CX ARTIK L2 DE GEZILEN ELEMANIN INDISI   
                                      
        MOV SI,DI
        MOV DI,LINK[SI];DI SONRAKI ELEMANIN INDESKI
        
        CMP DI,-1
        JNE EKLEME
        
        MOV LINK[SI],AX 
        MOV SI,AX
        MOV LINK[SI], -1 
        POP CX
        POP SI
        POP CX
        JMP SF
EKLEME:
        
        CMP DX,DIZI[DI] 
        JG BYK2
              
        PUSH CX
        MOV CX, LINK[SI]
        MOV LINK[SI],AX
        PUSH SI
        MOV SI,AX
        MOV LINK[SI],CX
        POP SI
        POP CX
        
        POP CX
        POP SI
        POP CX   
        
        JMP SF       
        
BYK2:
        POP CX 
        LOOP L2  
       
SF:     
        ADD SI,2  
        LOOP L3;loop dizisi tastigi icin 
        JMP LP
L3:
        JMP L1
L4:;YAZDIRMA     
        MOV DI,HEAD
        PUSH SI
        XOR SI, SI
        MOV AX, OFFSET SIRALANMIS
        CALL PUT_STR  
        MOV AX, OFFSET HEADM 
        CALL PUT_STR
        MOV AX,DI
        SHR AX,1
        CALL PUTN
        MOV AX, OFFSET DIZILINK
        CALL PUT_STR
L5:     
        PUSH SI           
        MOV SI, DI
        MOV AX, OFFSET SATIR
        CALL PUT_STR
        MOV AX,DIZI[SI]
        CALL PUTN
        MOV DI,LINK[SI]
        MOV AX, OFFSET BOSLUK
        CALL PUT_STR
        MOV AX,DI
        CMP AX,-1
        JE  YZM
        SHR AX,1
YZM:
        CALL PUTN
        POP SI
        INC SI 
        CMP DI,-1
        JNE L5
        
        PUSH CX
        MOV CX, SI
        XOR SI,SI
        MOV AX, OFFSET SATIR 
        CALL PUT_STR
        MOV AX, OFFSET NORM
        CALL PUT_STR
        MOV AX, OFFSET HEADM 
        CALL PUT_STR
        MOV AX,HEAD
        SHR AX,1
        CALL PUTN
        MOV AX, OFFSET DIZILINK
        CALL PUT_STR
LG:     
        MOV AX, OFFSET SATIR 
        CALL PUT_STR
        MOV AX,DIZI[SI]
        CALL PUTN
        
        MOV AX, OFFSET BOSLUK
        CALL PUT_STR
        MOV AX,LINK[SI]
        CMP AX,-1
        JE  YZM2
        SHR AX,1
YZM2:
        CALL PUTN
        ADD SI,2   
        LOOP LG       
        POP CX
        POP SI
        
LP:     
        JMP START
SON:        
        RETF 
ANA 	ENDP


























GETC	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden bas�lan karakteri AL yazmac�na al�r ve ekranda g�sterir. 
        ; i�lem sonucunda sadece AL etkilenir. 
        ;------------------------------------------------------------------------
        MOV AH, 1h
        INT 21H
        RET 
GETC	ENDP 

PUTC	PROC NEAR
        ;------------------------------------------------------------------------
        ; AL yazmac�ndaki de�eri ekranda g�sterir. DL ve AH de�i�iyor. AX ve DX 
        ; yazma�lar�n�n de�erleri korumak i�in PUSH/POP yap�l�r. 
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH,2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC 	ENDP 

GETN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden bas�lan sayiyi okur, sonucu AX yazmac� �zerinden dondurur. 
        ; DX: say�n�n i�aretli olup/olmad���n� belirler. 1 (+), -1 (-) demek 
        ; BL: hane bilgisini tutar 
        ; CX: okunan say�n�n islenmesi s�ras�ndaki ara de�eri tutar. 
        ; AL: klavyeden okunan karakteri tutar (ASCII)
        ; AX zaten d�n�� de�eri olarak de�i�mek durumundad�r. Ancak di�er 
        ; yazma�lar�n �nceki de�erleri korunmal�d�r. 
        ;------------------------------------------------------------------------
        PUSH BX
        PUSH CX
        PUSH DX
GETN_START:
        MOV DX, 1	                        ; say�n�n �imdilik + oldu�unu varsayal�m 
        XOR BX, BX 	                        ; okuma yapmad� Hane 0 olur. 
        XOR CX,CX	                        ; ara toplam de�eri de 0�d�r. 
NEW:
        CALL GETC	                        ; klavyeden ilk de�eri AL�ye oku. 
        CMP AL,CR 
        JE FIN_READ	                        ; Enter tu�una basilmi� ise okuma biter
        CMP  AL, '-'	                        ; AL ,'-' mi geldi ? 
        JNE  CTRL_NUM	                        ; gelen 0-9 aras�nda bir say� m�?
NEGATIVE:
        MOV DX, -1	                        ; - bas�ld� ise say� negatif, DX=-1 olur
        JMP NEW		                        ; yeni haneyi al
CTRL_NUM:
        CMP AL, '0'	                        ; say�n�n 0-9 aras�nda oldu�unu kontrol et.
        JB error 
        CMP AL, '9'
        JA error		                ; de�il ise HATA mesaj� verilecek
        SUB AL,'0'	                        ; rakam al�nd�, haneyi toplama d�hil et 
        MOV BL, AL	                        ; BL�ye okunan haneyi koy 
        MOV AX, 10 	                        ; Haneyi eklerken *10 yap�lacak 
        PUSH DX		                        ; MUL komutu DX�i bozar i�aret i�in saklanmal�
        MUL CX		                        ; DX:AX = AX * CX
        POP DX		                        ; i�areti geri al 
        MOV CX, AX	                        ; CX deki ara de�er *10 yap�ld� 
        ADD CX, BX 	                        ; okunan haneyi ara de�ere ekle 
        JMP NEW 		                ; klavyeden yeni bas�lan de�eri al 
ERROR:
        MOV AX, OFFSET HATA 
        CALL PUT_STR	                        ; HATA mesaj�n� g�ster 
        JMP GETN_START                          ; o ana kadar okunanlar� unut yeniden say� almaya ba�la 
FIN_READ:
        MOV AX, CX	                        ; sonu� AX �zerinden d�necek 
        CMP DX, 1	                        ; ��arete g�re say�y� ayarlamak laz�m 
        JE FIN_GETN
        NEG AX		                        ; AX = -AX
FIN_GETN:
        POP DX
        POP CX
        POP DX
        RET 
GETN 	ENDP 

PUTN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de bulunan sayiyi onluk tabanda hane hane yazd�r�r. 
        ; CX: haneleri 10�a b�lerek bulaca��z, CX=10 olacak
        ; DX: 32 b�lmede i�leme d�hil olacak. Soncu etkilemesin diye 0 olmal� 
        ;------------------------------------------------------------------------
        PUSH CX
        PUSH DX 	
        XOR DX,	DX 	                        ; DX 32 bit b�lmede soncu etkilemesin diye 0 olmal� 
        PUSH DX		                        ; haneleri ASCII karakter olarak y���nda saklayaca��z.
                                                ; Ka� haneyi alaca��m�z� bilmedi�imiz i�in y���na 0 
                                                ; de�eri koyup onu alana kadar devam edelim.
        MOV CX, 10	                        ; CX = 10
        CMP AX, 0
        JGE CALC_DIGITS	
        NEG AX 		                        ; say� negatif ise AX pozitif yap�l�r. 
        PUSH AX		                        ; AX sakla 
        MOV AL, '-'	                        ; i�areti ekrana yazd�r. 
        CALL PUTC
        POP AX		                        ; AX�i geri al 
        
CALC_DIGITS:
        DIV CX  		                ; DX:AX = AX/CX  AX = b�l�m DX = kalan 
        ADD DX, '0'	                        ; kalan de�erini ASCII olarak bul 
        PUSH DX		                        ; y���na sakla 
        XOR DX,DX	                        ; DX = 0
        CMP AX, 0	                        ; b�len 0 kald� ise say�n�n i�lenmesi bitti demek
        JNE CALC_DIGITS	                        ; i�lemi tekrarla 
        
DISP_LOOP:
                                                ; yaz�lacak t�m haneler y���nda. En anlaml� hane �stte 
                                                ; en az anlaml� hane en alta ve onu alt�nda da 
                                                ; sona vard���m�z� anlamak i�in konan 0 de�eri var. 
        POP AX		                        ; s�rayla de�erleri y���ndan alal�m
        CMP AX, 0 	                        ; AX=0 olursa sona geldik demek 
        JE END_DISP_LOOP 
        CALL PUTC 	                        ; AL deki ASCII de�eri yaz
        JMP DISP_LOOP                           ; i�leme devam
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN 	ENDP 

PUT_STR	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazd�r�r.
        ; BX dizgeye indis olarak kullan�l�r. �nceki de�eri saklanmal�d�r. 
        ;------------------------------------------------------------------------
	PUSH BX 
        MOV BX,	AX			        ; Adresi BX�e al 
        MOV AL, BYTE PTR [BX]	                ; AL�de ilk karakter var 
PUT_LOOP:   
        CMP AL,0		
        JE  PUT_FIN 			        ; 0 geldi ise dizge sona erdi demek
        CALL PUTC 			        ; AL�deki karakteri ekrana yazar
        INC BX 				        ; bir sonraki karaktere ge�
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP			        ; yazd�rmaya devam 
PUT_FIN:
	POP BX
	RET 
PUT_STR	ENDP

CSEG 	ENDS 
	END ANA