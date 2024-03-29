//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.8-b130911.1802 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2017.12.06 at 11:04:28 AM CET 
//


package org.dmg.pmml.pmml_4_2.descr;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
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
 *       &lt;sequence>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}Baseline"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}Alternate" minOccurs="0"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}Extension" maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="field" use="required" type="{http://www.dmg.org/PMML-4_2}FIELD-NAME" />
 *       &lt;attribute name="testStatistic" use="required" type="{http://www.dmg.org/PMML-4_2}BASELINE-TEST-STATISTIC" />
 *       &lt;attribute name="resetValue" type="{http://www.dmg.org/PMML-4_2}REAL-NUMBER" default="0.0" />
 *       &lt;attribute name="windowSize" type="{http://www.dmg.org/PMML-4_2}INT-NUMBER" default="0" />
 *       &lt;attribute name="weightField" type="{http://www.dmg.org/PMML-4_2}FIELD-NAME" />
 *       &lt;attribute name="normalizationScheme" type="{http://www.w3.org/2001/XMLSchema}string" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "baseline",
    "alternate",
    "extensions"
})
@XmlRootElement(name = "TestDistributions")
public class TestDistributions implements Serializable
{

    private final static long serialVersionUID = 145235L;
    @XmlElement(name = "Baseline", required = true)
    protected Baseline baseline;
    @XmlElement(name = "Alternate")
    protected Alternate alternate;
    @XmlElement(name = "Extension")
    protected List<Extension> extensions;
    @XmlAttribute(name = "field", required = true)
    protected String field;
    @XmlAttribute(name = "testStatistic", required = true)
    protected BASELINETESTSTATISTIC testStatistic;
    @XmlAttribute(name = "resetValue")
    protected Double resetValue;
    @XmlAttribute(name = "windowSize")
    protected BigInteger windowSize;
    @XmlAttribute(name = "weightField")
    protected String weightField;
    @XmlAttribute(name = "normalizationScheme")
    protected String normalizationScheme;

    /**
     * Gets the value of the baseline property.
     * 
     * @return
     *     possible object is
     *     {@link Baseline }
     *     
     */
    public Baseline getBaseline() {
        return baseline;
    }

    /**
     * Sets the value of the baseline property.
     * 
     * @param value
     *     allowed object is
     *     {@link Baseline }
     *     
     */
    public void setBaseline(Baseline value) {
        this.baseline = value;
    }

    /**
     * Gets the value of the alternate property.
     * 
     * @return
     *     possible object is
     *     {@link Alternate }
     *     
     */
    public Alternate getAlternate() {
        return alternate;
    }

    /**
     * Sets the value of the alternate property.
     * 
     * @param value
     *     allowed object is
     *     {@link Alternate }
     *     
     */
    public void setAlternate(Alternate value) {
        this.alternate = value;
    }

    /**
     * Gets the value of the extensions property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the extensions property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getExtensions().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Extension }
     * 
     * 
     */
    public List<Extension> getExtensions() {
        if (extensions == null) {
            extensions = new ArrayList<Extension>();
        }
        return this.extensions;
    }

    /**
     * Gets the value of the field property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getField() {
        return field;
    }

    /**
     * Sets the value of the field property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setField(String value) {
        this.field = value;
    }

    /**
     * Gets the value of the testStatistic property.
     * 
     * @return
     *     possible object is
     *     {@link BASELINETESTSTATISTIC }
     *     
     */
    public BASELINETESTSTATISTIC getTestStatistic() {
        return testStatistic;
    }

    /**
     * Sets the value of the testStatistic property.
     * 
     * @param value
     *     allowed object is
     *     {@link BASELINETESTSTATISTIC }
     *     
     */
    public void setTestStatistic(BASELINETESTSTATISTIC value) {
        this.testStatistic = value;
    }

    /**
     * Gets the value of the resetValue property.
     * 
     * @return
     *     possible object is
     *     {@link Double }
     *     
     */
    public Double getResetValue() {
        if (resetValue == null) {
            return  0.0D;
        } else {
            return resetValue;
        }
    }

    /**
     * Sets the value of the resetValue property.
     * 
     * @param value
     *     allowed object is
     *     {@link Double }
     *     
     */
    public void setResetValue(Double value) {
        this.resetValue = value;
    }

    /**
     * Gets the value of the windowSize property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getWindowSize() {
        if (windowSize == null) {
            return new BigInteger("0");
        } else {
            return windowSize;
        }
    }

    /**
     * Sets the value of the windowSize property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setWindowSize(BigInteger value) {
        this.windowSize = value;
    }

    /**
     * Gets the value of the weightField property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getWeightField() {
        return weightField;
    }

    /**
     * Sets the value of the weightField property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setWeightField(String value) {
        this.weightField = value;
    }

    /**
     * Gets the value of the normalizationScheme property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNormalizationScheme() {
        return normalizationScheme;
    }

    /**
     * Sets the value of the normalizationScheme property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNormalizationScheme(String value) {
        this.normalizationScheme = value;
    }

}
