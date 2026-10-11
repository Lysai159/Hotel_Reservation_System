/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import uef.edu.vn.model.RoomType;
import uef.edu.vn.service.RoomTypeService;

@Controller
@RequestMapping("/admin/room-type")
public class RoomTypeController {

    @Autowired
    private RoomTypeService roomTypeService;

    @GetMapping("/list")
    public String listRoomTypes(Model model) {
        List<RoomType> list = roomTypeService.findAll();
        model.addAttribute("roomTypes", list);
        return "roomtypes/list"; // Trỏ vào views/roomtypes/list.jsp
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("roomType", new RoomType());
        return "roomtypes/form"; // Trỏ vào views/roomtypes/form.jsp
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") int typeId, Model model) {
        RoomType roomType = roomTypeService.findById(typeId);
        if (roomType == null) {
            return "redirect:/admin/room-type/list";
        }
        model.addAttribute("roomType", roomType);
        return "roomtypes/form";
    }

    @PostMapping("/save")
    public String saveRoomType(@ModelAttribute RoomType roomType) {
        if (roomType.getTypeId() == null) {
            roomTypeService.create(roomType);
        } else {
            roomTypeService.update(roomType);
        }
        return "redirect:/admin/room-type/list";
    }

    @GetMapping("/delete/{id}")
    public String deleteRoomType(@PathVariable("id") int typeId) {
        roomTypeService.delete(typeId);
        return "redirect:/admin/room-type/list";
    }
}