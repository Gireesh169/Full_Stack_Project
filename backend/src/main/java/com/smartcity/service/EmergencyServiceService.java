package com.smartcity.service;

import com.smartcity.entity.EmergencyService;
import com.smartcity.repository.EmergencyServiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmergencyServiceService {

    @Autowired
    private EmergencyServiceRepository emergencyServiceRepository;

    public EmergencyService createEmergencyService(EmergencyService emergencyService) {
        return emergencyServiceRepository.save(emergencyService);
    }

    public List<EmergencyService> getAllEmergencyServices() {
        return emergencyServiceRepository.findAll();
    }

    public EmergencyService getEmergencyServiceById(Long id) {
        return emergencyServiceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Emergency Service not found with id: " + id));
    }

    public void deleteEmergencyService(Long id) {
        emergencyServiceRepository.deleteById(id);
    }
}
