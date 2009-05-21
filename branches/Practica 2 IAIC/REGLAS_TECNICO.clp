; PRACTICA 2 IAIC
; GRUPO B09
;
;	AUTORES:
;		- Jos� Miguel Guerrero Hern�ndez
;		- V�ctor Adail Ferrer
;
; Se ha definido una plantilla con los datos que utilizaremos para nuestras reglas.
; Aquellos que tienen un valor default, no son necesario asignarles valores, todos 
; aquellos slots que no tienen default, segun la pregunta hay que asignarle uno de 
; los valores posibles para el slot.
;
; Para la modificacion de los slot, se ha utilizado el mismo hecho (fact). Se ha
; evitado hacer asertos (assert) para evitar la repeticion innecesaria de las reglas.
; Por eso se tiene un unico hecho, el cual en funcion de los valores de los slots, los
; cuales pueden ser modificados en diferentes reglas, iran activando las reglas necesarias
; y guardando los consejos en el fichero deseado ("log_grupoB09.txt" por defecto).
;
; REGLAS DE USO, DESDE JAVA:
;	- Ejecutar (reset)
;	- Cargar el fichero (batch reglasB09.clp)
;	- Crear el Fact con el template "datos"
;	- Asignar los valores a los slots en funcion de la pregunta a contestar:
;		- Delante de cada pregunta se indica en la cabecera a que slots hay
;		  que darles valor para que funcione. Los valores entre corchetes [,]
;		  indica el valor string que puede tener (pej: sexo = ["hombre", "mujer"]
;		  indica que al slot sexo hay que darle un valor, o bien mujer o bien hombre).
;		- Aquellos valores que pone "(asignacion por defecto)" significa que
;		  hay que darle ese valor al slot para poder contestar a la pregunta deseada.
;		  (pej: estado_actual = "busqueda" (asignacion por defecto) indica que para
;		  contestar a la pregunta hay que darle a estado_actual el valor "busqueda").
;		- Para los valores entre <,> se le asignara un valor entero pedido al usuario
;		  (pej: tiempo_libre = <numero entero positivo> indica que a tiempo_libre se
;		  le asignara un valor del tipo entero y positivo)
;	- Realizar el aserto del fact
;	- Ejecutar la aplicacion (run)
;	- Utilizar el fichero generado ("log_grupoB09.txt" por defecto) con los consejos
;	  de nuestra aplicacion, el cual puede ser tratado desde cualquier lenguaje de 
;	  programacion. A este fichero generado se le agregaran todos los consejos que 
;	  salgan de esta base de reglas.
;
; EJEMPLO USO CON JAVA:
;	Rete rete=new Rete();
;	rete.executeCommand("(reset)");
;	rete.executeCommand("(batch reglasB09.clp)");
;	Fact f = new Fact("datos", rete);
;	f.setSlotValue("estado_actual", new Value("busqueda_empleo", RU.STRING));
;	f.setSlotValue("numero_paginas_CV", new Value(2, RU.INTEGER));
;	... [insertar valores de los slots necesarios para la pregunta] ...
;	rete.assertFact(f);
;	rete.executeCommand("(run)");
;
;	Para cualquier duda o consulta contactar con:
;		- jomy.mc@gmail.com (Jos� Miguel)
;		- lolken@gmail.com 	(V�ctor)
;


(deftemplate datos
    
	; variable general para la seleccion de la pregunta
    (slot estado_actual)
    (slot ruta_fichero_salida (default "log_grupoB09.txt"))        
    (slot fichero_salida (default "ficheroGuardar"))   
    
    ; variables del aspecto tecnico
    (slot tipo_estudios)    
    (slot conocimiento)   
    (slot apto_investigacion (default "no"))   
    (slot tipo_contrato (default "no_def"))
    (slot buscar_inem (default "no"))   
    (slot buscar_prensa (default "no"))
    (slot desea_informacion (default "no"))         
    (slot lee_prensa)
    (slot estudia)   
    (slot tiempo_libre)     
    (slot experiencia)   
    (slot destacar_formacion (default "no"))   
    (slot destacar_experiencia (default "no"))  
    (slot numero_paginas_CV)    
    (slot rango_edad)
    (slot situacion_laboral)
    (slot rechazado)
    (slot estudio)
    (slot seleccionado_entrevista) 
    (slot conoce_perfil) 
    (slot conoce_empresa) 
    (slot conoce_protocolo) 

)



; ****************************************
; **		REGLAS ASPECTO TECNICO		**
; ****************************************

;-------------------------------------------------------------------------------------------------------------------
; 	PREGUNTA A LA QUE RESPONDE: �Donde buscar informacion?
;
;	DATOS ENTRADA:
;		- estado_actual = "busqueda" (asignacion por defecto)
;
;		PREGUNTAS A REALIZAR, POSIBLES CONTESTACIONES PARA ASIGNAR A LA VARIABLE INDICADA:
;			�Que estudios posee?
;				- tipo_estudios = ["universitarios", "no_universitarios"]
;			�Que tipo de conocimiento posee?
;				- conocimiento = ["investigacion", "basico"]
;			�Que tipo de contrato desea?
;				- tipo_contrato = ["beca", "jornada"]
;			�Desea informacion adicional?
;				- desea_informacion = ["si", "no"]
;			�Lee la prensa?
;				- lee_prensa = ["si", "no"]
;-------------------------------------------------------------------------------------------------------------------

