package com.signal.signal_api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/incidents")
public class IncidentController {

    private final Map<String, Incident> store = new ConcurrentHashMap<>();

    public record CreateRequest(String title, String severity) {}

    @GetMapping
    public Collection<Incident> list() {

        return store.values();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Incident> get(@PathVariable String id) {

        Incident found = store.get(id);
        if (found == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(found);
    }

    @PostMapping
    public ResponseEntity<Incident> create(@RequestBody CreateRequest req) {

        String id = UUID.randomUUID().toString();
        Incident incident = new Incident(id, req.title, req.severity, "OPEN");
        store.put(id, incident);
        return ResponseEntity.status(201).body(incident);
    }
}