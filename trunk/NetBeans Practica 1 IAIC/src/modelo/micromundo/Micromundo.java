package modelo.micromundo;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Random;
import observador.Observador;
import modelo.juegos.GestorJuegos;
import modelo.matrices.GeneraMatrices;
import modelo.matrices.MatrizConexiones;
import modelo.matrices.MatrizProblemas;
import aima.search.framework.GraphSearch;
import aima.search.framework.Problem;
import aima.search.framework.Search;
import aima.search.framework.SearchAgent;
import aima.search.framework.TreeSearch;
import aima.search.informed.AStarSearch;
import aima.search.informed.GreedyBestFirstSearch;
import aima.search.uninformed.BreadthFirstSearch;

@SuppressWarnings("unchecked")
public class Micromundo extends Thread {
	private static Observador _observer;
	private Problem _problema=null;
	private Search _search=null;
	private InterfazPlaneta _planeta=null;
	private static int _coste=0;
	private int _semilla=0;
	private static ArrayList<Planeta> _listaPlanetas=new ArrayList<Planeta>();
	

	public Micromundo(){
		_coste=0;
		_listaPlanetas=new ArrayList<Planeta>();
		_semilla=GeneraMatrices.dameInstancia().dameSemilla();
		generarValoresParaHeuristica();
		generaInstaciaProblemaGlobal();
	}
	
	public void generarValoresParaHeuristica(){
		//creamos la lista de 216 planetas
		for(int i=0;i<216;i++){
			_listaPlanetas.add(new Planeta(i,_listaPlanetas));
		}
		Random rnd=new Random();  
		rnd.setSeed(_semilla);	
		//recorremos la matriz para asignar valores a los planetas conectados a un planeta final
		for(int i=215;i>=0;i--){
			for(int j=215;j>=0;j--){
				if(MatrizConexiones.getInstancia().conectados(j, i)){
					//j esta conectado
					Planeta conectado=_listaPlanetas.get(j);
					Planeta vecino=_listaPlanetas.get(i);
					int valor=rnd.nextInt(2);
					int agua=0;
					int oxigeno=0;
					int problema=MatrizProblemas.getInstancia().ping(j, i);
					int valorProblema=GestorJuegos.costeProblema(problema);
					if(valor==0){
						agua=(vecino.getAgua()-valorProblema*4);
						oxigeno=vecino.getOxigeno()-10;
					}else{
						agua=vecino.getAgua()-7;
						oxigeno=(vecino.getOxigeno()-valorProblema*3);
					}
					conectado.setAguaOxigeno(agua, oxigeno);
					//reasignamos el valor de la heuristica
					conectado.generaHeuristica();
				}
			}
		}
	}
	
	public void generaInstaciaProblemaGlobal(){
		_planeta=new Planeta(_listaPlanetas);
		_problema=_planeta.getProblema(_listaPlanetas);
	}
	
	public void pasoApaso(){
		_planeta.pasoApaso();
	}
	
	public void siguiente(){
		_planeta.siguiente();
	}

	public void solucionar(int numero){
		switch(numero){
			case 0://Voraz
				_search=new GreedyBestFirstSearch(new GraphSearch());
				break;
			case 1:// A*
				_search=new AStarSearch(new GraphSearch()) ;
				break;
			case 2://Primero en anchura
				_search=new BreadthFirstSearch(new TreeSearch()) ;
				break;
		}
	}
	
	public void run(){
		try {
			Log.dameInstancia().abrirLog();
			Estadisticas.dameInstancia().reiniciar();
			SearchAgent agent = new SearchAgent (_problema , _search) ;
			if(_planeta.resuelto()){
				printActions(agent.getActions());
				printInstrumentation(agent.getInstrumentation());
			}
			_observer.reiniciar();
			Log.dameInstancia().cerrarLog();
		}catch (Exception e){e.printStackTrace();}
	}
	
	public void setObserver(Observador obs){
		_observer=obs;
	}
	
	private static void printInstrumentation(Properties properties) {
		Iterator keys = properties.keySet().iterator();
		while (keys.hasNext()) {
			String key = (String) keys.next();
			String property = properties.getProperty(key);
			Log.dameInstancia().agregar(key + " : " + property);
			_observer.escribeLog(key + " : " + property);
		}
		Log.dameInstancia().agregar("Coste total: " + _coste);
		_observer.escribeLog("Coste total: " + _coste);
	}
		
	private static void printActions(List<Object> actions) {
		for (int i = 0; i < actions.size(); i++) {
			String action = (String) actions.get(i);
			String coste=action.substring(action.lastIndexOf("COSTE:")+6);
			int cont=0;
			String numero="";
			while(cont<coste.length() && Character.isDigit(coste.charAt(cont))){
				numero+=coste.charAt(cont);
				cont++;
			}
			_coste+=Integer.parseInt(numero.trim());
			Log.dameInstancia().agregar(action);
			_observer.escribeLog(action);
		}
	}

	public void muestraEstadisticas(){
		Estadisticas.dameInstancia().enviaValores();
	}
}
