package com.shamima.SCMSystem.security.restcontroller;

import com.shamima.SCMSystem.security.entity.AuthenticationResponse;
import com.shamima.SCMSystem.security.entity.User;
import com.shamima.SCMSystem.security.service.AuthService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class AuthenticationController {

private final AuthService authService;

@PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(@RequestBody User request) {
    return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/register/admin")
    public ResponseEntity<AuthenticationResponse> registerAdmin(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.registerAdmin(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthenticationResponse> login(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.authenticate(request));
    }

    @GetMapping("/activate/{id}")
    public ResponseEntity<String> activateUser(@PathVariable("id") int id) {
        String response = authService.activateUser(id);
        return ResponseEntity.ok(response);
    }

}
