//
//  ModelContainer+SwiftFlow.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

extension ModelContainer {
    /// Creates the SwiftFlow model container with all required schemas
    @MainActor
    static var swiftFlow: ModelContainer {
        let schema = Schema([
            // Core
            Project.self,
            Asset.self,

            // View models
            ViewFile.self,
            ViewBlock.self,
            ViewModifier.self,
            ViewProperty.self,
            ViewFunction.self,

            // Data models
            DataModel.self,
            ModelVersion.self,
            ModelProperty.self,
            ModelRelationship.self,

            // Query models
            QueryFile.self,
            QueryProperty.self,
            QueryFunction.self,
            LogicBlock.self,

            // Supporting models
            Expression.self,
            FunctionParameter.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
            // CloudKit sync disabled for now - enable when CloudKit is configured:
            // cloudKitDatabase: .private("iCloud.com.swiftflow.app")
        )

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    /// Creates an in-memory model container for previews and testing
    @MainActor
    static var preview: ModelContainer {
        let schema = Schema([
            Project.self,
            Asset.self,
            ViewFile.self,
            ViewBlock.self,
            ViewModifier.self,
            ViewProperty.self,
            ViewFunction.self,
            DataModel.self,
            ModelVersion.self,
            ModelProperty.self,
            ModelRelationship.self,
            QueryFile.self,
            QueryProperty.self,
            QueryFunction.self,
            LogicBlock.self,
            Expression.self,
            FunctionParameter.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )

        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])

            // Create sample data for preview
            let context = container.mainContext

            let project = Project(name: "Sample Project")
            context.insert(project)

            // Add sample view file
            let viewFile = ViewFile(name: "ContentView")
            project.addViewFile(viewFile)

            // Add root block
            let rootBlock = ViewBlock(blockType: .vStack)
            viewFile.rootBlock = rootBlock

            // Add some child blocks
            let textBlock = ViewBlock(blockType: .text, sortOrder: 0)
            textBlock.textContent = "Hello, World!"
            rootBlock.addChild(textBlock)

            let buttonBlock = ViewBlock(blockType: .button, sortOrder: 1)
            buttonBlock.buttonLabel = "Tap Me"
            rootBlock.addChild(buttonBlock)

            // Add a state property
            let countProperty = ViewProperty.state(
                name: "count",
                type: .int,
                defaultValue: "0"
            )
            viewFile.addProperty(countProperty)

            // Add sample data model
            let dataModel = DataModel(name: "Item")
            project.addDataModel(dataModel)

            let version = ModelVersion(versionNumber: 1)
            dataModel.addVersion(version)

            let nameProperty = ModelProperty(
                name: "name",
                typeDefinition: .string
            )
            version.addProperty(nameProperty)

            let createdAtProperty = ModelProperty(
                name: "createdAt",
                typeDefinition: .date,
                defaultValue: "Date()"
            )
            version.addProperty(createdAtProperty)

            // Add sample query file
            let queryFile = QueryFile(name: "ItemStore")
            project.addQueryFile(queryFile)

            let itemsProperty = QueryProperty(
                name: "items",
                typeDefinition: .array(of: .custom("Item")),
                defaultValue: "[]"
            )
            queryFile.addProperty(itemsProperty)

            let fetchFunction = QueryFunction(
                name: "fetchItems",
                isAsync: true
            )
            queryFile.addFunction(fetchFunction)

            try? context.save()

            return container
        } catch {
            fatalError("Could not create preview ModelContainer: \(error)")
        }
    }
}
