package uef.edu.vn.controller;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import uef.edu.vn.model.Room;
import uef.edu.vn.service.RoomService;
import uef.edu.vn.service.RoomTypeService;
import uef.edu.vn.util.DateFormats;
import uef.edu.vn.util.FileUploadUtil;

@Controller
@RequestMapping("/room")
public class RoomController {

    @Autowired
    private RoomService roomService;

    @Autowired
    private RoomTypeService roomTypeService;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    @GetMapping("/list")
    public String listRooms(
            @RequestParam(value = "checkInDate", required = false) String checkInDateRaw,
            @RequestParam(value = "checkOutDate", required = false) String checkOutDateRaw,
            @RequestParam(value = "typeId", required = false) List<Integer> typeIds,
            @RequestParam(value = "guests", required = false) Integer guests,
            HttpSession session,
            Model model) {

        LocalDate checkInDate = DateFormats.parse(checkInDateRaw);
        LocalDate checkOutDate = DateFormats.parse(checkOutDateRaw);

        String error = null;
        if (checkInDate != null && checkOutDate != null && !checkOutDate.isAfter(checkInDate)) {
            error = "Ngày trả phòng phải sau ngày nhận phòng.";
            checkInDate = null;
            checkOutDate = null;
        }

        session.setAttribute("searchCheckIn", checkInDate);
        session.setAttribute("searchCheckOut", checkOutDate);

        List<Room> rooms = roomService.searchAvailable(checkInDate, checkOutDate, typeIds, guests);
        model.addAttribute("rooms", rooms);
        model.addAttribute("roomTypes", roomTypeService.findAll());
        model.addAttribute("checkInDate", checkInDate);
        model.addAttribute("checkOutDate", checkOutDate);
        model.addAttribute("guests", guests);
        model.addAttribute("selectedTypeIds", typeIds);
        model.addAttribute("error", error);
        return "rooms/list";
    }

    @GetMapping("/image/{id}")
    public void serveImage(@PathVariable("id") int roomId, HttpServletResponse response) throws IOException {
        Path file = fileUploadUtil.findRoomFile(roomId);
        if (file == null || !Files.isRegularFile(file)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        String contentType = Files.probeContentType(file);
        response.setContentType(contentType != null ? contentType : "image/jpeg");
        response.setHeader("Cache-Control", "no-store");
        Files.copy(file, response.getOutputStream());
    }

    @GetMapping("/detail/{id}")
    public String roomDetail(
            @PathVariable("id") int roomId,
            @RequestParam(value = "checkInDate", required = false) String checkInRaw,
            @RequestParam(value = "checkOutDate", required = false) String checkOutRaw,
            HttpSession session,
            Model model) {
        Room room = roomService.findById(roomId);
        if (room == null) {
            return "redirect:/room/list";
        }
        model.addAttribute("room", room);

        LocalDate checkInDate = DateFormats.parse(checkInRaw);
        LocalDate checkOutDate = DateFormats.parse(checkOutRaw);
        if (checkInDate == null) {
            Object stored = session.getAttribute("searchCheckIn");
            if (stored instanceof LocalDate) {
                checkInDate = (LocalDate) stored;
            }
        }
        if (checkOutDate == null) {
            Object stored = session.getAttribute("searchCheckOut");
            if (stored instanceof LocalDate) {
                checkOutDate = (LocalDate) stored;
            }
        }
        model.addAttribute("checkInDate", checkInDate);
        model.addAttribute("checkOutDate", checkOutDate);
        return "rooms/detail";
    }

    @PostMapping("/status")
    public String updateStatus(@RequestParam int roomId, @RequestParam String status) {
        roomService.updateStatus(roomId, status);
        return "redirect:/admin/room/list";
    }
}
