/**
 * 
 */
package at.dallermassl.ap.security.taint.extension;



/**
 * Default implementation of TaintedObject interface.
 * @author cdaller
 *
 */
public aspect TaintedObjectAspect implements TaintedObject {
    
    declare parents: java.lang.String implements TaintedObject;
    declare parents: java.lang.StringBuffer implements TaintedObject;
    declare parents: java.lang.StringBuilder implements TaintedObject;
    
    private boolean TaintedObject.tainted = false;
    // bit field of sources: cannot use any other types than "int" -> vm will not start otherwise!
    private int TaintedObject.sourceIdBitField = 0; 

    /**
     * {@inheritDoc}
     */
    public final boolean TaintedObject.isTainted() {
        return tainted;
    }

    /**
     * {@inheritDoc}
     */
    public final void TaintedObject.setTainted(boolean tainted) {
//        System.out.println("set tainted to " + tainted);
        this.tainted = tainted;
    }
    
    /**
     * {@inheritDoc}
     */
    public final int TaintedObject.getTaintedSourceIdBits() {
        return sourceIdBitField;
    }
    
    /**
     * Returns an int array of ids of the sources. The implementation uses the bit field 
     * and creates an int array from it using the real ids (0-31) instead of the bit field.
     * @return an int array of ids or an empty array.
     */
    public final int[] TaintedObject.getTaintedSourceIds() {
        int count = 0;
        for (int bit = 0; bit < 31; bit++) {
            if ((sourceIdBitField & (1 << bit)) > 0) {
                count++;
            }
        }
        int[] ids = new int[count];
        int index = 0;
        for (int bit = 0; bit < 31; bit++) {
            if ((sourceIdBitField & (1 << bit)) > 0) {
                ids[index] = bit;
                index++;
            }
        }
        return ids;
    }
    
    /**
     * {@inheritDoc}
     */
    public void TaintedObject.addTaintedSourceId(int sourceId) {
        if (sourceId > 30) {
            throw new IllegalArgumentException("Source id must be <= 30!");
        }
        int mask = 1 << sourceId;
        sourceIdBitField = sourceIdBitField | mask;
    }

    /**
     * {@inheritDoc}
     */
    public void TaintedObject.addTaintedSourceIds(int... sourceIds) {
        if (sourceIds != null) {
            for (int sourceId : sourceIds) {
                addTaintedSourceId(sourceId);
            }
        }
    }
}
