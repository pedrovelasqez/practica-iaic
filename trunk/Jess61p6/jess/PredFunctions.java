package jess;

import java.io.Serializable;
import java.util.HashMap;

/** **********************************************************************
 * Predicate functions (is X of type Y?).
 *
 * <P>
 * (C) 1998 E.J. Friedman-Hill and the Sandia Corporation
 * @author Ernest J. Friedman-Hill
 */

class PredFunctions implements IntrinsicPackage, Serializable {

    private void addFunction(Userfunction uf, HashMap ht) {
        ht.put(uf.getName(), uf);
    }

    public void add(HashMap table) {
        addFunction(new EvenP(), table);
        addFunction(new OddP(), table);
        addFunction(new TypeP("lexemep", RU.ATOM | RU.STRING), table);
        addFunction(new TypeP("numberp", RU.INTEGER | RU.FLOAT | RU.LONG),
                table);
        addFunction(new TypeP("longp", RU.LONG), table);
        addFunction(new TypeP("floatp", RU.FLOAT), table);
        addFunction(new TypeP("integerp", RU.INTEGER), table);
        addFunction(new TypeP("stringp", RU.STRING), table);
        addFunction(new TypeP("symbolp", RU.ATOM), table);
        addFunction(new TypeP("multifieldp", RU.LIST), table);
        addFunction(new TypeP("external-addressp", RU.EXTERNAL_ADDRESS),
                table);
    }
}


class EvenP implements Userfunction, Serializable {
    public String getName() {
        return "evenp";
    }

    public Value call(ValueVector vv, Context context) throws JessException {

        boolean b = ((((int) vv.get(1).numericValue(context)) % 2) == 0);
        return b ? Funcall.TRUE : Funcall.FALSE;
    }
}

class OddP implements Userfunction, Serializable {
    public String getName() {
        return "oddp";
    }

    public Value call(ValueVector vv, Context context) throws JessException {

        boolean b = ((((int) vv.get(1).numericValue(context)) % 2) == 0);
        return b ? Funcall.FALSE : Funcall.TRUE;
    }
}

class TypeP implements Userfunction, Serializable {
    private String m_name;
    private int m_type;

    TypeP(String name, int type) {
        m_name = name;
        m_type = type;
    }

    public String getName() {
        return m_name;
    }

    public Value call(ValueVector vv, Context context) throws JessException {
        return ((vv.get(1).resolveValue(context).type() & m_type) != 0) ?
                Funcall.TRUE : Funcall.FALSE;
    }
}






