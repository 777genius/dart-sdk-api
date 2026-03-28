# Dart SDK API Guide

This guide provides a comprehensive overview of the Dart SDK libraries, explains key concepts, and helps you navigate the API reference effectively.

## What is the Dart SDK?

The Dart SDK ships with a rich set of standard libraries that cover everything from basic types and collections to asynchronous programming, file I/O, networking, and foreign function calls. These libraries form the foundation upon which all Dart and Flutter applications are built.

Unlike many languages where the standard library is a single monolith, Dart organizes its SDK into **focused libraries** that you import individually. This keeps your program lean — you only pay for what you use.

The libraries fall into three platform categories:

- **Core libraries** — available everywhere: VM, web, and Flutter
- **VM libraries** — server-side and CLI only (not available when compiled to JavaScript)
- **Web libraries** — browser-only (compiled to JavaScript via `dart compile js` or `webdev`)

## Try It Now

Run this example right here in the browser — click **Run** to see Dart in action:

```dartpad
import 'dart:math';

void main() {
  // Collections
  final languages = ['Dart', 'Kotlin', 'Swift', 'Rust', 'Go'];
  print('Languages: ${languages.join(", ")}');

  // Map & where
  final lengths = {for (final lang in languages) lang: lang.length};
  final short = lengths.entries.where((e) => e.value <= 4);
  print('Short names: ${short.map((e) => e.key).join(", ")}');

  // DateTime & Duration
  final now = DateTime.now();
  final future = now.add(Duration(days: 365));
  print('Today: ${now.toIso8601String().split("T").first}');
  print('In a year: ${future.toIso8601String().split("T").first}');

  // Random
  final rng = Random();
  final dice = List.generate(5, (_) => rng.nextInt(6) + 1);
  print('Dice rolls: $dice (sum: ${dice.reduce((a, b) => a + b)})');

  // Pattern matching (Dart 3)
  final json = {'name': 'Dart', 'version': 3.5};
  if (json case {'name': String name, 'version': num ver}) {
    print('$name version $ver');
  }
}
```

## Core Libraries

These libraries are available on all Dart platforms (VM, web, Flutter).

### dart:core — The Foundation

[Browse dart:core](/api/dart-core/)

The most fundamental library in the SDK. It provides the types you use in nearly every line of Dart code: `int`, `double`, `String`, `bool`, `List`, `Map`, `Set`, `Iterable`, `DateTime`, `Duration`, `RegExp`, `Uri`, and the core error/exception hierarchy.

**Unique trait:** `dart:core` is the only library auto-imported in every Dart file. You never write `import 'dart:core';` — it's always available.

Key areas:
- **Numbers**: `int`, `double`, `num` — Dart has no separate float/long types
- **Strings**: UTF-16 based, immutable, with rich pattern matching via `RegExp`
- **Collections**: `List` (growable array), `Map` (hash map), `Set` (unique elements)
- **Dates & Time**: `DateTime` for timestamps, `Duration` for intervals
- **Errors**: `Error` (programmer mistakes), `Exception` (recoverable conditions)
- **Type system**: `Type`, `Null`, `Object`, `dynamic`, `Never`

```dart
// dart:core is always available — no import needed
final greeting = 'Hello, Dart ${DateTime.now().year}!';
final numbers = [1, 2, 3, 4, 5];
final doubled = numbers.map((n) => n * 2).toList();
final unique = {...doubled}; // Set literal
final uri = Uri.parse('https://dart.dev/guides');
```

### dart:async — Futures and Streams

[Browse dart:async](/api/dart-async/)

The asynchronous programming backbone. Provides `Future` for single async results and `Stream` for sequences of async events. Nearly every I/O operation in Dart returns a `Future` or `Stream`.

Key classes:
- **`Future<T>`** — represents a value that will be available later. Use `async`/`await` syntax for readability
- **`Stream<T>`** — a sequence of asynchronous events (like an async `Iterable`). Supports `listen()`, `where()`, `map()`, `fold()`, `first`, `last`
- **`Completer<T>`** — manually create and complete a `Future`. Useful for bridging callback-based APIs
- **`Timer`** — schedule one-shot or periodic callbacks
- **`Zone`** — execution context for intercepting async operations, errors, and scheduling
- **`StreamController<T>`** — create custom streams, with single or broadcast modes

```dart
import 'dart:async';

// Future composition
Future<String> fetchUserName(int id) async {
  final response = await httpGet('/users/$id');
  return response.body['name'] as String;
}

// Stream processing
Stream<int> countdown(int from) async* {
  for (var i = from; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

// Completer for callback-to-future conversion
Future<String> readCallback() {
  final completer = Completer<String>();
  legacyApi.read(
    onSuccess: (data) => completer.complete(data),
    onError: (e) => completer.completeError(e),
  );
  return completer.future;
}
```

