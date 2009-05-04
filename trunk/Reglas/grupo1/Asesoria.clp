/* -------------- <Definici�n de Plantillas para los Hechos> --------------- */
(deftemplate persona 
    (slot nombre)
    (slot apellidos)
    (slot dni) 
    (slot edad)
    (slot email) 
    (slot residencia)
    (slot nacionalidad)
    (slot categoriaEstudios) 
    (slot estudios) 
    (slot idiomas) 
    (slot situacionLaboral) 
    (slot tipoJornada) 
    (slot experiencia) 
    (slot tiempoParado) 
    (slot coche)
    (slot carnetConducir)
)

(deftemplate fortaleza
	(slot contenido)
)

(deftemplate debilidad
	(slot contenido)
)

(deftemplate recomendacion
    (slot id)
)

(deftemplate lenguajes
    (slot tipo)
)

(deftemplate conductor
    (slot tipo)
)

/* -------------------- <Reglas de Encadenamientos> ------------------------ */
/* Idiomas */
(defrule reglaLenguajes
	(persona (idiomas ?x|:(eq "Aleman" ?x)
						|:(eq "Ingles" ?x)
            			|:(eq "Frances" ?x)
            			|:(eq "Portugues" ?x)
            			|:(eq "Frances" ?x)
            			|:(eq "Italiano" ?x)))
	=>
    (assert (lenguajes (tipo "Poliglota"))  )
)

/* Conducci�n */
(defrule reglaConducion
   (persona (coche "Si"))
   (persona (carnetConducir "Si")) 
    =>
    (assert (conductor (tipo "Si")) )
)

/* Mucha Experiencia Laboral */
/* Una persona tiene como fortaleza en el mundo laboral la experiencia si
 * seg�n la cantidad de a�os que haya trabajado dependiendo del tipo de 
 * contrato que haya mantenido */
(defrule reglaMuchaExperiencia
   (persona (experiencia ?x&:(> ?x 4)))
   (persona (situacionLaboral ?y|:(eq "becario" ?y)|:(eq "desempleado" ?y)))
    =>
    (assert (fortaleza (contenido "muchaExperiencia")) )
)

(defrule reglaMuchaExperiencia2
	(persona (experiencia ?x&:(> ?x 2)))
	(persona (situacionLaboral "contrato indefinido"))
	=>
	(assert (fortaleza (contenido "muchaExperiencia")) )
)

(defrule reglaMuchaExperiencia3
	(persona (experiencia ?x&:(> ?x 3)))
	(persona (situacionLaboral "contrato temporal"))
	=>
	(assert (fortaleza (contenido "muchaExperiencia")) )
)

/* Poca Experiencia Laboral */
/* Como contraposici�n a mucha experiencia laboral, se crea el hecho debilidad
 * pocaExperiencia */
(defrule reglaPocaExperiencia1
    (persona (experiencia ?x&:(< ?x 5)))
    (persona (situacionLaboral ?y|:(eq "becario" ?y)|:(eq "desempleado" ?y)))
    =>
    (assert (debilidad (contenido "pocaExperiencia")) )
)

(defrule reglaPocaExperiencia2
    (persona (experiencia ?x&:(< ?x 2)))
    (persona (situacionLaboral "contrato indefinido"))
    =>
    (assert (debilidad (contenido "pocaExperiencia")) )
)

(defrule reglaPocaExperiencia3
    (persona (experiencia ?x&:(< ?x 2)))
    (persona (situacionLaboral "contrato temporal"))
    =>
    (assert (debilidad (contenido "pocaExperiencia")) )
)

/* Mucha Preparacion */
/* Si una persona posee un t�tulo y conoce idiomas se a�ade a la MT la
 * fortaleza "muchaPreparacion" */
(defrule reglaMuchaPreparacion1
	(persona (categoriaEstudios ?x|:(eq "doctor" ?x)|:(eq "licenciado" ?x)))
    (persona (idiomas "Ninguno"))
	=>
	(assert (fortaleza (contenido "muchaPreparacion")) )
)

