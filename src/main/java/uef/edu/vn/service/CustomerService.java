/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Customer;
import uef.edu.vn.repository.CustomerRepository;

@Service
public class CustomerService {

    @Autowired
    private CustomerRepository customerRepository;

    public List<Customer> findAll() {
        return customerRepository.findAll();
    }

    public Customer findById(int userId) {
        return customerRepository.findById(userId);
    }

    public Customer findByEmail(String email) {
        return customerRepository.findByEmail(email);
    }

    public boolean register(Customer customer) {
        try {
            if (customerRepository.findByEmail(customer.getEmail()) != null) {
                throw new ValidationException("Email đã tồn tại trong hệ thống.");
            }
            // Public signup is always Customer (1=Admin, 2=Receptionist, 3=Customer)
            customer.setRoleId(3);
            return customerRepository.save(customer) > 0;
        } catch (ValidationException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ValidationException("Không thể đăng ký tài khoản. Vui lòng thử lại.");
        }
    }

    public boolean update(Customer customer) {
        return customerRepository.update(customer) > 0;
    }

    public Customer updateProfile(int userId, String fullName, String email, String phoneNumber, String address) {
        Customer current = customerRepository.findById(userId);
        if (current == null) {
            throw new ValidationException("Không tìm thấy tài khoản.");
        }
        fullName = trim(fullName);
        email = trim(email);
        phoneNumber = trim(phoneNumber);
        address = trim(address);
        if (fullName.isEmpty()) {
            throw new ValidationException("Vui lòng nhập họ và tên.");
        }
        if (email.isEmpty()) {
            throw new ValidationException("Vui lòng nhập email.");
        }
        if (!email.contains("@") || !email.contains(".")) {
            throw new ValidationException("Email không hợp lệ.");
        }
        if (phoneNumber.isEmpty()) {
            throw new ValidationException("Vui lòng nhập số điện thoại.");
        }
        Customer existing = customerRepository.findByEmail(email);
        if (existing != null && existing.getUserId() != userId) {
            throw new ValidationException("Email đã tồn tại trong hệ thống.");
        }
        current.setFullName(fullName);
        current.setEmail(email);
        current.setPhoneNumber(phoneNumber);
        current.setAddress(address);
        if (customerRepository.updateProfile(current) <= 0) {
            throw new ValidationException("Không thể cập nhật hồ sơ. Vui lòng thử lại.");
        }
        return customerRepository.findById(userId);
    }

    public Customer changePassword(int userId, String currentPassword, String newPassword, String confirmPassword) {
        Customer current = customerRepository.findById(userId);
        if (current == null) {
            throw new ValidationException("Không tìm thấy tài khoản.");
        }
        if (currentPassword == null || currentPassword.isEmpty()) {
            throw new ValidationException("Vui lòng nhập mật khẩu hiện tại.");
        }
        if (!currentPassword.equals(current.getPasswordHash())) {
            throw new ValidationException("Mật khẩu hiện tại không đúng.");
        }
        if (newPassword == null || newPassword.length() < 6) {
            throw new ValidationException("Mật khẩu mới phải có ít nhất 6 ký tự.");
        }
        if (!newPassword.equals(confirmPassword)) {
            throw new ValidationException("Xác nhận mật khẩu mới không khớp.");
        }
        if (newPassword.equals(currentPassword)) {
            throw new ValidationException("Mật khẩu mới phải khác mật khẩu hiện tại.");
        }
        if (customerRepository.updatePassword(userId, newPassword) <= 0) {
            throw new ValidationException("Không thể đổi mật khẩu. Vui lòng thử lại.");
        }
        return customerRepository.findById(userId);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    public boolean delete(int userId) {
        return customerRepository.delete(userId) > 0;
    }
}