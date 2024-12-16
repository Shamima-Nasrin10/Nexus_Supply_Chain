package com.shamima.SCMSystem.accounting.entity;

import com.shamima.SCMSystem.goods.entity.RawMaterial;
import com.shamima.SCMSystem.goods.entity.RawMaterialSupplier;
import com.shamima.SCMSystem.production.entity.ProductionProduct;
import com.shamima.SCMSystem.products.entity.ProductRetailer;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "acc_sales")
public class Sales {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne
    private ProductionProduct productionProduct;

    @ManyToOne
    @JoinColumn(name = "retailer_id")
    private ProductRetailer productRetailer;

    private Date salesDate;

    private double unitPrice;

    private int quantity;

    private double totalPrice;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private Sales.Status status;

    public Sales(long id) {
        this.id = id;
    }

    public enum Status {
        PENDING,
        APPROVED,
        REJECTED
    }

}
