      IOBASE  EQU       280H
 IO8253_MODE  EQU       IOBASE+06H
    IO8253_0  EQU       IOBASE+00H
 IO8255_MODE  EQU       IOBASE+0EH
    IO8255_A  EQU       IOBASE+08H

        PAGE  50,70
       DATA1  SEGMENT
       FREQ1  DW        247,277,311,330,370,415,466,494,0
       TIME1  DW        100,100,100,100,100,100,100,200,0
       FREQ2  DW        311,311,277,311,311,370,311,277,311,247,247,277,311,370,310,277,277,247,277
              DW        311,370,311,415,370,415,377,377,311,370
              DW        311,277,311,370,311,277,277,247,0
       TIME2  DW        100,50,50,200,50,50,50,50,200,100,50,50,50,50,100,100,50,50,200
              DW        150,25,25,50,150,50,50,50,50,200
              DW        100,50,50,100,50,50,50,200,0
       FREQ3  DW        265,294,330,262,262,294,330,262,330,349
              DW        392,330,349,392,392,440,392,349,330,262
              DW        392,440,392,349,330,262,294,196,262,294
              DW        196,262,0
       TIME3  DW        50,50,100,100,100,100,100,50,50,100
              DW        100,100,100,100,50,50,100,100,100,100
              DW        100,100,50,50,100,100,100,100,100,50
              DW        100,100,0,0
       DATA1  ENDS

      STACK1  SEGMENT   PARA STACK
              DW        100 DUP(?)
      STACK1  ENDS

;====================
        CODE  SEGMENT
              ASSUME    CS:CODE,DS:DATA1
              ASSUME    SS:STACK1
      START:
              MOV       AX,DATA1
              MOV       DS,AX
              MOV       AX,0
              MOV       SI,AX
              MOV       DX,IO8255_MODE
              MOV       AL,90H      ;A�˿ڷ�ʽ0����
              OUT       DX,AL
              MOV       DX,IO8253_MODE          ;����8253�Ŀ��ƶ˿�
              MOV       AL,36H      ;����8253Ϊͨ��0����ʽ3��
              OUT       DX,AL       ;�����ƣ��ȶ���λ/�����λ

;;;MUSIC1===
     MUSIC1:
              LEA       DI,FREQ1    ;ȡƫ�Ƶ�ַ
              LEA       BP,TIME1    ;ȡʱ��ƫ�Ƶ�ַ
      LOOP1:
              MOV       AX,[DI]     ;ȡʱ��ƫ�Ƶ�ַ
              CMP       AX,0
              JE        MUSIC1
              CALL      SPEAKER
              XOR       AX,AX
              MOV       DX,IO8255_A ;����8255����˿�
              IN        AL,DX       ;���ֶ����ƶ˶������ѡ����Ϣ
              MOV       AH,0
              CMP       AX,SI       ;�ж��������Ϣ�仯û�У�
              JZ        AAA1        ;û�����ʾû�иı�ԭ����ѡ��
              MOV       SI,AX
              CMP       AL,1H       ;�ж��������Ϣ
              JNZ       AAA2        ;ѡ�񲥷���������
              JMP       MUSIC1
       AAA2:
              CMP       AL,2H
              JNZ       AAA3
              JMP       MUSIC2
       AAA3:
              CMP       AL,4H
              JNZ       AAA1
              JMP       MUSIC3
       AAA1:
              ADD       DI,2
              ADD       BP,2
              JMP       LOOP1
;;;===MUSIC1

;;;MUSIC2===
     MUSIC2:
              LEA       DI,FREQ2    ;ȡƫ�Ƶ�ַ
              LEA       BP,TIME2    ;ȡʱ��ƫ�Ƶ�ַ
      LOOP2:
              MOV       AX,[DI]
              CMP       AX,0
              JE        MUSIC2
              CALL      SPEAKER
              XOR       AX,AX
              MOV       DX,IO8255_A ;����8255����˿�
              IN        AL,DX       ;���ֶ����ƶ˶������ѡ����Ϣ
              MOV       AH,0H
              CMP       AX,SI       ;�ж��������Ϣ�仯û�У�û��
              JZ        AAA6        ;���ʾû�иı�ԭ����ѡ��
              MOV       SI,AX
              CMP       AL,1H       ;�ж��������Ϣ��ѡ�񲥷���������
              JNZ       AAA4
              JMP       MUSIC1
       AAA4:
              CMP       AL,2H
              JNZ       AAA5
              JMP       MUSIC2
       AAA5:
              CMP       AL,4H
              JNZ       AAA6
              JMP       MUSIC3
       AAA6:
              ADD       DI,2
              ADD       BP,2
              JMP       LOOP2
;;;===MUSIC2

;;;MUSIC3===
     MUSIC3:
              LEA       DI,FREQ3    ;ȡƫ�Ƶ�ַ
              LEA       BP,TIME3    ;ȡʱ��ƫ�Ƶ�ַ
      LOOP3:
              MOV       AX,[DI]
              CMP       AX,0
              JE        MUSIC3
              CALL      SPEAKER
              XOR       AX,AX
              MOV       DX,IO8255_A ;����8255����˿�
              IN        AL,DX       ;���ֶ����ƶ˶������ѡ����Ϣ
              MOV       AH,0H
              CMP       AX,SI       ;�ж��������Ϣ�仯û�У�û
              JZ        AAA9        ; �����ʾû�иı�ԭ����ѡ��
              MOV       SI,AX
              CMP       AL,1H       ;�ж��������Ϣ��ѡ�񲥷���������
              JNZ       AAA7
              JMP       MUSIC1
       AAA7:
              CMP       AL,2H
              JNZ       AAA8
              JMP       MUSIC2
       AAA8:
              CMP       AL,4H
              JNZ       AAA9
              JMP       MUSIC3
       AAA9:
              ADD       DI,2
              ADD       BP,2
              JMP       LOOP3
;;;===MUSIC3

;========���������ӳ���========
     SPEAKER  PROC
              PUSH      AX
              PUSH      BX
              PUSH      CX
              PUSH      DX
              MOV       AX,[DI]
              MOV       BX,AX
              MOV       DX,0FH
              MOV       AX,4240H    ;�������ֵclk=1MHZ 0x0F4240 = 1000000
              DIV       BX
              MOV       DX,IO8253_0 ;��������8253��������
              OUT       DX,AL
              MOV       AL,AH
              OUT       DX,AL       ;��ÿ�����ڵ�ʱ�����ڴ���CX
              ;MOV       CX,2710H    ;��0.5s��ʱ�����������ѭ������
              MOV       BX,WORD PTR DS:[BP]
              ADD       BX,BX
              ADD       BX,BX
 LOOP_TIMES:
              MOV       AX,2710H    ;����С���Ĳ���ʱ��Ϊ0.5s
              ADD       AX,AX
              ADD       AX,AX
 DELAY_TIME:
              DEC       AX
              JNZ       DELAY_TIME
              DEC       BX
              JNZ       LOOP_TIMES
              POP       DX
              POP       CX
              POP       BX
              POP       AX
              RET
     SPEAKER  ENDP

        CODE  ENDS
              END       START
