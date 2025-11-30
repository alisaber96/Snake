
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _play_ground_width=R5
	.DEF _play_ground_height=R4
	.DEF _snake_head=R7
	.DEF _snake_tail=R6
	.DEF _snake_length=R9
	.DEF _apple_x_pos=R8
	.DEF _apple_y_pos=R11
	.DEF _snake_last_direction=R10
	.DEF _snake_old2_direction=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xE,0xE,0x0,0x2
	.DB  0x0,0x0,0x1,0x0
	.DB  0x0,0x1

_0x0:
	.DB  0x53,0x63,0x6F,0x72,0x65,0x3A,0x0,0x25
	.DB  0x64,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <glcd.h>
;#include <font5x7.h>
;#include <delay.h>
;#include <stdio.h>
;#include <stdlib.h>
;
;#define SCREEN_WIDTH 128
;#define SCREEN_HEIGHT 64
;
;#define RIGHT   1
;#define LEFT   -1
;#define UP      2
;#define DOWN   -2
;
;unsigned char play_ground_width  = 14; // 4 to 14
;unsigned char play_ground_height = 14; // 2 to 14
;
;unsigned char snake_x_poses[256];
;unsigned char snake_y_poses[256];
;unsigned char snake_head   = 2;
;unsigned char snake_tail   = 0;
;unsigned char snake_length = 0;
;unsigned char apple_x_pos;
;unsigned char apple_y_pos;
;char          snake_last_direction = RIGHT;
;char          snake_old2_direction = RIGHT;
;
;void draw_play_ground()
; 0000 001E {

	.CSEG
_draw_play_ground:
; .FSTART _draw_play_ground
; 0000 001F     char xpos;
; 0000 0020     char ypos = 4 * (play_ground_height+1);
; 0000 0021 
; 0000 0022 
; 0000 0023     // horizontal lines
; 0000 0024     //for(xpos=-64; xpos<((4*(play_ground_width+2))-64); xpos++)
; 0000 0025     for(xpos=0; xpos<((4*(play_ground_width+2))); xpos++)
	ST   -Y,R17
	ST   -Y,R16
;	xpos -> R17
;	ypos -> R16
	MOV  R30,R4
	SUBI R30,-LOW(1)
	LSL  R30
	LSL  R30
	MOV  R16,R30
	LDI  R17,LOW(0)
_0x4:
	MOV  R30,R5
	LDI  R31,0
	ADIW R30,2
	CALL __LSLW2
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x5
; 0000 0026     {
; 0000 0027         // lower wall
; 0000 0028         glcd_setpixel(xpos, 0);
	ST   -Y,R17
	LDI  R26,LOW(0)
	CALL _glcd_setpixel
; 0000 0029         glcd_setpixel(xpos, 1);
	ST   -Y,R17
	LDI  R26,LOW(1)
	CALL _glcd_setpixel
; 0000 002A         glcd_setpixel(xpos, 2);
	ST   -Y,R17
	LDI  R26,LOW(2)
	CALL _glcd_setpixel
; 0000 002B         glcd_setpixel(xpos, 3);
	ST   -Y,R17
	LDI  R26,LOW(3)
	CALL SUBOPT_0x0
; 0000 002C 
; 0000 002D         // upper wall
; 0000 002E         glcd_setpixel(xpos, ypos);
	CALL SUBOPT_0x0
; 0000 002F         glcd_setpixel(xpos, ypos+1);
	SUBI R26,-LOW(1)
	CALL SUBOPT_0x0
; 0000 0030         glcd_setpixel(xpos, ypos+2);
	SUBI R26,-LOW(2)
	CALL SUBOPT_0x0
; 0000 0031         glcd_setpixel(xpos, ypos+3);
	SUBI R26,-LOW(3)
	CALL _glcd_setpixel
; 0000 0032     }
	SUBI R17,-1
	RJMP _0x4
_0x5:
; 0000 0033 
; 0000 0034     //xpos = (4 * (play_ground_width+1)) - 64;
; 0000 0035     xpos = (4 * (play_ground_width+1));
	MOV  R30,R5
	SUBI R30,-LOW(1)
	LSL  R30
	LSL  R30
	MOV  R17,R30
; 0000 0036     // vertical lines
; 0000 0037     for (ypos=0; ypos <(4*(play_ground_width+2)); ypos++)
	LDI  R16,LOW(0)
_0x7:
	MOV  R30,R5
	LDI  R31,0
	ADIW R30,2
	CALL __LSLW2
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x8
; 0000 0038     {
; 0000 0039         // left side wall
; 0000 003A         glcd_setpixel(64-64, ypos);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1
; 0000 003B         glcd_setpixel(64-63, ypos);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1
; 0000 003C         glcd_setpixel(64-62, ypos);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x1
; 0000 003D         glcd_setpixel(64-61, ypos);
	LDI  R30,LOW(3)
	ST   -Y,R30
	MOV  R26,R16
	CALL SUBOPT_0x0
; 0000 003E 
; 0000 003F         // right side wall
; 0000 0040         glcd_setpixel(xpos,   ypos);
	CALL SUBOPT_0x2
; 0000 0041         glcd_setpixel(xpos+1, ypos);
; 0000 0042         glcd_setpixel(xpos+2, ypos);
	MOV  R30,R17
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x1
; 0000 0043         glcd_setpixel(xpos+3, ypos);
	MOV  R30,R17
	SUBI R30,-LOW(3)
	CALL SUBOPT_0x1
; 0000 0044     }
	SUBI R16,-1
	RJMP _0x7
_0x8:
; 0000 0045 }
	RJMP _0x2120009
; .FEND
;
;void draw_new_snake_body(unsigned char head)
; 0000 0048 {
_draw_new_snake_body:
; .FSTART _draw_new_snake_body
; 0000 0049     unsigned char head_x_pos = snake_x_poses[head];
; 0000 004A     unsigned char head_y_pos = snake_y_poses[head];
; 0000 004B     //unsigned char xpos = (4 * (head_x_pos + 1)) - 64;
; 0000 004C     unsigned char xpos = (4 * (head_x_pos + 1));
; 0000 004D     unsigned char ypos = (4 * (head_y_pos + 1));
; 0000 004E 
; 0000 004F     glcd_setpixel(xpos,     ypos);
	CALL SUBOPT_0x3
;	head -> Y+4
;	head_x_pos -> R17
;	head_y_pos -> R16
;	xpos -> R19
;	ypos -> R18
	CALL SUBOPT_0x4
; 0000 0050     glcd_setpixel(xpos,     ypos+1);
	SUBI R26,-LOW(1)
	CALL SUBOPT_0x4
; 0000 0051     glcd_setpixel(xpos,     ypos+2);
	SUBI R26,-LOW(2)
	CALL SUBOPT_0x4
; 0000 0052     glcd_setpixel(xpos,     ypos+3);
	CALL SUBOPT_0x5
; 0000 0053 
; 0000 0054     glcd_setpixel(xpos+1,   ypos);
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x6
; 0000 0055     glcd_setpixel(xpos+1,   ypos+1);
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x7
; 0000 0056     glcd_setpixel(xpos+1,   ypos+2);
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x8
; 0000 0057     glcd_setpixel(xpos+1,   ypos+3);
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	CALL SUBOPT_0x5
; 0000 0058 
; 0000 0059     glcd_setpixel(xpos+2,   ypos);
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x6
; 0000 005A     glcd_setpixel(xpos+2,   ypos+1);
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x7
; 0000 005B     glcd_setpixel(xpos+2,   ypos+2);
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x8
; 0000 005C     glcd_setpixel(xpos+2,   ypos+3);
	SUBI R30,-LOW(2)
	ST   -Y,R30
	MOV  R26,R18
	CALL SUBOPT_0x5
; 0000 005D 
; 0000 005E     glcd_setpixel(xpos+3,   ypos);
	SUBI R30,-LOW(3)
	CALL SUBOPT_0x6
; 0000 005F     glcd_setpixel(xpos+3,   ypos+1);
	SUBI R30,-LOW(3)
	CALL SUBOPT_0x7
; 0000 0060     glcd_setpixel(xpos+3,   ypos+2);
	SUBI R30,-LOW(3)
	CALL SUBOPT_0x8
; 0000 0061     glcd_setpixel(xpos+3,   ypos+3);
	SUBI R30,-LOW(3)
	ST   -Y,R30
	MOV  R26,R18
	SUBI R26,-LOW(3)
	CALL _glcd_setpixel
; 0000 0062 }
	RJMP _0x212000A
