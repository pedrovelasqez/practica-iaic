package jess;

import java.util.ArrayList;
import java.util.Iterator;

/**
 * Iterate over the patterns in a HasLHS in left to right order.
 */

class PatternIterator implements Iterator {
    private int m_index;
    private Pattern[] m_patterns;

    PatternIterator(LHSComponent ce) {
        ArrayList list = new ArrayList();
        storePatternsInList(ce, list);
        m_patterns = (Pattern[]) list.toArray(new Pattern[list.size()]);
    }

    private void storePatternsInList(LHSComponent ce,
                                     ArrayList list) {
        for (int i=0; i<ce.getGroupSize(); ++i) {
            LHSComponent each = ce.getLHSComponent(i);
            if (each instanceof Pattern)
                list.add(each);
            else
                storePatternsInList(each, list);
        }
    }

    public boolean hasNext() {
        return m_index < m_patterns.length;
    }

    public Object next() {
        return m_patterns[m_index++];
    }

    public void remove() {
        throw new UnsupportedOperationException();
    }

}
