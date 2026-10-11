package uef.edu.vn.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Room;
import uef.edu.vn.model.RoomType;
import uef.edu.vn.service.RoomService;
import uef.edu.vn.service.RoomTypeService;
import uef.edu.vn.util.ServletPartMultipartFile;

@Controller
@RequestMapping("/admin/room")
public class RoomManageController {

    @Autowired
    private RoomService roomService;

    @Autowired
    private RoomTypeService roomTypeService;

    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("rooms", roomService.findAll());
        return "rooms/admin-list";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("room", new Room());
        model.addAttribute("roomTypes", roomTypeService.findAll());
        return "rooms/form";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") int roomId, Model model) {
        Room room = roomService.findById(roomId);
        if (room == null) {
            return "redirect:/admin/room/list";
        }
        model.addAttribute("room", room);
        model.addAttribute("roomTypes", roomTypeService.findAll());
        return "rooms/form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Room room,
                       @RequestParam(value = "typeId", required = false) Integer typeId,
                       @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                       HttpServletRequest request,
                       Model model) {
        try {
            if (typeId != null) {
                RoomType roomType = new RoomType();
                roomType.setTypeId(typeId);
                room.setRoomType(roomType);
            }
            MultipartFile resolvedImage = resolveImageFile(imageFile, request);
            roomService.saveRoom(room, resolvedImage);
            return "redirect:/admin/room/edit/" + room.getRoomId();
        } catch (ValidationException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("room", room);
            model.addAttribute("roomTypes", roomTypeService.findAll());
            return "rooms/form";
        }
    }

    private MultipartFile resolveImageFile(MultipartFile imageFile, HttpServletRequest request) {
        if (imageFile != null && !imageFile.isEmpty()) {
            return imageFile;
        }
        try {
            Part part = request.getPart("imageFile");
            if (part != null && part.getSize() > 0) {
                return new ServletPartMultipartFile(part);
            }
        } catch (Exception ignored) {
            // Tomcat chưa parse multipart; để RoomService báo lỗi rõ nếu có chọn file.
        }
        return imageFile;
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") int roomId) {
        roomService.delete(roomId);
        return "redirect:/admin/room/list";
    }
}