; .FEND
;
;void clear_snake_body   (unsigned char tail)
; 0000 0065 {
_clear_snake_body:
; .FSTART _clear_snake_body
; 0000 0066     unsigned char tail_x_pos = snake_x_poses[tail];
; 0000 0067     unsigned char tail_y_pos = snake_y_poses[tail];
; 0000 0068     //unsigned char xpos = (4 * (tail_x_pos + 1)) - 64;
; 0000 0069     unsigned char xpos = (4 * (tail_x_pos + 1));
; 0000 006A     unsigned char ypos = (4 * (tail_y_pos + 1));
; 0000 006B 
; 0000 006C     glcd_clrpixel(xpos,     ypos);
	CALL SUBOPT_0x3
;	tail -> Y+4
;	tail_x_pos -> R17
;	tail_y_pos -> R16
;	xpos -> R19
;	ypos -> R18
	CALL SUBOPT_0x9
; 0000 006D     glcd_clrpixel(xpos,     ypos+1);
	SUBI R26,-LOW(1)
	CALL SUBOPT_0x9
; 0000 006E     glcd_clrpixel(xpos,     ypos+2);
	SUBI R26,-LOW(2)
	CALL SUBOPT_0x9
; 0000 006F     glcd_clrpixel(xpos,     ypos+3);
	CALL SUBOPT_0xA
; 0000 0070 
; 0000 0071     glcd_clrpixel(xpos+1,   ypos);
	SUBI R30,-LOW(1)
	CALL SUBOPT_0xB
; 0000 0072     glcd_clrpixel(xpos+1,   ypos+1);
	SUBI R30,-LOW(1)
	CALL SUBOPT_0xC
; 0000 0073     glcd_clrpixel(xpos+1,   ypos+2);
	SUBI R30,-LOW(1)
	CALL SUBOPT_0xD
; 0000 0074     glcd_clrpixel(xpos+1,   ypos+3);
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	CALL SUBOPT_0xA
; 0000 0075 
; 0000 0076     glcd_clrpixel(xpos+2,   ypos);
	SUBI R30,-LOW(2)
	CALL SUBOPT_0xB
; 0000 0077     glcd_clrpixel(xpos+2,   ypos+1);
	SUBI R30,-LOW(2)
	CALL SUBOPT_0xC
; 0000 0078     glcd_clrpixel(xpos+2,   ypos+2);
	SUBI R30,-LOW(2)
	CALL SUBOPT_0xD
; 0000 0079     glcd_clrpixel(xpos+2,   ypos+3);
	SUBI R30,-LOW(2)
	ST   -Y,R30
	MOV  R26,R18
	CALL SUBOPT_0xA
; 0000 007A 
; 0000 007B     glcd_clrpixel(xpos+3,   ypos);
	SUBI R30,-LOW(3)
	CALL SUBOPT_0xB
; 0000 007C     glcd_clrpixel(xpos+3,   ypos+1);
	SUBI R30,-LOW(3)
	CALL SUBOPT_0xC
; 0000 007D     glcd_clrpixel(xpos+3,   ypos+2);
	SUBI R30,-LOW(3)
	CALL SUBOPT_0xD
; 0000 007E     glcd_clrpixel(xpos+3,   ypos+3);
	SUBI R30,-LOW(3)
	ST   -Y,R30
	MOV  R26,R18
	SUBI R26,-LOW(3)
	CALL _glcd_clrpixel
; 0000 007F }
_0x212000A:
	CALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
