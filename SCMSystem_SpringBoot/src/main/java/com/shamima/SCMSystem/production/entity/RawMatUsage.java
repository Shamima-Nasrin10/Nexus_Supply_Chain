package com.shamima.SCMSystem.production.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.shamima.SCMSystem.goods.entity.RawMaterial;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "rawmat_usage")
public class RawMatUsage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "rawmaterial_id")
    private RawMaterial rawMaterial;

    private int quantity;

    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    @ManyToOne
    @JoinColumn(name = "production_product_id")
    private ProductionProduct productionProduct;

    public RawMatUsage(Long id) {
        this.id = id;
    }

}
