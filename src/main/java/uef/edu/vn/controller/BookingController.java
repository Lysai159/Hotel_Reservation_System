package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Booking;
import uef.edu.vn.model.Customer;
import uef.edu.vn.model.Room;
import uef.edu.vn.service.BookingService;
import uef.edu.vn.service.RoomService;

@Controller
@RequestMapping("/booking")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private RoomService roomService;

    @GetMapping("/history")
    public String bookingHistory(HttpSession session, Model model) {
        Customer currentUser = currentUser(session);
        if (currentUser == null) {
            return "redirect:/customer/login";
        }
        model.addAttribute("bookings", bookingService.findByCustomerId(currentUser.getUserId()));
        return "booking/history";
    }

    @GetMapping("/detail/{id}")
    public String bookingDetail(@PathVariable("id") int bookingId, HttpSession session, Model model) {
        Customer currentUser = currentUser(session);
        if (currentUser == null) {
            return "redirect:/customer/login";
        }
        Booking booking = bookingService.findById(bookingId);
        if (booking == null) {
            return "redirect:/booking/history";
        }
        boolean owner = booking.getCustomer() != null
                && currentUser.getUserId() != null
                && currentUser.getUserId().equals(booking.getCustomer().getUserId());
        boolean staff = currentUser.isStaff();
        if (!owner && !staff) {
            return "redirect:/booking/history";
        }
        model.addAttribute("booking", booking);
        model.addAttribute("staffView", staff);
        return "booking/detail";
    }

    @GetMapping("/create")
    public String showCreateForm(@RequestParam("roomId") int roomId, HttpSession session, Model model) {
        Room room = roomService.findById(roomId);
        if (room == null) {
            return "redirect:/room/list";
        }
        model.addAttribute("room", room);
        Object checkIn = session.getAttribute("searchCheckIn");
        Object checkOut = session.getAttribute("searchCheckOut");
        if (checkIn instanceof java.time.LocalDate) {
            model.addAttribute("checkInDate", checkIn);
        }
        if (checkOut instanceof java.time.LocalDate) {
            model.addAttribute("checkOutDate", checkOut);
        }
        return "booking/form";
    }

    @PostMapping("/create")
    public String createBooking(@ModelAttribute Booking booking, HttpSession session, Model model) {
        Customer currentUser = currentUser(session);
        if (currentUser == null) {
            return "redirect:/customer/login";
        }

        try {
            booking.setCustomer(currentUser);
            bookingService.createBooking(booking);
            return "redirect:/booking/history";
        } catch (ValidationException ex) {
            Integer roomId = booking.getRoom() == null ? null : booking.getRoom().getRoomId();
            if (roomId != null) {
                model.addAttribute("room", roomService.findById(roomId));
            }
            model.addAttribute("error", ex.getMessage());
            return "rooms/detail";
        }
    }

    @PostMapping("/cancel/{id}")
    public String cancelBooking(@PathVariable("id") int bookingId, HttpSession session) {
        bookingService.cancelBooking(bookingId);
        Customer currentUser = currentUser(session);
        if (currentUser != null && currentUser.isStaff()) {
            return "redirect:/booking/admin/list";
        }
        return "redirect:/booking/history";
    }

    @GetMapping("/admin/list")
    public String adminList(Model model) {
        model.addAttribute("bookings", bookingService.findAll());
        return "booking/list";
    }

    @PostMapping("/admin/confirm/{id}")
    public String confirm(@PathVariable("id") int bookingId) {
        bookingService.confirmBooking(bookingId);
        return "redirect:/booking/admin/list";
    }

    @PostMapping("/admin/check-in/{id}")
    public String checkIn(@PathVariable("id") int bookingId) {
        bookingService.checkIn(bookingId);
        return "redirect:/booking/admin/list";
    }

    @PostMapping("/admin/check-out/{id}")
    public String checkOut(@PathVariable("id") int bookingId) {
        bookingService.checkOut(bookingId);
        return "redirect:/booking/admin/list";
    }

    private Customer currentUser(HttpSession session) {
        return (Customer) session.getAttribute("currentUser");
    }
}