;
;void draw_apple()
; 0000 0082 {
_draw_apple:
; .FSTART _draw_apple
; 0000 0083     //unsigned char xpos = (4 * (apple_x_pos + 1)) - 64;
; 0000 0084     unsigned char xpos = (4 * (apple_x_pos + 1));
; 0000 0085     unsigned char ypos = (4 * (apple_y_pos + 1));
; 0000 0086 
; 0000 0087     //glcd_setpixel(xpos,     ypos);
; 0000 0088     //glcd_setpixel(xpos,     ypos+1);
; 0000 0089     glcd_setpixel(xpos,     ypos+2);
	ST   -Y,R17
	ST   -Y,R16
;	xpos -> R17
;	ypos -> R16
	MOV  R30,R8
	SUBI R30,-LOW(1)
	LSL  R30
	LSL  R30
	MOV  R17,R30
	MOV  R30,R11
	SUBI R30,-LOW(1)
	LSL  R30
	LSL  R30
	MOV  R16,R30
	ST   -Y,R17
	MOV  R26,R16
	SUBI R26,-LOW(2)
	CALL SUBOPT_0x2
; 0000 008A     //glcd_setpixel(xpos,     ypos+3);
; 0000 008B 
; 0000 008C     glcd_setpixel(xpos+1,   ypos);
; 0000 008D     glcd_setpixel(xpos+1,   ypos+1);
	MOV  R30,R17
	SUBI R30,-LOW(1)
	CALL SUBOPT_0xE
; 0000 008E     glcd_setpixel(xpos+1,   ypos+2);
	SUBI R30,-LOW(1)
	CALL SUBOPT_0xF
; 0000 008F     //glcd_setpixel(xpos+1,   ypos+3);
; 0000 0090 
; 0000 0091     //glcd_setpixel(xpos+2,   ypos);
; 0000 0092     glcd_setpixel(xpos+2,   ypos+1);
	CALL SUBOPT_0xE
; 0000 0093     glcd_setpixel(xpos+2,   ypos+2);
	SUBI R30,-LOW(2)
	CALL SUBOPT_0xF
; 0000 0094     glcd_setpixel(xpos+2,   ypos+3);
	ST   -Y,R30
	MOV  R26,R16
	SUBI R26,-LOW(3)
	CALL _glcd_setpixel
; 0000 0095 
; 0000 0096     //glcd_setpixel(xpos+3,   ypos);
; 0000 0097     glcd_setpixel(xpos+3,   ypos+1);
	MOV  R30,R17
	SUBI R30,-LOW(3)
	ST   -Y,R30
	MOV  R26,R16
	SUBI R26,-LOW(1)
	CALL _glcd_setpixel
; 0000 0098     //glcd_setpixel(xpos+3,   ypos+2);
; 0000 0099     //glcd_setpixel(xpos+3,   ypos+3);
; 0000 009A }
_0x2120009:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void respawn_new_apple()
; 0000 009D {
_respawn_new_apple:
; .FSTART _respawn_new_apple
; 0000 009E     unsigned int  pos;
; 0000 009F     unsigned char random_x_pos;
; 0000 00A0     unsigned char random_y_pos;
; 0000 00A1     unsigned char found = 0;
; 0000 00A2     unsigned char i;
; 0000 00A3     unsigned char cntr = 0;
; 0000 00A4     random_x_pos = rand() % play_ground_width;
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
	CALL __SAVELOCR6
;	pos -> R16,R17
;	random_x_pos -> R19
;	random_y_pos -> R18
;	found -> R21
;	i -> R20
;	cntr -> Y+6
	LDI  R21,0
	CALL _rand
	MOVW R26,R30
	MOV  R30,R5
	LDI  R31,0
	CALL __MODW21
	MOV  R19,R30
; 0000 00A5     random_y_pos = rand() % play_ground_height;
	CALL _rand
	MOVW R26,R30
	MOV  R30,R4
	LDI  R31,0
	CALL __MODW21
	MOV  R18,R30
; 0000 00A6 
; 0000 00A7     while(!found)
_0x9:
	CPI  R21,0
	BRNE _0xB
; 0000 00A8     {
; 0000 00A9         cntr++;
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
; 0000 00AA         // calculate new position for the apple
; 0000 00AB         random_x_pos++;
	SUBI R19,-1
; 0000 00AC         if (random_x_pos == play_ground_width)
	CP   R5,R19
	BRNE _0xC
; 0000 00AD         {
; 0000 00AE             random_x_pos = 0;
	LDI  R19,LOW(0)
; 0000 00AF             random_y_pos++;
	SUBI R18,-1
; 0000 00B0             if (random_y_pos == play_ground_height)
	CP   R4,R18
	BRNE _0xD
; 0000 00B1                 random_y_pos = 0;
	LDI  R18,LOW(0)
; 0000 00B2         }
_0xD:
; 0000 00B3 
; 0000 00B4         found = 1;
_0xC:
	LDI  R21,LOW(1)
; 0000 00B5         // check if the apple is outside of the snake's body
; 0000 00B6         for (i = 0; i< snake_length; i++)
	LDI  R20,LOW(0)
_0xF:
	CP   R20,R9
	BRSH _0x10
; 0000 00B7         {
; 0000 00B8             pos = snake_tail + i;
	MOV  R26,R6
	CLR  R27
	MOV  R30,R20
	CALL SUBOPT_0x10
; 0000 00B9             pos = pos % 256;
; 0000 00BA             if((snake_x_poses[pos] == random_x_pos) && (snake_y_poses[pos] == random_y_pos))
	CP   R19,R26
	BRNE _0x12
	LDI  R26,LOW(_snake_y_poses)
	LDI  R27,HIGH(_snake_y_poses)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CP   R18,R26
	BREQ _0x13
_0x12:
	RJMP _0x11
_0x13:
; 0000 00BB             {
; 0000 00BC                 found = 0;
	LDI  R21,LOW(0)
; 0000 00BD                 break;
	RJMP _0x10
; 0000 00BE             }
; 0000 00BF         }
_0x11:
	SUBI R20,-1
	RJMP _0xF
_0x10:
; 0000 00C0     }
	RJMP _0x9
_0xB:
; 0000 00C1     apple_x_pos = random_x_pos;
	MOV  R8,R19
; 0000 00C2     apple_y_pos = random_y_pos;
	MOV  R11,R18
; 0000 00C3     draw_apple();
	RCALL _draw_apple
; 0000 00C4 }
	CALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
;
;char snake_move(char snake_direction)
; 0000 00C7 {
_snake_move:
; .FSTART _snake_move
; 0000 00C8     unsigned int  pos;
; 0000 00C9     unsigned char i;
; 0000 00CA     unsigned char head_x_pos;
; 0000 00CB     unsigned char head_y_pos;
; 0000 00CC     unsigned char ate = 0;
; 0000 00CD     unsigned char tmp;
; 0000 00CE 
; 0000 00CF 
; 0000 00D0     //  direction correction
; 0000 00D1     tmp = snake_last_direction + snake_direction;
	ST   -Y,R26
	SBIW R28,1
	CALL __SAVELOCR6
;	snake_direction -> Y+7
;	pos -> R16,R17
;	i -> R19
;	head_x_pos -> R18
;	head_y_pos -> R21
;	ate -> R20
;	tmp -> Y+6
	LDI  R20,0
	LDD  R30,Y+7
	ADD  R30,R10
	STD  Y+6,R30
; 0000 00D2     if(tmp == 0)
	CPI  R30,0
	BRNE _0x14
; 0000 00D3         snake_direction = snake_last_direction;
	__PUTBSR 10,7
; 0000 00D4     snake_old2_direction = snake_last_direction;
_0x14:
	MOV  R13,R10
; 0000 00D5     snake_last_direction = snake_direction;
	LDD  R10,Y+7
; 0000 00D6 
; 0000 00D7 
; 0000 00D8     //  Dynamics of the head
; 0000 00D9     //head_x_pos = snake_x_poses[snake_head] + (snake_direction % 2);
; 0000 00DA     //head_y_pos = snake_y_poses[snake_head] - (snake_direction / 2);
; 0000 00DB     switch (snake_direction)
	LDD  R30,Y+7
	LDI  R31,0
; 0000 00DC     {
; 0000 00DD     case 0X02:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x18
; 0000 00DE         head_x_pos = snake_x_poses[snake_head];
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
; 0000 00DF         head_y_pos = snake_y_poses[snake_head] - 1;
	SUBI R30,LOW(1)
	MOV  R21,R30
; 0000 00E0         break;
	RJMP _0x17
; 0000 00E1     case 0X01:
_0x18:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x19
; 0000 00E2         head_x_pos = snake_x_poses[snake_head] + 1;
	CALL SUBOPT_0x11
	LD   R30,Z
	SUBI R30,-LOW(1)
	RJMP _0x54
; 0000 00E3         head_y_pos = snake_y_poses[snake_head];
; 0000 00E4         break;
; 0000 00E5     case 0XFE:
_0x19:
	CPI  R30,LOW(0xFE)
	LDI  R26,HIGH(0xFE)
	CPC  R31,R26
	BRNE _0x1A
; 0000 00E6         head_x_pos = snake_x_poses[snake_head];
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
; 0000 00E7         head_y_pos = snake_y_poses[snake_head] + 1;
	SUBI R30,-LOW(1)
	MOV  R21,R30
; 0000 00E8         break;
	RJMP _0x17
; 0000 00E9     case 0XFF:
_0x1A:
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BRNE _0x17
; 0000 00EA         head_x_pos = snake_x_poses[snake_head] - 1;
	CALL SUBOPT_0x11
	LD   R30,Z
	SUBI R30,LOW(1)
_0x54:
	MOV  R18,R30
; 0000 00EB         head_y_pos = snake_y_poses[snake_head];
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_snake_y_poses)
	SBCI R31,HIGH(-_snake_y_poses)
	LD   R21,Z
; 0000 00EC         break;
; 0000 00ED     };
_0x17:
; 0000 00EE 
; 0000 00EF 
; 0000 00F0 
; 0000 00F1     snake_head++;
	INC  R7
; 0000 00F2     snake_x_poses[snake_head] = head_x_pos;
	CALL SUBOPT_0x11
	ST   Z,R18
; 0000 00F3     snake_y_poses[snake_head] = head_y_pos;
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_snake_y_poses)
	SBCI R31,HIGH(-_snake_y_poses)
	ST   Z,R21
; 0000 00F4 
; 0000 00F5     //  Drawing new head for the snake
; 0000 00F6     draw_new_snake_body(snake_head);
	MOV  R26,R7
	RCALL _draw_new_snake_body
