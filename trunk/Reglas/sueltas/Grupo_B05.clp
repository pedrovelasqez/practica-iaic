(deftemplate persona
    (slot nombre)
    (slot tiempodesocupado)
    (slot titulacion (allowed-values GradoMedio GradoSuperior))
    (slot notatitulacion)
    (slot master)
    (slot sector)
    (slot edad)
    (slot a�osexperiencia)
    (multislot cursos)
)
(deftemplate curso
    (slot persona)
    (slot sector)
    (slot duracion)
    )

(deftemplate tipo-cv
    (slot persona)
	(slot concreto (allowed-values 0 1))
    (slot ambito (allowed-values P�blico Privado ))
    (slot sector)
   )
(deftemplate tipo-organizacion
    (slot persona)
    (slot tipo (allowed-values funcional cronol�gico))
    )
(deftemplate tipo-extension
  	(slot persona)
    (slot tipo (allowed-values cl�sica americana))  
    )
(deftemplate incluir-cursos
    (slot persona)
    (slot opcion (allowed-values 0 1))
    
    )
(deftemplate incluir-calificaciones
    (slot persona)
    (slot opcion (allowed-values 0 1))
 )


/* Un cv funcional se configura por temas. Es adecuado cuando ha habido grandes periodos de inactividad, cambios de trabajo o de rumbo, o cuando
	el cv se crea espec�ficamente para optar un puesto de trabajo concreto*/ 
(defrule organizacion-cv-funcional 
    (or (persona (nombre ?n)(tiempodesocupado ?t&:(> ?t 24)))
     	(tipo-cv (persona ?n)(concreto 1))	   
    )    
    =>
    (assert (tipo-organizacion (persona ?n)(tipo funcional)))
 )
/* Un cv cronol�gico se configura de manera cronol�gica, primero las actividades/formaci�n m�s reciente. Es adecuado en condiciones normales*/
(defrule organizacion-cv-cronologico 
    (persona (nombre ?n)(tiempodesocupado ?t&:(<= ?t 24)))
     =>
    (assert (tipo-organizacion (persona ?n)(tipo cronol�gico)))
 )
/* Un cv cl�sico tiene una extensi�n de varias p�ginas y un nivel alto de detalle. Es adecuado cuando se quiere optar a una plaza en la 
Administraci�n P�blica o se tiene un largo historial que se quiere subrayar*/
(defrule extension-cv-clasica
    (persona (nombre ?n))
    (or (tipo-cv (persona ?n)(ambito P�blico))
     	(and 
            (persona (nombre ?n)(a�osexperiencia ?e&:(>= ?e 10)))
            (tipo-cv (persona ?n)(ambito Privado))
            )   
     )
    =>
    (assert (tipo-extension (persona ?n)(tipo cl�sica)))
 )
/*Un cv americano tiene una extensi�n de una o dos p�ginas y una estructura de titulares que busca llamar la atenci�n de un vistazo, sin atender
a los detalles. Es adecuado cuando se opta a un puesto en la empresa privada y no se cuenta con una larga trayectoria*/
(defrule extension-cv-americana
    (persona (nombre ?n))
    (tipo-cv (persona ?n)(ambito Privado))
    (persona (nombre ?n)(a�osexperiencia ?e&:(< ?e 10)))
    =>
    (assert (tipo-extension (persona ?n)(tipo americana)))
)
/* La nota final de la titulaci�n s�lo debe ponerse si es inusualmente alta o se trata de un cv cl�sico, con alto nivel de detalle*/
(defrule incluir-notastitulacion
    (or (persona (nombre ?n)(notatitulacion ?nt&:(>= ?nt 8)))
        (tipo-extension (persona ?n)(tipo clasica))
        )
    =>
    (assert (incluir-calificaciones (persona ?n)(opcion 1)))
 )
