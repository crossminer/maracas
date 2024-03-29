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
 * <p>Java class for RULE-FEATURE.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="RULE-FEATURE">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="antecedent"/>
 *     &lt;enumeration value="consequent"/>
 *     &lt;enumeration value="rule"/>
 *     &lt;enumeration value="ruleId"/>
 *     &lt;enumeration value="confidence"/>
 *     &lt;enumeration value="support"/>
 *     &lt;enumeration value="lift"/>
 *     &lt;enumeration value="leverage"/>
 *     &lt;enumeration value="affinity"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "RULE-FEATURE")
@XmlEnum
public enum RULEFEATURE {

    @XmlEnumValue("antecedent")
    ANTECEDENT("antecedent"),
    @XmlEnumValue("consequent")
    CONSEQUENT("consequent"),
    @XmlEnumValue("rule")
    RULE("rule"),
    @XmlEnumValue("ruleId")
    RULE_ID("ruleId"),
    @XmlEnumValue("confidence")
    CONFIDENCE("confidence"),
    @XmlEnumValue("support")
    SUPPORT("support"),
    @XmlEnumValue("lift")
    LIFT("lift"),
    @XmlEnumValue("leverage")
    LEVERAGE("leverage"),
    @XmlEnumValue("affinity")
    AFFINITY("affinity");
    private final String value;

    RULEFEATURE(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static RULEFEATURE fromValue(String v) {
        for (RULEFEATURE c: RULEFEATURE.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
