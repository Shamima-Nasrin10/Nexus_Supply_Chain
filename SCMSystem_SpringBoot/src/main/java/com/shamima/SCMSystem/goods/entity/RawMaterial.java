package com.shamima.SCMSystem.goods.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.shamima.SCMSystem.accounting.entity.Procurement;
import com.shamima.SCMSystem.production.entity.RawMatUsage;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "inv_raw_materials")
public class RawMaterial {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(name = "unit")
    private Unit unit;

    private String image;
    
    @ManyToOne()
    @JoinColumn(name = "category_id")
    private RawMaterialCategory category;

    @Transient
    private int quantity;

    @JsonIgnore
    @OneToMany(mappedBy = "rawMaterial", cascade = CascadeType.REMOVE, orphanRemoval = true)
    List<Procurement> procurements;

    @JsonIgnore
    @OneToMany(mappedBy = "rawMaterial", cascade = CascadeType.REMOVE, orphanRemoval = true)
    List<RawMaterialStock> stocks;

    @JsonIgnore
    @OneToMany(mappedBy = "rawMaterial", cascade = CascadeType.REMOVE, orphanRemoval = true)
    List<RawMatUsage> usages;

    public enum Unit {
        LITRE,
        PIECE,
        KG,
        GRAM
    }

    public RawMaterial(Long id) {
        this.id = id;
    }
}
