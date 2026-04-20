## 0.0.3

- Initial release of FlowBoxPopup.
- Support for custom popup decoration, animation curve, and barrier color.

## 0.0.4
- patch interface errors

## 1.0.0
- Remove custom `curve` and `reverseCurve`.
- Improve the interface update in `BoxDecoration` when hot-reload.
- Remove `FlowPopupDecoration` and replace it with `BoxDecoration`.
- Change the name from `childDecoration` to `boxDecoration`.
- Change the name from `popDecoration` to `popupDecoration`.
- Change the name from `popBuilder` to `popupBuilder`.
- Change the name from `childPadding` to `boxPadding` and remove popPadding.

## 1.0.1
- Improve the animation effects for a more seamless experience.
- Optimize popup closing: support dismiss via Navigator.pop(context)

## 1.0.3
- Improved morph animation effects:
- Fixed text wrapping issues when the popup is activated by fixing the layout of the trigger widget.
- Synchronized alignment eliminates content jerking during size changes.
- Optimized transition experience, maintaining a consistent and smooth interface from box to popup state.