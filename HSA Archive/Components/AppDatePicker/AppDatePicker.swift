//
//  AppDatePicker.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/23/26.
//

import SwiftUI

struct AppDatePicker: View {
    @Binding private var selection: Date
    @FocusState private var isFocused: Bool
    private let prompt: String
    private let displayedComponents: DatePicker.Components
    private let isLoading: Bool
    private let viewID = UUID().uuidString
    
    private var menuLabelSelection: Selection {
        .init(title: selection.formatted(date: .abbreviated, time: .omitted))
    }
    
    init(
        _ prompt: String,
        selection: Binding<Date>,
        displayedComponents: DatePicker.Components = .date,
        isLoading: Bool = false
    ) {
        self._selection = selection
        self.prompt = prompt
        self.displayedComponents = displayedComponents
        self.isLoading = isLoading
    }
    
    var body: some View {
        content
            .toolbar {
                if isFocused {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { isFocused = false }
                    }
                }
            }
    }
}

// MARK: - Private Views

private extension AppDatePicker {
    var content: some View {
        InputContainer(
            prompt,
            action: {
                guard !isLoading else { return }
                isFocused = true
            }
        ) {
            MenuLabel(selection: menuLabelSelection)
                .background(focusProxy)
                .redactedShimmer(isShimmering: isLoading)
        }
    }
    
    var focusProxy: some View {
        TextField(
            viewID,
            text: .constant(selection.formatted(date: .abbreviated, time: .omitted))
        )
        .focused($isFocused)
        .multilineTextAlignment(.trailing)
        .overlay {
            InputAccessoryInjector(id: viewID) {
                datePicker
            }
        }
        .opacity(0)
    }
    
    var datePicker: some View {
        DatePicker(
            "",
            selection: $selection,
            displayedComponents: displayedComponents
        )
        .labelsHidden()
        .datePickerStyle(.wheel)
    }
}

// MARK: - InputAccessoryHostView

private class InputAccessoryHostView: UIView {
    let id: String
    let content: AnyView
    
    init(id: String, content: AnyView) {
        self.id = id
        self.content = content
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let window,
              let textField = window.allSubViews(type: UITextField.self).first(where: {
                  $0.placeholder == id
              }) else { return }
        textField.tintColor = .clear
        let hostView = UIHostingController(rootView: content).view!
        hostView.backgroundColor = .clear
        hostView.frame.size = hostView.intrinsicContentSize
        textField.inputView = hostView
        textField.reloadInputViews()
    }
}

// MARK: - InputAccessoryInjector

private struct InputAccessoryInjector<Content: View>: UIViewRepresentable {
    let content: Content
    let id: String
    
    init(id: String, @ViewBuilder content: () -> Content) {
        self.id = id
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIView {
        InputAccessoryHostView(id: id, content: AnyView(content))
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - allSubViews Extension

private extension UIView {
    func allSubViews<T: UIView>(type: T.Type) -> [T] {
        var resultViews = subviews.compactMap { $0 as? T }
        for view in subviews {
            resultViews.append(contentsOf: view.allSubViews(type: type))
        }
        return resultViews
    }
}

// MARK: - Previews

#Preview {
    PreviewInput {
        AppDatePicker(
            "Prompt",
            selection: .constant(.now),
            isLoading: true
        )
        AppDatePicker(
            "Prompt",
            selection: .constant(.now)
        )
    }
}
