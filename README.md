# Laborator 4 PAM: Learning App (varianta 4)

Aplicatie Flutter cu Clean Architecture si Cubit (`flutter_bloc`). Datele vin dintr-un REST API prin HTTP (`package:http`),
in format JSON, deserializat in modele si apoi in entitati de domeniu. Designul este cel din laboratorul 3.

API (varianta 4):

- `GET https://test-api-jlbn.onrender.com/lab2026/v4/feed` -> ecranul Home
- `GET https://test-api-jlbn.onrender.com/lab2026/v4/feed/details` -> ecranul Course Overview

## Rulare

```bash
flutter pub get
flutter run                                   # Android / iOS
flutter run --dart-define=API_VERSION=v2      # alta versiune a API-ului
flutter run --dart-define=API_BASE_URL=http://localhost:1/x   # demonstreaza starea Error
flutter test
```

API-ul nu trimite headere CORS, deci in browser cererile sunt blocate. Pe web se ruleaza doar pentru verificare, cu
`flutter run -d chrome --web-browser-flag=--disable-web-security`.

## Structura

```
lib/
  core/          tema, ApiConfig, DataException, widget-uri reutilizabile (state views, butoane, chip-uri, imagini)
  domain/        entitati, LessonQuery (cautare/filtrare/sortare), contracte de repository
  data/          LearningDataSource (contract), LearningRemoteDataSource (HTTP + JSON), modele fromJson, repository-uri
  presentation/  home/ si course/: cubit + state, ecrane, widget-uri
```

## Fluxul datelor

```
Screen -> Cubit.load() -> LearningRepository (domain) -> LearningRepositoryImpl
  -> LearningRemoteDataSource: http GET -> bodyBytes -> UTF-8 + jsonDecode (isolate) -> Map
  -> HomeDataModel / CourseOverviewModel.fromJson -> entitate de domeniu
  -> Cubit emite State (loading / success / empty / error) -> BlocBuilder reconstruieste UI-ul
```

Erorile (fara internet, timeout de 60 s, status != 200, JSON invalid, camp cu alt tip) devin `DataException` cu un mesaj
afisat in `ErrorView`, cu buton "Try again".

## Stari

| Stare   | Unde se vede |
|---------|--------------|
| Loading | la pornire si la deschiderea cursului; dupa 5 s apare "The server may be waking up" (Render adoarme serverul) |
| Success | Home, lista de lectii |
| Empty   | cautare fara rezultat, filtrul Favorites gol, tab-ul Description (textul din API e gol) |
| Error   | fara retea, timeout, status HTTP gresit sau JSON invalid, cu buton "Try again" |

## Functionalitati

Cautare dupa titlu, filtre (All / Available / Locked / Favorites), sortare (ordine curs, titlu A-Z / Z-A, durata),
favorite persistente (SharedPreferences), pagina de detalii lectie cu "Next lesson", Enroll.
