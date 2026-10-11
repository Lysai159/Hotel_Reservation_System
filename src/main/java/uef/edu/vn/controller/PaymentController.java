/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Booking;
import uef.edu.vn.model.Payment;
import uef.edu.vn.service.BookingService;
import uef.edu.vn.service.PaymentService;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private BookingService bookingService;

    @GetMapping("/checkout/{bookingId}")
    public String showCheckout(@PathVariable("bookingId") int bookingId, Model model) {
        Booking booking = bookingService.findById(bookingId);
        if (booking == null) {
            return "redirect:/booking/history";
        }
        model.addAttribute("bookingId", bookingId);
        model.addAttribute("booking", booking);
        return "payments/checkout";
    }

    @PostMapping("/process")
    public String processPayment(@ModelAttribute Payment payment, Model model) {
        try {
            paymentService.processPayment(payment);
            return "redirect:/booking/history";
        } catch (ValidationException ex) {
            model.addAttribute("error", ex.getMessage());
            return "payments/checkout"; // Trỏ vào views/payments/checkout.jsp khi lỗi
        }
    }
}