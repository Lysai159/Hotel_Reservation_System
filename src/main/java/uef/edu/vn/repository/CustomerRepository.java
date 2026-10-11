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
import uef.edu.vn.model.Customer;

@Repository
public class CustomerRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Customer> findAll() {
        String sql = "SELECT UserID as userId, RoleID as roleId, FullName as fullName, Email as email, PasswordHash as passwordHash, PhoneNumber as phoneNumber, Address as address, CreatedAt as createdAt FROM Users ORDER BY UserID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Customer.class));
    }

    public Customer findById(int userId) {
        String sql = "SELECT UserID as userId, RoleID as roleId, FullName as fullName, Email as email, PasswordHash as passwordHash, PhoneNumber as phoneNumber, Address as address, CreatedAt as createdAt FROM Users WHERE UserID = ?";
        List<Customer> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Customer.class), userId);
        return list.isEmpty() ? null : list.get(0);
    }

    public Customer findByEmail(String email) {
        String sql = "SELECT UserID as userId, RoleID as roleId, FullName as fullName, Email as email, PasswordHash as passwordHash, PhoneNumber as phoneNumber, Address as address, CreatedAt as createdAt FROM Users WHERE Email = ?";
        List<Customer> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Customer.class), email);
        return list.isEmpty() ? null : list.get(0);
    }

    public int save(Customer customer) {
        String sql = "INSERT INTO Users (RoleID, FullName, Email, PasswordHash, PhoneNumber, Address) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, customer.getRoleId(), customer.getFullName(), customer.getEmail(), customer.getPasswordHash(), customer.getPhoneNumber(), customer.getAddress());
    }

    public int update(Customer customer) {
        String sql = "UPDATE Users SET RoleID = ?, FullName = ?, Email = ?, PasswordHash = ?, PhoneNumber = ?, Address = ? WHERE UserID = ?";
        return jdbcTemplate.update(sql, customer.getRoleId(), customer.getFullName(), customer.getEmail(), customer.getPasswordHash(), customer.getPhoneNumber(), customer.getAddress(), customer.getUserId());
    }

    public int updateProfile(Customer customer) {
        String sql = "UPDATE Users SET FullName = ?, Email = ?, PhoneNumber = ?, Address = ? WHERE UserID = ?";
        return jdbcTemplate.update(sql, customer.getFullName(), customer.getEmail(),
                customer.getPhoneNumber(), customer.getAddress(), customer.getUserId());
    }

    public int updatePassword(int userId, String passwordHash) {
        String sql = "UPDATE Users SET PasswordHash = ? WHERE UserID = ?";
        return jdbcTemplate.update(sql, passwordHash, userId);
    }

    public int delete(int userId) {
        String sql = "DELETE FROM Users WHERE UserID = ?";
        return jdbcTemplate.update(sql, userId);
    }
}