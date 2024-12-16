package com.shamima.SCMSystem.production.entity;

import com.shamima.SCMSystem.products.entity.Product;
import com.shamima.SCMSystem.products.entity.Warehouse;
import jakarta.persistence.*;
import lombok.*;

import java.util.Date;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "production_product")
public class ProductionProduct {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product; //from angular send class only containing product.id
    private Date completionDate;
    private Date movedToWarehouseDate;

    private Long batchNumber;
    private int quantity;

    @ManyToOne
    @JoinColumn(name = "warehouse_id")
    private Warehouse warehouse;

    private String qrCodePath;

    @OneToMany(mappedBy = "productionProduct", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<RawMatUsage> rawMatUsages;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private ProductionProduct.Status status = Status.IN_PROGRESS;

    public enum Status {
        IN_PROGRESS,
        COMPLETED,
        MOVED_TO_WAREHOUSE

    }

    public ProductionProduct(Long id) {
        this.id = id;
    }

    public ProductionProduct(Status status) {
        this.status = status;
    }
}