/* La formaci�n no reglada se incluye cuando est� relacionada con el trabajo al que se opta o cuando se trata de un cv cl�sico, donde 
los cursos pueden dar m�s puntos, como en el caso de las Administraciones P�blicas*/
(defrule incluir-otraformacion
    (or (and
           (persona (nombre ?n)(cursos ?c))
    	   (curso (persona ?n)(sector ?s))
    	   (tipo-cv (persona ?n)(sector ?s))
         )
        (tipo-extension (persona ?n)(tipo clasica))
        )   
    =>
    (assert (incluir-cursos (persona ?n)(opcion 1)))
 )

(deftemplate entrevista
    (slot persona)
    (slot oferta)	
    (slot tipocita (allowed-values Telef�nica Escrito))
    (slot tipoentrevista (allowed-values Selecci�n Grupo Telef�nica))
    (slot tipoentrevistador (allowed-values EmpresaSelecci�n RRHH T�cnico))
    )

(deftemplate oferta
    (slot empresa)
    (slot sector)
    (slot puesto (allowed-values Directivo Administrativo T�cnico Gerente Creativo P�blico))
    (slot titulacionrequerida)
    (multislot formacionadicional)
    (slot experienciarequerida)
)
(deftemplate punto-fuerte
    (slot persona)
    (slot oferta)
    (slot punto(allowed-values Sector Titulaci�n FormacionAdicional Edad Experiencia))
)
(deftemplate punto-debil
    (slot persona)
    (slot oferta)
    (slot punto(allowed-values Sector Titulaci�n FormacionAdicional Edad Experiencia))
)

/* A la hora de realizar una entrevista es importante saber qu� puntos fuertes se tienen para el puesto solicitado.*/

/*Una titulaci�n o experiencia en el sector de la empresa a la que se quiere entrar es un punto fuerte a destacar en la entrevista*/
(defrule punto-fuerte-sector
    (and (oferta (sector ?s))
             (persona (nombre ?p)(sector ?s))
    )
    =>
    (assert (punto-fuerte (persona ?p)(oferta ?f)(punto Sector)))
)
/*Contar con una titulaci�n adecuada es un punto fuerte*/
(defrule punto-fuerte-titulacion
     (and ?o <-(oferta (titulacionrequerida ?t))
             (persona (nombre ?p)(titulacion ?t))	
            )
    =>
    (assert (punto_fuerte (persona ?p)(oferta ?o)(punto Titulaci�n)))
)
/* En ocasiones la formaci�n no reglada puede ser un punto fuerte, si es �til para el trabajo a desempe�ar*/
(defrule punto-fuerte-formacionadicional    
   (and ?o <- (oferta (formacionadicional ?f))
        (persona (nombre ?p)(cursos ?f))
    ) 
        =>
		(assert (punto-fuerte (persona ?p)(oferta ?o)(punto FormacionAdicional )))
)
/* La experiencia adquirida es un punto fuerte*/
(defrule punto-fuerte-experiencia
    (persona (nombre ?p)  (a�osexperiencia ?x))
    (oferta (empresa ?e) (experienciarequerida ?x2))
    (>= ?x ?x2)
    =>
    (assert (punto-fuerte (persona ?p)(oferta ?f)(punto Experiencia)))
)
/* Cuando no se cuenta con algun requisito para el puesto de trabajo, tenemos un punto d�bil del que hay que ser consciente para intentar mitigar durante la entrevista*/

/*No contar con experiencia o una formaci�n adecuada para el sector al que optamos es un punto d�bil*/
(defrule punto-debil-sector
    (not (punto-fuerte (persona ?p)(oferta ?f)(punto Sector)))
        =>
        (assert (punto-debil (persona ?p)(oferta ?f)(punto Sector)))
    
)
/*No contar con la titulaci�n requerida para el puesto es un punto d�bil*/
(defrule punto-debil-titulacion
    (not (punto-fuerte (persona ?p)(oferta ?f)(punto Titulaci�n)))
        =>
        (assert (punto-debil (persona ?p)(oferta ?f)(punto Titulaci�n)))
)
/*No contar con formaci�n adicional requerida, es un punto d�bil*/
(defrule punto-debil-formacionadicional
    (not (punto-fuerte (persona ?p)(oferta ?f)(punto FormacionAdicional)))
        =>
        (assert (punto-debil (persona ?p)(oferta ?f)(punto FormacionAdicional)))
    
)
/*No contar con suficiente experiencia para el puesto es un punto d�bil*/
(defrule punto-debil-experiencia
    (persona (nombre ?p)  (a�osexperiencia ?x))
    (oferta (empresa ?e) (experienciarequerida ?x2))
    (< ?x ?x2)
    =>
    (assert (punto-debil (persona ?p)(oferta ?f)(punto Experiencia)))
)

