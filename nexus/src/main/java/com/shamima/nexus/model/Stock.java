package com.shamima.nexus.model;

import jakarta.persistence.*;
import lombok.Data;

import java.sql.Date;

@Data
@Entity
@Table(name = "stock")
public class Stock {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "stock_id")
    private Long stockId;

    @ManyToOne
    @JoinColumn(name = "material_id")
    private RawMaterial rawMaterial;



    @Column(name = "previous_price")
    private Double previousPrice;

    @Column(name = "unit_price")
    private double unitPrice;



    @Column(name = "quantity")
    private int quantity;

    @Column(name = "last_stock_update_date")
    private Date lastStockUpdateDate;

    @Column(name = "increase")
    private int increase;

    @Column(name = "decrease")
    private int decrease;


}
