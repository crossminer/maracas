//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.8-b130911.1802 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2017.12.06 at 11:04:28 AM CET 
//


package org.dmg.pmml.pmml_4_2.descr;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
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
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}Extension" maxOccurs="unbounded" minOccurs="0"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}Taxonomy" minOccurs="0"/>
 *         &lt;group ref="{http://www.dmg.org/PMML-4_2}STRING-ARRAY"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "extensions",
    "taxonomy",
    "array"
})
@XmlRootElement(name = "TextDictionary")
public class TextDictionary implements Serializable
{

    private final static long serialVersionUID = 145235L;
    @XmlElement(name = "Extension")
    protected List<Extension> extensions;
    @XmlElement(name = "Taxonomy")
    protected Taxonomy taxonomy;
    @XmlElement(name = "Array")
    protected Array array;

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
     * Gets the value of the taxonomy property.
     * 
     * @return
     *     possible object is
     *     {@link Taxonomy }
     *     
     */
    public Taxonomy getTaxonomy() {
        return taxonomy;
    }

    /**
     * Sets the value of the taxonomy property.
     * 
     * @param value
     *     allowed object is
     *     {@link Taxonomy }
     *     
     */
    public void setTaxonomy(Taxonomy value) {
        this.taxonomy = value;
    }

    /**
     * Gets the value of the array property.
     * 
     * @return
     *     possible object is
     *     {@link Array }
     *     
     */
    public Array getArray() {
        return array;
    }

    /**
     * Sets the value of the array property.
     * 
     * @param value
     *     allowed object is
     *     {@link Array }
     *     
     */
    public void setArray(Array value) {
        this.array = value;
    }

}
