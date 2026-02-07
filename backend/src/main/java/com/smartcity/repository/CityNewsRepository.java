package com.smartcity.repository;

import com.smartcity.entity.CityNews;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CityNewsRepository extends JpaRepository<CityNews, Long> {
}
