/*---------------------------------------------------------
    UVG 2021 - Assembler 
    Programa realizado para el laboratorio 7 
    Alejandro Gomez 20347 
    Fecha: 25/04/21
---------------------------------------------------------*/

/* Basado en ejemplos subidos a canvas
    y mucha prueba y error.
    Todo realizado con lagrimas y mucha dedicacion.  */

/*  En cuanto a las decisiones de diseno, se encuentra
    los siguientes formatos utilizados:
    .word = calificaciones
    asciz = ID trabajador */



/* ------------ CONTROL DE VERSIONES ----------------- */
/* VERSION 23/04: 
    Log del dia:
        -Primeros acercamientos
        -Analisis de codigos subidos a canvas
        -Revision de conceptos mostrados en clase*/

/* VERSION 24/04:
    Log del dia:
        No hubo avances, me enferme. */

/* VERSION 25/04:
    Log del dia:
    -  Trabajo general en codigo
    - Organizacion y tomas de
    decision respecto al codigo*/

/* VERSION 26/04:
    Log del dia:
        - Con lo visto en clase ya tengo una
            vision general y amplia
            de como realizarlo mejor el codigo.
            Se rehace parte del codigo
        */
/* VERSION 27/04: 
    Log del dia:
        - El promedio ya se ve,
            no cuenta con el valor correcto*/

 /* VERSION 28/04:
    Log del día:
    - Ya se muestra promedio
    - Ya se muestra moda
    - Solo falta agregar el inciso de mejores empleados 
    - Error muuuy extrano en el codigo... */

/* ---------------------------------------- */

// Area de codigo

.text
.align 2
.global main
.type main,%function // Programa principal

// Se define el main del programa 


/* ---------------------------------------
    CODIGO DE CADA ESPACIO Y QUE SIGNIFICAN
    ---------------------------------------
    R12 = Contador
    R10 = Cantidad de elementos x Array
    R6 = El array es cargado 
    ----------------------------------------*/

main:
    stmfd sp!,{lr} /* SP = R13 link register */

    ldr R6, = WorkerProgress

    // Se inicializa el contador a utilizar
    mov R5, #0
    mov R4, #0


    /* Se define metodo para realizar la sumatoria
        dentro de una lista y almacenar la misma.
        Posteriormente los valores se cargan,
        despues de resetear el contador. */
    ProcesoDeSumatoria:

        ldrb R1,[R6],#4
        add R5,R5,R8
        add R4,R4,#1

        cmp R4,#10  
    
        blt ProcesoDeSumatoria

        // LINEA DE ERROR DE RAMIFICACION
        //bge FinalRes


        //add R4,#1
        ldr R5,=FinalRes

        str R5,[R6]
        mov R4,#0
        ldr R5,=NumerosUtilizados

	/* Se define metodo para realizar el proceso
        de division, basado principalmente en
        uno de los ejemplos durante clase. */
  

    ProcesoDeDivision:
        // Despues de comparar, lo muestra, resta uno y suma
        // al contador.
		cmp R5, #10
		bgt ResultadoTotalProm 

		sub R6,R5		
		add R4,R4,#1		
		b ProcesoDeDivision
		

    /* Se utiliza el siguiente metodo
        para lograr implementar el resultado total
        y poner su formato para hacer un print */
    ResultadoTotalProm:
        // Despues de poner formato para impresion
        // mueve posicion registro.
		ldr R0,=PromedioCalifiaciones  
		mov R8,R6
		bl printf


/* Se definen los valores de contador a utilizar
    Cada uno corresponde a una nota posible
    Ademas del contador global utilizado. */

    mov R10,#0
    mov R9,#0
    mov R12,#0
    mov R7,#0
    ldr R4,=WorkerProgress



