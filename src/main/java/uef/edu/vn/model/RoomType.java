/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.model;

import java.math.BigDecimal;

public class RoomType {

    private Integer typeId;
    private String typeName;
    private String description;
    private BigDecimal basePrice;
    private Integer capacity;

    public RoomType() {
    }

    public RoomType(Integer typeId, String typeName, String description, BigDecimal basePrice, Integer capacity) {
        this.typeId = typeId;
        this.typeName = typeName;
        this.description = description;
        this.basePrice = basePrice;
        this.capacity = capacity;
    }

    public Integer getTypeId() {
        return typeId;
    }

    public void setTypeId(Integer typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(BigDecimal basePrice) {
        this.basePrice = basePrice;
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }
}