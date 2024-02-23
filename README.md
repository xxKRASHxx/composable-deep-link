# ComposableDeepLink
ComposableDeepLink – is a Swift DSL library for handling deep links in a composable and flexible way.  
It provides an approach to deep link processing, allowing you to define complex deep link handling logic using a composition of smaller components.

## Features
-   Composable handlers for:
    - schemes 
    - hosts
    - paths 
    - parameters
-   Support for static and parameterized paths.
-   Easy-to-use syntax for defining deep link handling logic.

## Installation
You can integrate **ComposableDeepLink** into your project using:
- Swift Package Manager (SPM)
    - Add the following dependency to your `Package.swift`
        - `.package(url: "https://github.com/example/ComposableDeepLink", from:  "0.1.0")`
  - add `ComposableDeepLink` to your target's dependencies.
- Xcode project
    1. From the  **File**  menu, select  **Add Packages...**
    2. Enter "[https://github.com/xxKRASHxx/composable-deep-link](https://github.com/xxKRASHxx/composable-deep-link)" into the package repository URL text field
    3. Import library to the reqired target

## Usage
Here's a simple example demonstrating how to use ComposableDeepLink to handle deep links:
```swift
import ComposableDeepLink // 1. Import Library

enum DeepLinkResult { // 2. Define result type
  case foo(id: String)
  case bar
  case biz
}

let processor: DeepLinkResult = DeepLink { // 3. Compose handling
  Scheme("myapp") {
    Host("example.host.com") {
      Path("/foo/:id") { context in
        Handle { // Handle the deep link logic here
          guard let id = context.id else { return nil }
          return .foo(id: id)
        }
      }
    }
    Host("another.host.com") {
      Path("/bar") { context in
        Handle { // Handle the deep link logic here
          .bar
        }
      }
      Path("/bar/biz") { context in
        Handle { // Handle the deep link logic here
          .biz
        }
      }
    }
  }
}

if let result = processor.handle(url: deepLinkURL) {
  // 4. Do something with the result
}
```

## Contributing

Contributions are welcome!  
If you have any suggestions, feature requests, or bug reports, please open an issue or submit a pull request

## License

ComposableDeepLink is available under the MIT license.  
See the [LICENSE](LICENSE) file for more information.
