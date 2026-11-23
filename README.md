# Laborator 3 PAM: Learning App (varianta 4)

Aplicatie Flutter cu Cubit (`flutter_bloc`), date JSON incarcate asincron din `assets/data/lab_v4.json`.

## Rulare

```bash
flutter pub get
flutter run                     # normal
flutter run -d chrome           # in browser
flutter run --dart-define=DATA_ASSET=assets/data/missing.json   # demonstreaza starea Error
flutter test                    # 39 teste
```

## Structura

```
lib/
  core/          tema, erori, widget-uri reutilizabile (state views, butoane, chip-uri, imagini/iconite din retea)
  domain/        entitati, LessonQuery (cautare/filtrare/sortare), contracte de repository
  data/          sursa locala JSON (async + compute), modele fromJson, repository-uri (JSON, favorite in SharedPreferences)
  presentation/  home/ si course/: cubit + state, ecrane, widget-uri
```

## Stari

| Stare   | Unde se vede |
|---------|--------------|
| Loading | la pornire si la deschiderea cursului (latenta simulata 700 ms) |
| Success | Home, lista de lectii |
| Empty   | cautare fara rezultat, filtrul Favorites gol, tab-ul Description (textul din JSON e gol) |
| Error   | asset lipsa sau JSON invalid, cu buton "Try again" |

## Functionalitati

Cautare dupa titlu, filtre (All / Available / Locked / Favorites), sortare (ordine curs, titlu A-Z / Z-A, durata),
favorite persistente, pagina de detalii lectie cu "Next lesson", Enroll.
