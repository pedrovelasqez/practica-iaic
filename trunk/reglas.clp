; Plantilla con los datos que utilizaremos para nuestras reglas
; aquellos que tienen un valor default, no son necesario asignarles
; valores, todos aquellos slots que no tienen default, obligatoriamente
; hay que asignarle uno de los valores posibles para el slot
(deftemplate datos
    (slot estado_actual)
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
    (slot ruta_fichero_salida (default "log_grupoB09.txt"))        
    (slot fichero_salida (default "ficheroGuardar"))    
)



;------------------------------------------------------------------------------
; �Donde buscar informacion?
;
;	DATOS ENTRADA:
;		- estado_actual = busqueda
;		- tipo_estudios = ["universitarios", "no_universitarios"]
;		- conocimiento = ["investigacion", "basico"]
;		- tipo_contrato = ["beca", "jornada"]
;		- desea_informacion = ["si", "no"]
;		- lee_prensa = ["si", "no"]
;------------------------------------------------------------------------------

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



;------------------------------------------------------------------------------
; �Que tipo de contrato me interesa?
;
;	DATOS ENTRADA:
;		- estado_actual = "contrato"
;		- estudia = ["si", "no"]
;		- conocimiento = ["investigacion", "basico"]
;		- tiempo_libre = <numero entero positivo>;
;------------------------------------------------------------------------------

(defrule tipo_contrato1 "Comprobamos si le interesa una beca"
    ; SI (estado_actual=contrato & estudia=si & tipo_contrato<>beca)
    ;	ENTONCES tipo_contrato=beca
	?dat <- (datos (estado_actual "contrato") (estudia "si")(tipo_contrato ~"beca"))
	=> 

    ;cumple los requisitos para ser apto para la beca (tipo_contrato=beca)
    (modify ?dat (tipo_contrato "beca"))
)

(defrule tipo_contrato2 "Comprobamos si le interesa un trabajo normal a jornada"
    ; SI (estado_actual=contrato & estudia=no & tipo_contrato<>jornada)
    ;	ENTONCES tipo_contrato=jornada
	?dat <- (datos (estado_actual "contrato") (estudia "no")(tipo_contrato ~"jornada"))
	=> 

    ;cumple los requisitos para ser apto para la beca (tipo_contrato=jornada)
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



;------------------------------------------------------------------------------
; �Que debo destacar de mi curriculum?
;
;	DATOS ENTRADA:
;		- estado_actual = "curriculum"
;		- tipo_estudios = ["universitarios", "no_universitarios"]
;		- experiencia = ["si", "no"]
;		- numero_paginas_CV = <numero entero positivo>
;------------------------------------------------------------------------------

(defrule destacar_curriculum1 "Comprobamos si debe destacar la formacion"
    ; SI (estado_actual=curriculum & tipo_estudios=universitarios & destacar_formacion=no)
    ;	ENTONCES destacar_formacion=si
	?dat <- (datos (estado_actual "curriculum") (tipo_estudios "universitarios")(destacar_formacion "no"))
	=> 
    
    ;cumple los requisitos para ser apto para la beca (destacar_formacion=si)
    (modify ?dat (destacar_formacion "si"))
)

(defrule destacar_curriculum2 "Comprobamos si debe destacar la experiencia"
    ; SI (estado_actual=curriculum & experiencia=si & destacar_experiencia=no)
    ;	ENTONCES destacar_experiencia=si
	?dat <- (datos (estado_actual "curriculum") (experiencia "si")(destacar_experiencia "no"))
	=> 
    
    ;cumple los requisitos para ser apto para la beca (destacar_experiencia=si)
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