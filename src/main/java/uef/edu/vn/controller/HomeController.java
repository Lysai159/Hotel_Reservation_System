package uef.edu.vn.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import uef.edu.vn.service.RoomService;

@Controller
public class HomeController {

    @Autowired
    private RoomService roomService;

    @GetMapping({"/", "/home"})
    public String index(Model model) {
        model.addAttribute("rooms", roomService.searchAvailable(null, null, null, null));
        return "home";
    }
}