/* Si la entrevista que vamos a realizar es de Selecci�n, nos da un consejo apropiado*/
(defrule entrevista-seleccion
    (persona (nombre ?n))
    (entrevista (persona ?n)(tipoentrevista Selecci�n))
    =>
    (printout "Consejo- Entrevista de selecci�n " ?n " Prepare una entrevista prestando atenci�n a la parte referente a su personalidad, motivaciones, competencias generales y aptitud" crlf)
    
)
/* Si la entrevista va a ser una din�mica de grupo, aconseja c�mo enfrentarse a ella*/
(defrule entrevista-grupo
	(persona (nombre ?n))
    (entrevista (persona ?n)(tipoentrevista Grupo))
    =>
    (printout "Consejo- Entrevista en grupo/din�mica de grupo " ?n "Participe en la din�mica, pero sin monopolizar la atenci�n" crlf "Escuche las opiniones y respuestas de los dem�s, pero no las critique" crlf "Analice a los entrevistadores y a los dem�s candidatos" crlf)    
)
/* Si vamos a hacer una entrevista telef�nica, nos aconseja qu� hacer*/
(defrule entrevista-telefono
    (persona (nombre ?n))
    (entrevista (persona ?n)(tipoentrevista Telef�nica))
    =>
    (printout "Consejo- Entrevista telef�nica" ?n "Intente evitar este tipo de entrevista en la medida de lo posible.Si no puede conseguir una entrevista personal, intente dar s�lo la informaci�n necesaria durante la entrevista telef�nica, para conseguir una entrevista cara a cara" crlf)
    )
/*Si vamos a tener una entrevista con un miembro de una empresa de selecci�n de personal, nos aconseja c�mo prepararla*/
(defrule entrevistador-empresaseleccion
     (persona (nombre ?n))
    (entrevista (persona ?n)(tipoentrevistador EmpresaSelecci�n))
    =>
    (printout "Consejo- Entrevista realizada por empresa de selecci�n " ?n " Prepare una entrevista prestando atenci�n a la parte referente a su personalidad, motivaciones, competencias generales y aptitud" crlf)
    
 )
/*Si vamos a tener una entrevista con una persona de RRHH de la propia empresa, nos aconseja c�mo prepararla*/
(defrule entrevistador-rrhh
    (persona (nombre ?n))
    (entrevista (persona ?n)(tipoentrevistador RRHH))
    =>
    (printout "Consejo- Entrevista realizada por RRHH" ?n "Prepare su CV para responder preguntas sobre el mismo, preste atenci�n a la parte de personalidad, motivaci�n y no descuide nada en general" crlf)
    )
/*Si vamos a hacer una entrevista t�cnica, nos aconseja c�mo prepararla*/
(defrule entrevistador-tecnico
    (persona (nombre ?n))
    (entrevista (persona ?n)(tipoentrevistador T�cnico))
    =>
    (printout "Consejo- Entrevista t�cnica" ?n "Preparese para responder preguntas acerca de su cualificaci�n t�cnica enfocando hacia el trabajo a realizar" crlf "Incida en su capacidad para desempe�ar el trabajo que se ofrece y en su motivaci�n para incorporarse al departamento espec�fico" crlf) 
    )


(assert (persona (nombre Juan)(edad 29)(titulacion GradoMedio)(a�osexperiencia 2)(cursos Maya)(sector software)))
(assert (entrevista (persona Juan)(oferta Dacartec)(tipocita Telef�nica)(tipoentrevista Telef�nica)(tipoentrevistador T�cnico)))
(assert (oferta (empresa Dacartec)(sector software)(puesto T�cnico)(experienciarequerida 1)(titulacionrequerida GradoSuperior)))
	

