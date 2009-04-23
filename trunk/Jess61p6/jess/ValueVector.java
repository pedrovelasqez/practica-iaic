// -*- java -*-

package jess;

import java.io.Serializable;

/**
 * A mini version of Vector (a self-extending array) that only holds Values.
 * Not synchronized, so you must be careful of multithreading issues.
 * <P>
 * (C) E.J Friedman-Hill and Sandia National Laboratories
 * @author E.J. Friedman-Hill
 */

public class ValueVector implements Cloneable, Serializable {
    // This is public so that I can get fast access in the Rete
    // network. Don't overuse this, please, and don't write to the
    // array! Subject to reprivatization at any time.
    Value[] m_v;
    private int m_ptr = 0;

    /**
     * Construct a ValueVector of the default size (10)
     */

    public ValueVector() {
        this(10);
    }

    /**
     * Construct a ValueVector of the given size
     * @param size The number of Values this vector can hold at creation
     */
    public ValueVector(int size) {
        m_v = new Value[size];
    }

    /**
     * Fetch the size of this ValueVector
     * @return The size of this ValueVector
     */
    public final int size() {
        return m_ptr;
    }

    /**
     * Create a shallow copy of this ValueVector
     * @return The copy
     */
    public Object clone() {
        return cloneInto(new ValueVector(m_ptr));
    }

    /**
     * Make the parameter into a copy of this ValueVector
     * @param vv A ValueVector, whose contents are erased.
     * @return The parameter
     */
    public ValueVector cloneInto(ValueVector vv) {
        if (m_ptr > vv.m_v.length)  {
            Value[] nv = new Value[m_ptr];
            vv.m_v = nv;
        }
        vv.m_ptr = m_ptr;
        System.arraycopy(m_v, 0, vv.m_v, 0, m_ptr);
        return vv;
    }

    /**
     * Fetch the entry at position i in thie ValueVector
     * @param i The 0-based index of the Value to fetch
     * @return The Value
     */

    public Value get(int i) throws JessException {
        if (i < 0 || i >= m_ptr)
            throw new JessException("ValueVector.get",
                                    "Bad index " + i +
                                    " in call to get() on this vector: ",
                                    toStringWithParens());
        return m_v[i];
    }

    /**
     * Set the length of this ValueVector. If necessary the storage
     * will be extended.
     * @param i The new length (>= 0)
     */
    public ValueVector setLength(int i) {
        if (i > m_v.length)  {
            Value[] nv = new Value[i];
            System.arraycopy(m_v, 0, nv, 0, m_v.length);
            m_v = nv;
        }
        m_ptr = i;
        return this;
    }


    /**
     * Set the entry at position i to val. The argument must be >= 0
     * and < the return value of size().
     * @param val The new value
     * @param i The index at which to place it.
     */

    public final ValueVector set(Value val, int i) throws JessException {
        if (i < 0 || i >= m_ptr)
            throw new JessException("ValueVector.set",
                                    "Bad index " + i +
                                    " in call to set() on this vector:",
                                    toStringWithParens());

        m_v[i] = val;
        return this;
    }

    /**
     * Add a new element to the end of this ValueVector. The storage
     * will be extended if necessary.
     * @param val The value to add.
     */
    public final ValueVector add(Value val) {
        if (m_ptr >= m_v.length) {
            Value[] nv = new Value[m_v.length * 2];
            System.arraycopy(m_v, 0, nv, 0, m_v.length);
            m_v = nv;
        }
        m_v[m_ptr++] = val;
        return this;
    }

    /**
     * Remove the item at index i from the ValueVector; move all the
     * higher-numbered elements down.
     */
    public final ValueVector remove(int i) throws JessException {
        if (i < 0 || i >= m_ptr)
            throw new JessException("ValueVector.set",
                                    "Bad index " + i +
                                    " in call to remove() on this vector:",
                                    toStringWithParens());
        if (i < (m_ptr - 1))
            System.arraycopy(m_v, i+1, m_v, i, m_ptr-i);
        m_v[--m_ptr] = null;
        return this;
    }


    /**
     * Comparethis valueVector to another object.
     * @param o Another object
     * @return True if the object is a valueVector of the same size
     * containing Values that compare equal to the ones in this
     * Vector.
     */
    public boolean equals(Object o) {
        if (this == o)
            return true;

        if (! (o instanceof ValueVector) )
            return false;

        ValueVector vv = (ValueVector) o;

        if (m_ptr != vv.m_ptr)
            return false;

        for (int i=m_ptr -1; i>=0; i--)
            if (!m_v[i].equals(vv.m_v[i]))
                return false;

        return true;
    }


    /**
     * System.arraycopy DeLuxe for <i>ValueVector</i>s.
     * Contributed by Thomas Barnekow
     */
    public static void copy(ValueVector src, int srcPos, ValueVector dest,
                            int destPos, int length) {
        // What is the minimal destination length?
        int minDestSize = destPos + length;

        // Extend destination length if necessary
        int oldDestSize = dest.m_ptr;
        if (minDestSize > oldDestSize)
            dest.setLength(minDestSize);

        // Fill in nil values if necessary
        for (int i = oldDestSize ; i < destPos ; i++)
            dest.m_v[i] = Funcall.NIL;

        System.arraycopy(src.m_v, srcPos, dest.m_v, destPos, length);
    }

    /**
     * Append all <i>Value</i>s.
     * Contributed by Thomas Barnekow
     */
    public ValueVector addAll(ValueVector vv) {
        copy(vv, 0, this, m_ptr, vv.m_ptr);
        return this;
    }

    /**
     * Return a String version of this ValueVector, without parentheses.
     * @return The String
     */
    public String toString() {
        StringBuffer sb = new StringBuffer(100);
        for (int i=0; i < m_ptr; i++) {
            if (i > 0)
                sb.append(" ");
            sb.append(m_v[i]);
        }
        return sb.toString();
    }

    /**
     * Return a String version of this ValueVector, with parentheses
     * around all ValueVectors.
     * @return The String
     */
    public String toStringWithParens() {
        StringBuffer sb = new StringBuffer(100);
        sb.append("(");
        for (int i=0; i < m_ptr; i++) {
            if (i > 0)
                sb.append(" ");
            sb.append(m_v[i].toStringWithParens());
        }
        sb.append(")");
        return sb.toString();
    }
}


