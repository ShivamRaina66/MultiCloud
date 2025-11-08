package com.bankpro.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class AccountController {

    @GetMapping("/")
    public String home() {
        return "✅ BankPro Microservice is running successfully!";
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("OK");
    }

    @GetMapping("/api/account/{id}")
    public ResponseEntity<String> getAccount(@PathVariable String id) {
        return ResponseEntity.ok("Account:" + id);
    }
}
