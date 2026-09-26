import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 10,
  duration: '1m30s',
  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed: ['rate<0.01'],
  },
};

const MENSAJES = [
  'agrega nueva funcion de login',
  'arregla bug en el registro',
  'actualiza documentacion del README',
  'agrega pruebas unitarias',
  'refactoriza el modulo de usuarios',
  'actualiza dependencias',
  'mejora el rendimiento del endpoint',
  'corrige error de validacion',
];

export default function () {
  const mensaje = MENSAJES[Math.floor(Math.random() * MENSAJES.length)];
  const payload = JSON.stringify({ mensaje: mensaje });
  const params = {
    headers: { 'Content-Type': 'application/json' },
  };

  const res = http.post('http://api-ia:8000/clasificar', payload, params);

  check(res, {
    'status es 200': (r) => r.status === 200,
    'tiene tipo': (r) => r.body.includes('tipo'),
  });

  sleep(1);
}
