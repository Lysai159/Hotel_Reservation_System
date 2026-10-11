/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Customer;
import uef.edu.vn.service.CustomerService;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @GetMapping("/login")
    public String showLoginForm(HttpSession session, Model model) {
        if (session.getAttribute("redirectAfterLogin") != null) {
            Object pending = session.getAttribute("redirectAfterLogin");
            if (pending instanceof String redirect
                    && (redirect.startsWith("/admin") || redirect.startsWith("/booking/admin"))) {
                model.addAttribute("loginMessage",
                        redirect.startsWith("/booking/admin")
                                ? "Vui lòng đăng nhập tài khoản quản trị hoặc lễ tân."
                                : "Vui lòng đăng nhập tài khoản quản trị.");
            } else {
                model.addAttribute("loginMessage", "Vui lòng đăng nhập để đặt phòng.");
            }
        }
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam("email") String email, 
                        @RequestParam("password") String password, 
                        HttpSession session, 
                        Model model) {
        Customer customer = customerService.findByEmail(email);
        if (customer != null && customer.getPasswordHash().equals(password)) {
            Object pendingRedirect = session.getAttribute("redirectAfterLogin");
            session.setAttribute("currentUser", customer);
            session.removeAttribute("redirectAfterLogin");
            if (pendingRedirect instanceof String redirect
                    && redirect.startsWith("/")
                    && !redirect.startsWith("//")) {
                boolean adminPath = redirect.startsWith("/admin");
                boolean bookingDeskPath = redirect.startsWith("/booking/admin");
                if ((!adminPath && !bookingDeskPath)
                        || (adminPath && isAdmin(customer))
                        || (bookingDeskPath && isStaff(customer))) {
                    return "redirect:" + redirect;
                }
            }
            if (isAdmin(customer)) {
                return "redirect:/admin/room/list";
            }
            if (isReceptionist(customer)) {
                return "redirect:/booking/admin/list";
            }
            return "redirect:/room/list";
        }
        model.addAttribute("error", "Email hoặc mật khẩu không chính xác.");
        return "auth/login";
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("customer", new Customer());
        return "auth/register"; // Đã sửa: Trỏ vào views/auth/register.jsp
    }

    @PostMapping("/register")
    public String register(@ModelAttribute Customer customer, Model model) {
        try {
            customerService.register(customer);
            return "redirect:/customer/login";
        } catch (ValidationException ex) {
            model.addAttribute("error", ex.getMessage());
            return "auth/register"; // Đã sửa: Trỏ vào views/auth/register.jsp
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/customer/login";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Customer user = currentUser(session);
        if (user == null) {
            return "redirect:/customer/login";
        }
        Customer fresh = customerService.findById(user.getUserId());
        if (fresh != null) {
            session.setAttribute("currentUser", fresh);
            user = fresh;
        }
        model.addAttribute("profile", user);
        model.addAttribute("staffView", user.isStaff());
        return "customer/profile";
    }

    @PostMapping("/profile")
    public String updateProfile(@RequestParam("fullName") String fullName,
                                @RequestParam("email") String email,
                                @RequestParam(value = "phoneNumber", required = false) String phoneNumber,
                                @RequestParam(value = "address", required = false) String address,
                                HttpSession session,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        Customer user = currentUser(session);
        if (user == null) {
            return "redirect:/customer/login";
        }
        try {
            Customer updated = customerService.updateProfile(
                    user.getUserId(), fullName, email, phoneNumber, address);
            session.setAttribute("currentUser", updated);
            redirectAttributes.addFlashAttribute("success", "Đã cập nhật thông tin cá nhân.");
            return "redirect:/customer/profile";
        } catch (ValidationException ex) {
            model.addAttribute("infoError", ex.getMessage());
            model.addAttribute("profile", profileDraft(user, fullName, email, phoneNumber, address));
            model.addAttribute("staffView", user.isStaff());
            return "customer/profile";
        }
    }

    @PostMapping("/profile/password")
    public String changePassword(@RequestParam("currentPassword") String currentPassword,
                                 @RequestParam("newPassword") String newPassword,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 HttpSession session,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {
        Customer user = currentUser(session);
        if (user == null) {
            return "redirect:/customer/login";
        }
        try {
            Customer updated = customerService.changePassword(
                    user.getUserId(), currentPassword, newPassword, confirmPassword);
            session.setAttribute("currentUser", updated);
            redirectAttributes.addFlashAttribute("success", "Đã đổi mật khẩu thành công.");
            return "redirect:/customer/profile";
        } catch (ValidationException ex) {
            model.addAttribute("passwordError", ex.getMessage());
            model.addAttribute("profile", user);
            model.addAttribute("staffView", user.isStaff());
            return "customer/profile";
        }
    }

    private Customer currentUser(HttpSession session) {
        Object user = session.getAttribute("currentUser");
        return user instanceof Customer customer ? customer : null;
    }

    private Customer profileDraft(Customer user, String fullName, String email,
                                  String phoneNumber, String address) {
        Customer draft = new Customer();
        draft.setUserId(user.getUserId());
        draft.setRoleId(user.getRoleId());
        draft.setFullName(fullName);
        draft.setEmail(email);
        draft.setPhoneNumber(phoneNumber);
        draft.setAddress(address);
        return draft;
    }

    private boolean isAdmin(Customer customer) {
        return customer != null && customer.isAdmin();
    }

    private boolean isReceptionist(Customer customer) {
        return customer != null && customer.isReceptionist();
    }

    private boolean isStaff(Customer customer) {
        return customer != null && customer.isStaff();
    }
}