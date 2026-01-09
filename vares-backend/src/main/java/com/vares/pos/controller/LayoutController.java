package com.vares.pos.controller;

import com.vares.pos.model.entity.LayoutCell;
import com.vares.pos.repository.LayoutCellRepository;
import com.vares.pos.service.LayoutService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/layout")
public class LayoutController {

    @Autowired
    private LayoutCellRepository layoutCellRepository;

    @Autowired
    private LayoutService layoutService;

    @GetMapping("/zone/{zoneId}")
    public List<LayoutCell> getLayoutByZone(@PathVariable String zoneId) {
        return layoutCellRepository.findByZoneId(zoneId);
    }

    @PostMapping("/zone/{zoneId}")
    public ResponseEntity<?> saveLayout(@PathVariable String zoneId, @RequestBody List<LayoutCell> cells) {
        try {
            layoutService.saveLayout(zoneId, cells);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
