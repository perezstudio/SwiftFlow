//
//  TypeSelector.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A picker for selecting Swift types
struct TypeSelector: View {
    @Binding var selectedType: TypeDefinition
    var allowOptional: Bool = true
    var allowArray: Bool = true
    var customTypes: [String] = []

    @State private var showingCustomTypeSheet = false
    @State private var customTypeName = ""

    var body: some View {
        HStack(spacing: 8) {
            // Base type picker
            Picker("Type", selection: baseTypeBinding) {
                Section("Primitives") {
                    Text("String").tag(BaseType.string)
                    Text("Int").tag(BaseType.int)
                    Text("Double").tag(BaseType.double)
                    Text("Bool").tag(BaseType.bool)
                }

                Section("Foundation") {
                    Text("Date").tag(BaseType.date)
                    Text("Data").tag(BaseType.data)
                    Text("URL").tag(BaseType.url)
                    Text("UUID").tag(BaseType.uuid)
                }

                Section("SwiftUI") {
                    Text("Color").tag(BaseType.color)
                    Text("Image").tag(BaseType.image)
                }

                Section("Other") {
                    Text("Any").tag(BaseType.any)
                    Text("Void").tag(BaseType.void)
                    if !customTypes.isEmpty {
                        ForEach(customTypes, id: \.self) { typeName in
                            Text(typeName).tag(BaseType.custom)
                        }
                    }
                    Text("Custom...").tag(BaseType.custom)
                }
            }
            .labelsHidden()
            .frame(minWidth: 100)

            // Optional toggle
            if allowOptional {
                Toggle("?", isOn: optionalBinding)
                    .toggleStyle(.checkbox)
                    .help("Optional")
            }

            // Array toggle
            if allowArray {
                Toggle("[]", isOn: arrayBinding)
                    .toggleStyle(.checkbox)
                    .help("Array")
            }
        }
        .sheet(isPresented: $showingCustomTypeSheet) {
            CustomTypeSheet(
                typeName: $customTypeName,
                onConfirm: {
                    if !customTypeName.isEmpty {
                        selectedType = .custom(customTypeName)
                    }
                    showingCustomTypeSheet = false
                },
                onCancel: {
                    showingCustomTypeSheet = false
                }
            )
        }
    }

    private var baseTypeBinding: Binding<BaseType> {
        Binding(
            get: { selectedType.baseType },
            set: { newValue in
                if newValue == .custom && selectedType.customTypeName == nil {
                    showingCustomTypeSheet = true
                } else {
                    selectedType = TypeDefinition(
                        baseType: newValue,
                        genericParameters: selectedType.genericParameters,
                        isOptional: selectedType.isOptional,
                        customTypeName: newValue == .custom ? selectedType.customTypeName : nil
                    )
                }
            }
        )
    }

    private var optionalBinding: Binding<Bool> {
        Binding(
            get: { selectedType.isOptional },
            set: { newValue in
                selectedType = TypeDefinition(
                    baseType: selectedType.baseType,
                    genericParameters: selectedType.genericParameters,
                    isOptional: newValue,
                    customTypeName: selectedType.customTypeName
                )
            }
        )
    }

    private var arrayBinding: Binding<Bool> {
        Binding(
            get: {
                selectedType.baseType == .array
            },
            set: { isArray in
                if isArray {
                    // Wrap current type in array
                    let innerType = selectedType
                    selectedType = .array(of: innerType)
                } else {
                    // Unwrap from array
                    if let innerTypes = selectedType.genericParameters, let first = innerTypes.first {
                        selectedType = first
                    }
                }
            }
        )
    }
}

/// Sheet for entering a custom type name
private struct CustomTypeSheet: View {
    @Binding var typeName: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Custom Type")
                .font(.headline)

            CustomTextField("Type name", text: $typeName, isMonospaced: true)

            HStack {
                Button("Cancel", action: onCancel)
                    .keyboardShortcut(.cancelAction)

                Button("Add", action: onConfirm)
                    .keyboardShortcut(.defaultAction)
                    .disabled(typeName.isEmpty)
            }
        }
        .padding()
        .frame(width: 250)
    }
}

/// A compact type display (read-only)
struct TypeBadge: View {
    let type: TypeDefinition

    var body: some View {
        Text(type.toSwiftCode())
            .font(.system(size: 11, design: .monospaced))
            .foregroundStyle(.cyan)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.cyan.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

/// A simplified type picker for common cases
struct SimpleTypeSelector: View {
    @Binding var selectedType: TypeDefinition

    var body: some View {
        Picker("Type", selection: $selectedType) {
            Text("String").tag(TypeDefinition.string)
            Text("Int").tag(TypeDefinition.int)
            Text("Double").tag(TypeDefinition.double)
            Text("Bool").tag(TypeDefinition.bool)
            Text("Date").tag(TypeDefinition.date)
        }
        .labelsHidden()
    }
}

#Preview {
    VStack(spacing: 20) {
        TypeSelector(selectedType: .constant(.string))

        TypeSelector(selectedType: .constant(.optional(.int)))

        TypeSelector(selectedType: .constant(.array(of: .string)))

        Divider()

        HStack {
            Text("Type:")
            TypeBadge(type: .string)
            TypeBadge(type: .optional(.int))
            TypeBadge(type: .array(of: .custom("Item")))
        }

        Divider()

        SimpleTypeSelector(selectedType: .constant(.string))
    }
    .padding()
}
