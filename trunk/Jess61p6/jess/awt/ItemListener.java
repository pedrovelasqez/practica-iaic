package jess.awt;
import jess.JessException;
import jess.Rete;

import java.awt.event.ItemEvent;

/** **********************************************************************
 * ItemListener
 * An AWT Event Adapter for Jess.
 * <P>
 * (C) 1997 Ernest J. Friedman-Hill and Sandia National Laboratories
 * @author Ernest J. Friedman-Hill
 */
public class ItemListener extends JessAWTListener
                          implements java.awt.event.ItemListener
{
  /**
   * Connect the Jess function specified by name to this event handler object. When this
   * handler receives an AWT event, the named function will be invoked in the given
   * engine.
   * @param uf The name of a Jess function
   * @param engine The Jess engine to execute the function in
   * @exception JessException If anything goes wrong.
   */
  public ItemListener(String uf, Rete engine) throws JessException
  {
    super(uf, engine);
  }

  /**
   * An event-handler method. Invokes the function passed to the constructor with the
   * received event as the argument.
   * @param e The event
   */
  public void itemStateChanged(ItemEvent e) { receiveEvent(e); }

}