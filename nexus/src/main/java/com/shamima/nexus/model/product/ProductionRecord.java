package com.shamima.nexus.model.product;

import jakarta.persistence.*;
import lombok.Data;

import java.sql.Date;

@Data
@Entity
@Table(name = "productionrecord")
public class ProductionRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long productionId;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    private int productionQuantity;
    private Date productionDate;
}
