package com.shamima.nexus.model;


import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Data
@Entity
@Table(name = "raw_material")
public class RawMaterial {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "material_id")
//    @JsonProperty("materialId")

    private Long materialID;

    @Column(name = "material_name")
    private String materialName;

    @Column(name = "material_type")
    private String materialType;


    @JsonIgnore
    @OneToMany(mappedBy = "rawMaterial")
    private List<Inventory> inventories;


}
