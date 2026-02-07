package com.smartcity.controller;

import com.smartcity.entity.CityService;
import com.smartcity.service.CityServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/city-services")
@CrossOrigin(origins = "*", maxAge = 3600)
public class CityServiceController {
    
    @Autowired
    private CityServiceService cityServiceService;
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<CityService> createCityService(@RequestBody CityService cityService) {
        return ResponseEntity.ok(cityServiceService.createCityService(cityService));
    }
    
    @GetMapping
    public ResponseEntity<List<CityService>> getAllCityServices() {
        return ResponseEntity.ok(cityServiceService.getAllCityServices());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<CityService> getCityServiceById(@PathVariable Long id) {
        return ResponseEntity.ok(cityServiceService.getCityServiceById(id));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteCityService(@PathVariable Long id) {
        cityServiceService.deleteCityService(id);
        return ResponseEntity.ok().build();
    }
}
