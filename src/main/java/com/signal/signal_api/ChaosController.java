package com.signal.signal_api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.ThreadLocalRandom;

@RestController
@RequestMapping("/chaos")
public class ChaosController {

    @GetMapping
    public ResponseEntity<String> chaos(
            @RequestParam(defaultValue = "0") long latencyMs,
            @RequestParam(defaultValue = "0.0") double errorRate
    ) throws InterruptedException {

        if(latencyMs > 0) {
            Thread.sleep(latencyMs);
        }

        if(ThreadLocalRandom.current().nextDouble() < errorRate) {
            return ResponseEntity.status(500).body("injected failure");
        }

        return ResponseEntity.ok("ok");
    }
}
