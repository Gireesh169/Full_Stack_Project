package com.smartcity.controller;

import com.smartcity.entity.EmergencyService;
import com.smartcity.service.EmergencyServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/emergency-services")
@CrossOrigin(origins = "*", maxAge = 3600)
public class EmergencyServiceController {
    
    @Autowired
    private EmergencyServiceService emergencyServiceService;
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<EmergencyService> createEmergencyService(@RequestBody EmergencyService emergencyService) {
        return ResponseEntity.ok(emergencyServiceService.createEmergencyService(emergencyService));
    }
    
    @GetMapping
    public ResponseEntity<List<EmergencyService>> getAllEmergencyServices() {
        return ResponseEntity.ok(emergencyServiceService.getAllEmergencyServices());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<EmergencyService> getEmergencyServiceById(@PathVariable Long id) {
        return ResponseEntity.ok(emergencyServiceService.getEmergencyServiceById(id));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteEmergencyService(@PathVariable Long id) {
        emergencyServiceService.deleteEmergencyService(id);
        return ResponseEntity.ok().build();
    }
}
