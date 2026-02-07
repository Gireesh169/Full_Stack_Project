package com.smartcity.repository;

import com.smartcity.entity.CityService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CityServiceRepository extends JpaRepository<CityService, Long> {
}
