# 🌀 FlowBoxPopup

**FlowBoxPopup** is a custom Flutter widget that displays a **smooth expanding popup** from a child widget.  
It provides elegant transitions, flexible decoration customization (radius, border, shadow, color, padding), and seamless keyboard handling.

---

## Demo

<p align="center">
  <img src="https://raw.githubusercontent.com/haivc2002/flow_box_popup/main/demo/demo.gif"
       width="300"
       style="border-radius:12px;" />
  <br><b>Auto-loop demo animation</b>
</p>

## 🚀 Features

✅ Smooth popup transition from a source widget (child).  
✅ Fully customizable appearance using standard `BoxDecoration`.  
✅ Automatically centers popup on screen.  
✅ Supports closing via back button or tapping the barrier.  
✅ Measures popup content size dynamically before showing.  
✅ Handles keyboard visibility gracefully (shifts and shrinks to fit). 

---

## 📦 Class Overview

### `FlowBoxPopup`

The main widget that manages the popup display and animation.

#### Parameters

| Name | Type | Description |
|------|------|-------------|
| `child` | `Widget` | **Required.** The base widget that triggers the popup when tapped. |
| `popupBuilder` | `Widget Function(BuildContext)` | **Required.** Builder for the popup content. |
| `boxDecoration` | `BoxDecoration?` | Custom style for the child widget in its resting state. |
| `popupDecoration` | `BoxDecoration?` | Custom style for the popup window in its expanded state. |
| `boxPadding` | `EdgeInsetsGeometry` | Inner padding for the child widget content (Default: `EdgeInsets.all(8.0)`). |
| `duration` | `Duration` | Duration of the morph animation (Default: `350ms`). |
| `barrierColor` | `Color?` | The color of the dimmed background behind the popup. |

---

## 💡 Example Usage

```dart
FlowBoxPopup(
  duration: const Duration(milliseconds: 500),
  boxDecoration: BoxDecoration(
    color: Colors.blueAccent,
    borderRadius: BorderRadius.circular(16),
  ),
  popupDecoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 20,
        spreadRadius: 5,
      )
    ],
  ),
  boxPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  popupBuilder: (context) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Animated Popup',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text('This popup expands smoothly from the trigger widget.'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  ),
  child: const Text(
    "Tap to Expand",
    style: TextStyle(color: Colors.white),
  ),
)
```