(defrule donde_buscar_info1 "Comprobamos si es apto para la investigacion"
    (initial-fact)
    ; SI (estado_actual=busqueda & tipo_estudio=universitarios & apto_investigacion=no)
    ;	ENTONCES apto_investigacion=si
	?dat <- (datos (estado_actual "busqueda") (tipo_estudios "universitarios")(apto_investigacion "no"))
	=> 
    
    ;cumple los requisitos para ser apto para la investigacion (apto_investigacion=si)
    (modify ?dat (apto_investigacion "si"))
)

(defrule donde_buscar_info2 "Comprobamos donde podemos buscar"
    ; SI (estado_actual=busqueda & conocimiento=investigacion & apto_investigacion=si & tipo_contrato=beca & buscar_prensa=no & buscar_inem=no) 
    ; 	ENTONCES buscar_prensa=si & buscar_inem=si
	?dat <- (datos (estado_actual "busqueda") (conocimiento "investigacion") (apto_investigacion "si") (tipo_contrato "beca")(buscar_prensa "no")(buscar_inem "no")(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
    => 
    
    ;si cumple los requisitos puede buscar en la prensa o en el inem (buscar_prensa=si & buscar_inem=si)
    (modify ?dat (buscar_prensa "si")(buscar_inem "si"))
    
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Puede buscar empleo en el INEM o en la prensa.
        Si lo que desea es dedicarse a la investigaci�n puede ponerse en contacto con 
        cualquier universidad y que le informe de los grupos de investigaci�n que tienen 
        actualmente, de todas formas al desear una beca, puede mirar en la p�gina web del 
        ministerio de ciencia e innovaci�n (http://web.micinn.es/contenido.asp).
        
     	" crlf)
    (close ?fichero)    
)

(defrule donde_buscar_info3 "Comprobamos donde podemos buscar"
    ; SI (estado_actual=busqueda & tipo_contrato=jornada & buscar_prensa=no & buscar_inem=no) 
    ; 	ENTONCES buscar_prensa=si & buscar_inem=si
	?dat <- (datos (estado_actual "busqueda") (tipo_contrato "jornada")(buscar_prensa "no")(buscar_inem "no")(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
    => 
    
    ;si cumple los requisitos puede buscar en la prensa o en el inem (buscar_prensa=si & buscar_inem=si)
    (modify ?dat (buscar_prensa "si")(buscar_inem "si"))
    
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Puede buscar empleo en el INEM o en la prensa.
        
     	" crlf)
    (close ?fichero)    
)

(defrule donde_buscar_info4 "Miramos si puede buscar en la prensa"
    ; SI (estado_actual=busqueda & apto_investigacion=no & buscar_prensa=no) 
    ; 	ENTONCES buscar_prensa=si
	?dat <- (datos (estado_actual "busqueda") (apto_investigacion "no") (buscar_prensa "no")(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
    => 
    
    ;si cumple los requisitos puede buscar en la prensa (buscar_prensa=si)
    (modify ?dat (buscar_prensa "si"))
    
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Puede buscar empleo en la prensa.
        
     	" crlf)
    (close ?fichero)    
)

(defrule donde_buscar_info5 "Miramos si quiere mas informacion y puede buscar en el INEM"
    ; SI (estado_actual=busqueda & buscar_inem=si & desea_informacion=si) 
    ; 	ENTONCES mostrar consejo
	?dat <- (datos (estado_actual "busqueda") (buscar_inem "si") (desea_informacion "si")(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
    => 
       
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Esta es una fuente de b�squeda de empleo de car�cter p�blico, el Instituto Nacional 
        de Empleo (I.N.E.M.), en cuyas oficinas puedes inscribirte como demandante activo en 
        b�squeda de empleo, debi�ndolo de hacer en aquella que m�s cerca se encuentre de tu 
        domicilio o localidad. Este paso es imprescindible para acceder a las ofertas de trabajo 
        que se canalizan a trav�s de este organismo.
        
		�Por qu� puede ser interesante estar inscrito en �l? porque es un espacio de b�squeda 
        que te ofrece:
			�	ENTRAR EN PROCESOS DE SELECCI�N. 
			�	LA POSIBILIDAD DE CONSEGUIR ORIENTACI�N PROFESIONAL. 
			�	REALIZAR CURSOS DE FORMACI�N OCUPACIONAL DEL I.N.E.M. U OTROS ORGANISMOS. 
			�	QUE TE INCLUYAN EN PROGRAMAS ESPEC�FICOS DE B�SQUEDA DE EMPLEO
        
		Para registrarte como demandante debes llevar el carnet de identidad, y tu cartilla o 
        n�mero de la Seguridad Social (lo tendr�s en caso de haber trabajado con anterioridad), 
        as� como las justificaciones acad�micas y profesionales. Como demandante rellenar�s una 
        solicitud que se tramita mediante una entrevista personalizada. Deber�as ir con una 
        orientaci�n clara del sector profesional o de las actividades en las que te vayas a 
        inscribir. Si no la tuvieras, p�deles asesoramiento, est�n suficientemente preparados 
        y disponen de la informaci�n para orientarte.
        
		Tienes dos formas de inscribirte en este organismo:
			�	COMO CUALQUIER OTRO TRABAJADOR 
			�	EN EL REGISTRO DE MINUSV�LIDOS
        
		Muchas personas con discapacidad de las que buscan trabajo se inscriben como demandantes 
        no discapacitados, porque piensan que si no, les puede restar posibilidades de encontrar 
        un empleo.
        
		O bien te puedes inscribir en el registro de minusv�lidos. Lo m�s importante de esto es 
        que hay empresas que solicitan expresamente trabajadores con alg�n tipo de discapacidad 
        a este organismo. Para inscribirse en este registro, hay que presentar el Certificado 
        Oficial de Minusval�a.
        
		Una vez inscrito como demandante de empleo en tu oficina m�s cercana (la que te corresponde), 
        debes presentarte peri�dicamente en la fecha que aparece en tu tarjeta de demanda. Debes 
        renovarla en los d�as exactos indicados y acudir a la oficina de empleo cuando previamente 
        seas requerido. Si no la renuevas en estas fechas o no te presentas, perder�s la antig�edad, 
        que en algunos programas o puestos es en s� un criterio a�adido de selecci�n, as� como todos 
        los derechos derivados de tu inscripci�n. Debes comunicarles todos los cambios que consideres 
        importantes a nivel formativo y profesional que te puedan ayuda a encontrar trabajo.
        
		Existen dos acciones y actitudes a la hora de estar inscrito en el I.N.E.M. para sacar el 
        m�ximo beneficio o provecho:
        
		ACCION ACTIVA Y ACTITUD POSITIVA
			�	Realizar cursos de formaci�n ocupacional 
			�	Solicitar informaci�n y orientaci�n laboral 
			�	Preguntar por las ofertas actuales 
			�	Pasarse peri�dicamente por la oficina
        
		ACCION O ACTITUD PASIVA  
			�	Presentarse cuando se�ala la tarjeta de demanda 
			�	Presentarse s�lo cuando se es requerido 
			�	No solicitar informaci�n
        
		De ti depende que emprendas una acci�n u otra, nosotros te recomendamos que emprendas la 
        primera. Ac�rcate siempre que puedas o quieras, hay una secci�n de demandas actuales, 
        solic�talas, no te d� verg�enza el solicitar cuanta informaci�n creas necesaria para ti. 
        Por �ltimo, recordarte que estar inscrito como demandante de empleo en la oficina del 
        I.N.E.M. es un requisito previo para poder ser contratado y si ya est�s trabajando puedes 
        inscribirte como demandante de mejora de empleo.
        
     	" crlf)
    (close ?fichero)    
)

(defrule donde_buscar_info6 "Miramos si quiere mas informacion y puede buscar en la prensa si la lee"
    ; SI (estado_actual=busqueda & buscar_prensa=si & desea_informacion=si & lee_prensa=si) 
    ; 	ENTONCES mostrar consejo
	?dat <- (datos (estado_actual "busqueda") (buscar_prensa "si") (desea_informacion "si")(lee_prensa "si")(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
    => 
       
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Los medios de comunicaci�n (sobre todo la prensa escrita) constituyen otra fuente de informaci�n
        valiosa en la b�squeda de empleo. En ellos puedes encontrar informaci�n interesante acerca del
        mercado laboral, ofertas de puestos de trabajo, actividades empresariales de nueva creaci�n, 
        nuevas ideas, etc�tera. 
        
		En la prensa diaria aparecen anuncios de ofertas y demandas de trabajo, no s�lo diariamente, 
        sino que algunos peri�dicos los concentran los fines de semana, sobre todo el domingo, como por 
        ejemplo: ABC, EL PA�S (ambos de tirada nacional). Es otro espacio de b�squeda de empleo que 
        puedes y debes utilizar.
        
		Para muchas empresas la prensa es el canal m�s habitual para captar a sus trabajadores. Normalmente 
        son empresas especializadas en selecci�n de personal las que ponen los anuncios. Los perfiles son 
        predefinidos y dan como resultado respuestas masivas.
        
		Debes acostumbrarte a saber cuando salen y en que peri�dicos se concentra el mayor numero de ofertas.
			
        	ANUNCIOS EN LA PRENSA (OFERTAS):  
				�	TIRADA O AMBITO LOCAL: 
					o	Empresas ubicadas en tu zona. 
        
				�	TIRADA O AMBITO NACIONAL: 
					o	Oferta m�s amplia y diversificada. 
					o	Mas informaci�n sobre el mercado laboral en general 
					o	Ofertas fuera de tu lugar de residencia.
        
				�	REVISTAS ESPECIALIZADAS: 
					o	Informaci�n espec�fica y bolsa de empleo.
        
			Ante una oferta interesante:
				�	Responde r�pidamente (en el plazo de cinco d�as). 
				�	Env�a una carta de presentaci�n y el curriculum vitae
        
		No te desanimes si crees no cumplir alguno de los requisitos exigidos. Piensa que la mayor�a de las 
        demandas conlleva procesos de selecci�n personalizados (entrevista personal). Puedes destacar por 
        otras cualidades de las que no eras consciente y que no est�n expuestas en el anuncio. Las personas 
        que logran superar la entrevista personal tienen que superar a su vez un periodo de prueba.
        
		Recuerda que tambi�n puedes acceder o informarte por este canal sobre las convocatorias de empleo 
        p�blico-oposiciones, contrataciones laborales, en pr�cticas, etc�tera.
        
		Puedes utilizar este medio para ofrecer tus servicios profesionales (puedes crear tu demanda). Es otra 
        v�a que te ofrece el mercado para poder acceder a un puesto de trabajo. Los pasos que debes seguir si 
        optas por este caso serian:
			1.	Saber lo que quieres: c�mo hacerlo, que deber�as poner, y que puedes o deseas conseguir. 
			2.	Selecciona el medio o los medios de comunicaci�n m�s acordes con lo que deseas para tu anuncio. 
        		Esto depender� de tus intereses y objetivos, no descartes el hacerlo en los de gran difusi�n 
        		(aunque su coste sea superior que en los locales) o tal vez, en aquellos de difusi�n especializada, 
        		pero de menor divulgaci�n. 
			3.	Crea un buen anuncio, en el que de manera atractiva y sencilla ofertes tus servicios. Intenta ser 
        		original, pero teniendo en cuenta la sencillez y la claridad en el mismo. 
			4.	Debes estar preparado por si te llaman para salir bien del proceso de selecci�n.
        
     	" crlf)
    (close ?fichero)    
)



;-------------------------------------------------------------------------------------------------------------------
; 	PREGUNTA A LA QUE RESPONDE: �Que tipo de contrato me interesa?
;
;	DATOS ENTRADA:
;		- estado_actual = "contrato" (asignacion por defecto)
;
;		PREGUNTAS A REALIZAR, POSIBLES CONTESTACIONES PARA ASIGNAR A LA VARIABLE INDICADA:
;			�Estudia actualmente?
;				- estudia = ["si", "no"]
;			�Que tipo de conocimiento posee?
;				- conocimiento = ["investigacion", "basico"]
;			�Cuanto tiempo libre posee?
;				- tiempo_libre = <numero entero positivo>;
;-------------------------------------------------------------------------------------------------------------------

(defrule tipo_contrato1 "Comprobamos si le interesa una beca"
    ; SI (estado_actual=contrato & estudia=si & tipo_contrato<>beca)
    ;	ENTONCES tipo_contrato=beca
	?dat <- (datos (estado_actual "contrato") (estudia "si")(tipo_contrato ~"beca"))
	=> 

    ;cumple los requisitos (tipo_contrato=beca)
    (modify ?dat (tipo_contrato "beca"))
)

(defrule tipo_contrato2 "Comprobamos si le interesa un trabajo normal a jornada"
    ; SI (estado_actual=contrato & estudia=no & tipo_contrato<>jornada)
    ;	ENTONCES tipo_contrato=jornada
	?dat <- (datos (estado_actual "contrato") (estudia "no")(tipo_contrato ~"jornada"))
	=> 

    ;cumple los requisitos (tipo_contrato=jornada)
    (modify ?dat (tipo_contrato "jornada"))
)

(defrule tipo_contrato3 "Comprobamos si le interesa una beca de investigacion"
    ; SI (estado_actual=contrato & tipo_contrato=beca & conocimiento=investigacion & tiempo_libre<=6)
    ;	ENTONCES mostrar consejo
	?dat <- (datos (estado_actual "contrato") (tipo_contrato "beca") (conocimiento "investigacion") (tiempo_libre ?tiempo_libre &:(<= ?tiempo_libre 6))(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
	=> 

    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Con los conocimientos de investigaci�n y las " ?tiempo_libre " horas de las que dispone, le interesar�a 
        buscar un contrato que sea una beca de investigaci�n.
        
     	" crlf)
    (close ?fichero)  
)

(defrule tipo_contrato4 "Comprobamos si le interesa una beca normal"
    ; SI (estado_actual=contrato & tipo_contrato=beca & conocimiento<>investigacion & tiempo_libre<=6)
    ;	ENTONCES mostrar consejo
	?dat <- (datos (estado_actual "contrato") (tipo_contrato "beca") (conocimiento ~"investigacion") (tiempo_libre ?tiempo_libre &:(<= ?tiempo_libre 6))(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
	=> 

    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Le interesa un contrato de beca, el cual sea flexible para poder asistir a clase.
        
     	" crlf)
    (close ?fichero)  
)

(defrule tipo_contrato5 "Comprobamos si le interesa trabajo a media jornada"
    ; SI (estado_actual=contrato & tipo_contrato=jornada & tiempo_libre<=6)
    ;	ENTONCES mostrar consejo
	?dat <- (datos (estado_actual "contrato") (tipo_contrato "jornada") (tiempo_libre ?tiempo_libre &:(<= ?tiempo_libre 6))(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
	=> 

    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Le interesar�a un contrato a media jornada de unas 4-6 horas diarias.
        
     	" crlf)
    (close ?fichero)  
)

(defrule tipo_contrato6 "Comprobamos si le interesa trabajo a jornada completa"
    ; SI (estado_actual=contrato & tipo_contrato=jornada & tiempo_libre>6)
    ;	ENTONCES mostrar consejo
	?dat <- (datos (estado_actual "contrato") (tipo_contrato "jornada") (tiempo_libre ?tiempo_libre &:(> ?tiempo_libre 6))(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
	=> 

    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Le interesar�a un contrato a jornada completa, normalmente unas 8 horas diarias.
        
     	" crlf)
    (close ?fichero)  
)

(defrule tipo_contrato7 "Comprobamos si le interesa trabajo de beca pero tambien puede ser jornada"
    ; SI (estado_actual=contrato & tipo_contrato=beca & tiempo_libre>6)
    ;	ENTONCES mostrar consejo
	?dat <- (datos (estado_actual "contrato") (tipo_contrato "beca") (tiempo_libre ?tiempo_libre &:(> ?tiempo_libre 6))(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
	=> 
    
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Aunque le interesar�a una beca, con el tiempo libre que dispone, puede aceptar un trabajo a media jornada.
        
     	" crlf)
    (close ?fichero)  
)



;-------------------------------------------------------------------------------------------------------------------
; 	PREGUNTA A LA QUE RESPONDE: �Que debo destacar de mi curriculum?
;
;	DATOS ENTRADA:
;		- estado_actual = "curriculum" (asignacion por defecto)
;
;		PREGUNTAS A REALIZAR, POSIBLES CONTESTACIONES PARA ASIGNAR A LA VARIABLE INDICADA:
;			�Que estudios posee?
;				- tipo_estudios = ["universitarios", "no_universitarios"]
;			�Tiene experiencia laboral?
;				- experiencia = ["si", "no"]
;			�Cuantas paginas posee actualmente su curriculum?
;				- numero_paginas_CV = <numero entero positivo>
;-------------------------------------------------------------------------------------------------------------------

(defrule destacar_curriculum1 "Comprobamos si debe destacar la formacion"
    ; SI (estado_actual=curriculum & tipo_estudios=universitarios & destacar_formacion=no)
    ;	ENTONCES destacar_formacion=si
	?dat <- (datos (estado_actual "curriculum") (tipo_estudios "universitarios")(destacar_formacion "no"))
	=> 
    
    ;cumple los requisitos (destacar_formacion=si)
    (modify ?dat (destacar_formacion "si"))
)

(defrule destacar_curriculum2 "Comprobamos si debe destacar la experiencia"
    ; SI (estado_actual=curriculum & experiencia=si & destacar_experiencia=no)
    ;	ENTONCES destacar_experiencia=si
	?dat <- (datos (estado_actual "curriculum") (experiencia "si")(destacar_experiencia "no"))
	=> 
    
    ;cumple los requisitos (destacar_experiencia=si)
    (modify ?dat (destacar_experiencia "si"))
)

(defrule destacar_curriculum3 "Comprobamos si debe reducir el numero de paginas del curriculum"
    ; SI (estado_actual=curriculum & numero_paginas_CV>=3)
    ;	ENTONCES mostrar consejo
	?dat <- (datos (estado_actual "curriculum")  (numero_paginas_CV ?numero_paginas_CV &:(>= ?numero_paginas_CV 3))(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
	=> 

    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Debe de reducir el n�mero de p�ginas de tu CV. Para ello, destaca tus habilidades interesantes para 
        la oferta deseada en una p�gina y elimina las que no sean necesarias para el puesto solicitado. 
        Recuerda que la persona que revisa los curr�culum tiene 15 segundos para decidir seleccionarte.
        
     	" crlf)
    (close ?fichero) 
)

(defrule destacar_curriculum4 "Comprobamos si debe mostrar el consejo para destacar su formacion"
    ; SI (estado_actual=curriculum & destacar_formacion=si)
    ;	ENTONCES mostrar consejo
	?dat <- (datos (estado_actual "curriculum")  (destacar_formacion "si")(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
	=> 

    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Deber�a destacar su formaci�n indique claramente los cursos, estudios, seminarios as� como la titulaci�n que posee. Si su 
        calificaci�n es superior a 2.55 dest�quela, si le ha sido otorgada una menci�n, p�ngala en negrita y subrayada, igualmente 
        indique su calificaci�n indicando su calificaci�n y el m�ximo que puede ser, por ejemplo: 2.55 sobre 4
     	
        " crlf)
    (close ?fichero) 
)

(defrule destacar_curriculum5 "Comprobamos si debe mostrar el consejo para destacar su experiencia"
    ; SI (estado_actual=curriculum & destacar_formacion=si)
    ;	ENTONCES mostrar consejo
	?dat <- (datos (estado_actual "curriculum")  (destacar_experiencia "si")(ruta_fichero_salida ?ruta)(fichero_salida ?fichero))
	=> 

    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Destaque los trabajos que ha realizado, cual ha sido su funci�n, el cargo y el tiempo que ha desempe�ado, haga hincapi� 
        en aquellos trabajos que le han sido m�s fruct�feros y haga que se note estos por encima, p�ngalos en cursiva o subr�yelos.
        
     	" crlf)
    (close ?fichero) 
)

; ----------- A�ADIDAS -----------



;; PR�CTICA 2 -IAIC-
;;
;; Reglas y hechos iniciales correspondientes a un
;; asesor laboral con enfoque t�cnico.
;;
;; Autores: I�aki Goffard Gim�nez, Daniel Mart�n Carabias, Ra�l Requero Garc�a
;;
;; Curso: 4�B
;;
;; Para rellenar la base de hechos inicial (BH_0), el usuario deber� responder a ciertas
;; preguntas realizadas desde la interfaz gr�fica.
;;
;;  1. Nivel de estudios.
;;  2. Experiencia laboral en a�os.
;;  3. Tiempo que lleva desempleado en meses.
;;  4. Edad del usuario en a�os.
;;  5. Sexo del usuario.
;;  6. Curr�culum disponible.
;;  7. Idiomas extranjeros que habla.
;;  8. Intereses del usuario.
;;  9. Tiene coche o no.
;; 10. Tiene carnet de conducir o no.
;; 11. Pretensiones salariales en euros.
;; 12. Meses desde que realiz� el �ltimo curso.
;; 13. �ltima profesi�n que ha tenido el usuario.
;; 14. Tiempo que llevaba trabajando.
;; 15. Tiempo que lleva desempleado.
;; 16. A�os de experiencia en el extranjero.
;; 17. Fue aceptado o rechazado en su �ltima entrevista.
;;

;; Instrucciones de ejecuci�n:
;;
;; 1. Almacenar el fichero Asesor.clp en la carpeta \bin de Jess.
;; 2. Cargar el fichero CLP con el comando (batch Asesor.clp).
;; 3. Cargar la base de hechos iniciales (BH_0) con el comando (reset).
;; 4. Ejecutar el motor de inferencia con el comando (run).
;; 5. Se observar�n los consejos obtenidos seg�n se ejecutan las reglas.


;; Base de hechos inicial (preguntas respondidas por el usuario)

;; Reglas


;; Si el usuario es joven y tiene estudios universitarios, da la impresi�n de tener una gran capacidad para aprender

(defrule capacidadAprender
	"El usuario debe potenciar el hecho de que est� muy capacitado para aprender y adaptarse"
	(estado_actual "reglas_1")
	(edad  ?edad)
	(test (< ?edad 24))
	(tipo_estudios "universitarios")
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (cap-aprender "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Potencie su capacidad para aprender
        
        " crlf)
    (close ?fichero) 
)

;; Existen las denominadas exposiciones de empleo. Se trata de un evento presencial o virtual en el que empresarios
;; usan su tiempo para descubrir nuevos talentos. Se recomienda asistir solo como visitante si el candidato no tiene
;; mucha experiencia y adem�s hace poco que se ha quedado desempleado.

(defrule asistirExpoVisitante
	"Asiste a una exposici�n de empleo pero como visitante"
	(estado_actual "reglas_1")
	(tiene-curriculum "si")
	(tiempo-desempleado ?tiempo)
	(test (< ?tiempo 5))
        (tiempo_experiencia ?experiencia)
	(test (< ?experiencia 2))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (asiste-Expo-visitante "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Seria recomendable que acudiera a una exposicion de empleo como visitante
        
        " crlf)
    (close ?fichero)
)

;; Si en cambio el usuario dispone de una m�nima experiencia laboral, es recomendable que asista y deje su curr�culum

(defrule asistirExpoActivamente
	"Asiste a una exposici�n de empleo, y deja su curr�culum"
	(estado_actual "reglas_1")
	(tiene-curriculum "si")
	(tiempo_experiencia ?experiencia)
	(test (>= ?experiencia 2))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (asiste-Expo-visitante "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Seria recomendable que acudiera a una exposicion de empleo y dejara su curriculum
        
        " crlf)
    (close ?fichero)
)

;; Si una persona llevaba mucho tiempo trabajando y se ha quedado recientemente en paro, es recomendable que reelabore
;; su curr�culum, para as� poner de manifiesto todo lo aprendido durante esos a�os.

(defrule reelaborarCurriculum
	"Aconseja reelaborar el curr�culum del candidato"
	(estado_actual "reglas_1")
	(tiempo-trabajando ?trabajando)
	(test (> ?trabajando 10))
	(tiempo-desempleado ?desempleado)
	(test (< ?desempleado 4))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (reelabora-curriculum "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Le aconsejo que reelabore su curriculum
        
        " crlf)
    (close ?fichero)
)

;; Si una persona llevaba mucho tiempo trabajando y se ha quedado recientemente en paro, tambi�n va a tener que renovar
;; sus conocimientos para adaptarse al mercado. En el caso de que no tenga familia se le puede aconsejar cambiar
;; de ciudad.

(defrule cambiarCiudad
	"Aconseja al candidato probar a encontrar empleo en otra ciudad"
	(estado_actual "reglas_1")
	(reelabora-curriculum? usuario)
	(not (con-familia "si"))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (cambia-ciudad "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Considere la posibilidad de cambiar de ciudad
        
        " crlf)
    (close ?fichero)
)

;; Si es un primer empleo, es recomendable que las pretensiones econ�micas no sean elevadas (menores a 1200 euros), excepto si
;; el candidato sabe otro idioma extranjero (franc�s).

(defrule rebajarSalario
	"Aconseja al candidato a reducir sus pretensiones econ�micas"
	(estado_actual "reglas_1")
	(pretensiones-salariales ?salario)
	(test (> ?salario 1200))
	(tiempo_experiencia ?experiencia)
	(test (< ?experiencia 2))
	(not (idioma2 "si"))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (rebaja-salario "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Seria recomendable que rebajara sus pretensiones salariales
        
        " crlf)
    (close ?fichero)
)

;; Si el candidato tiene familia, es m�s recomendable que haga cursos para renovar sus conocimientos, especialmente si no dispone de
;; estudios universitarios

(defrule hacerCursos
	"El usuario debe hacer algunos cursos relacionados con sus intereses para renovarse"
	(estado_actual "reglas_1")
	(not (tipo_estudios "universitarios"))
	(con-familia "si")
	(reelabora-curriculum "si")
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (hacer-cursos "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Es recomendable que haga un curso relacionado con sus intereses
        
        " crlf)
    (close ?fichero)
)

;; Si se le ha recomendado hacer cursos, y no tiene idiomas, ser�a interesante que hiciera un curso de idiomas primero.

(defrule hacerCursosIdiomas
	"El usuario deber�a aprender idiomas para volver a ser competitivo en el mundo laboral"
	(estado_actual "reglas_1")
	(hacer-cursos "si")
	(not (idioma1 "si"))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (hacer-curso-ingles "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Es recomendable que haga un curso de idiomas
        
        " crlf)
    (close ?fichero)
)


;; Si se el usuario tiene estudios universitarios y ya tiene idiomas entre ellos el ingles ponerse en contacto con su universidad para buscar
;; trabajo a partir de ella


(defrule ponerseContactoUniversidad
	"El usuario deberia ponerse en contacto con su universidad para buscar trabajo a partir de ella"
	(estado_actual "reglas_1")
	(tipo_estudios "universitarios")
	(idioma1 "si")
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=> 
	(assert (ponerseContactoUniversidad "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Pongase en contacto con su universidad para tratar de buscar trabajo a partir de ella
        
        " crlf)
    (close ?fichero)
)

;;Si el usuario tiene tiene capacidad de aprender y sus aspiraciones son la informatica y el ultimo curso hace mas de 6 meses hacerse cursos de 
;;informatica para ampliar sus conocimiento y estar al dia

(defrule hacer-curso-informatica
	"El usuario deberia hacer un curso de informatica ya sus aspiraciones son de trabajar de informatico, tiene capacidad de aprender y el ultimo curso 		hecho es de informatica"
	(estado_actual "reglas_1")
	(intereses "informatica")
	(cap-aprender "si")
	(meses-desde-ultimo-curso ?meses)
	(test (> ?meses 6))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=> 	
	(assert (hacer-curso-informatica "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Hagase un curso de informatica para actualizar sus conocimientos en la materia
        
        " crlf)
    (close ?fichero)
)

;; Si se el usuario tiene estudios de modulo y ya tiene idiomas entre ellos el ingles ponerse en contacto con su universidad para buscar
;; trabajo a partir de ella

(defrule ponerseContactoInstituto
	"El usuario deberia ponerse en contacto con su instituto para buscar trabajo a partir de ella"
	(estado_actual "reglas_1")
	(tipo_estudios "modulo")
	(idioma1 "si")
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=> 
	(assert (ponerseContactoInstituo "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Pongase en contacto con su instituto para tratar de buscar trabajo a partir de ella
        
        " crlf)
    (close ?fichero)
)

;; Si el usuario tiene carnet de conducir, tiene coche y no tiene familia que incluya en su curriculum la posibilidad de trasladarse

(defrule posibilidadTrasladarse
	"El usuario deberia incluir en su curriculum la posibilidad de trasladarse si tiene carnet de conducir, tiene coche y no tiene familia"
	(estado_actual "reglas_1")
	(carnet-conducir "si")
	(tiene-coche "si")
	(not(con-familia "si"))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (posibilidad-trasladarse "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Introduce en tu curriculum la posibilidad de trasladarte para mejorar tus posibilidades
        
        " crlf)
    (close ?fichero)
)



;;Si el usuario no ha tenido trabajo y ha hecho alguna entrevista y ha sido rechazado en la ultima entrevista que haga algun curso para mejorar 
;; la forma de hacer las entrevistas

(defrule curso-mejorar-entrevista
	"El usuario deberia hacer un curso para mejorar la forma de hacer sus entrevistas si ha no ha tenenido trabajo todavia y ha hecho entrevistas en las 		que has sido rechazado"
	(estado_actual "reglas_1")
	(not(ultimo-trabajo ?trabajo))
	(ultima-entrevista "rechazado")
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)

	=>
	(assert (curso-mejorar-entrevista "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Hazte un curso para aprender ha hacer entrevistas para que cuando tengas que hacer una estes preparado
        
        " crlf)
    (close ?fichero)
)

;; Si el usuario ha trabajado y el total de tiempo que ha trabajado es mayor a 12 meses que pida el paro

(defrule pedir-subvencion-paro
	"El usuario puede solicitar el paro si cumple la condicion de haber trabajado mas de 12 meses"
	(estado_actual "reglas_1")
    (ultimo-trabajo ?trabajo)
	(tiempo-trabajando ?meses)
	(test (> ?meses 12))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (pedir-subvencion-paro "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Para conseguir algo de dinero mientras buscas trabajo puedes pedir la subvencion que da el inem por desempleo
        " crlf)
    (close ?fichero)
)

;; Si el usuario no se ha apuntado a los principales lugares de busqueda de trabajoo que se apunte al inem, ett, paginas de busqueda de trabajo por internet

(defrule apuntarse-busqueda-trabajo
	"Si el usuario no se ha apuntado en las principales sitios para buscar trabajo que se apunte"
    (estado_actual "reglas_1")
	(tiene-curriculum "si")
	(not(apuntado-inem "si"))
	(not(apuntado-ett "si"))
	(not(apuntado-paginas-trabajo "si"))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (apuntado-inem "si"))
	(assert (apuntado-ett "si"))
	(assert (apuntado-paginas-trabajo "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Para mejorar tus posibilidades de buscar trabajo apuntate a las principales fuentes de ofertas de empleo
        
        " crlf)
    (close ?fichero)
)


;;Si el usuario busca un trabajo no altamente especializado, que repase sus conocimientos generales sobre la actualidad. Se est� poniendo de moda que muchas entrevistas de trabajo deriven hacia conversaciones sobre �ltimas noticias, libros o pel�culas de moda que el usuario conozca,etc...

(defrule cultura-general
	"Si el trabajo no es altamente especializado y el usuario es muy joven, repasar sus conocimientos de cultura general y actualidad"
	(estado_actual "reglas_1")
	(trabajo-no-especializado "no")
	(edad ?usuario ?edad)
	(test (< ?edad 21))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (cultura-general-preparada "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Preparese para una posible entrevista sobre temas de cultura general y de actualidad
        
        " crlf)
    (close ?fichero)
)

;;Si el usuario ha fracasado varias ocasiones y ya ha hecho alg�n curso para mejorar las t�cticas a la hora de realizar una entrevista, puede intentar informarse previamente de qu� perfiles buscan y a qu� se dedican exactamente las pr�ximas empresas con las que contacte, para as� dar una mejor impresi�n

(defrule estudiar-empresas-objetivo
	"EL usuario puede estudiar previamente los perfiles de las empresas, para dar mejor impresi�n en las entrevistas"
	(estado_actual "reglas_1")	
    (tiene-curriculum "si")
	(ultima-entrevista "rechazado")
	(curso-mejorar-entrevista "si")
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (estudiada-empresa-objetivo "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        El usuario puede estudiar previamente el perfil de los empleados y a que se dedica la empresa, para causar mejor impresion en la entrevista
        
        " crlf)
    (close ?fichero)
)

;;Si el usuario tiene experiencia laboral y ha reelaborado su curr�culum ,puede solicitar cartas de recomendaci�n de sus anteriores empleadores

(defrule solicitar-recomendacion
	"El usuario puede solicitar recomendaciones de sus anteriores trabajos"
    (estado_actual "reglas_1")
	(tiempo_experiencia ?experiencia)
	(reelabora-curriculum "si")
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (pedir-recomendacion "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Para aumentar la buena imagen frente a un nuevo empleo, solicita una recomendacion
        
        " crlf)
    (close ?fichero)
) 

;;Si el usuario ha elaborado un curr�culum, es muy �til que lo acompa�e con una carta de presentaci�n

(defrule carta-presentacion
	"Es muy �til acompa�ar el curr�culum con una carta de presentaci�n"
	(estado_actual "reglas_1")
	(tiene-curriculum "si")
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (adjuntar-carta-presentacion "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Es muy util adjuntar al curriculum, una carta de presentacion
        
        " crlf)
    (close ?fichero)
)

;;Si el usuario tiene experiencia en viajes, ha vivido en el extranjero m�s de un a�o, etc... es muy �til que amplie el curr�culum incluyendo estos puntos

(defrule ampliar-curriculum
	"Incluir experiencias personales �ptimas para el trabajo buscado"
    (estado_actual "reglas_1")
	(tiene-curriculum "si")
	(experiencia-extranjero ?experiencia)
	(test (> ?experiencia 1))
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (ampliar-curriculum-usuario "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Si se tiene experiencia en el extranjero superior a un anio, es muy util incluirla en el curriculum
        
        " crlf)
    (close ?fichero)
)


;;Si el usuario ha estudiado una empresa objetivo, es �til que estudie adem�s la demanda actual del mercado laboral en ese sector
(defrule estudiar-mercado-laboral
	"Estudiar las demandas del mercado laboral"
    (estado_actual "reglas_1")
	(estudiada-empresa-objetivo "si")
	(curso-mejorar-entrevista "si")
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (estudiar-mercado-laboral-usuario "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Ademas de estudiar a una empresa objetivo, es util estar informado de la situacion actual del mercado laboral en ese sector
        
        " crlf)
    (close ?fichero)
)

;;Si el usuario tiene capacidad de aprender, es muy �til que realice alg�n curso de postgrado

(defrule curso-postgrado
	"Realizar alg�n m�ster, etc..."
    (estado_actual "reglas_1")
	(cap-aprender "si")
	(hacer-cursos "si")
    (ruta_fichero_salida ?ruta)(fichero_salida ?fichero)
	=>
	(assert (curso-postgrado-usuario "si"))
    ;agregamos los resultados al fichero deseado (abrimos fichero, a�adimos y lo cerramos)
    (open ?ruta ?fichero "a")
    (printout ?fichero " 
        Si el usuario tiene capacidad de aprender, deberia seguir realizando alg�n curso de postgrado
        
        " crlf)
    (close ?fichero)
)