; 0000 00F7 
; 0000 00F8     //  Dynamics of the tail
; 0000 00F9     // check if the snake ate the apple
; 0000 00FA     if ((head_x_pos == apple_x_pos) && (head_y_pos == apple_y_pos))
	CP   R8,R18
	BRNE _0x1D
	CP   R11,R21
	BREQ _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
; 0000 00FB     {
; 0000 00FC         ate = 1;
	LDI  R20,LOW(1)
; 0000 00FD         snake_length++;
	INC  R9
; 0000 00FE         respawn_new_apple();
	RCALL _respawn_new_apple
; 0000 00FF     }
; 0000 0100     else
	RJMP _0x1F
_0x1C:
; 0000 0101     {
; 0000 0102         clear_snake_body(snake_tail);
	MOV  R26,R6
	RCALL _clear_snake_body
; 0000 0103         snake_tail++;
	INC  R6
; 0000 0104     }
_0x1F:
; 0000 0105 
; 0000 0106     // check if the snake ate itself
; 0000 0107     for (i = 0; i< snake_length-1; i++)
	LDI  R19,LOW(0)
_0x21:
	MOV  R30,R9
	LDI  R31,0
	SBIW R30,1
	MOV  R26,R19
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x22
; 0000 0108     {
; 0000 0109         pos = snake_tail + i;
	MOV  R26,R6
	CLR  R27
	MOV  R30,R19
	CALL SUBOPT_0x10
; 0000 010A         pos = pos % 256;
; 0000 010B 
; 0000 010C         if((snake_x_poses[pos] == head_x_pos) && (snake_y_poses[pos] == head_y_pos))
	CP   R18,R26
	BRNE _0x24
	LDI  R26,LOW(_snake_y_poses)
	LDI  R27,HIGH(_snake_y_poses)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CP   R21,R26
	BREQ _0x25
_0x24:
	RJMP _0x23
_0x25:
; 0000 010D             return -1;
	LDI  R30,LOW(255)
	JMP  _0x2120005
; 0000 010E 
; 0000 010F     }
_0x23:
	SUBI R19,-1
	RJMP _0x21
