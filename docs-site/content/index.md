---
layout: home
title: "Dart"
description: "Beautiful, searchable API reference for the Dart SDK"
hero:
  name: "Dart"
  text: API Documentation
  tagline: Beautiful, searchable API reference for the Dart SDK
  actions:
    - theme: brand
      text: API Reference
      link: /api/
    - theme: alt
      text: Guide
      link: /guide/
    - theme: alt
      text: GitHub
      link: https://github.com/777genius/dart-sdk-api
features:
  - icon: "\U0001F9E9"
    title: "dart:core"
    details: Fundamental types - num, String, List, Map, Set, Iterable, RegExp, DateTime, Duration, and more.
  - icon: "\u231B"
    title: "dart:async"
    details: Asynchronous programming - Future, Stream, Completer, Timer, Zone, and scheduleMicrotask.
  - icon: "\U0001F4E6"
    title: "dart:collection"
    details: Specialized collections - HashMap, LinkedList, Queue, SplayTreeMap, UnmodifiableListView.
  - icon: "\U0001F504"
    title: "dart:convert"
    details: Encoders and decoders - JSON, UTF-8, Base64, Latin-1, and custom codecs.
  - icon: "\U0001F5C2\uFE0F"
    title: "dart:io"
    details: I/O for servers and CLI - File, Directory, HttpClient, Socket, Process, Platform.
  - icon: "\U0001F522"
    title: "dart:math"
    details: Mathematical constants and functions - Random, Point, Rectangle, min, max, sqrt, sin, cos.
---

## Core Libraries

| Library | Description | |
|---------|-------------|-|
| [**dart:core**](/api/dart-core/library) | Fundamental types - num, String, List, Map, Set, Iterable, RegExp, DateTime, Duration | [Browse dart:core ->](/api/dart-core/library) |
| [**dart:async**](/api/dart-async/library) | Asynchronous programming - Future, Stream, Completer, Timer, Zone, scheduleMicrotask | [Browse dart:async ->](/api/dart-async/library) |
| [**dart:collection**](/api/dart-collection/library) | Specialized collections - HashMap, LinkedList, Queue, SplayTreeMap, UnmodifiableListView | [Browse dart:collection ->](/api/dart-collection/library) |
| [**dart:convert**](/api/dart-convert/library) | Encoders and decoders - JSON, UTF-8, Base64, Latin-1, and custom codecs | [Browse dart:convert ->](/api/dart-convert/library) |
| [**dart:math**](/api/dart-math/library) | Mathematical constants and functions - Random, Point, Rectangle, min, max, sqrt, sin, cos | [Browse dart:math ->](/api/dart-math/library) |
| [**dart:typed_data**](/api/dart-typed_data/library) | Efficient binary data - ByteBuffer, Uint8List, Float64List, Int32List | [Browse dart:typed_data ->](/api/dart-typed_data/library) |
| [**dart:developer**](/api/dart-developer/library) | Debugging and profiling - Timeline, debugger, ServiceExtension | [Browse dart:developer ->](/api/dart-developer/library) |

## VM Libraries

| Library | Description | |
|---------|-------------|-|
| [**dart:io**](/api/dart-io/library) | File system, HTTP, sockets, processes, platform detection | [Browse dart:io ->](/api/dart-io/library) |
| [**dart:isolate**](/api/dart-isolate/library) | Concurrent programming with isolated memory spaces | [Browse dart:isolate ->](/api/dart-isolate/library) |
| [**dart:ffi**](/api/dart-ffi/library) | Foreign function interface for calling C code | [Browse dart:ffi ->](/api/dart-ffi/library) |

## Web Libraries

| Library | Description | |
|---------|-------------|-|
| [**dart:js_interop**](/api/dart-js_interop/library) | Type-safe JavaScript interop | [Browse dart:js_interop ->](/api/dart-js_interop/library) |
| [**dart:html**](/api/dart-html/library) | DOM manipulation, events, HTTP requests (legacy) | [Browse dart:html ->](/api/dart-html/library) |

## Quick Example

```dart
import 'dart:async';
import 'dart:convert';

void main() async {
  // Futures and async/await
  final response = await fetchData();

  // JSON encoding/decoding
  final data = jsonDecode(response);
  print('Name: ${data['name']}');

  // Streams
  Stream.periodic(Duration(seconds: 1), (i) => i)
    .take(5)
    .listen((value) => print('Tick: $value'));
}

Future<String> fetchData() async {
  await Future.delayed(Duration(milliseconds: 100));
  return '{"name": "Dart", "version": "3.x"}';
}
```

## Learn More

- [Dart SDK Guide](/guide/) - Comprehensive overview of all libraries
- [Official Dart Documentation](https://dart.dev/guides)
- [DartPad](https://dartpad.dev) - Try Dart in the browser
- [pub.dev](https://pub.dev) - Package ecosystem
