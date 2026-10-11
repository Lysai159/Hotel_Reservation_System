/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.constant.BookingStatus;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Booking;
import uef.edu.vn.model.Payment;
import uef.edu.vn.repository.BookingRepository;
import uef.edu.vn.repository.PaymentRepository;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private BookingRepository bookingRepository;

    public List<Payment> findAll() {
        return paymentRepository.findAll();
    }

    public Payment findById(int paymentId) {
        return paymentRepository.findById(paymentId);
    }

    public Payment findByBookingId(int bookingId) {
        return paymentRepository.findByBookingId(bookingId);
    }

    public boolean processPayment(Payment payment) {
        try {
            Booking booking = bookingRepository.findById(payment.getBooking().getBookingId());
            if (booking == null) {
                throw new ValidationException("Đơn đặt phòng không tồn tại.");
            }

            payment.setStatus("Completed");
            boolean success = paymentRepository.save(payment) > 0;
            if (success) {
                bookingRepository.updateStatus(booking.getBookingId(), BookingStatus.CONFIRMED);
            }
            return success;
        } catch (ValidationException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ValidationException("Giao dịch thanh toán thất bại. Vui lòng thử lại.");
        }
    }

    public boolean updateStatus(int paymentId, String status) {
        return paymentRepository.updateStatus(paymentId, status) > 0;
    }

    public boolean delete(int paymentId) {
        return paymentRepository.delete(paymentId) > 0;
    }
}