_0x22:
; 0000 0110 
; 0000 0111     // check if the snake hit the wall
; 0000 0112     if ((head_x_pos == play_ground_width) || (head_y_pos == play_ground_height) || (head_x_pos == 0XFF) || (head_y_pos = ...
	CP   R5,R18
	BREQ _0x27
	CP   R4,R21
	BREQ _0x27
	CPI  R18,255
	BREQ _0x27
	CPI  R21,255
	BRNE _0x26
_0x27:
; 0000 0113         return -2;
	LDI  R30,LOW(254)
	JMP  _0x2120005
; 0000 0114 
; 0000 0115     // check it the player won
; 0000 0116     if (snake_length == (play_ground_width * play_ground_height))
_0x26:
	CALL SUBOPT_0x13
	MOV  R26,R9
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x29
; 0000 0117         return 2;
	LDI  R30,LOW(2)
	JMP  _0x2120005
; 0000 0118 
; 0000 0119     // normal return
; 0000 011A     return ate;
_0x29:
	MOV  R30,R20
	JMP  _0x2120005
; 0000 011B }
; .FEND
;
;void lose_effect()
; 0000 011E {
_lose_effect:
; .FSTART _lose_effect
; 0000 011F     char pos_x = 0;
; 0000 0120     char pos_y = 0;
; 0000 0121     char beg_x = -1;
; 0000 0122     char beg_y = -1;
; 0000 0123     char end_x = play_ground_width;
; 0000 0124     char end_y = play_ground_height;
; 0000 0125     unsigned char i;
; 0000 0126     unsigned char dir = 0;
; 0000 0127     char        SS[20];
; 0000 0128 
; 0000 0129     for(i=0; i<(play_ground_width*play_ground_height); i++)
	SBIW R28,22
	LDI  R30,LOW(0)
	STD  Y+20,R30
	CALL __SAVELOCR6
;	pos_x -> R17
;	pos_y -> R16
;	beg_x -> R19
;	beg_y -> R18
;	end_x -> R21
;	end_y -> R20
;	i -> Y+27
;	dir -> Y+26
;	SS -> Y+6
	LDI  R17,0
	LDI  R16,0
	LDI  R19,255
	LDI  R18,255
	MOV  R21,R5
	MOV  R20,R4
	STD  Y+27,R30
_0x2B:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	BRLT PC+2
	RJMP _0x2C
; 0000 012A     {
; 0000 012B         snake_x_poses[i] = pos_x;
	LDD  R30,Y+27
	LDI  R31,0
	SUBI R30,LOW(-_snake_x_poses)
	SBCI R31,HIGH(-_snake_x_poses)
	ST   Z,R17
; 0000 012C         snake_y_poses[i] = pos_y;
	LDD  R30,Y+27
	LDI  R31,0
	SUBI R30,LOW(-_snake_y_poses)
	SBCI R31,HIGH(-_snake_y_poses)
	ST   Z,R16
; 0000 012D         switch(dir%4)
	LDD  R26,Y+26
	CLR  R27
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
; 0000 012E         {
; 0000 012F         case 0:
	SBIW R30,0
	BRNE _0x30
; 0000 0130             pos_x ++;
	SUBI R17,-1
; 0000 0131             if(pos_x == end_x)
	CP   R21,R17
	BRNE _0x31
; 0000 0132             {
; 0000 0133                 pos_x--;
	SUBI R17,1
; 0000 0134                 pos_y++;
	SUBI R16,-1
; 0000 0135                 beg_y++;
	SUBI R18,-1
; 0000 0136                 dir++;
	LDD  R30,Y+26
	SUBI R30,-LOW(1)
	STD  Y+26,R30
; 0000 0137             }
; 0000 0138             break;
_0x31:
	RJMP _0x2F
; 0000 0139         case 1:
_0x30:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x32
; 0000 013A             pos_y++;
	SUBI R16,-1
; 0000 013B             if(pos_y == end_y)
	CP   R20,R16
	BRNE _0x33
; 0000 013C             {
; 0000 013D                 pos_y--;
	SUBI R16,1
; 0000 013E                 pos_x--;
	SUBI R17,1
; 0000 013F                 end_x--;
	SUBI R21,1
; 0000 0140                 dir++;
	LDD  R30,Y+26
	SUBI R30,-LOW(1)
	STD  Y+26,R30
; 0000 0141             }
; 0000 0142             break;
_0x33:
	RJMP _0x2F
; 0000 0143         case 2:
_0x32:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x34
; 0000 0144             pos_x--;
	SUBI R17,1
; 0000 0145             if(pos_x == beg_x)
	CP   R19,R17
	BRNE _0x35
; 0000 0146             {
; 0000 0147                 pos_x++;
	SUBI R17,-1
; 0000 0148                 pos_y--;
	SUBI R16,1
; 0000 0149                 end_y--;
	SUBI R20,1
; 0000 014A                 dir++;
	LDD  R30,Y+26
	SUBI R30,-LOW(1)
	STD  Y+26,R30
; 0000 014B             }
; 0000 014C             break;
_0x35:
	RJMP _0x2F
; 0000 014D         case 3:
_0x34:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2F
; 0000 014E             pos_y--;
	SUBI R16,1
; 0000 014F             if(pos_y == beg_y)
	CP   R18,R16
	BRNE _0x37
; 0000 0150             {
; 0000 0151                 pos_y++;
	SUBI R16,-1
; 0000 0152                 pos_x++;
	SUBI R17,-1
; 0000 0153                 beg_x++;
	SUBI R19,-1
; 0000 0154                 dir++;
	LDD  R30,Y+26
	SUBI R30,-LOW(1)
	STD  Y+26,R30
; 0000 0155             }
; 0000 0156             break;
_0x37:
; 0000 0157         }
_0x2F:
; 0000 0158     }
	LDD  R30,Y+27
	SUBI R30,-LOW(1)
	STD  Y+27,R30
	RJMP _0x2B
_0x2C:
; 0000 0159 
; 0000 015A     for(i=0; i<(play_ground_width*play_ground_height); i++)
	LDI  R30,LOW(0)
	STD  Y+27,R30
_0x39:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	BRGE _0x3A
; 0000 015B     {
; 0000 015C         draw_new_snake_body(i);
	LDD  R26,Y+27
	RCALL _draw_new_snake_body
; 0000 015D         delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 015E     }
	LDD  R30,Y+27
	SUBI R30,-LOW(1)
	STD  Y+27,R30
	RJMP _0x39
_0x3A:
; 0000 015F 
; 0000 0160 
; 0000 0161 
; 0000 0162 
; 0000 0163     for(i=0; i<(play_ground_width*play_ground_height); i++)
	LDI  R30,LOW(0)
	STD  Y+27,R30
_0x3C:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	BRGE _0x3D
; 0000 0164     {
; 0000 0165         clear_snake_body(i);
	LDD  R26,Y+27
	RCALL _clear_snake_body
; 0000 0166         delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 0167     }
	LDD  R30,Y+27
	SUBI R30,-LOW(1)
	STD  Y+27,R30
	RJMP _0x3C
_0x3D:
; 0000 0168 }
	CALL __LOADLOCR6
	ADIW R28,28
	RET
; .FEND
;
;void main(void) {
; 0000 016A void main(void) {
_main:
; .FSTART _main
; 0000 016B     int         i=0;
; 0000 016C     char        future_direction;
; 0000 016D     int         score = 0;
; 0000 016E     char        move_result;
; 0000 016F     char        playing = 1;
; 0000 0170     char        SS[20];
; 0000 0171     //sprintf(SS,"Score :%d",Score);
; 0000 0172     //glcd_moveto(64,10);
; 0000 0173     //glcd_outtext(SS);
; 0000 0174 
; 0000 0175     GLCDINIT_t glcd_init_data;
; 0000 0176     glcd_init_data.font = font5x7;
	SBIW R28,27
	LDI  R30,LOW(1)
	STD  Y+26,R30
;	i -> R16,R17
;	future_direction -> R19
;	score -> R20,R21
;	move_result -> R18
;	playing -> Y+26
;	SS -> Y+6
;	glcd_init_data -> Y+0
	__GETWRN 16,17,0
	__GETWRN 20,21,0
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0177     glcd_init_data.readxmem = NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0178     glcd_init_data.writexmem = NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0179     glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 017A     glcd_clear();
	RCALL _glcd_clear
; 0000 017B     srand(123);
	LDI  R26,LOW(123)
	LDI  R27,0
	CALL _srand
; 0000 017C 
; 0000 017D     DDRA  = 0X00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 017E     PORTA = 0XFF;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 017F 
; 0000 0180     //  drawing the playground
; 0000 0181     draw_play_ground();
	RCALL _draw_play_ground
; 0000 0182 
; 0000 0183     while (1)
_0x3E:
; 0000 0184     {
; 0000 0185         snake_head   = 2;
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 0186         snake_tail   = 0;
	CLR  R6
; 0000 0187         snake_length = snake_head - snake_tail + 1;
	SUB  R30,R6
	SUBI R30,-LOW(1)
	MOV  R9,R30
; 0000 0188 
; 0000 0189         // initializing the snake with length 3
; 0000 018A         for(i=0; i<300; i++)
	__GETWRN 16,17,0
_0x42:
	__CPWRN 16,17,300
	BRGE _0x43
; 0000 018B         {
; 0000 018C             snake_x_poses[i] = 0;
	LDI  R26,LOW(_snake_x_poses)
	LDI  R27,HIGH(_snake_x_poses)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 018D             snake_y_poses[i] = 0;
	LDI  R26,LOW(_snake_y_poses)
	LDI  R27,HIGH(_snake_y_poses)
	ADD  R26,R16
	ADC  R27,R17
	ST   X,R30
; 0000 018E         }
	__ADDWRN 16,17,1
	RJMP _0x42
_0x43:
; 0000 018F         snake_x_poses[0] = 0;
	LDI  R30,LOW(0)
	STS  _snake_x_poses,R30
; 0000 0190         snake_y_poses[0] = play_ground_height/2;
	CALL SUBOPT_0x15
	STS  _snake_y_poses,R30
; 0000 0191         snake_x_poses[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _snake_x_poses,1
; 0000 0192         snake_y_poses[1] = play_ground_height/2;
	CALL SUBOPT_0x15
	__PUTB1MN _snake_y_poses,1
; 0000 0193         snake_x_poses[2] = 2;
	LDI  R30,LOW(2)
	__PUTB1MN _snake_x_poses,2
; 0000 0194         snake_y_poses[2] = play_ground_height/2;
	CALL SUBOPT_0x15
	__PUTB1MN _snake_y_poses,2
; 0000 0195 
; 0000 0196         //  drawing three first pieces of the snake body
; 0000 0197         draw_new_snake_body(0);
	LDI  R26,LOW(0)
	RCALL _draw_new_snake_body
; 0000 0198         draw_new_snake_body(1);
	LDI  R26,LOW(1)
	RCALL _draw_new_snake_body
; 0000 0199         draw_new_snake_body(2);
	LDI  R26,LOW(2)
	RCALL _draw_new_snake_body
; 0000 019A 
; 0000 019B         //  rewpawning the apple;
; 0000 019C         respawn_new_apple();
	RCALL _respawn_new_apple
; 0000 019D 
; 0000 019E         //  printing the score word
; 0000 019F         sprintf(SS,"Score:");
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0000 01A0         glcd_moveto(80,10);
	LDI  R30,LOW(80)
	ST   -Y,R30
	LDI  R26,LOW(10)
	CALL SUBOPT_0x16
; 0000 01A1         glcd_outtext(SS);
; 0000 01A2 
; 0000 01A3         // starting the game:
; 0000 01A4         playing = 1;
	LDI  R30,LOW(1)
	STD  Y+26,R30
; 0000 01A5         future_direction = RIGHT;
	LDI  R19,LOW(1)
; 0000 01A6         snake_last_direction = RIGHT;
	MOV  R10,R30
; 0000 01A7         snake_old2_direction = RIGHT;
	MOV  R13,R30
; 0000 01A8         while(playing == 1)
_0x44:
	LDD  R26,Y+26
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x46
; 0000 01A9         {
; 0000 01AA             //  taking a direction
; 0000 01AB             future_direction = snake_last_direction;
	MOV  R19,R10
; 0000 01AC             if(PINA.0 == 0)
	SBIS 0x19,0
; 0000 01AD                  future_direction = UP;
	LDI  R19,LOW(2)
; 0000 01AE             if(PINA.1 == 0)
	SBIS 0x19,1
; 0000 01AF                  future_direction = RIGHT;
	LDI  R19,LOW(1)
; 0000 01B0             if(PINA.2 == 0)
	SBIS 0x19,2
; 0000 01B1                  future_direction = DOWN;
	LDI  R19,LOW(254)
; 0000 01B2             if(PINA.3 == 0)
	SBIS 0x19,3
; 0000 01B3                  future_direction = LEFT;
	LDI  R19,LOW(255)
; 0000 01B4 
; 0000 01B5 
; 0000 01B6             //  Moving the snake in the play ground
; 0000 01B7             move_result = snake_move(future_direction);
	MOV  R26,R19
	RCALL _snake_move
	MOV  R18,R30
; 0000 01B8 
; 0000 01B9             // check the snake status
; 0000 01BA             switch (move_result)
	LDI  R31,0
; 0000 01BB             {
; 0000 01BC             case 0XFE:
	CPI  R30,LOW(0xFE)
	LDI  R26,HIGH(0xFE)
	CPC  R31,R26
	BRNE _0x4E
; 0000 01BD                 // the snake hit the wall
; 0000 01BE                 delay_ms(500);
	CALL SUBOPT_0x17
; 0000 01BF                 playing = 0;
	RJMP _0x55
; 0000 01C0                 break;
; 0000 01C1             case 0XFF:
_0x4E:
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BRNE _0x4F
; 0000 01C2                 // the snake ate itself
; 0000 01C3                 delay_ms(500);
	CALL SUBOPT_0x17
; 0000 01C4                 playing = 0;
	RJMP _0x55
; 0000 01C5                 break;
; 0000 01C6             case 0X00:
_0x4F:
	SBIW R30,0
	BREQ _0x4D
; 0000 01C7                 break;
; 0000 01C8             case 0X01:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x51
; 0000 01C9                 score += move_result;
	MOV  R30,R18
	LDI  R31,0
	__ADDWRR 20,21,30,31
; 0000 01CA                 break;
	RJMP _0x4D
; 0000 01CB             case 0X02:
_0x51:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4D
; 0000 01CC                 playing = 0;
_0x55:
	LDI  R30,LOW(0)
	STD  Y+26,R30
; 0000 01CD                 break;
; 0000 01CE             };
_0x4D:
; 0000 01CF 
; 0000 01D0             sprintf(SS,"%d",score);
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01D1             glcd_moveto(90,20);
	LDI  R30,LOW(90)
	ST   -Y,R30
	LDI  R26,LOW(20)
	CALL SUBOPT_0x16
; 0000 01D2             glcd_outtext(SS);
; 0000 01D3 
; 0000 01D4             //  Waiting for a moment for the snake to rest.
; 0000 01D5             delay_ms(500);
	CALL SUBOPT_0x17
; 0000 01D6         }
	RJMP _0x44
_0x46:
; 0000 01D7         lose_effect();
	RCALL _lose_effect
; 0000 01D8     }
	RJMP _0x3E
; 0000 01D9 }
_0x53:
	RJMP _0x53
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_ks0108_enable_G100:
; .FSTART _ks0108_enable_G100
	nop
	SBI  0x12,0
	nop
	RET
; .FEND
_ks0108_disable_G100:
; .FSTART _ks0108_disable_G100
	CBI  0x12,0
	CBI  0x12,4
	CBI  0x12,5
	RET
; .FEND
_ks0108_rdbus_G100:
; .FSTART _ks0108_rdbus_G100
	ST   -Y,R17
	RCALL _ks0108_enable_G100
	IN   R17,19
	CBI  0x12,0
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G100:
; .FSTART _ks0108_busy_G100
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(0)
	OUT  0x14,R30
	SBI  0x12,1
	CBI  0x12,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2000003
	SBI  0x12,4
	RJMP _0x2000004
_0x2000003:
	CBI  0x12,4
_0x2000004:
	SBRS R17,1
	RJMP _0x2000005
	SBI  0x12,5
	RJMP _0x2000006
_0x2000005:
	CBI  0x12,5
_0x2000006:
_0x2000007:
	RCALL _ks0108_rdbus_G100
	ANDI R30,LOW(0x80)
	BRNE _0x2000007
	LDD  R17,Y+0
	RJMP _0x2120008
; .FEND
_ks0108_wrcmd_G100:
; .FSTART _ks0108_wrcmd_G100
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G100
	CALL SUBOPT_0x18
	RJMP _0x2120008
; .FEND
_ks0108_setloc_G100:
; .FSTART _ks0108_setloc_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G100,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	RET
; .FEND
_ks0108_gotoxp_G100:
; .FSTART _ks0108_gotoxp_G100
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G100,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G100,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G100,2
	RCALL _ks0108_setloc_G100
	RJMP _0x2120008
; .FEND
_ks0108_nextx_G100:
; .FSTART _ks0108_nextx_G100
	LDS  R26,_ks0108_coord_G100
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G100,R26
	CPI  R26,LOW(0x80)
	BRLO _0x200000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G100,R30
_0x200000A:
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	BRNE _0x200000B
	LDS  R30,_ks0108_coord_G100
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G100,2
	RCALL _ks0108_gotoxp_G100
_0x200000B:
	RET
; .FEND
_ks0108_wrdata_G100:
; .FSTART _ks0108_wrdata_G100
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	SBI  0x12,2
	CALL SUBOPT_0x18
	ADIW R28,1
	RET
; .FEND
_ks0108_rddata_G100:
; .FSTART _ks0108_rddata_G100
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	LDI  R30,LOW(0)
	OUT  0x14,R30
	SBI  0x12,1
	SBI  0x12,2
	RCALL _ks0108_rdbus_G100
	RET
; .FEND
_ks0108_rdbyte_G100:
; .FSTART _ks0108_rdbyte_G100
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	RCALL _ks0108_rddata_G100
_0x2120008:
	ADIW R28,2
	RET
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x11,0
	SBI  0x11,1
	SBI  0x11,2
	SBI  0x11,3
	SBI  0x12,3
	SBI  0x11,4
	SBI  0x11,5
	RCALL _ks0108_disable_G100
	CBI  0x12,3
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x12,3
	LDI  R17,LOW(0)
_0x200000C:
	CPI  R17,2
	BRSH _0x200000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G100
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G100
	RJMP _0x200000C
_0x200000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x200000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000AC
_0x200000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20000AC:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2000015
	LDI  R16,LOW(255)
_0x2000015:
_0x2000016:
	CPI  R19,8
	BRSH _0x2000018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G100
	LDI  R17,LOW(0)
_0x2000019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x200001B
	MOV  R26,R16
	CALL SUBOPT_0x1B
	RJMP _0x2000019
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G100
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x80)
	BRSH _0x200001D
	LDD  R26,Y+3
	CPI  R26,LOW(0x40)
	BRLO _0x200001C
_0x200001D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120003
_0x200001C:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x200001F
	OR   R17,R16
	RJMP _0x2000020
_0x200001F:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000020:
	MOV  R26,R17
	RCALL _ks0108_wrdata_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120003
; .FEND
_ks0108_wrmasked_G100:
; .FSTART _ks0108_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x200002B
	CPI  R30,LOW(0x8)
	BRNE _0x200002C
_0x200002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x200002D
_0x200002C:
	CPI  R30,LOW(0x3)
	BRNE _0x200002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000030
_0x200002F:
	CPI  R30,0
	BRNE _0x2000031
_0x2000030:
_0x200002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x2)
	BRNE _0x2000033
_0x2000032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2000029
_0x2000033:
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2000029
_0x2000034:
	CPI  R30,LOW(0x4)
	BRNE _0x2000029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2000029:
	MOV  R26,R17
	CALL SUBOPT_0x1B
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2000037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2000037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2000037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2000036
_0x2000037:
	RJMP _0x2120007
_0x2000036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2000039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2000039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x200003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x200003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x200003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	RJMP _0x2120007
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000041
	RJMP _0x2120007
_0x2000041:
_0x2000042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000043
_0x2000044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x1C
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2000046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2000048
	MOV  R17,R16
_0x2000049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200004B
	CALL SUBOPT_0x1D
	RJMP _0x2000049
_0x200004B:
	RJMP _0x2000046
_0x2000048:
_0x2000043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x200004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x1C
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x200004D
	SUBI R19,-LOW(1)
_0x200004D:
	LDI  R18,LOW(0)
_0x200004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000050
	LDD  R17,Y+14
_0x2000051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000053
	CALL SUBOPT_0x1D
	RJMP _0x2000051
_0x2000053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x1C
	RJMP _0x200004E
_0x2000050:
_0x200004C:
_0x200003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2000057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2000058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x200005D
	CPI  R30,LOW(0x3)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2000060
_0x200005F:
	RJMP _0x2000061
_0x2000060:
	CPI  R30,LOW(0x8)
	BRNE _0x2000062
_0x2000061:
	RJMP _0x2000063
_0x2000062:
	CPI  R30,LOW(0x6)
	BRNE _0x2000064
_0x2000063:
	RJMP _0x2000065
_0x2000064:
	CPI  R30,LOW(0x9)
	BRNE _0x2000066
_0x2000065:
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x2000067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x1A
_0x200005B:
_0x2000069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x200006C
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	CALL SUBOPT_0x1E
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G100
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G100
	RJMP _0x200006D
_0x200006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000071
	LDI  R21,LOW(0)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0xA)
	BRNE _0x2000070
	LDI  R21,LOW(255)
	RJMP _0x2000072
