package com.smartcity.service;

import com.smartcity.entity.CityNews;
import com.smartcity.repository.CityNewsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CityNewsService {

    @Autowired
    private CityNewsRepository cityNewsRepository;

    public CityNews createNews(CityNews cityNews) {
        return cityNewsRepository.save(cityNews);
    }

    public List<CityNews> getAllNews() {
        return cityNewsRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"));
    }

    public CityNews getNewsById(Long id) {
        return cityNewsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("News not found with id: " + id));
    }

    public void deleteNews(Long id) {
        cityNewsRepository.deleteById(id);
    }
}
