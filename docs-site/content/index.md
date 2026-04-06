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

## Browse Libraries

| Library | Description | |
|---------|-------------|-|
| [**dart:core**](/api/dart-core/) | Fundamental types - num, String, List, Map, Set, Iterable, RegExp, DateTime, Duration | [Browse ->](/api/dart-core/) |
| [**dart:async**](/api/dart-async/) | Asynchronous programming - Future, Stream, Completer, Timer, Zone | [Browse ->](/api/dart-async/) |
| [**dart:collection**](/api/dart-collection/) | Specialized collections - HashMap, LinkedList, Queue, SplayTreeMap | [Browse ->](/api/dart-collection/) |
| [**dart:convert**](/api/dart-convert/) | Encoders and decoders - JSON, UTF-8, Base64, Latin-1, custom codecs | [Browse ->](/api/dart-convert/) |
| [**dart:io**](/api/dart-io/) | I/O for servers and CLI - File, Directory, HttpClient, Socket, Process | [Browse ->](/api/dart-io/) |
| [**dart:math**](/api/dart-math/) | Math constants and functions - Random, Point, Rectangle, min, max, sqrt | [Browse ->](/api/dart-math/) |
| [**dart:typed_data**](/api/dart-typed_data/) | Efficient binary data - ByteBuffer, Uint8List, Float64List | [Browse ->](/api/dart-typed_data/) |
| [**dart:developer**](/api/dart-developer/) | Debugging and profiling - Timeline, debugger, ServiceExtension | [Browse ->](/api/dart-developer/) |

### VM Libraries

| Library | Description | |
|---------|-------------|-|
| [**dart:io**](/api/dart-io/) | File system, HTTP, sockets, processes, platform detection | [Browse ->](/api/dart-io/) |
| [**dart:isolate**](/api/dart-isolate/) | Concurrent programming with isolated memory spaces | [Browse ->](/api/dart-isolate/) |
| [**dart:ffi**](/api/dart-ffi/) | Foreign function interface for calling C code | [Browse ->](/api/dart-ffi/) |

### Web Libraries

| Library | Description | |
|---------|-------------|-|
| [**dart:js_interop**](/api/dart-js_interop/) | Type-safe JavaScript interop | [Browse ->](/api/dart-js_interop/) |
| [**dart:html**](/api/dart-html/) | DOM manipulation, events, HTTP requests (legacy) | [Browse ->](/api/dart-html/) |

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
