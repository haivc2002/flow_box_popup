# 🌀 FlowBoxPopup

**FlowBoxPopup** is a custom Flutter widget that displays a **smooth expanding popup** from a child widget.  
It provides elegant transitions, flexible decoration customization (radius, border, shadow, color, padding), and seamless keyboard handling.

---

## 🚀 Features

✅ Smooth popup transition from a source widget (child).  
✅ Fully customizable appearance: radius, shadow, border, padding, background color.  
✅ Automatically centers popup on screen.  
✅ Supports closing via back button.  
✅ Measures popup content size dynamically before showing.  
✅ Handles keyboard visibility gracefully. 

---

## 📦 Class Overview

### `FlowBoxPopup`

The main widget that manages the popup display and animation.

#### Parameters

| Name | Type | Description |
|------|------|-------------|
| `child` | `Widget` | The base widget that triggers the popup when tapped. |
| `popBuilder` | `Widget Function(BuildContext)` | Builder for the popup content. |
| `childDecoration` | `FlowPopupDecoration?` | Custom style for the child widget. |
| `popDecoration` | `FlowPopupDecoration?` | Custom style for the popup window. |
| `duration` | `Duration` | Duration of the show/hide animation. |
| `curve` | `Curve?` | Curve used for the forward animation. |
| `reverseCurve` | `Curve?` | Curve used for the reverse animation. |

---

### `FlowPopupDecoration`

Defines the visual styling for both the popup and the trigger widget.

#### Parameters

| Name | Type | Description |
|------|------|-------------|
| `color` | `Color?` | Background color. |
| `border` | `Border?` | Optional border. |
| `boxShadows` | `BoxShadow` | Shadow applied to the container. |
| `radius` | `BorderRadius` | Corner radius. |
| `padding` | `EdgeInsetsGeometry` | Inner padding. |

---

## 💡 Example Usage

```dart
FlowBoxPopup(
  duration: const Duration(milliseconds: 400),
  curve: Curves.easeOutBack,
  childDecoration: FlowPopupDecoration(
    color: Colors.white,
    radius: BorderRadius.circular(12),
    boxShadows: BoxShadow(
      color: Colors.black26,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ),
  popDecoration: FlowPopupDecoration(
    color: Colors.white,
    radius: BorderRadius.circular(16),
    boxShadows: BoxShadow(
      color: Colors.black38,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.info_outline),
      SizedBox(width: 8),
      Text("Show popup"),
    ],
  ),
  popBuilder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        "This is the popup content!",
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 12),
      ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text("Close"),
      ),
    ],
  ),
)
```# flow_box_popup
