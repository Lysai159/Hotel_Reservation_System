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
import uef.edu.vn.model.Amenity;
import uef.edu.vn.service.AmenityService;

@Controller
@RequestMapping("/admin/amenity")
public class AmenityController {

    @Autowired
    private AmenityService amenityService;

    @GetMapping("/list")
    public String listAmenities(Model model) {
        List<Amenity> list = amenityService.findAll();
        model.addAttribute("amenities", list);
        return "amenities/list";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") int amenityId, Model model) {
        Amenity amenity = amenityService.findById(amenityId);
        if (amenity == null) {
            return "redirect:/admin/amenity/list";
        }
        model.addAttribute("amenity", amenity);
        return "amenities/form";
    }

    @PostMapping("/save")
    public String saveAmenity(@ModelAttribute Amenity amenity) {
        if (amenity.getAmenityId() == null) {
            amenityService.create(amenity);
        } else {
            amenityService.update(amenity);
        }
        return "redirect:/admin/amenity/list";
    }

    @GetMapping("/delete/{id}")
    public String deleteAmenity(@PathVariable("id") int amenityId) {
        amenityService.delete(amenityId);
        return "redirect:/admin/amenity/list";
    }
}