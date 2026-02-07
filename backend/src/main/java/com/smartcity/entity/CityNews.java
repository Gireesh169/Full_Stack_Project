package com.smartcity.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "city_news")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CityNews {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String title;
    
    @Column(nullable = false, length = 2000)
    private String content;
    
    private String imageUrl;
    
    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;
}
