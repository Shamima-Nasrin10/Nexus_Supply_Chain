package com.shamima.nexus.security.repository;

import com.shamima.nexus.security.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<com.shamima.nexus.security.entity.User, Long> {
    Optional<com.shamima.nexus.security.entity.User> findByEmail(String email);

}
