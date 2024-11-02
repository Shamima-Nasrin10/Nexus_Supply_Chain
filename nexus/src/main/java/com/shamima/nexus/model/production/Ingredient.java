package com.shamima.nexus.model.production;


import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.shamima.nexus.model.RawMaterial;
import com.shamima.nexus.model.Stock;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name =  "ingredient")
public class Ingredient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ingredient_id")
    private Long ingredientId;

    @ManyToOne
    @JoinColumn(name = "recipe_id")
    @JsonBackReference
    private Recipe recipe;

    @Column(name = "name")
    private String name;

    @Column(name = "quantity")
    private int quantity;


    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "material_id")
//    @JsonBackReference
    @JsonIgnore//for solving infinite recursion
    private RawMaterial rawMaterial;


    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "stock_id")
    private Stock stock;
}