/* SECCION CORRESPONDIENTE A LA LECTURA DE ARRAY/COMPARACION */

    /* Se realiza metodo para la lectura
    de array, y comparaciones */


    ArrayComparacion:
        // Se verifica valor de contador, luego se suma 1
        cmp R10,#10
        beq Verificador
        ldr R1,[R4],#4
        add R10,R10,#1

        // Se realizan procesos de comparacion entre 0,5,9
        cmp R8,#0
        addeq R7,#1
        cmp R8,#9
        addeq R9,#1

        bl ArrayComparacion

    Verificador:
       
        cmp R7, R12
        bgt ModaCero

        cmp R9, R12
        bgt ModaNueve

       
    /* Se definen las distintas opciones para
        el valor que mas se repite en 
        las calificaciones de trabajadores. 
        Equivalente estadistico = Moda */

        // Se declaran las comparativas si existen menos ceros que nueves
        
        /*  1. Existen mas 9 que 0 dentro de los datos
            2. Existen mas 5 dentro de los datos analizado
            3. Existen mas 0 que 9 en los datos */
        ModaCero:
            cmp R9,R7
            bgt ModaNueve
            ldr R0,=RepetidoCero
            bl printf
            bl FinalizacionProceso
            

        
        ModaCinco:
            ldr R0,= RepetidoCinco
            bl printf
            bl FinalizacionProceso
            

        ModaNueve:
            cmp R7,R9
            bgt ModaCero
            ldr R0,= RepetidoNueve
            bl printf
            bl FinalizacionProceso
            


        FinalizacionProceso:
        
            mov pc, lr

    mov R12, #0
    ldr R10,=NumerosUtilizados
    ldr R6,=WorkerProgress


    /* SECCION CORRESPONDIENTE AL DESENPENO Y LA OBTENCION */
        EvaluacionTrabajadores:
            cmp R12,#10
            beq ExitProgram
            add R12,R12,#1

            ldr R1,[R6],#4
            cmp R8,#9
            beq ObtainWorkerID
            b EvaluacionTrabajadores

        ObtainWorkerID:
            mov R11,R12
            sub R11,R11,#1
            mov R3,#4
            mul R3,R3,R11
            ldr R1,=WorkerID
            add R8,R8,R3

            ldr R0,=BestWorkersUVG
            bl printf
            b EvaluacionTrabajadores
            
   
            

ExitProgram:
	/* Se ejecutan las lineas de
        codigo pertinentes para
        salir del programa. */
    mov R0,#0
	mov R3,#0
	ldmfd sp!,{lr}
	bx lr


// Se definen los distintos mensajes de impresion y datos a utilizar en el programa
.data
.align 2

/* --------------------------------- */
/* SECCION DE PRUEBAS DEL PROGRAMA:
    Utilizado como parte del debug entre cada corrida, para
    verificar su funcionamiento */
Pruebas:
    .asciz "Este es un mensaje de prueba para probar el programa"
PruebaWord:
    .word 0,0,0,0,0,0,0,0,0,0
PruebaWordNueve:
    .word 9,9,9,9,9,9,9,9,9,9
PruebaWordCinco:
    .word 5,5,5,5,5,5,5,5,5,5
/* --------------------------------- */

/* VALORES UTILIZADOS EN EL PROGRAMA:
    Cada valor a implementar es definido */

FinalRes: 
	.word 1

NumerosUtilizados: 
	.word 10

// Se definen los valores obtenidos por trabajadores
WorkerProgress:
    /* Se utiliza word ya que todos los valores del array corresponden a numeros */
    .word  5,0,5,5,9,5,0,9,5,5

// Se definen los codigos de trabajadores:
WorkerID:
    /* Se utiliza asciz ya que tienen numeros y letras los valores del array */
	.asciz "C14","RH2","TI2","V59","RH2","C09","C19","A19","D19","E90"

// Se define mensaje para el valor promedio de las calificaciones obtenidas 
PromedioCalifiaciones:	
	.asciz	"\nPromedio de calificaciones de trabajadores es: %d\n"

// En caso valor mas repetido sea 0, se muestra este mensaje:
RepetidoCero:
	.asciz "\nCalificación mas comun NO es 0: pesimo desempeno laboral\n"

// En caso valor mas repetido sea 5, se muestra este mensaje:
RepetidoCinco:
	.asciz "\nCalificación mas comun es 5: desempeno laboral intermedio\n"

// En caso valor mas repetido sea 9, se muestra este mensaje:
RepetidoNueve:
	.asciz "\nCalificación mas comun NO es 9: excelente desempeno laboral\n"

// Codigo de los mejores trabajadores
BestWorkersUVG:
	.asciz "\nTrabajadores excelentes son: %s\n"

