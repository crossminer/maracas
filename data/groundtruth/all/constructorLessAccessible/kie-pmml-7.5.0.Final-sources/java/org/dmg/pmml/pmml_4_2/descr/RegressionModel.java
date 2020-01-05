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
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;
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
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}MiningSchema"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}Output" minOccurs="0"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}ModelStats" minOccurs="0"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}ModelExplanation" minOccurs="0"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}Targets" minOccurs="0"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}LocalTransformations" minOccurs="0"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}RegressionTable" maxOccurs="unbounded"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}ModelVerification" minOccurs="0"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}Extension" maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="modelName" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="functionName" use="required" type="{http://www.dmg.org/PMML-4_2}MINING-FUNCTION" />
 *       &lt;attribute name="algorithmName" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="modelType">
 *         &lt;simpleType>
 *           &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *             &lt;enumeration value="linearRegression"/>
 *             &lt;enumeration value="stepwisePolynomialRegression"/>
 *             &lt;enumeration value="logisticRegression"/>
 *           &lt;/restriction>
 *         &lt;/simpleType>
 *       &lt;/attribute>
 *       &lt;attribute name="targetFieldName" type="{http://www.dmg.org/PMML-4_2}FIELD-NAME" />
 *       &lt;attribute name="normalizationMethod" type="{http://www.dmg.org/PMML-4_2}REGRESSIONNORMALIZATIONMETHOD" default="none" />
 *       &lt;attribute name="isScorable" type="{http://www.w3.org/2001/XMLSchema}boolean" default="true" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "extensionsAndRegressionTablesAndMiningSchemas"
})
@XmlRootElement(name = "RegressionModel")
public class RegressionModel implements Serializable
{

    private final static long serialVersionUID = 145235L;
    @XmlElements({
        @XmlElement(name = "Extension", required = true, type = Extension.class),
        @XmlElement(name = "RegressionTable", required = true, type = RegressionTable.class),
        @XmlElement(name = "MiningSchema", required = true, type = MiningSchema.class),
        @XmlElement(name = "Output", required = true, type = Output.class),
        @XmlElement(name = "ModelStats", required = true, type = ModelStats.class),
        @XmlElement(name = "ModelExplanation", required = true, type = ModelExplanation.class),
        @XmlElement(name = "Targets", required = true, type = Targets.class),
        @XmlElement(name = "LocalTransformations", required = true, type = LocalTransformations.class),
        @XmlElement(name = "ModelVerification", required = true, type = ModelVerification.class)
    })
    protected List<Serializable> extensionsAndRegressionTablesAndMiningSchemas;
    @XmlAttribute(name = "modelName")
    protected String modelName;
    @XmlAttribute(name = "functionName", required = true)
    protected MININGFUNCTION functionName;
    @XmlAttribute(name = "algorithmName")
    protected String algorithmName;
    @XmlAttribute(name = "modelType")
    protected String modelType;
    @XmlAttribute(name = "targetFieldName")
    protected String targetFieldName;
    @XmlAttribute(name = "normalizationMethod")
    protected REGRESSIONNORMALIZATIONMETHOD normalizationMethod;
    @XmlAttribute(name = "isScorable")
    protected Boolean isScorable;

    /**
     * Gets the value of the extensionsAndRegressionTablesAndMiningSchemas property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the extensionsAndRegressionTablesAndMiningSchemas property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getExtensionsAndRegressionTablesAndMiningSchemas().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Extension }
     * {@link RegressionTable }
     * {@link MiningSchema }
     * {@link Output }
     * {@link ModelStats }
     * {@link ModelExplanation }
     * {@link Targets }
     * {@link LocalTransformations }
     * {@link ModelVerification }
     * 
     * 
     */
    public List<Serializable> getExtensionsAndRegressionTablesAndMiningSchemas() {
        if (extensionsAndRegressionTablesAndMiningSchemas == null) {
            extensionsAndRegressionTablesAndMiningSchemas = new ArrayList<Serializable>();
        }
        return this.extensionsAndRegressionTablesAndMiningSchemas;
    }

    /**
     * Gets the value of the modelName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getModelName() {
        return modelName;
    }

    /**
     * Sets the value of the modelName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setModelName(String value) {
        this.modelName = value;
    }

    /**
     * Gets the value of the functionName property.
     * 
     * @return
     *     possible object is
     *     {@link MININGFUNCTION }
     *     
     */
    public MININGFUNCTION getFunctionName() {
        return functionName;
    }

    /**
     * Sets the value of the functionName property.
     * 
     * @param value
     *     allowed object is
     *     {@link MININGFUNCTION }
     *     
     */
    public void setFunctionName(MININGFUNCTION value) {
        this.functionName = value;
    }

    /**
     * Gets the value of the algorithmName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAlgorithmName() {
        return algorithmName;
    }

    /**
     * Sets the value of the algorithmName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAlgorithmName(String value) {
        this.algorithmName = value;
    }

    /**
     * Gets the value of the modelType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getModelType() {
        return modelType;
    }

    /**
     * Sets the value of the modelType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setModelType(String value) {
        this.modelType = value;
    }

    /**
     * Gets the value of the targetFieldName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTargetFieldName() {
        return targetFieldName;
    }

    /**
     * Sets the value of the targetFieldName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTargetFieldName(String value) {
        this.targetFieldName = value;
    }

    /**
     * Gets the value of the normalizationMethod property.
     * 
     * @return
     *     possible object is
     *     {@link REGRESSIONNORMALIZATIONMETHOD }
     *     
     */
    public REGRESSIONNORMALIZATIONMETHOD getNormalizationMethod() {
        if (normalizationMethod == null) {
            return REGRESSIONNORMALIZATIONMETHOD.NONE;
        } else {
            return normalizationMethod;
        }
    }

    /**
     * Sets the value of the normalizationMethod property.
     * 
     * @param value
     *     allowed object is
     *     {@link REGRESSIONNORMALIZATIONMETHOD }
     *     
     */
    public void setNormalizationMethod(REGRESSIONNORMALIZATIONMETHOD value) {
        this.normalizationMethod = value;
    }

    /**
     * Gets the value of the isScorable property.
     * 
     * @return
     *     possible object is
     *     {@link Boolean }
     *     
     */
    public Boolean getIsScorable() {
        if (isScorable == null) {
            return true;
        } else {
            return isScorable;
        }
    }

    /**
     * Sets the value of the isScorable property.
     * 
     * @param value
     *     allowed object is
     *     {@link Boolean }
     *     
     */
    public void setIsScorable(Boolean value) {
        this.isScorable = value;
    }

}
