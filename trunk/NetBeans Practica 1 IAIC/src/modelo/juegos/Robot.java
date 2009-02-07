package modelo.juegos;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import aima.search.framework.GoalTest;
import aima.search.framework.HeuristicFunction;
import aima.search.framework.Problem;
import aima.search.framework.Successor;
import aima.search.framework.SuccessorFunction;
import modelo.matrices.GeneraMatrices;


	/** Sea un micro-mundo formado por 3 habitaciones y un robot aspirador. 
	 * Hay una habitacion a la izquierda, otra en el centro y otra a la derecha,
	 * cuyas alfombras pueden estar sucias o limpias. El robot puede estar en 
	 * cualquiera de las habitaciones y puede ejecutar dos tipos de operaciones:
	 * aspirar o moverse.
	 * La operacion de aspirar requiere que la habitacion en la que se encuentra
	 * el robot esta sucia y su resultado es que dicha habitacion pasa a estar limpia.
	 * La operacion mover tiene dos opciones: mover hacia la izquierda, que requiere que haya
	 *  alguna habitacion a la izquierda de aquella en la que se encuentra el robot, y mover
	 *  hacia la derecha que requiere la existencia de alguna habitacion situada a la derecha.
	 *  En cualquier caso, los movimientos seran elementales, es decir, solo permitiran el paso
	 *  a la habitacion contigua a la actual.
     *      
     * @author Mercedes Bernal Perez 71031656C
	 */

public class Robot  extends InterfazJuego{
	/**
	 * Indica la posici�n del robot-aspiradora:
	 * 0. Esta en la habitacion de la izquierda.
	 * 1. Esta en la habitacion del centro.
	 * 2. Esta en la habitacion de la derecha.
	 */
	int _posRobot;
	
	/**
	 * Indica si la alfomrbra de la habitacion de la izquierda esta limpia.
	 */
	boolean _limpiaHabIzq;
	
	/**
	 * Indica si la alfomrbra de la habitaci�n del centro esta limpia.
	 */
	boolean _limpiaHabCen;
	
	/**
	 * Indica si la alfomrbra de la habitaci�n de la derecha esta limpia.
	 */
	boolean _limpiaHabDer;
    
    private int _dificultad=6;

    
	public Robot() {
        _enunciadoProblema="En un minimundo hay 3 habitaciones que pueden estar sucias, para ello hay un robot que las va a limpiar.";
	    _nodosExpandidos=0;
		_resuelto=false;
		Random generador = new Random();
        generador.setSeed(GeneraMatrices.dameInstancia().dameSemilla());
		_posRobot = generador.nextInt(3);

		if ((generador.nextInt(2))==0){
			_limpiaHabIzq = false;
		}else{
			_limpiaHabIzq = true;
		}
		
		if ((generador.nextInt(2))==0){
			_limpiaHabCen = false;
		}else{
			_limpiaHabCen = true;
		}
		
		if ((generador.nextInt(2))==0){
			_limpiaHabDer = false;
		}else{
			_limpiaHabDer = true;
		}
	}

	public Robot(int robot, boolean habIzq, boolean habCen, boolean habDer) {
		super();
		_posRobot = robot;
		_limpiaHabIzq = habIzq;
		_limpiaHabCen = habCen;
		_limpiaHabDer = habDer;
	}

	public Problem getProblema() {
		Problem problem = new Problem(new Robot(), new Sucesores(), new EsFinal(),new ValorReal(), new ValorHeuristico());
		return problem;		
	}

	public boolean valido(){
		boolean aux=true;
		if(_nodosExpandidos>5000){
			aux=false;
		}
		return aux;
	}
	
	public int dificultad(){
		return _dificultad;
	}
	
	//------------------------------------------------- CLASES FUNCIONES

    //GENERACION DE SUCESORES

