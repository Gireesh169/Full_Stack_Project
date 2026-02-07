package com.smartcity.controller;

import com.smartcity.entity.CityNews;
import com.smartcity.service.CityNewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/news")
@CrossOrigin(origins = "*", maxAge = 3600)
public class CityNewsController {
    
    @Autowired
    private CityNewsService cityNewsService;
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<CityNews> createNews(@RequestBody CityNews cityNews) {
        return ResponseEntity.ok(cityNewsService.createNews(cityNews));
    }
    
    @GetMapping
    public ResponseEntity<List<CityNews>> getAllNews() {
        return ResponseEntity.ok(cityNewsService.getAllNews());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<CityNews> getNewsById(@PathVariable Long id) {
        return ResponseEntity.ok(cityNewsService.getNewsById(id));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteNews(@PathVariable Long id) {
        cityNewsService.deleteNews(id);
        return ResponseEntity.ok().build();
    }
}
