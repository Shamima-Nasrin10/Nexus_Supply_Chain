package com.shamima.nexus.model.product;



import jakarta.persistence.*;
import lombok.Data;

import java.util.Map;

@Data
@Entity
@Table(name = "product")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long productId;

    private String productName;
    private String productType;


    @ElementCollection
    @CollectionTable(name = "product_raw_materials", joinColumns = @JoinColumn(name = "product_id"))
    @MapKeyColumn(name = "raw_material_name")
    @Column(name = "quantity")
    private Map<String ,Integer> recipe;
}
