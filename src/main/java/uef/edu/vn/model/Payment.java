/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Payment {

    private Integer paymentId;
    private Booking booking;
    private LocalDateTime paymentDate;
    private BigDecimal amount;
    private String paymentMethod;
    private String status;
    private Customer processedBy;

    public Payment() {
    }

    public Payment(Integer paymentId, Booking booking, LocalDateTime paymentDate,
                   BigDecimal amount, String paymentMethod, String status, Customer processedBy) {
        this.paymentId = paymentId;
        this.booking = booking;
        this.paymentDate = paymentDate;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.processedBy = processedBy;
    }

    public Integer getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Integer paymentId) {
        this.paymentId = paymentId;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Customer getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(Customer processedBy) {
        this.processedBy = processedBy;
    }
} 