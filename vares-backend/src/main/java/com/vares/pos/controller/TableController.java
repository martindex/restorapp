package com.vares.pos.controller;

import com.vares.pos.model.entity.TableEntity;
import com.vares.pos.repository.TableRepository;
import com.vares.pos.service.LayoutService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/tables")
public class TableController {

    @Autowired
    private TableRepository tableRepository;

    @Autowired
    private LayoutService layoutService;

    @GetMapping
    public List<TableEntity> getAllTables() {
        return tableRepository.findAll();
    }

    @GetMapping("/zone/{zoneId}")
    public List<TableEntity> getTablesByZone(@PathVariable String zoneId) {
        return tableRepository.findByZoneId(zoneId);
    }

    @PostMapping("/{tableId}/calculate-capacity")
    public ResponseEntity<Integer> calculateCapacity(@PathVariable String tableId) {
        return tableRepository.findById(tableId)
                .map(table -> ResponseEntity.ok(layoutService.calculateTableCapacity(table)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{tableId}/status")
    public ResponseEntity<?> updateStatus(@PathVariable String tableId, @RequestBody String status) {
        return tableRepository.findById(tableId)
                .map(table -> {
                    table.setStatus(TableEntity.TableStatus.valueOf(status.replace("\"", "")));
                    tableRepository.save(table);
                    return ResponseEntity.ok().build();
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
