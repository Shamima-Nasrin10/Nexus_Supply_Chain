package com.shamima.nexus.repository;

import com.shamima.nexus.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface PaymentRepository extends JpaRepository<Payment, Long> {

    @Query("SELECT SUM(p.paymentAmount) FROM Payment p")
    Double getTotalPaymentAmount();





}
