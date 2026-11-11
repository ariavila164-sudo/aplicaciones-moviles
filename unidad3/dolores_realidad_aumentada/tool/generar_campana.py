"""Genera una campana 3D (GLB) para el modo de realidad aumentada.

No usa modelos de terceros: la malla se construye por revolución y se guarda
en assets/modelos/campana.glb.

Uso: python3 tool/generar_campana.py
"""
from __future__ import annotations

import json
import math
import struct
from pathlib import Path

import numpy as np

RAIZ = Path(__file__).resolve().parent.parent
SALIDA = RAIZ / "assets" / "modelos" / "campana.glb"

SEGMENTOS = 72
SEGMENTOS_TUBO = 20


def perfil_campana() -> list[tuple[float, float]]:
    """Puntos (radio, altura) de la silueta, de la base a la copa."""
    return [
        (0.620, 0.000),
        (0.640, 0.045),
        (0.610, 0.100),
        (0.540, 0.180),
        (0.470, 0.300),
        (0.400, 0.450),
        (0.330, 0.600),
        (0.270, 0.720),
        (0.210, 0.800),
        (0.150, 0.855),
        (0.090, 0.885),
        (0.050, 0.895),
    ]


def triangulos(
    vertices: np.ndarray,
    indices: list[tuple[int, int, int]],
    normales: np.ndarray | None = None,
    direccion: np.ndarray | None = None,
) -> np.ndarray:
    """Corrige el winding para que las caras miren hacia afuera."""
    resultado = []
    for a, b, c in indices:
        v0, v1, v2 = vertices[a], vertices[b], vertices[c]
        normal = np.cross(v1 - v0, v2 - v0)
        if normales is not None:
            referencia = normales[a] + normales[b] + normales[c]
        elif direccion is not None:
            referencia = direccion
        else:
            centro = (v0 + v1 + v2) / 3.0
            referencia = np.array([centro[0], 0.0, centro[2]])
        if np.dot(normal, referencia) < 0:
            b, c = c, b
        resultado.append((a, b, c))
    return np.asarray(resultado, dtype=np.uint32)


def revolucion(perfil: list[tuple[float, float]]) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Superficie de revolución alrededor del eje Y, con normales suaves."""
    n = len(perfil)
    vertices = []
    normales = []

    for i, (r, y) in enumerate(perfil):
        anterior = perfil[max(0, i - 1)]
        siguiente = perfil[min(n - 1, i + 1)]
        dr = siguiente[0] - anterior[0]
        dy = siguiente[1] - anterior[1]
        nr, ny = dy, -dr
        largo = math.hypot(nr, ny) or 1.0
        nr, ny = nr / largo, ny / largo
        for j in range(SEGMENTOS):
            a = 2 * math.pi * j / SEGMENTOS
            vertices.append((r * math.cos(a), y, r * math.sin(a)))
            normales.append((nr * math.cos(a), ny, nr * math.sin(a)))

    indices: list[tuple[int, int, int]] = []
    for i in range(n - 1):
        for j in range(SEGMENTOS):
            j2 = (j + 1) % SEGMENTOS
            a = i * SEGMENTOS + j
            b = i * SEGMENTOS + j2
            c = (i + 1) * SEGMENTOS + j
            d = (i + 1) * SEGMENTOS + j2
            indices.append((a, c, b))
            indices.append((b, c, d))

    return (
        np.asarray(vertices, dtype=np.float64),
        np.asarray(normales, dtype=np.float64),
        triangulos(np.asarray(vertices), indices, normales=np.asarray(normales)),
    )


def tapa(radio: float, y: float, hacia_arriba: bool) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Disco que cierra la campana por abajo o por arriba."""
    vertices = [(0.0, y, 0.0)]
    normales = [(0.0, 1.0 if hacia_arriba else -1.0, 0.0)]
    for j in range(SEGMENTOS):
        a = 2 * math.pi * j / SEGMENTOS
        vertices.append((radio * math.cos(a), y, radio * math.sin(a)))
        normales.append(normales[0])

    indices = []
    for j in range(SEGMENTOS):
        indices.append((0, 1 + j, 1 + (j + 1) % SEGMENTOS))
    direccion = np.array([0.0, 1.0 if hacia_arriba else -1.0, 0.0])
    return (
        np.asarray(vertices, dtype=np.float64),
        np.asarray(normales, dtype=np.float64),
        triangulos(np.asarray(vertices), indices, direccion=direccion),
    )