_0x2000070:
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2000079
	CPI  R30,LOW(0x8)
	BRNE _0x200007A
_0x2000079:
_0x2000072:
	CALL SUBOPT_0x20
	MOV  R21,R30
	RJMP _0x200007B
_0x200007A:
	CPI  R30,LOW(0x3)
	BRNE _0x200007D
	COM  R21
	RJMP _0x200007E
_0x200007D:
	CPI  R30,0
	BRNE _0x2000080
_0x200007E:
_0x200007B:
	MOV  R26,R21
	CALL SUBOPT_0x1B
	RJMP _0x2000077
_0x2000080:
	CALL SUBOPT_0x21
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
_0x2000077:
_0x200006D:
	RJMP _0x2000069
_0x200006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000081
_0x2000058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000082
_0x2000057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000084
_0x2000083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000088
_0x2000089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200008B
	CALL SUBOPT_0x22
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x23
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x1E
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2000089
_0x200008B:
	RJMP _0x2000087
_0x2000088:
	CPI  R30,LOW(0x9)
	BRNE _0x200008C
	LDI  R21,LOW(0)
	RJMP _0x200008D
_0x200008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2000093
	LDI  R21,LOW(255)
_0x200008D:
	CALL SUBOPT_0x20
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2000090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000092
	CALL SUBOPT_0x21
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000090
_0x2000092:
	RJMP _0x2000087