	@SuppressWarnings({"unchecked"})
	public class Sucesores implements SuccessorFunction{
		public List<Successor> getSuccessors(Object state) {
			Robot robot=(Robot)state;
			List sucesores=new ArrayList();
			String movimiento="";
			int coste=0;
			boolean generado=false;
			_nodosExpandidos++;
			int newrobot = 0;
			boolean newlimpiaHabIzq = false, newlimpiaHabCen = false, newlimpiaHabDer = false;
		 	
		 	for (int operador = 0; operador <3; operador++){
		 		newrobot = robot._posRobot;
		 		newlimpiaHabIzq = robot._limpiaHabIzq;
		 		newlimpiaHabCen = robot._limpiaHabCen;
		 		newlimpiaHabDer = robot._limpiaHabDer;
		 		generado = false;
		 		
		 		switch(operador){
		 		case 0:	// Aspirar habitaci�n.
		 			// Comprobamos como est� la alfombra de la habitaci�n en la que est� el aspirador.
		 			boolean limpiaHab = false;
		 			switch (robot._posRobot){
		 				case 0: 
		 					limpiaHab = robot._limpiaHabIzq;
		 					break;
		 				case 1:
		 					limpiaHab = robot._limpiaHabCen;
		 					break;
		 				case 2:
		 					limpiaHab = robot._limpiaHabDer;
		 					break;
		 			}
		 			
		 			// Si no est� limpia, aplicamos operador.
		 			if (!limpiaHab){
		 				generado = true;
		 				coste = 1;
		 				movimiento = "aspirar";
		 				// Limpiamos la habitaci�n.
			 			switch (robot._posRobot){
			 				case 0: 
			 					newlimpiaHabIzq = true;
			 					newlimpiaHabCen = robot._limpiaHabCen;
			 					newlimpiaHabDer = robot._limpiaHabDer;
			 					break;
			 				case 1:
			 					newlimpiaHabCen = true;
			 					newlimpiaHabIzq = robot._limpiaHabIzq;
			 					newlimpiaHabDer = robot._limpiaHabDer;
			 					break;
			 				case 2:
			 					newlimpiaHabDer = true;
			 					newlimpiaHabCen = robot._limpiaHabCen;
			 					newlimpiaHabIzq = robot._limpiaHabIzq;
			 					break;
			 			}
			 			newrobot = robot._posRobot;
		 			}
		 			break;
		 		case 1:	// Mover robot a la habitaci�n de la izquierda.
		 			// Si el robot no est� en la habitaci�n de la izquierda.
		 			if (robot._posRobot!=0){
		 				// Aplicamos operador.
		 				generado = true;
		 				coste = 1;
		 				movimiento = "moverIzquierda";
		 				// Movemos al robot.
		 				newrobot = robot._posRobot-1;
		 				// El resto se queda igual.
	 					newlimpiaHabCen = robot._limpiaHabCen;
	 					newlimpiaHabDer = robot._limpiaHabDer;
	 					newlimpiaHabIzq = robot._limpiaHabIzq;
		 			}
		 			break;
		 		case 2:	// Mover robot a la habitaci�n de la derecha.
		 			// Si el robot no est� en la habitaci�n de la derecha.
		 			if (robot._posRobot!=2){
		 				// Aplicamos operador.
		 				generado = true;
		 				coste = 1;
		 				movimiento = "moverDerecha";
		 				// Movemos al robot.
		 				newrobot = robot._posRobot + 1;
		 				// El resto se queda igual.
	 					newlimpiaHabCen = robot._limpiaHabCen;
	 					newlimpiaHabDer = robot._limpiaHabDer;
	 					newlimpiaHabIzq = robot._limpiaHabIzq;
		 			}
		 			break;
		 		}
		 		
		 		Robot nuevoEstado = new Robot(newrobot,newlimpiaHabIzq,newlimpiaHabCen,newlimpiaHabDer);
		 		if (generado && nuevoEstado.valido()){	 		
		 			String datos=movimiento+" ,COSTE:"+coste;
					sucesores.add(new Successor(datos, nuevoEstado));
		 		}
	 	 	}		 	
			return sucesores;
		}
	}

    // COMPROBACION DEL ESTADO FINAL

    //Todas las habitacion estan limpias
	public class EsFinal implements GoalTest{
		public boolean isGoalState(Object state) {
			Robot robot=(Robot)state;
			if(robot._limpiaHabIzq && robot._limpiaHabCen && robot._limpiaHabDer){
				_resuelto=true;
			}
			return _resuelto;
		}
	}

    //VALOR HEURISTICO

	// Heuristica: Mejor cuanto menor sea heuristica, es decir, cuanto menos componentes
	// alfombras estan sucias.
	public class ValorHeuristico implements HeuristicFunction{
		public int getHeuristicValue(Object state) {
			int heuristica = 0;
			Robot robot =(Robot)state;
			if (!robot._limpiaHabIzq){
				heuristica++;
			}			
			if (!robot._limpiaHabCen){
				heuristica++;
			}			
			if (!robot._limpiaHabDer){
				heuristica++;
			}
			return heuristica;
		}
	}
}
