package com.smartcity.service;

import com.smartcity.entity.CityService;
import com.smartcity.repository.CityServiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CityServiceService {

    @Autowired
    private CityServiceRepository cityServiceRepository;

    public CityService createCityService(CityService cityService) {
        return cityServiceRepository.save(cityService);
    }

    public List<CityService> getAllCityServices() {
        return cityServiceRepository.findAll();
    }

    public CityService getCityServiceById(Long id) {
        return cityServiceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("City Service not found with id: " + id));
    }

    public void deleteCityService(Long id) {
        cityServiceRepository.deleteById(id);
    }
}