_0x2000093:
_0x2000094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000096
	CALL SUBOPT_0x24
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000094
_0x2000096:
_0x2000087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2000097
	RJMP _0x2000056
_0x2000097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2000098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000AD
_0x2000098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000AD:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200009D
_0x200009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A0
	CALL SUBOPT_0x22
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x23
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x1E
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x200009C
_0x200009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20000A1
	LDI  R21,LOW(0)
	RJMP _0x20000A2
_0x20000A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20000A8
	LDI  R21,LOW(255)
_0x20000A2:
	CALL SUBOPT_0x20
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20000A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A7
	CALL SUBOPT_0x21
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A5
_0x20000A7:
	RJMP _0x200009C
_0x20000A8:
_0x20000A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000AB
	CALL SUBOPT_0x24
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A9
_0x20000AB:
_0x200009C:
_0x2000081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000054
_0x2000056:
_0x2120007:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x25
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120002
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	JMP  _0x2120002
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120002
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x25
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120002
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2020006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	JMP  _0x2120002
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120002
; .FEND
_glcd_setpixel:
; .FSTART _glcd_setpixel
	CALL SUBOPT_0x19
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	JMP  _0x2120002
; .FEND
_glcd_clrpixel:
; .FSTART _glcd_clrpixel
	CALL SUBOPT_0x19
	ST   -Y,R30
	__GETB2MN _glcd_state,1
	RCALL _glcd_putpixel
	JMP  _0x2120002
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x26
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120006
_0x202000B:
	CALL SUBOPT_0x27
	STD  Y+7,R0
	CALL SUBOPT_0x27
	STD  Y+6,R0
	CALL SUBOPT_0x27
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120006
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120006
_0x202000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120006
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2120006:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x28
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x26
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020022
	RJMP _0x2120005
_0x2020022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,129
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x28
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x28
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x29
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x2120005
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x2120005:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtext:
; .FSTART _glcd_outtext
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x202002E:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020030
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x202002E
_0x2020030:
	LDD  R17,Y+0
	JMP  _0x2120001
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	JMP  _0x2120002
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G103:
; .FSTART _put_buff_G103
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2060014:
	RJMP _0x2060015
_0x2060010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120003
; .FEND
__print_G103:
; .FSTART __print_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2060016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x206001C
	CPI  R18,37
	BRNE _0x206001D
	LDI  R17,LOW(1)
	RJMP _0x206001E
_0x206001D:
	CALL SUBOPT_0x2A
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x2A
	RJMP _0x20600CC
_0x2060020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2060021
	LDI  R16,LOW(1)
	RJMP _0x206001B
_0x2060021:
	CPI  R18,43
	BRNE _0x2060022
	LDI  R20,LOW(43)
	RJMP _0x206001B
_0x2060022:
	CPI  R18,32
	BRNE _0x2060023
	LDI  R20,LOW(32)
	RJMP _0x206001B
_0x2060023:
	RJMP _0x2060024
_0x206001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2060025
_0x2060024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060026
	ORI  R16,LOW(128)
	RJMP _0x206001B
_0x2060026:
	RJMP _0x2060027
_0x2060025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x206001B
_0x2060027:
	CPI  R18,48
	BRLO _0x206002A
	CPI  R18,58
	BRLO _0x206002B
_0x206002A:
	RJMP _0x2060029
_0x206002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x206001B
_0x2060029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x206002F
	CALL SUBOPT_0x2B
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2C
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2060036
_0x2060035:
	CPI  R30,LOW(0x64)
	BREQ _0x2060039
	CPI  R30,LOW(0x69)
	BRNE _0x206003A
_0x2060039:
	ORI  R16,LOW(4)
	RJMP _0x206003B
_0x206003A:
	CPI  R30,LOW(0x75)
	BRNE _0x206003C
