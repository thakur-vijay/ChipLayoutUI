# ChipLayoutUI 🧩

A lightweight SwiftUI package that provides a **flexible, wrapping layout**
for building chip-style interfaces with clean alignment and spacing control.

Perfect for tags, categories, filters, or any horizontally flowing content.

------------------------------------------------------------------------

## ✨ Why ChipLayoutUI?

ChipLayoutUI gives you a **native SwiftUI-like API** for building layouts
that automatically wrap content across multiple rows.

- ⚡ Zero boilerplate usage
- 🔁 Automatic line wrapping
- 🎯 Alignment control (leading, center, trailing)
- 📏 Configurable spacing
- 🧩 Built using SwiftUI `Layout` protocol (iOS 16+)
- 🎨 Clean and minimal API

------------------------------------------------------------------------

## 📱 Demo

_Add your demo GIF or screenshots here_

------------------------------------------------------------------------

## 🚀 Installation

### Swift Package Manager

To integrate `ChipLayoutUI` using Swift Package Manager, add:

```swift
dependencies: [
    .package(url: "https://github.com/thakur-vijay/ChipLayoutUI.git", from: "1.0.0")
]
```

Then add to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: ["ChipLayoutUI"]
)
```

Or in Xcode:

```
File → Add Package Dependencies…
```

Repository URL:

```
https://github.com/thakur-vijay/ChipLayoutUI.git
```

------------------------------------------------------------------------

## 📦 Import

```swift
import ChipLayoutUI
```

------------------------------------------------------------------------

## 🛠 Requirements

- iOS 16.0+
- SwiftUI

------------------------------------------------------------------------

## 💡 Usage

```swift
import SwiftUI
import ChipLayoutUI

struct ContentView: View {
    var body: some View {
        ChipLayoutUI {
            Text("Swift")
            Text("iOS")
            Text("SwiftUI")
            Text("Layout")
        }
    }
}
```

------------------------------------------------------------------------

## ⚙️ Configuration Options

| Parameter   | Description                      |
|------------|----------------------------------|
| `alignment`| Row alignment (.leading/.center/.trailing) |
| `spacing`  | Space between items and rows     |

------------------------------------------------------------------------

## 🧠 How It Works

- Custom SwiftUI `Layout`
- Dynamic row generation
- Measures and wraps views based on width
- Applies alignment per row

------------------------------------------------------------------------

## 🎯 Best Practices

- Use for small, flexible content (chips/tags)
- Avoid very large views inside layout
- Keep spacing consistent for better UI

------------------------------------------------------------------------

## 📄 License

MIT License

## ⭐ Support

If you find this project useful:

- ⭐ Star the repository
- 🚀 Share it with other developers

