package com.shamima.nexus.model.production;


import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "production_product")
public class ProductionProduct {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Long productId;


    @Column(name = "product_name")
    private String productName;
}
