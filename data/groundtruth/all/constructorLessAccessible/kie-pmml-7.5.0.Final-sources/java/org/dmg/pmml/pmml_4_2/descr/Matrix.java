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
 *       &lt;choice minOccurs="0">
 *         &lt;group ref="{http://www.dmg.org/PMML-4_2}NUM-ARRAY" maxOccurs="unbounded"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}MatCell" maxOccurs="unbounded"/>
 *       &lt;/choice>
 *       &lt;attribute name="kind" default="any">
 *         &lt;simpleType>
 *           &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *             &lt;enumeration value="diagonal"/>
 *             &lt;enumeration value="symmetric"/>
 *             &lt;enumeration value="any"/>
 *           &lt;/restriction>
 *         &lt;/simpleType>
 *       &lt;/attribute>
 *       &lt;attribute name="nbRows" type="{http://www.dmg.org/PMML-4_2}INT-NUMBER" />
 *       &lt;attribute name="nbCols" type="{http://www.dmg.org/PMML-4_2}INT-NUMBER" />
 *       &lt;attribute name="diagDefault" type="{http://www.dmg.org/PMML-4_2}REAL-NUMBER" />
 *       &lt;attribute name="offDiagDefault" type="{http://www.dmg.org/PMML-4_2}REAL-NUMBER" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "matCells",
    "arraies"
})
@XmlRootElement(name = "Matrix")
public class Matrix
    implements Serializable
{

    private final static long serialVersionUID = 145235L;
    @XmlElement(name = "MatCell")
    protected List<MatCell> matCells;
    @XmlElement(name = "Array")
    protected List<Array> arraies;
    @XmlAttribute(name = "kind")
    protected String kind;
    @XmlAttribute(name = "nbRows")
    protected BigInteger nbRows;
    @XmlAttribute(name = "nbCols")
    protected BigInteger nbCols;
    @XmlAttribute(name = "diagDefault")
    protected Double diagDefault;
    @XmlAttribute(name = "offDiagDefault")
    protected Double offDiagDefault;

    /**
     * Gets the value of the matCells property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the matCells property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getMatCells().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link MatCell }
     * 
     * 
     */
    public List<MatCell> getMatCells() {
        if (matCells == null) {
            matCells = new ArrayList<MatCell>();
        }
        return this.matCells;
    }

    /**
     * Gets the value of the arraies property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the arraies property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getArraies().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Array }
     * 
     * 
     */
    public List<Array> getArraies() {
        if (arraies == null) {
            arraies = new ArrayList<Array>();
        }
        return this.arraies;
    }

    /**
     * Gets the value of the kind property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getKind() {
        if (kind == null) {
            return "any";
        } else {
            return kind;
        }
    }

    /**
     * Sets the value of the kind property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setKind(String value) {
        this.kind = value;
    }

    /**
     * Gets the value of the nbRows property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getNbRows() {
        return nbRows;
    }

    /**
     * Sets the value of the nbRows property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setNbRows(BigInteger value) {
        this.nbRows = value;
    }

    /**
     * Gets the value of the nbCols property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getNbCols() {
        return nbCols;
    }

    /**
     * Sets the value of the nbCols property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setNbCols(BigInteger value) {
        this.nbCols = value;
    }

    /**
     * Gets the value of the diagDefault property.
     * 
     * @return
     *     possible object is
     *     {@link Double }
     *     
     */
    public Double getDiagDefault() {
        return diagDefault;
    }

    /**
     * Sets the value of the diagDefault property.
     * 
     * @param value
     *     allowed object is
     *     {@link Double }
     *     
     */
    public void setDiagDefault(Double value) {
        this.diagDefault = value;
    }

    /**
     * Gets the value of the offDiagDefault property.
     * 
     * @return
     *     possible object is
     *     {@link Double }
     *     
     */
    public Double getOffDiagDefault() {
        return offDiagDefault;
    }

    /**
     * Sets the value of the offDiagDefault property.
     * 
     * @param value
     *     allowed object is
     *     {@link Double }
     *     
     */
    public void setOffDiagDefault(Double value) {
        this.offDiagDefault = value;
    }

}
