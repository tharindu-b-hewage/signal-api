import http from 'k6/http';
import {sleep} from 'k6';

export const options = {
    vus: 10, duration: '10m',
// 10 simulated users
};

const TARGET = __ENV.TARGET || 'http://host.docker.internal:8080';
const ERROR_RATE = __ENV.ERROR_RATE || '0.0';
const LATENCY_MS = __ENV.LATENCY_MS || '0';

export default function () {
    http.get(`${TARGET}/chaos?errorRate=${ERROR_RATE}&latencyMs=${LATENCY_MS}`);
    sleep(0.2);
}