::: tip Stream types
A **single-subscription** stream (default) allows one listener. A **broadcast** stream allows many — use `StreamController.broadcast()` or `.asBroadcastStream()`. Choose wisely: single-subscription buffers events until listened to; broadcast drops events if nobody is listening.
:::

### dart:collection — Specialized Collections

[Browse dart:collection](/api/dart-collection/)

When `List`, `Map`, and `Set` from `dart:core` aren't enough, `dart:collection` provides specialized implementations with different performance characteristics.

Notable classes:
- **`HashMap`** / **`LinkedHashMap`** — hash-based maps; `LinkedHashMap` preserves insertion order (it's the default `Map` implementation)
- **`SplayTreeMap`** / **`SplayTreeSet`** — self-balancing trees with O(log n) operations and sorted iteration
- **`Queue`** / **`ListQueue`** / **`DoubleLinkedQueue`** — FIFO queues for efficient add/remove at both ends
- **`LinkedList`** — intrusive doubly-linked list where elements extend `LinkedListEntry`
- **`UnmodifiableListView`** / **`UnmodifiableMapView`** — read-only wrappers that throw on mutation

```dart
import 'dart:collection';

// Sorted map — keys always in order
final scores = SplayTreeMap<String, int>();
scores['Alice'] = 95;
scores['Bob'] = 87;
scores['Charlie'] = 92;
print(scores.keys); // (Alice, Bob, Charlie) — alphabetical

// Queue for BFS
final queue = Queue<int>();
queue.addLast(1);
queue.addLast(2);
final first = queue.removeFirst(); // 1

// Unmodifiable view — safe to expose from API
final internal = <String>['a', 'b', 'c'];
final public = UnmodifiableListView(internal);
// public.add('d'); // throws UnsupportedError
```

### dart:convert — Encoders and Decoders

[Browse dart:convert](/api/dart-convert/)

A codec-based encoding/decoding framework. The library provides ready-made codecs for JSON, UTF-8, Base64, Latin-1, and ASCII, plus a `Codec`/`Converter` base for building custom transformers.

Key constants and classes:
- **`json`** (`JsonCodec`) — `jsonEncode()` and `jsonDecode()` for JSON serialization
- **`utf8`** (`Utf8Codec`) — converts between `String` and `List<int>` (bytes)
- **`base64`** (`Base64Codec`) — Base64 encoding/decoding
- **`ascii`**, **`latin1`** — single-byte character encodings
- **`LineSplitter`** — splits strings on line breaks
- **`Codec<S, T>`** — base class for building fused encode/decode pipelines

```dart
import 'dart:convert';

// JSON round-trip
final data = {'name': 'Dart', 'version': 3, 'features': ['null-safety', 'sound-types']};
final jsonString = jsonEncode(data);
final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

// Streaming JSON decode (for large files)
final stream = File('large.json').openRead();
final objects = stream.transform(utf8.decoder).transform(json.decoder);

// Base64
final encoded = base64Encode(utf8.encode('Hello, Dart!'));
final original = utf8.decode(base64Decode(encoded));

// Fused codecs — single pass, no intermediate allocation
final fused = utf8.fuse(json);
final bytes = fused.encode({'key': 'value'});
```

### dart:math — Math and Random

[Browse dart:math](/api/dart-math/)

Mathematical constants, functions, random number generation, and 2D geometry primitives.

What's inside:
- **Constants**: `pi`, `e`, `sqrt2`, `ln2`, `ln10`, `log2e`, `log10e`
- **Functions**: `min()`, `max()`, `sqrt()`, `pow()`, `log()`, `exp()`, `sin()`, `cos()`, `tan()`, `asin()`, `acos()`, `atan()`, `atan2()`
- **`Random`** — pseudo-random number generator. Use `Random.secure()` for cryptographic randomness
- **`Point<T>`** — immutable 2D point with distance calculations
- **`Rectangle<T>`** — axis-aligned rectangle with intersection and containment tests

```dart
import 'dart:math';

final rng = Random();
final roll = rng.nextInt(6) + 1; // 1..6

// Secure random for tokens
final secure = Random.secure();
final token = List.generate(32, (_) => secure.nextInt(256))
    .map((b) => b.toRadixString(16).padLeft(2, '0'))
    .join();

// Geometry
final a = Point(0, 0);
final b = Point(3, 4);
print(a.distanceTo(b)); // 5.0

final rect = Rectangle(0, 0, 100, 50);
print(rect.containsPoint(Point(10, 10))); // true
```

### dart:typed_data — Binary Data

[Browse dart:typed_data](/api/dart-typed_data/)

Fixed-size, typed lists for efficient binary data processing. Essential for file formats, network protocols, image processing, and interop with native code.

Key types:
- **`Uint8List`** — unsigned bytes (the most common binary buffer)
- **`Int32List`**, **`Float64List`**, etc. — typed arrays for specific numeric types
- **`ByteData`** — raw byte access with explicit endianness control
- **`ByteBuffer`** — the underlying memory block shared across typed list views

```dart
import 'dart:typed_data';

// Create a buffer and write structured data
final buffer = ByteData(12);
buffer.setUint32(0, 0xDEADBEEF, Endian.big);
buffer.setFloat64(4, 3.14159, Endian.little);

// View the same memory as bytes
final bytes = buffer.buffer.asUint8List();
```

::: tip
`dart:core` is auto-imported in every Dart file. All other libraries require an explicit `import` statement:
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:collection';
```
:::

## VM Libraries

Available only when running on the Dart VM or in Flutter (not compiled to JavaScript).

### dart:io — Files, HTTP, and Processes

[Browse dart:io](/api/dart-io/)

The workhorse library for server-side Dart. Covers file system access, HTTP clients and servers, TCP/UDP sockets, WebSockets, processes, and platform information.

Key areas:
- **File system**: `File`, `Directory`, `Link`, `FileSystemEntity` — full CRUD with sync and async APIs
- **HTTP**: `HttpClient` for outbound requests; `HttpServer` for building servers
- **Sockets**: `Socket` (TCP), `RawDatagramSocket` (UDP), `WebSocket`
- **Process**: `Process.run()` and `Process.start()` for spawning system commands
- **Platform**: `Platform.isLinux`, `Platform.environment`, `Platform.executable`
- **Stdin/Stdout**: `stdin`, `stdout`, `stderr` for console I/O

```dart
import 'dart:io';
import 'dart:convert';

// File operations
final file = File('config.json');
if (await file.exists()) {
  final config = jsonDecode(await file.readAsString());
  print('App: ${config['name']}');
}

// Simple HTTP server
final server = await HttpServer.bind('localhost', 8080);
print('Listening on http://localhost:8080');
await for (final request in server) {
  request.response
    ..headers.contentType = ContentType.json
    ..write(jsonEncode({'status': 'ok', 'time': DateTime.now().toIso8601String()}))
    ..close();
}

// Run external command
final result = await Process.run('dart', ['--version']);
print(result.stdout);
```

### dart:isolate — Concurrency

[Browse dart:isolate](/api/dart-isolate/)

Dart's concurrency model is based on **isolates** — independent workers with their own memory heap. Isolates communicate exclusively via message passing (`SendPort` / `ReceivePort`), which prevents shared-state bugs like data races.

```dart
import 'dart:isolate';

// Simple isolate: compute Fibonacci in background
Future<int> computeFib(int n) async {
  final receivePort = ReceivePort();
  await Isolate.spawn((SendPort port) {
    int fib(int n) => n <= 1 ? n : fib(n - 1) + fib(n - 2);
    port.send(fib(n));
  }, receivePort.sendPort);
  return await receivePort.first as int;
}

// High-level API (Dart 2.19+)
final result = await Isolate.run(() {
  // Runs in a separate isolate
  return heavyComputation();
});
```

::: tip Isolate.run
Since Dart 2.19, `Isolate.run()` is the simplest way to offload CPU-intensive work. It spawns an isolate, runs the function, and returns the result — no manual port management needed.
:::

### dart:ffi — Native Interop

[Browse dart:ffi](/api/dart-ffi/)

Call C functions and access native memory directly from Dart. Used by packages like `sqlite3`, `realm`, and platform-specific integrations.

```dart
import 'dart:ffi';
import 'dart:io' show Platform;

// Load the platform-appropriate library
final path = Platform.isLinux ? 'libnative.so'
    : Platform.isMacOS ? 'libnative.dylib'
    : 'native.dll';
final dylib = DynamicLibrary.open(path);

// Look up a C function: int add(int a, int b)
final add = dylib.lookupFunction<
    Int32 Function(Int32, Int32),
    int Function(int, int)>('add');

print(add(3, 4)); // 7

// Allocate native memory
final pointer = calloc<Int32>(10);
pointer[0] = 42;
calloc.free(pointer);
```

## Web Libraries

For Dart code compiled to JavaScript via `dart compile js` or `webdev`.

### dart:js_interop — Type-Safe JS Interop

[Browse dart:js_interop](/api/dart-js_interop/)

The modern, recommended way to call JavaScript from Dart. Uses **extension types** to provide static type safety over JS objects without runtime overhead.

```dart
import 'dart:js_interop';

// Declare a JS function
@JS('console.log')
external void consoleLog(JSString message);

// Call it
consoleLog('Hello from Dart!'.toJS);

// Typed access to a JS object
@JS()
@staticInterop
class Window {}

extension on Window {
  external JSString get title;
  external void alert(JSString message);
}
```

::: warning Deprecated web libraries
`dart:html`, `dart:js`, `dart:js_util`, and the `dart.dom.*` libraries are deprecated.
Migrate to `dart:js_interop` + `package:web`. See the [JS interop migration guide](https://dart.dev/interop/js-interop/package-web).
:::

## Common Patterns & Recipes

### Error Handling

Dart separates `Error` (programmer mistakes — should not be caught) from `Exception` (recoverable conditions — should be caught and handled).

```dart
// Catch specific exceptions
try {
  final data = jsonDecode(input);
} on FormatException catch (e) {
  print('Invalid JSON: ${e.message}');
} on TypeError {
  print('Unexpected data type');
} catch (e, stackTrace) {
  print('Unknown error: $e');
  print(stackTrace);
}

// Custom exception
class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
```

### JSON Serialization

```dart
import 'dart:convert';

// Simple encode/decode
final json = jsonEncode({'name': 'Dart', 'version': 3});
final map = jsonDecode(json) as Map<String, dynamic>;

// Pretty print
final pretty = JsonEncoder.withIndent('  ').convert(map);

// Streaming decode for large files
import 'dart:io';
final stream = File('large.json')
    .openRead()
    .transform(utf8.decoder)
    .transform(json.decoder);
```

### Working with Dates

```dart
final now = DateTime.now();
final utc = DateTime.now().toUtc();
final parsed = DateTime.parse('2024-01-15T10:30:00Z');
final custom = DateTime(2024, 6, 15, 14, 30);

// Duration arithmetic
final tomorrow = now.add(Duration(days: 1));
final diff = tomorrow.difference(now); // Duration of 1 day

// Comparison
if (now.isBefore(tomorrow)) {
  print('Time moves forward');
}
```

### Regular Expressions

```dart
final email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
print(email.hasMatch('user@example.com')); // true

// Named groups
final version = RegExp(r'(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)');
final match = version.firstMatch('Dart 3.5.0')!;
print('Major: ${match.namedGroup('major')}'); // 3

// Replace all
final cleaned = input.replaceAll(RegExp(r'\s+'), ' ');
```

### Collections — Advanced Usage

```dart
// Extension methods on Iterable
final words = ['hello', 'dart', 'world'];
final lengths = words.map((w) => w.length); // (5, 4, 5)
final total = lengths.reduce((a, b) => a + b); // 14
final first = words.firstWhere((w) => w.startsWith('d')); // 'dart'

// Spread and collection-if/for
final base = [1, 2, 3];
final extended = [
  ...base,
  if (true) 4,
  for (var i = 5; i <= 7; i++) i,
]; // [1, 2, 3, 4, 5, 6, 7]

// Map operations
final inventory = {'apples': 5, 'bananas': 3};
inventory.update('apples', (v) => v + 1, ifAbsent: () => 1);
final keys = inventory.entries
    .where((e) => e.value > 3)
    .map((e) => e.key);
```

## Navigating This Site

- **Sidebar** — Libraries are grouped by platform category. Click any library to see its classes, functions, and types.
- **Search** — Press <kbd>Ctrl</kbd>+<kbd>K</kbd> (or <kbd>Cmd</kbd>+<kbd>K</kbd> on macOS) to open full-text search across all libraries.
- **Breadcrumbs** — Navigate up from any member page to its class, then to the library.
- **"On this page"** — The right-side outline shows headings within the current page. On large API pages, sections are collapsible.
- **Code blocks** — All code blocks have a copy button in the top-right corner.

## External Resources

- [Dart language documentation](https://dart.dev/language) — Language tour and specification
- [Dart library tour](https://dart.dev/libraries) — In-depth walkthrough of core libraries
- [Effective Dart](https://dart.dev/effective-dart) — Style, documentation, usage, and design guidelines
- [pub.dev](https://pub.dev) — Package repository for Dart and Flutter
- [DartPad](https://dartpad.dev) — Try Dart code directly in the browser
- [dart-lang/sdk](https://github.com/dart-lang/sdk) — SDK source code on GitHub
- [Dart blog](https://medium.com/dartlang) — Announcements, deep dives, and tutorials
