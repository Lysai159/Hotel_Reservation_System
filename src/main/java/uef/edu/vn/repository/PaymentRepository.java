/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Payment;

@Repository
public class PaymentRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Payment> findAll() {
        String sql = "SELECT PaymentID as paymentId, PaymentDate as paymentDate, Amount as amount, PaymentMethod as paymentMethod, Status as status FROM Payments ORDER BY PaymentID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Payment.class));
    }

    public Payment findById(int paymentId) {
        String sql = "SELECT PaymentID as paymentId, PaymentDate as paymentDate, Amount as amount, PaymentMethod as paymentMethod, Status as status FROM Payments WHERE PaymentID = ?";
        List<Payment> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Payment.class), paymentId);
        return list.isEmpty() ? null : list.get(0);
    }

    public Payment findByBookingId(int bookingId) {
        String sql = "SELECT PaymentID as paymentId, PaymentDate as paymentDate, Amount as amount, PaymentMethod as paymentMethod, Status as status FROM Payments WHERE BookingID = ?";
        List<Payment> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Payment.class), bookingId);
        return list.isEmpty() ? null : list.get(0);
    }

    public int save(Payment payment) {
        String sql = "INSERT INTO Payments (BookingID, Amount, PaymentMethod, Status, ProcessedBy) VALUES (?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, payment.getBooking().getBookingId(), payment.getAmount(), payment.getPaymentMethod(), payment.getStatus(), payment.getProcessedBy() != null ? payment.getProcessedBy().getUserId() : null);
    }

    public int updateStatus(int paymentId, String status) {
        String sql = "UPDATE Payments SET Status = ? WHERE PaymentID = ?";
        return jdbcTemplate.update(sql, status, paymentId);
    }

    public int delete(int paymentId) {
        String sql = "DELETE FROM Payments WHERE PaymentID = ?";
        return jdbcTemplate.update(sql, paymentId);
    }
}