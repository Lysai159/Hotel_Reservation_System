/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Amenity;
import uef.edu.vn.repository.AmenityRepository;

@Service
public class AmenityService {

    @Autowired
    private AmenityRepository amenityRepository;

    public List<Amenity> findAll() {
        return amenityRepository.findAll();
    }

    public Amenity findById(int amenityId) {
        return amenityRepository.findById(amenityId);
    }

    public boolean create(Amenity amenity) {
        try {
            return amenityRepository.save(amenity) > 0;
        } catch (Exception ex) {
            throw new ValidationException("Không thể thêm tiện ích.");
        }
    }

    public boolean update(Amenity amenity) {
        return amenityRepository.update(amenity) > 0;
    }

    public boolean delete(int amenityId) {
        return amenityRepository.delete(amenityId) > 0;
    }
}