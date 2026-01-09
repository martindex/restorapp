package com.vares.pos.controller;

import com.vares.pos.model.entity.Zone;
import com.vares.pos.repository.ZoneRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/zones")
public class ZoneController {

    @Autowired
    private ZoneRepository zoneRepository;

    @GetMapping
    public List<Zone> getAllZones() {
        return zoneRepository.findAll();
    }
}