_0x206003B:
	LDI  R30,LOW(_tbl10_G103*2)
	LDI  R31,HIGH(_tbl10_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x206003D
_0x206003C:
	CPI  R30,LOW(0x58)
	BRNE _0x206003F
	ORI  R16,LOW(8)
	RJMP _0x2060040
_0x206003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2060071
_0x2060040:
	LDI  R30,LOW(_tbl16_G103*2)
	LDI  R31,HIGH(_tbl16_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x206003D:
	SBRS R16,2
	RJMP _0x2060042
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2E
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2060043:
	CPI  R20,0
	BREQ _0x2060044
	SUBI R17,-LOW(1)
	RJMP _0x2060045
_0x2060044:
	ANDI R16,LOW(251)
_0x2060045:
	RJMP _0x2060046
_0x2060042:
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2E
_0x2060046:
_0x2060036:
	SBRC R16,0
	RJMP _0x2060047
_0x2060048:
	CP   R17,R21
	BRSH _0x206004A
	SBRS R16,7
	RJMP _0x206004B
	SBRS R16,2
	RJMP _0x206004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x206004D
_0x206004C:
	LDI  R18,LOW(48)
_0x206004D:
	RJMP _0x206004E
_0x206004B:
	LDI  R18,LOW(32)
_0x206004E:
	CALL SUBOPT_0x2A
	SUBI R21,LOW(1)
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x206004F
_0x2060050:
	CPI  R19,0
	BREQ _0x2060052
	SBRS R16,3
	RJMP _0x2060053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2060054
_0x2060053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2060054:
	CALL SUBOPT_0x2A
	CPI  R21,0
	BREQ _0x2060055
	SUBI R21,LOW(1)
_0x2060055:
	SUBI R19,LOW(1)
	RJMP _0x2060050
_0x2060052:
	RJMP _0x2060056
_0x206004F:
_0x2060058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x206005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x206005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x206005A
_0x206005C:
	CPI  R18,58
	BRLO _0x206005D
	SBRS R16,3
	RJMP _0x206005E
	SUBI R18,-LOW(7)
	RJMP _0x206005F
_0x206005E:
	SUBI R18,-LOW(39)
_0x206005F:
_0x206005D:
	SBRC R16,4
	RJMP _0x2060061
	CPI  R18,49
	BRSH _0x2060063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2060062
_0x2060063:
	RJMP _0x20600CD
_0x2060062:
	CP   R21,R19
	BRLO _0x2060067
	SBRS R16,0
	RJMP _0x2060068
_0x2060067:
	RJMP _0x2060066
_0x2060068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2060069
	LDI  R18,LOW(48)
_0x20600CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x206006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x2C
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x2A
	CPI  R21,0
	BREQ _0x206006C
	SUBI R21,LOW(1)
_0x206006C:
_0x2060066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2060059
	RJMP _0x2060058
_0x2060059:
_0x2060056:
	SBRS R16,0
	RJMP _0x206006D
_0x206006E:
	CPI  R21,0
	BREQ _0x2060070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2C
	RJMP _0x206006E
_0x2060070:
_0x206006D:
_0x2060071:
_0x2060030:
_0x20600CC:
	LDI  R17,LOW(0)
_0x206001B:
	RJMP _0x2060016
_0x2060018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x2F
	SBIW R30,0
	BRNE _0x2060072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120004
_0x2060072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x2F
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2120004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG
_srand:
; .FSTART _srand
	ST   -Y,R27
	ST   -Y,R26
	LD   R30,Y
	LDD  R31,Y+1
	CALL __CWD1
	CALL SUBOPT_0x30
	JMP  _0x2120002
; .FEND
_rand:
; .FSTART _rand
	LDS  R30,__seed_G104
	LDS  R31,__seed_G104+1
	LDS  R22,__seed_G104+2
	LDS  R23,__seed_G104+3
	__GETD2N 0x41C64E6D
	CALL __MULD12U
	__ADDD1N 30562
	CALL SUBOPT_0x30
	movw r30,r22
	andi r31,0x7F
	RET
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2120003:
	ADIW R28,5
	RET
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2120002:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20C0007
	CPI  R30,LOW(0xA)
	BRNE _0x20C0008
_0x20C0007:
	LDS  R17,_glcd_state
	RJMP _0x20C0009
_0x20C0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20C000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20C0009
_0x20C000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20C0005
	__GETBRMN 17,_glcd_state,16
_0x20C0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20C000E
	CPI  R17,0
	BREQ _0x20C000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120001
_0x20C000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120001
_0x20C000E:
	CPI  R17,0
	BRNE _0x20C0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120001
_0x20C0011:
_0x20C0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120001
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20C0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120001
_0x20C0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20C0016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120001
_0x20C0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20C0018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120001
_0x20C0018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120001:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20C001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20C001B
_0x20C001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20C001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x20C001B
_0x20C001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20C001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20C001B:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_snake_x_poses:
	.BYTE 0x100
_snake_y_poses:
	.BYTE 0x100
_ks0108_coord_G100:
	.BYTE 0x3
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CALL _glcd_setpixel
	ST   -Y,R17
	MOV  R26,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	MOV  R26,R16
	JMP  _glcd_setpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CALL _glcd_setpixel
	MOV  R30,R17
	SUBI R30,-LOW(1)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x3:
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R30,Y+4
	LDI  R31,0
	SUBI R30,LOW(-_snake_x_poses)
	SBCI R31,HIGH(-_snake_x_poses)
	LD   R30,Z
	MOV  R17,R30
	LDD  R30,Y+4
	LDI  R31,0
	SUBI R30,LOW(-_snake_y_poses)
	SBCI R31,HIGH(-_snake_y_poses)
	LD   R30,Z
	MOV  R16,R30
	MOV  R30,R17
	SUBI R30,-LOW(1)
	LSL  R30
	LSL  R30
	MOV  R19,R30
	MOV  R30,R16
	SUBI R30,-LOW(1)
	LSL  R30
	LSL  R30
	MOV  R18,R30
	ST   -Y,R19
	MOV  R26,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL _glcd_setpixel
	ST   -Y,R19
	MOV  R26,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	SUBI R26,-LOW(3)
	CALL _glcd_setpixel
	MOV  R30,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	MOV  R26,R18
	CALL _glcd_setpixel
	MOV  R30,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	MOV  R26,R18
	SUBI R26,-LOW(1)
	CALL _glcd_setpixel
	MOV  R30,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	MOV  R26,R18
	SUBI R26,-LOW(2)
	CALL _glcd_setpixel
	MOV  R30,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL _glcd_clrpixel
	ST   -Y,R19
	MOV  R26,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	SUBI R26,-LOW(3)
	CALL _glcd_clrpixel
	MOV  R30,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ST   -Y,R30
	MOV  R26,R18
	CALL _glcd_clrpixel
	MOV  R30,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	MOV  R26,R18
	SUBI R26,-LOW(1)
	CALL _glcd_clrpixel
	MOV  R30,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	MOV  R26,R18
	SUBI R26,-LOW(2)
	CALL _glcd_clrpixel
	MOV  R30,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ST   -Y,R30
	MOV  R26,R16
	SUBI R26,-LOW(1)
	CALL _glcd_setpixel
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	ST   -Y,R30
	MOV  R26,R16
	SUBI R26,-LOW(2)
	CALL _glcd_setpixel
	MOV  R30,R17
	SUBI R30,-LOW(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	ANDI R17,HIGH(255)
	LDI  R26,LOW(_snake_x_poses)
	LDI  R27,HIGH(_snake_x_poses)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_snake_x_poses)
	SBCI R31,HIGH(-_snake_x_poses)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LD   R18,Z
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_snake_y_poses)
	SBCI R31,HIGH(-_snake_y_poses)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	MOV  R26,R5
	CLR  R27
	MOV  R30,R4
	LDI  R31,0
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDD  R26,Y+27
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	MOV  R26,R4
	LDI  R27,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	CALL _glcd_moveto
	MOVW R26,R28
	ADIW R26,6
	JMP  _glcd_outtext

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	CBI  0x12,1
	LDI  R30,LOW(255)
	OUT  0x14,R30
	LD   R30,Y
	OUT  0x15,R30
	CALL _ks0108_enable_G100
	JMP  _ks0108_disable_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL _ks0108_wrdata_G100
	JMP  _ks0108_nextx_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1D:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1E:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G100
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2A:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	STS  __seed_G104,R30
	STS  __seed_G104+1,R31
	STS  __seed_G104+2,R22
	STS  __seed_G104+3,R23
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
