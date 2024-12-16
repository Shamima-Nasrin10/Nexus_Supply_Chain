package com.shamima.SCMSystem.products.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.shamima.SCMSystem.accounting.entity.Procurement;
import com.shamima.SCMSystem.production.entity.ProductionProduct;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "warehouses")
public class Warehouse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(nullable = false, unique = true, length = 50)
    private String name;

    @Column(nullable = false)
    private String location;

    @JsonIgnore
    @OneToMany(mappedBy = "warehouse", cascade = CascadeType.REMOVE, orphanRemoval = true)
    List<ProductionProduct> productionProducts;

    public Warehouse(long id) {
        this.id = id;
    }
}
