package com.shamima.nexus.model;


import jakarta.persistence.*;
import lombok.Data;

import java.sql.Date;


@Data
@Entity
@Table(name = "procurement")
public class Procurement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "procurement_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "supplier_id")
    private Supplier supplier;

    @ManyToOne
    @JoinColumn(name = "material_id")
    private RawMaterial rawMaterial;

    @Column(name = "quantity")
    private int quantity;

    @Column(name = "unit_price")
    private double unitPrice;

    @Column(name = "total_price")
    private double totalPrice;

    @Column(name = "procurement_date")
    private Date procurementDate;



    // Default constructor
    public Procurement() {
    }

    // Constructor with String argument for id
    public Procurement(String id) {
        this.id = Long.parseLong(id);
    }

//    @ManyToOne
//    @JoinColumn(name = "employee_id")
//    private Employee employee;
}