/* Pero si es diplomado y tiene idiomas, se le considera con preparaci�n */
(defrule reglaMuchaPreparacion2
	(persona (categoriaEstudios "diplomado"))
    (lenguajes (tipo "Poliglota"))
	=>
	(assert (fortaleza (contenido "muchaPreparacion")) )
)

/* Poca Preparacion */
/* Si una persona es estudiante y no conoce idiomas se a�ade a la MT la
 * debilidad "pocaPreparacion" */
(defrule reglaPocaPreparacion1
	(persona (categoriaEstudios "estudiante"))
	(persona (idiomas "Ninguno"))
	=>
	(assert (debilidad (contenido "pocaPreparacion")) )
)

/* Datos de Interes */
/* Si una persona sabe idiomas, es un dato de inter�s para algunas carreras */
(defrule reglaDatosInteres
	(lenguajes (tipo "Poliglota"))
	(persona (estudios ?x|:(eq "Ingenieria Informatica" ?x)
            			 |:(eq "Marketing" ?x)
            			 |:(eq "Administraci�n de empresas" ?x)) )
	=> (assert (fortaleza (contenido "datosInteres")) )
)

/* Experiencia en un �mbito determinado */
/* Si una persona tiene t�tulo de doctorado, tiene idiomas y mucha 
 * experiencia laboral */ 
(defrule reglaConcreto
	(persona (categoriaEstudios "doctor") )
    (lenguajes (tipo "Poliglota"))
    (fortaleza (contenido "muchaExperiencia"))
	=> (assert (fortaleza (contenido "expConcreta")) )
)

/* Estabilidad */
/* Si una persona ha conseguido terminar estudios en tiempos normales
 * entonces ha tenido estabilidad en su vida acad�mica */
(defrule reglaEstable1
	(persona (edad ?x&:(< ?x 23)))
	(persona (categoriaEstudios "diplomado"))
	=>
	(assert (fortaleza (contenido "estabilidad")))
)

(defrule reglaEstable2
	(persona (edad ?x&:(< ?x 26)))
	(persona (categoriaEstudios "licenciado"))
	=>
	(assert (fortaleza (contenido "estabilidad")))
)

(defrule reglaEstable3
	(persona (edad ?x&:(< ?x 29)))
	(persona (categoriaEstudios "doctor"))
	=>
	(assert (fortaleza (contenido "estabilidad")))
)

/* Evoluci�n Ascendente */
/* Si una persona ha conseguido el doctorado, y posee datos de inter�s en
 * su carrera, as� como escaso tiempo parado entonces  ha tenido una evoluci�n 
 * ascendente */
(defrule reglaEvolUp
	(fortaleza (contenido "datosInteres"))
	(persona (categoriaEstudios "doctor"))
    (persona (tiempoParado ?x|:(<= ?x 2))) ; corta duraci�n
	=>
	(assert (fortaleza (contenido "evolucionAscendente")))
)

/* -------------------- <Reglas de Recomendaciones> ------------------------ */

(defrule reglaRecBecaErasmus
    (persona (categoriaEstudios "estudiante"))
    (lenguajes (tipo "Poliglota")) 
    =>
    (assert (recomendacion (id 12)) )
) 
/* recomendacion.12= Solicita una beca Erasmus al pa�s cuyo idioma hables.
 * Manera de presentar curriculum: Resalta la realizaci�n de una beca en el
 * extranjero. */

(defrule reglaRecOfertasExtranjero
   (persona (categoriaEstudios "estudiante"))
   (lenguajes (tipo "Poliglota"))
   (debilidad (contenido "pocaExperiencia"))
    =>
    (assert (recomendacion (id 13)) )
) 
/* recomendacion.13= Inscr�bete a ofertas de pr�cticas en el extranjero. Manera
 * de presentar curriculum: Resalta la realizaci�n de practicas en el 
 * extranjero. */

(defrule reglaRecCursosIdiomas
   (persona (categoriaEstudios ?x|:(eq "estudiante" ?x)))
   (persona (idiomas "Ninguno"))
    =>
    (assert (recomendacion (id 14)) )
) 
/* recomendacion.14= Realiza cursos de idiomas. Manera de presentar curriculum:
 * Refleja en el curriculum los cursos de idiomas que realizes. */

