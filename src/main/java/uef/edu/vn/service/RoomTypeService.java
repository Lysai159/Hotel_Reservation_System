/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.RoomType;
import uef.edu.vn.repository.RoomTypeRepository;

@Service
public class RoomTypeService {

    @Autowired
    private RoomTypeRepository roomTypeRepository;

    public List<RoomType> findAll() {
        return roomTypeRepository.findAll();
    }

    public RoomType findById(int typeId) {
        return roomTypeRepository.findById(typeId);
    }

    public boolean create(RoomType roomType) {
        try {
            return roomTypeRepository.save(roomType) > 0;
        } catch (Exception ex) {
            throw new ValidationException("Không thể tạo loại phòng mới.");
        }
    }

    public boolean update(RoomType roomType) {
        return roomTypeRepository.update(roomType) > 0;
    }

    public boolean delete(int typeId) {
        return roomTypeRepository.delete(typeId) > 0;
    }
}