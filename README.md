# Fitness Mockup

Replica in Flutter a doua machete Figma din fisierul *Laboratoare 2026 (Copy)*:

| Ecran | Nod Figma |
|---|---|
| Home v2 | [`3:1167`](https://www.figma.com/design/ML6U37uiTJ9oXWsyf8xJzj/Laboratoare-2026--Copy-?node-id=3-1167) |
| Fitness Detail | [`3:1332`](https://www.figma.com/design/ML6U37uiTJ9oXWsyf8xJzj/Laboratoare-2026--Copy-?node-id=3-1332) |

Ecranele sunt statice: fara navigare intre ele, fara date reale.

## Rulare

```bash
flutter pub get
flutter run -d chrome  # cel mai simplu, nu cere Android Studio
flutter run            # device Android conectat prin USB
```

## Trecerea de la o macheta la alta

Comutatorul Home / Fitness, sau swipe orizontal. Swipe-ul merge si cu mouse-ul:
`MaterialScrollBehavior` implicit ignora mouse-ul pe desktop si web, asa ca
`main.dart` declara explicit toate tipurile de pointer in `dragDevices`.

Pe o fereastra de cel putin 471x908 macheta apare intr-un cadru de 375x812, cu
comutatorul sub el. Pe ecran mai mic macheta ocupa tot spatiul, iar comutatorul
sta peste marginea de jos.

Macheta e proiectata pentru 375x812 logical pixels (iPhone X). Layoutul foloseste
`Expanded` si liste cu scroll orizontal, deci se comporta corect si pe ecrane mai
inguste, pana la 320px.

## Structura

```
lib/
  main.dart                  galeria celor doua ecrane
  theme/
    app_colors.dart          culorile din Figma (Primary/500, Greyscale/*)
    app_text_styles.dart     stilurile de text (Heading/H4, Body/Small/*, ...)
  widgets/                   componente reutilizate de ambele ecrane
  screens/
    home_screen.dart
    fitness_screen.dart
assets/
  images/                    fotografii exportate din Figma, redimensionate
  icons/                     iconite SVG exportate din Figma
  fonts/                     Plus Jakarta Sans (400/500/600/700), Inter 500
```

## Asset-uri

Toate imaginile si iconitele sunt exportate din Figma si comise in repo. URL-urile
de export ale Figma expira dupa 7 zile, deci nu sunt referite direct.

Fotografiile au fost exportate la rezolutie foarte mare (15 MB per imagine) si au
fost redimensionate la 2x fata de dimensiunea din macheta si convertite in JPEG:
39 MB in total inainte, 120 KB dupa.