(defrule reglaRecCursosMasters
   (persona (categoriaEstudios "estudiante"))
   (persona (tiempoParado ?x|:(> ?x 2))) ; larga duraci�n
    =>
    (assert (recomendacion (id 15)) )
)
/* recomendacion.15=Realiza cursos de certificaci�n, Masters. Manera de
 * presentar curriculum: Refleja en el curriculum las certificaciones y
 * masters que realizes.*/

(defrule reglaRecFueraCiudad
   (persona (tiempoParado ?x|:(> ?x 2))) ; larga duraci�n
   (conductor (tipo "Si"))
    =>
    (assert (recomendacion (id 16)) )
)
/* recomendacion.16=Condidera ofertas de empresas en las afueras de tu ciudad.
 * Manera de presentar curriculum: Pon que tienes coche y carnet de conducir.*/

(defrule reglaRecCursosDesempleados
   (persona (situacionLaboral "desempleado"))
   (persona (tiempoParado ?x|:(> ?x 2))) ; larga duraci�n
    =>
    (assert (recomendacion (id 17)) )
    (assert (debilidad (contenido "tiempoParado")) )
)
/* recomendacion.17=Realiza los cursos para desempleados que ofrece el INEM.*/

(defrule reglaRecINEM
   (persona (situacionLaboral "desempleado"))
   (persona (tiempoParado ?x|:(<= ?x 2))) ; corta duraci�n
    =>
    (assert (recomendacion (id 18)) )
)
/* recomendacion.18=Dirigete al INEM para apuntarte al paro.*/

(defrule reglaRecTerminaEstudios
   (persona (tiempoParado ?x|:(> ?x 2))) ; larga duraci�n
   (persona (idiomas "Ninguno"))
   (persona (categoriaEstudios ?x|:(eq "estudiante" ?x)))
    =>
    (assert (recomendacion (id 19)) )
)
/* recomendacion.19=Rebaja tus pretensiones econ�micas, y aprovecha para
 * terminar tus estudios.*/

(defrule reglaRecCurriculumFuncional
	(persona (tiempoParado ?x|:(> ?x 2))) 
	(fortaleza (contenido "expConcreta") )
	=>
	(assert (recomendacion (id 20)) )
)
/* recomendacion.20=Hacer un curriculum de tipo funcional resaltar� tus puntos
 * positivos y podr�s emitir eventuales errores como cambios de trabajo o
 * tiempos de parada. */


(defrule reglaRecCurriculumCronologico
	(fortaleza (contenido "estabilidad") )
	(fortaleza (contenido "evolucionAscendente") )
	=> 
	(assert (recomendacion (id 21)) )
)
/* recomendacion.21=Hacer un curriculum con elementos con orden cronol�gico,
 * para mostrar tu estabilidad y la evoluci�n ascendente de tu carrera. */


(defrule reglaRecCurriculumInverso
	(fortaleza (contenido "muchaPreparacion") )
	(lenguajes (tipo "Poliglota"))
	=>
	(assert (recomendacion (id 22)) )
)
/* recomendacion.22=Hacer un curriculum con cronolog�a inversa resaltar� las
 * experiencias m�s recientes. */


(defrule reglaRecFormacionAcademica
	(fortaleza (contenido "muchaPreparacion") )
	(debilidad (contenido "pocaExperiencia") )
	=>
	(assert (recomendacion (id 23)) )
)
/* recomendacion.23=Haz hincapi� en el apartado "Formaci�n Acad�mica" sobre
 * tus logros acad�micos. */

(defrule reglaRecExperienciaLaboral
	(debilidad (contenido "pocaPreparacion") )
	(fortaleza (contenido "muchaExperiencia") )
	=>
	(assert (recomendacion (id 24)) )
)
/* recomendacion.24=Haz hincapi� en el apartado "Experiencia Laboral" sobre
 * tus anteriores trabajos para eclipsar la falta de preparaci�n. */

(defrule reglaRecExperienciaPreparacion
	(fortaleza (contenido "muchaPreparacion") )
	(fortaleza (contenido "muchaExperiencia") )
	=>
	(assert (recomendacion (id 25)) )
)

