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
 * <p>Java class for VALID-TIME-SPEC.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="VALID-TIME-SPEC">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="includeAll"/>
 *     &lt;enumeration value="includeFromTo"/>
 *     &lt;enumeration value="excludeFromTo"/>
 *     &lt;enumeration value="includeSet"/>
 *     &lt;enumeration value="excludeSet"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "VALID-TIME-SPEC")
@XmlEnum
public enum VALIDTIMESPEC {

    @XmlEnumValue("includeAll")
    INCLUDE_ALL("includeAll"),
    @XmlEnumValue("includeFromTo")
    INCLUDE_FROM_TO("includeFromTo"),
    @XmlEnumValue("excludeFromTo")
    EXCLUDE_FROM_TO("excludeFromTo"),
    @XmlEnumValue("includeSet")
    INCLUDE_SET("includeSet"),
    @XmlEnumValue("excludeSet")
    EXCLUDE_SET("excludeSet");
    private final String value;

    VALIDTIMESPEC(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static VALIDTIMESPEC fromValue(String v) {
        for (VALIDTIMESPEC c: VALIDTIMESPEC.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
