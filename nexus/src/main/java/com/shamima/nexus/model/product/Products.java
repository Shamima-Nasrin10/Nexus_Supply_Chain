package com.shamima.nexus.model.product;


import jakarta.persistence.*;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
@Entity
@Table(name = "products")
public class Products {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private String batchNumber;
    private double price;

    // New field for image upload


    // Existing field for storing the image URL or path
    private String imageUrl;
}
