//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.8-b130911.1802 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2017.12.06 at 11:04:28 AM CET 
//


package org.dmg.pmml.pmml_4_2.descr;

import java.io.Serializable;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;attribute name="alpha" type="{http://www.dmg.org/PMML-4_2}REAL-NUMBER" />
 *       &lt;attribute name="smoothedValue" type="{http://www.dmg.org/PMML-4_2}REAL-NUMBER" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "")
@XmlRootElement(name = "Level")
public class Level
    implements Serializable
{

    private final static long serialVersionUID = 145235L;
    @XmlAttribute(name = "alpha")
    protected Double alpha;
    @XmlAttribute(name = "smoothedValue")
    protected Double smoothedValue;

    /**
     * Gets the value of the alpha property.
     * 
     * @return
     *     possible object is
     *     {@link Double }
     *     
     */
    public Double getAlpha() {
        return alpha;
    }

    /**
     * Sets the value of the alpha property.
     * 
     * @param value
     *     allowed object is
     *     {@link Double }
     *     
     */
    public void setAlpha(Double value) {
        this.alpha = value;
    }

    /**
     * Gets the value of the smoothedValue property.
     * 
     * @return
     *     possible object is
     *     {@link Double }
     *     
     */
    public Double getSmoothedValue() {
        return smoothedValue;
    }

    /**
     * Sets the value of the smoothedValue property.
     * 
     * @param value
     *     allowed object is
     *     {@link Double }
     *     
     */
    public void setSmoothedValue(Double value) {
        this.smoothedValue = value;
    }

}
