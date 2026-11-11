"""Genera el ícono de Dolores AR (PNG 1024x1024).

Uso: python3 tool/generar_icono.py
Requiere Pillow y numpy.
"""
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont

RAIZ = Path(__file__).resolve().parent.parent
SALIDA = RAIZ / "assets" / "icon"
FUENTE = "/usr/share/fonts/noto/NotoSans-Bold.ttf"

S = 4  # supersampling para bordes suaves
BASE = 1024
N = BASE * S
AZUL = (18, 35, 63, 255)
ORO = (242, 166, 90, 255)
BLANCO = (255, 255, 255, 255)


def degradado() -> Image.Image:
    """Cielo nocturno que termina en un atardecer cálido."""
    paradas = [
        (0.00, (10, 22, 42)),
        (0.45, (23, 52, 86)),
        (0.78, (150, 82, 58)),
        (1.00, (235, 160, 92)),
    ]
    alto = N
    filas = np.zeros((alto, 3), dtype=np.float32)
    for i in range(len(paradas) - 1):
        y0, c0 = paradas[i]
        y1, c1 = paradas[i + 1]
        desde, hasta = int(y0 * alto), int(y1 * alto)
        for y in range(desde, min(hasta, alto)):
            t = (y - desde) / max(1, hasta - desde)
            filas[y] = np.array(c0) * (1 - t) + np.array(c1) * t
    filas[alto - 1] = paradas[-1][1]
    datos = np.repeat(filas[:, None, :], N, axis=1).astype(np.uint8)
    return Image.fromarray(datos, "RGB").convert("RGBA")


def pin(dibujo: ImageDraw.ImageDraw, relleno, escala: float = 1.0) -> None:
    cx, cy = 512 * S, 420 * S
    r = 190 * S * escala
    tri = [
        (343.6 * S * escala, 508 * S * escala),
        (680.4 * S * escala, 508 * S * escala),
        (512 * S, 830 * S * escala),
    ]
    # Mantener el pin centrado al escalar.
    if escala != 1.0:
        ajuste_x = cx - 512 * S * escala
        ajuste_y = cy - 420 * S * escala
        tri = [(x + ajuste_x, y + ajuste_y) for x, y in tri]
        cy += ajuste_y
    dibujo.ellipse((cx - r, cy - r, cx + r, cy + r), fill=relleno)
    dibujo.polygon(tri, fill=relleno)


def esquinas(dibujo: ImageDraw.ImageDraw) -> None:
    """Cuatro esquinas de visor: guiño a la realidad aumentada."""
    margen, largo, grosor = 70 * S, 150 * S, 17 * S
    radio = 10 * S
    blanco = (255, 255, 255, 225)  # type: ignore[assignment]
    for x0, y0, dx, dy in [
        (margen, margen, 1, 1),
        (N - margen, margen, -1, 1),
        (margen, N - margen, 1, -1),
        (N - margen, N - margen, -1, -1),
    ]:
        x1 = x0 + dx * largo
        y1 = y0 + dy * largo
        hx0, hx1 = sorted((x0, x1))
        vy0, vy1 = sorted((y0, y1))
        dibujo.rounded_rectangle(
            (hx0, min(y0, y0 + dy * grosor), hx1, max(y0, y0 + dy * grosor)),
            radius=radio,
            fill=blanco,
        )
        dibujo.rounded_rectangle(
            (min(x0, x0 + dx * grosor), vy0, max(x0, x0 + dx * grosor), vy1),
            radius=radio,
            fill=blanco,
        )


def dibujar_pin(imagen: Image.Image, escala: float = 1.0) -> None:
    capa = Image.new("L", (N, N), 0)
    pin(ImageDraw.Draw(capa), 255, escala)

    # Sombra suave.
    sombra = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    negro = Image.new("RGBA", (N, N), (0, 0, 0, 110))
    sombra.paste(negro, (0, int(18 * S)), capa)
    sombra = sombra.filter(ImageFilter.GaussianBlur(14 * S))
    imagen.alpha_composite(sombra)

    # Pin blanco.
    blanco = Image.new("RGBA", (N, N), BLANCO)
    imagen.paste(blanco, (0, 0), capa)

    # Círculo interior dorado + monograma AR.
    dibujo = ImageDraw.Draw(imagen)
    cx, cy = 512 * S, 420 * S
    if escala != 1.0:
        aj_x = cx - 512 * S * escala
        aj_y = cy - 420 * S * escala
        cx += aj_x
        cy += aj_y
    r = 120 * S * escala
    dibujo.ellipse((cx - r, cy - r, cx + r, cy + r), fill=ORO)
    fuente = ImageFont.truetype(FUENTE, int(138 * S * escala))
    dibujo.text((cx, cy), "AR", font=fuente, fill=AZUL, anchor="mm")


def icono_completo() -> Image.Image:
    imagen = degradado()

    # Resplandor cálido detrás del pin.
    brillo = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    dibujo = ImageDraw.Draw(brillo)
    dibujo.ellipse(
        (250 * S, 560 * S, 774 * S, 900 * S),
        fill=(242, 166, 90, 70),
    )
    brillo = brillo.filter(ImageFilter.GaussianBlur(50 * S))
    imagen.alpha_composite(brillo)

    esquinas(ImageDraw.Draw(imagen))
    dibujar_pin(imagen)
    return imagen.resize((BASE, BASE), Image.Resampling.LANCZOS)


def icono_adaptativo() -> Image.Image:
    imagen = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    dibujar_pin(imagen)
    return imagen.resize((BASE, BASE), Image.Resampling.LANCZOS)


def main() -> None:
    SALIDA.mkdir(parents=True, exist_ok=True)
    icono_completo().save(SALIDA / "icon.png")
    icono_adaptativo().save(SALIDA / "icon_foreground.png")
    print(f"Íconos generados en {SALIDA}")


if __name__ == "__main__":
    main()
