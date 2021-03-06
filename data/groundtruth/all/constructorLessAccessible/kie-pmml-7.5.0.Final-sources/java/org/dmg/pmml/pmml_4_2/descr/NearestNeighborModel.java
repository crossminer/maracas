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
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}TrainingInstances"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}ComparisonMeasure"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}KNNInputs"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}ModelVerification" minOccurs="0"/>
 *         &lt;element ref="{http://www.dmg.org/PMML-4_2}Extension" maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="modelName" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="functionName" use="required" type="{http://www.dmg.org/PMML-4_2}MINING-FUNCTION" />
 *       &lt;attribute name="algorithmName" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="numberOfNeighbors" use="required" type="{http://www.dmg.org/PMML-4_2}INT-NUMBER" />
 *       &lt;attribute name="continuousScoringMethod" type="{http://www.dmg.org/PMML-4_2}CONT-SCORING-METHOD" default="average" />
 *       &lt;attribute name="categoricalScoringMethod" type="{http://www.dmg.org/PMML-4_2}CAT-SCORING-METHOD" default="majorityVote" />
 *       &lt;attribute name="instanceIdVariable" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="threshold" type="{http://www.dmg.org/PMML-4_2}REAL-NUMBER" default="0.001" />
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
    "extensionsAndKNNInputsAndComparisonMeasures"
})
@XmlRootElement(name = "NearestNeighborModel")
public class NearestNeighborModel implements Serializable
{

    private final static long serialVersionUID = 145235L;
    @XmlElements({
        @XmlElement(name = "Extension", required = true, type = Extension.class),
        @XmlElement(name = "KNNInputs", required = true, type = KNNInputs.class),
        @XmlElement(name = "ComparisonMeasure", required = true, type = ComparisonMeasure.class),
        @XmlElement(name = "TrainingInstances", required = true, type = TrainingInstances.class),
        @XmlElement(name = "MiningSchema", required = true, type = MiningSchema.class),
        @XmlElement(name = "Output", required = true, type = Output.class),
        @XmlElement(name = "ModelStats", required = true, type = ModelStats.class),
        @XmlElement(name = "ModelExplanation", required = true, type = ModelExplanation.class),
        @XmlElement(name = "Targets", required = true, type = Targets.class),
        @XmlElement(name = "LocalTransformations", required = true, type = LocalTransformations.class),
        @XmlElement(name = "ModelVerification", required = true, type = ModelVerification.class)
    })
    protected List<Serializable> extensionsAndKNNInputsAndComparisonMeasures;
    @XmlAttribute(name = "modelName")
    protected String modelName;
    @XmlAttribute(name = "functionName", required = true)
    protected MININGFUNCTION functionName;
    @XmlAttribute(name = "algorithmName")
    protected String algorithmName;
    @XmlAttribute(name = "numberOfNeighbors", required = true)
    protected BigInteger numberOfNeighbors;
    @XmlAttribute(name = "continuousScoringMethod")
    protected CONTSCORINGMETHOD continuousScoringMethod;
    @XmlAttribute(name = "categoricalScoringMethod")
    protected CATSCORINGMETHOD categoricalScoringMethod;
    @XmlAttribute(name = "instanceIdVariable")
    protected String instanceIdVariable;
    @XmlAttribute(name = "threshold")
    protected Double threshold;
    @XmlAttribute(name = "isScorable")
    protected Boolean isScorable;

    /**
     * Gets the value of the extensionsAndKNNInputsAndComparisonMeasures property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the extensionsAndKNNInputsAndComparisonMeasures property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getExtensionsAndKNNInputsAndComparisonMeasures().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Extension }
     * {@link KNNInputs }
     * {@link ComparisonMeasure }
     * {@link TrainingInstances }
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
    public List<Serializable> getExtensionsAndKNNInputsAndComparisonMeasures() {
        if (extensionsAndKNNInputsAndComparisonMeasures == null) {
            extensionsAndKNNInputsAndComparisonMeasures = new ArrayList<Serializable>();
        }
        return this.extensionsAndKNNInputsAndComparisonMeasures;
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
     * Gets the value of the numberOfNeighbors property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getNumberOfNeighbors() {
        return numberOfNeighbors;
    }

    /**
     * Sets the value of the numberOfNeighbors property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setNumberOfNeighbors(BigInteger value) {
        this.numberOfNeighbors = value;
    }

    /**
     * Gets the value of the continuousScoringMethod property.
     * 
     * @return
     *     possible object is
     *     {@link CONTSCORINGMETHOD }
     *     
     */
    public CONTSCORINGMETHOD getContinuousScoringMethod() {
        if (continuousScoringMethod == null) {
            return CONTSCORINGMETHOD.AVERAGE;
        } else {
            return continuousScoringMethod;
        }
    }

    /**
     * Sets the value of the continuousScoringMethod property.
     * 
     * @param value
     *     allowed object is
     *     {@link CONTSCORINGMETHOD }
     *     
     */
    public void setContinuousScoringMethod(CONTSCORINGMETHOD value) {
        this.continuousScoringMethod = value;
    }

    /**
     * Gets the value of the categoricalScoringMethod property.
     * 
     * @return
     *     possible object is
     *     {@link CATSCORINGMETHOD }
     *     
     */
    public CATSCORINGMETHOD getCategoricalScoringMethod() {
        if (categoricalScoringMethod == null) {
            return CATSCORINGMETHOD.MAJORITY_VOTE;
        } else {
            return categoricalScoringMethod;
        }
    }

    /**
     * Sets the value of the categoricalScoringMethod property.
     * 
     * @param value
     *     allowed object is
     *     {@link CATSCORINGMETHOD }
     *     
     */
    public void setCategoricalScoringMethod(CATSCORINGMETHOD value) {
        this.categoricalScoringMethod = value;
    }

    /**
     * Gets the value of the instanceIdVariable property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getInstanceIdVariable() {
        return instanceIdVariable;
    }

    /**
     * Sets the value of the instanceIdVariable property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setInstanceIdVariable(String value) {
        this.instanceIdVariable = value;
    }

    /**
     * Gets the value of the threshold property.
     * 
     * @return
     *     possible object is
     *     {@link Double }
     *     
     */
    public Double getThreshold() {
        if (threshold == null) {
            return  0.001D;
        } else {
            return threshold;
        }
    }

    /**
     * Sets the value of the threshold property.
     * 
     * @param value
     *     allowed object is
     *     {@link Double }
     *     
     */
    public void setThreshold(Double value) {
        this.threshold = value;
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
