# Real-Time SSE Trading App (Sarmayex Interview Task)

A robust, real-time cryptocurrency market application built with Flutter. This project strictly
implements a **manual Server-Sent Events (SSE)** connection architecture without relying on
third-party SSE packages, adhering to Clean Architecture principles.

## 🏗️ Architecture & Core Decisions

The application is structured using **Clean Architecture** (Presentation, Domain, Data) and the *
*Repository Pattern** to ensure strict separation of concerns.

### 1. Manual SSE Implementation (`BaseSseClient`)

- **No Third-Party SSE Packages**: Implemented custom SSE parsing from the ground up using
  `dart:convert` (`LineSplitter` and `utf8.decoder`) combined with Dart Streams.
- **Web-Safe Streaming**: Chose `package:http` (`HttpSseClient`) as the primary client. Natively,
  `Dio`'s `ResponseType.stream` has well-known blocking limitations on Flutter Web due to XHR
  constraints. The `http` package falls back to the modern `Fetch` API, perfectly supporting
  continuous SSE chunking across all platforms (Mobile & Web).
- **Graceful Parsing**: Reads stream chunks, specifically filtering lines starting with `data: `,
  and parses the JSON payloads cleanly while aggressively catching format exceptions to prevent
  silent stream death.

### 2. Stream Multiplexing & Repository Pattern

- **Single Source of Truth**: The `MarketRepository` maintains a single active
  `StreamController.broadcast()` through the Data Source.
- **Decoupled Features**: Both the `MarketBloc` (handling the Markets List) and `OrderBookBloc` (
  handling Bids/Asks) listen to the **exact same shared stream**.
- **Event Filtering**: Instead of creating duplicate network connections, `MarketBloc` filters for
  `"markets"` events, and `OrderBookBloc` filters for `"order_book"` events. This saves memory,
  bandwidth, and prevents "stream already listened to" errors.

### 3. State Management (`flutter_bloc`)

- **Targeted Rebuilds**: Uses `BlocBuilder` combined with strict `buildWhen` logic. High-frequency
  SSE updates only trigger rebuilds for the specific UI components (e.g., the exact Order Book list)
  rather than re-rendering the whole page.
- **Dynamic Market Switching**: Tapping a new market symbol commands the Repository to safely
  `.disconnect()` the old URL and `.reconnect()` to the new one, automatically flushing the BLoCs
  without dropping the listeners.

### 4. Lifecycle & Robustness

- **App Lifecycle Handling**: Integrated `WidgetsBindingObserver` in the presentation layer to
  disconnect the stream when the app goes into the background, and seamlessly reconnect when
  foregrounded.
- **Reconnection Logic**: The `BaseSseClient` implements a recursive timer fallback. If the
  connection drops or fails to start, it safely clears the active socket/URL and schedules a
  reconnect attempt every 3 seconds, emitting `connectionStateStream` updates so the UI can clear
  stale order book data.

## 🚀 Getting Started

```bash
# Fetch dependencies
flutter pub get

# Run on Web (Recommended for observing Fetch stream capabilities)
flutter run -d chrome

# Run on Mobile
flutter run
```

## 🛠 Tech Stack

- **Flutter** & **Dart**
- **flutter_test** (testing sse connection and event receiving)
- **flutter_bloc** (State Management)
- **get_it** (Dependency Injection)
- **http** (Raw chunked stream parsing)
- **equatable** (State comparisons)