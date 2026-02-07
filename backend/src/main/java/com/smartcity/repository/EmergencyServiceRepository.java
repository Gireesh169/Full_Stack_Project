package com.smartcity.repository;

import com.smartcity.entity.EmergencyService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EmergencyServiceRepository extends JpaRepository<EmergencyService, Long> {
}
