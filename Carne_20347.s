/*---------------------------------------------------------*/

/*  UVG 2021 - Assembler 
    Programa realizado para el laboratorio 7 
    Alejandro Gomez 20347 
    Fecha: 25/04/21 */
    
/*---------------------------------------------------------*/

/* Basado en ejemplos subidos a canvas
    e investigacion realizada durante
    el transcurso de los 2 dias de 
    realizacion del programa. */



// Area de codigo
.text
.align 2
.global main
.type main,%function // Programa principal

// Se define el main del programa 

main:
    stmfd sp!,{lr}

    ldr R5 = WorkerProgress
    // Se inicializa el contador a utilizar
    mov R6, #0

    // Desde LDR se obtienen sus valores de memoria
    ldr R0, = MemoryValueLDR
    ldr R4,[R0]

    // Se definen valores de cantidad a utilizar
    ldr R0,= NumeroTotal
    ldr R5,[R0]
    mov R1,R4


    /* Se definen las distintas opciones para
        el valor que mas se repite en 
        las calificaciones de trabajadores. */

    // En caso el numero repetido sea cero.
    CasoCero:
        ldr R0,= RepetidoCero
        bl puts

    // En caso el numero repetido sea cinco.
    CasoCinco:
        ldr R0,= RepetidoCinco
        bl puts
    
    // En caso el numero repetido sea nueve.
    CasoNueve:
        ldr R0,= RepetidoNueve
        bl puts


    // Comparacion entre el valor de 5 y 9
    CincoYNueveComparacion:
    	cmp R7,R9
       
        // Si es 0	 
        blt CasoCero
        // Si es 5
        bgt CasoCinco

    // Comparacion entre el valor de 0 y 9
    CeroYNueveComparacion:
    	cmp R8,R9	
        
        // Si es 0
        blt CasoCero
        // Si es 9
        bgt CasoNueve

    //Se define el final del ciclo.
    CierreDeCiclo:
        mov R1,R5
        ldr R0,=PromedioCalifiaciones
        mov R1,R6
        bl printf
        ldr R0,=Average
        str R6, [R0]
        mov R0,#0
        mov R3,#0
        ldmfd sp!,{lr}
        bx lr

    // Comparacion entre el valor de 5 y 0
    CincoYCeroComparacion:
    	cmp R7,R8  
        // Accesa a instrucciones definidas arriba
        // Segun corresponda el valor.
        blt CeroYNueveComparacion
        bgt CincoYNueveComparacion
        b CierreDeCiclo

    CounterCycle:
        cmp R6, #10
        beq  CincoYCeroComparacion
        ldr R1,[R5],#4
        cmp R1,#5
        addeq R7,#1
        addle R8,#1
        addgt R9,#1

        b CounterCycle

    AverageCycle:
        cmp R5, R4
        bgt CounterCycle
        sub R4,R5
        add R6,#1
        b AverageCycle
        

// Se definen los disntos mensajes de impresion y datos a utilizar en el programa
.data
.align 2

// Se definen los valores obtenidos por trabajadores
WorkerProgress:
    /* Se utiliza word ya que todos los valores del array corresponden a numeros */
    .word  5,0,5,5,9,5,0,9,5,5

// Se definen los codigos de trabajadores:
WorkerID:
    /* Se utiliza asciz ya que tienen numeros y letras los valores del array */
	.asciz "C14","RH2","TI2","V59","RH2","C09","C19","A19","D19","E90"
Average:
	.word 0

NumerosUtilizados: 
	.word 10
MemoryValueLDR: 
	.word 47
TotalDeNumeros:	
	.word 10

// Se define mensaje para el valor promedio de las calificaciones obtenidas 
PromedioCalifiaciones:	
	.asciz	"\nPromedio de calificaciones de trabajadores es: %d\n"

// En caso valor mas repetido sea 0, se muestra este mensaje:
RepetidoCero:
	.asciz "\nCalificación mas comun es 0: pesimo desempeno laboral\n"

// En caso valor mas repetido sea 5, se muestra este mensaje:
RepetidoCinco:
	.asciz "\nCalificación mas comun es 5: desempeno laboral intermedio\n"

// En caso valor mas repetido sea 9, se muestra este mensaje:
RepetidoNueve:
	.asciz "\nCalificación mas comun es 9: excelente desempeno laboral\n"

// Codigo de los mejores trabajadores
BestWorkersUVG:
	.asciz "\nTrabajadores excelentes son: %s\n"