package com.shamima.SCMSystem.accounting.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.shamima.SCMSystem.goods.entity.RawMaterial;
import com.shamima.SCMSystem.goods.entity.RawMaterialSupplier;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "acc_procurement")
public class Procurement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne
    private RawMaterial rawMaterial;

    @ManyToOne
    @JoinColumn(name = "supplier_id")
    private RawMaterialSupplier rawMaterialSupplier;

    private Date procurementDate;

    private double unitPrice;

    private int quantity;

    private double totalPrice;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private Procurement.Status status;

    public enum Status {
        PENDING,
        APPROVED,
        REJECTED
    }

}
