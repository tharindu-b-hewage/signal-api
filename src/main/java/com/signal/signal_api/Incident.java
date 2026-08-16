package com.signal.signal_api;

/**
 * Holds information for an Incident.
 * // TODO: 16/8/2026 write documentation.
 * @param id
 * @param title
 * @param severity
 * @param status
 */
public record Incident(
        String id,
        String title,
        String severity,
        String status) {
}