def toro(
    radio_mayor: float,
    radio_tubo: float,
    centro: tuple[float, float, float],
    eje: str,
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Toro suave: sirve para el asa y las bandas decorativas."""
    cx, cy, cz = centro
    vertices = []
    normales = []
    for i in range(SEGMENTOS):
        u = 2 * math.pi * i / SEGMENTOS
        for j in range(SEGMENTOS_TUBO):
            v = 2 * math.pi * j / SEGMENTOS_TUBO
            cos_v, sin_v = math.cos(v), math.sin(v)
            if eje == "y":  # banda horizontal alrededor del eje Y
                x = (radio_mayor + radio_tubo * cos_v) * math.cos(u)
                y = cy + radio_tubo * sin_v
                z = (radio_mayor + radio_tubo * cos_v) * math.sin(u)
                nx = cos_v * math.cos(u)
                ny = sin_v
                nz = cos_v * math.sin(u)
            else:  # asa vertical en el plano XY
                x = cx + (radio_mayor + radio_tubo * cos_v) * math.cos(u)
                y = cy + (radio_mayor + radio_tubo * cos_v) * math.sin(u)
                z = cz + radio_tubo * sin_v
                nx = cos_v * math.cos(u)
                ny = cos_v * math.sin(u)
                nz = sin_v
            vertices.append((x, y, z))
            normales.append((nx, ny, nz))

    indices = []
    for i in range(SEGMENTOS):
        i2 = (i + 1) % SEGMENTOS
        for j in range(SEGMENTOS_TUBO):
            j2 = (j + 1) % SEGMENTOS_TUBO
            a = i * SEGMENTOS_TUBO + j
            b = i * SEGMENTOS_TUBO + j2
            c = i2 * SEGMENTOS_TUBO + j
            d = i2 * SEGMENTOS_TUBO + j2
            indices.append((a, c, b))
            indices.append((b, c, d))

    vertices_np = np.asarray(vertices, dtype=np.float64)
    return (
        vertices_np,
        np.asarray(normales, dtype=np.float64),
        triangulos(vertices_np, indices, normales=np.asarray(normales)),
    )


def unir(partes):
    vertices, normales, indices = [], [], []
    desplazamiento = 0
    for v, n, idx in partes:
        vertices.append(v)
        normales.append(n)
        indices.append(idx + desplazamiento)
        desplazamiento += len(v)
    vertices = np.concatenate(vertices)
    normales = np.concatenate(normales)
    indices = np.concatenate(indices)
    # Normalizar por si algún cálculo acumuló error.
    normales /= np.linalg.norm(normales, axis=1, keepdims=True)
    return vertices, normales, indices


def escribir_glb(vertices: np.ndarray, normales: np.ndarray, indices: np.ndarray) -> None:
    pos = vertices.astype("<f4")
    nor = normales.astype("<f4")
    idx = indices.reshape(-1).astype("<u4")

    datos = pos.tobytes() + nor.tobytes() + idx.tobytes()
    relleno = (-len(datos)) % 4
    datos += b"\x00" * relleno

    accesores = [
        {
            "bufferView": 0,
            "componentType": 5126,
            "count": int(len(pos)),
            "type": "VEC3",
            "min": pos.min(axis=0).tolist(),
            "max": pos.max(axis=0).tolist(),
        },
        {
            "bufferView": 1,
            "componentType": 5126,
            "count": int(len(nor)),
            "type": "VEC3",
        },
        {
            "bufferView": 2,
            "componentType": 5125,
            "count": int(len(idx)),
            "type": "SCALAR",
        },
    ]
    gltf = {
        "asset": {"version": "2.0", "generator": "Dolores AR · tool/generar_campana.py"},
        "scene": 0,
        "scenes": [{"nodes": [0]}],
        "nodes": [{"name": "Campana de Dolores", "mesh": 0}],
        "meshes": [
            {
                "name": "Campana",
                "primitives": [
                    {
                        "attributes": {"POSITION": 0, "NORMAL": 1},
                        "indices": 2,
                        "material": 0,
                        "mode": 4,
                    }
                ],
            }
        ],
        "materials": [
            {
                "name": "Bronce",
                "pbrMetallicRoughness": {
                    "baseColorFactor": [0.76, 0.50, 0.16, 1.0],
                    "metallicFactor": 0.9,
                    "roughnessFactor": 0.3,
                },
                "doubleSided": False,
            }
        ],
        "bufferViews": [
            {"buffer": 0, "byteOffset": 0, "byteLength": len(pos.tobytes()), "target": 34962},
            {
                "buffer": 0,
                "byteOffset": len(pos.tobytes()),
                "byteLength": len(nor.tobytes()),
                "target": 34962,
            },
            {
                "buffer": 0,
                "byteOffset": len(pos.tobytes()) + len(nor.tobytes()),
                "byteLength": len(idx.tobytes()),
                "target": 34963,
            },
        ],
        "accessors": accesores,
        "buffers": [{"byteLength": len(datos)}],
    }

    json_bytes = json.dumps(gltf, separators=(",", ":")).encode("utf-8")
    json_bytes += b" " * ((-len(json_bytes)) % 4)

    total = 12 + 8 + len(json_bytes) + 8 + len(datos)
    glb = bytearray()
    glb += struct.pack("<III", 0x46546C67, 2, total)
    glb += struct.pack("<II", len(json_bytes), 0x4E4F534A)
    glb += json_bytes
    glb += struct.pack("<II", len(datos), 0x004E4942)
    glb += datos

    SALIDA.parent.mkdir(parents=True, exist_ok=True)
    SALIDA.write_bytes(glb)
    print(f"Campana generada: {SALIDA} ({len(glb) / 1024:.1f} KB)")
    print(f"Vértices: {len(pos):,} · Triángulos: {len(idx) // 3:,}")


def main() -> None:
    perfil = perfil_campana()
    cuerpo = revolucion(perfil)
    base = tapa(perfil[0][0], perfil[0][1], hacia_arriba=False)
    copa = tapa(perfil[-1][0], perfil[-1][1], hacia_arriba=True)
    asa = toro(0.110, 0.028, (0.0, 0.955, 0.0), eje="xy")
    banda_inferior = toro(0.548, 0.018, (0.0, 0.180, 0.0), eje="y")
    banda_superior = toro(0.278, 0.014, (0.0, 0.720, 0.0), eje="y")

    vertices, normales, indices = unir([cuerpo, base, copa, asa, banda_inferior, banda_superior])
    escribir_glb(vertices, normales, indices)


if __name__ == "__main__":
    main()
