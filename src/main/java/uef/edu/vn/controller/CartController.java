package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Cart;
import uef.edu.vn.model.Customer;
import uef.edu.vn.service.CartService;
import uef.edu.vn.util.DateFormats;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        model.addAttribute("cart", cartService.getOrCreate(session));
        return "cart/cart";
    }

    @GetMapping("/add")
    public String addToCart(
            @RequestParam("roomId") int roomId,
            @RequestParam(value = "checkInDate", required = false) String checkInRaw,
            @RequestParam(value = "checkOutDate", required = false) String checkOutRaw,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        LocalDate checkIn = firstDate(checkInRaw, session, "searchCheckIn");
        LocalDate checkOut = firstDate(checkOutRaw, session, "searchCheckOut");

        if (checkIn == null || checkOut == null) {
            redirectAttributes.addFlashAttribute("error", "Vui lòng chọn ngày nhận và trả phòng trước khi đặt.");
            return "redirect:/room/detail/" + roomId;
        }

        try {
            cartService.addRoom(session, roomId, checkIn, checkOut);
            redirectAttributes.addFlashAttribute("success", "Đã thêm phòng vào giỏ hàng.");
            return "redirect:/cart";
        } catch (ValidationException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/room/detail/" + roomId;
        }
    }

    @PostMapping("/remove")
    public String removeItem(@RequestParam("itemId") String itemId, HttpSession session) {
        cartService.removeItem(session, itemId);
        return "redirect:/cart";
    }

    @GetMapping("/checkout")
    public String checkoutForm(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        Cart cart = cartService.getOrCreate(session);
        if (cart.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Giỏ hàng đang trống.");
            return "redirect:/cart";
        }
        model.addAttribute("cart", cart);
        return "cart/checkout";
    }

    @PostMapping("/checkout")
    public String checkout(
            @RequestParam("paymentMethod") String paymentMethod,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Customer currentUser = (Customer) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/customer/login";
        }
        try {
            cartService.checkout(session, currentUser, paymentMethod);
            redirectAttributes.addFlashAttribute("success", "Thanh toán thành công. Đơn đặt phòng đã được xác nhận.");
            return "redirect:/booking/history";
        } catch (ValidationException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/cart/checkout";
        }
    }

    private LocalDate firstDate(String raw, HttpSession session, String sessionKey) {
        LocalDate parsed = DateFormats.parse(raw);
        if (parsed != null) {
            return parsed;
        }
        Object stored = session.getAttribute(sessionKey);
        return stored instanceof LocalDate ? (LocalDate) stored : null;
    }
}
