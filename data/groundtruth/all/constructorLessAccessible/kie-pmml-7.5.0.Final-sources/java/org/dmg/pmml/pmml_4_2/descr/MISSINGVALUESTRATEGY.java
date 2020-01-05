//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.8-b130911.1802 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2017.12.06 at 11:04:28 AM CET 
//


package org.dmg.pmml.pmml_4_2.descr;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for MISSING-VALUE-STRATEGY.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="MISSING-VALUE-STRATEGY">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="lastPrediction"/>
 *     &lt;enumeration value="nullPrediction"/>
 *     &lt;enumeration value="defaultChild"/>
 *     &lt;enumeration value="weightedConfidence"/>
 *     &lt;enumeration value="aggregateNodes"/>
 *     &lt;enumeration value="none"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "MISSING-VALUE-STRATEGY")
@XmlEnum
public enum MISSINGVALUESTRATEGY {

    @XmlEnumValue("lastPrediction")
    LAST_PREDICTION("lastPrediction"),
    @XmlEnumValue("nullPrediction")
    NULL_PREDICTION("nullPrediction"),
    @XmlEnumValue("defaultChild")
    DEFAULT_CHILD("defaultChild"),
    @XmlEnumValue("weightedConfidence")
    WEIGHTED_CONFIDENCE("weightedConfidence"),
    @XmlEnumValue("aggregateNodes")
    AGGREGATE_NODES("aggregateNodes"),
    @XmlEnumValue("none")
    NONE("none");
    private final String value;

    MISSINGVALUESTRATEGY(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static MISSINGVALUESTRATEGY fromValue(String v) {
        for (MISSINGVALUESTRATEGY c: MISSINGVALUESTRATEGY.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
