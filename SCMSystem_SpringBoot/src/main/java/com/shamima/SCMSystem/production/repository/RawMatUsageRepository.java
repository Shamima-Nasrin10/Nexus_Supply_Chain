package com.shamima.SCMSystem.production.repository;

import com.shamima.SCMSystem.production.entity.RawMatUsage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RawMatUsageRepository extends JpaRepository<RawMatUsage, Long> {
}
