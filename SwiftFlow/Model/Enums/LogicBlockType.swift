//
//  LogicBlockType.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation

/// All available logic block types for the workflow/query editor
enum LogicBlockType: String, Codable, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    // MARK: - Variables
    case declareVariable
    case assignVariable
    case declareConstant

    // MARK: - Control Flow
    case ifStatement
    case elseIfStatement
    case elseStatement
    case guardStatement
    case switchStatement
    case caseStatement
    case defaultCase
    case forLoop
    case forEachLoop
    case whileLoop
    case repeatWhileLoop
    case breakStatement
    case continueStatement
    case returnStatement
    case fallthroughStatement

    // MARK: - SwiftData Operations
    case modelContextInsert
    case modelContextDelete
    case modelContextSave
    case fetchDescriptor
    case sortDescriptor
    case predicate
    case fetchRequest

    // MARK: - Network/API
    case urlRequest
    case urlSessionDataTask
    case jsonDecode
    case jsonEncode
    case httpHeader
    case httpBody

    // MARK: - Async/Concurrency
    case asyncAwait
    case taskBlock
    case taskGroup
    case withCheckedContinuation
    case withCheckedThrowingContinuation
    case mainActor
    case detachedTask

    // MARK: - Error Handling
    case doTryCatch
    case throwError
    case catchBlock
    case resultSuccess
    case resultFailure

    // MARK: - Collection Operations
    case mapOperation
    case filterOperation
    case reduceOperation
    case compactMapOperation
    case flatMapOperation
    case sortOperation
    case firstWhere
    case contains
    case forEach
    case appendToArray
    case removeFromArray
    case insertIntoArray

    // MARK: - Optional Handling
    case optionalBinding
    case nilCoalescing
    case optionalChaining
    case forceUnwrap

    // MARK: - String Operations
    case stringInterpolation
    case stringConcat
    case stringSplit
    case stringReplace
    case stringTrim
    case stringLowercase
    case stringUppercase

    // MARK: - Math Operations
    case add
    case subtract
    case multiply
    case divide
    case modulo
    case power
    case squareRoot
    case absolute
    case round
    case floor
    case ceil
    case random

    // MARK: - Comparison
    case equal
    case notEqual
    case lessThan
    case greaterThan
    case lessOrEqual
    case greaterOrEqual

    // MARK: - Logical
    case andOperator
    case orOperator
    case notOperator

    // MARK: - Date/Time
    case currentDate
    case dateFormat
    case dateComponents
    case dateComparison
    case timeInterval

    // MARK: - Utility
    case print
    case comment
    case customCode
    case functionCall
    case closure

    // MARK: - Display Properties

    var displayName: String {
        switch self {
        case .declareVariable: return "Declare Variable"
        case .assignVariable: return "Assign Variable"
        case .declareConstant: return "Declare Constant"
        case .ifStatement: return "If"
        case .elseIfStatement: return "Else If"
        case .elseStatement: return "Else"
        case .guardStatement: return "Guard"
        case .switchStatement: return "Switch"
        case .caseStatement: return "Case"
        case .defaultCase: return "Default"
        case .forLoop: return "For Loop"
        case .forEachLoop: return "For Each"
        case .whileLoop: return "While Loop"
        case .repeatWhileLoop: return "Repeat While"
        case .breakStatement: return "Break"
        case .continueStatement: return "Continue"
        case .returnStatement: return "Return"
        case .fallthroughStatement: return "Fallthrough"
        case .modelContextInsert: return "Insert Model"
        case .modelContextDelete: return "Delete Model"
        case .modelContextSave: return "Save Context"
        case .fetchDescriptor: return "Fetch Descriptor"
        case .sortDescriptor: return "Sort Descriptor"
        case .predicate: return "Predicate"
        case .fetchRequest: return "Fetch Request"
        case .urlRequest: return "URL Request"
        case .urlSessionDataTask: return "URL Session Task"
        case .jsonDecode: return "JSON Decode"
        case .jsonEncode: return "JSON Encode"
        case .httpHeader: return "HTTP Header"
        case .httpBody: return "HTTP Body"
        case .asyncAwait: return "Async/Await"
        case .taskBlock: return "Task"
        case .taskGroup: return "Task Group"
        case .withCheckedContinuation: return "Checked Continuation"
        case .withCheckedThrowingContinuation: return "Throwing Continuation"
        case .mainActor: return "Main Actor"
        case .detachedTask: return "Detached Task"
        case .doTryCatch: return "Do/Try/Catch"
        case .throwError: return "Throw Error"
        case .catchBlock: return "Catch"
        case .resultSuccess: return "Result Success"
        case .resultFailure: return "Result Failure"
        case .mapOperation: return "Map"
        case .filterOperation: return "Filter"
        case .reduceOperation: return "Reduce"
        case .compactMapOperation: return "Compact Map"
        case .flatMapOperation: return "Flat Map"
        case .sortOperation: return "Sort"
        case .firstWhere: return "First Where"
        case .contains: return "Contains"
        case .forEach: return "For Each"
        case .appendToArray: return "Append to Array"
        case .removeFromArray: return "Remove from Array"
        case .insertIntoArray: return "Insert into Array"
        case .optionalBinding: return "Optional Binding"
        case .nilCoalescing: return "Nil Coalescing"
        case .optionalChaining: return "Optional Chaining"
        case .forceUnwrap: return "Force Unwrap"
        case .stringInterpolation: return "String Interpolation"
        case .stringConcat: return "String Concat"
        case .stringSplit: return "String Split"
        case .stringReplace: return "String Replace"
        case .stringTrim: return "String Trim"
        case .stringLowercase: return "Lowercase"
        case .stringUppercase: return "Uppercase"
        case .add: return "Add"
        case .subtract: return "Subtract"
        case .multiply: return "Multiply"
        case .divide: return "Divide"
        case .modulo: return "Modulo"
        case .power: return "Power"
        case .squareRoot: return "Square Root"
        case .absolute: return "Absolute"
        case .round: return "Round"
        case .floor: return "Floor"
        case .ceil: return "Ceiling"
        case .random: return "Random"
        case .equal: return "Equal"
        case .notEqual: return "Not Equal"
        case .lessThan: return "Less Than"
        case .greaterThan: return "Greater Than"
        case .lessOrEqual: return "Less or Equal"
        case .greaterOrEqual: return "Greater or Equal"
        case .andOperator: return "And"
        case .orOperator: return "Or"
        case .notOperator: return "Not"
        case .currentDate: return "Current Date"
        case .dateFormat: return "Format Date"
        case .dateComponents: return "Date Components"
        case .dateComparison: return "Compare Dates"
        case .timeInterval: return "Time Interval"
        case .print: return "Print"
        case .comment: return "Comment"
        case .customCode: return "Custom Code"
        case .functionCall: return "Function Call"
        case .closure: return "Closure"
        }
    }

    var category: LogicBlockCategory {
        switch self {
        case .declareVariable, .assignVariable, .declareConstant:
            return .variables
        case .ifStatement, .elseIfStatement, .elseStatement, .guardStatement, .switchStatement, .caseStatement, .defaultCase, .forLoop, .forEachLoop, .whileLoop, .repeatWhileLoop, .breakStatement, .continueStatement, .returnStatement, .fallthroughStatement:
            return .controlFlow
        case .modelContextInsert, .modelContextDelete, .modelContextSave, .fetchDescriptor, .sortDescriptor, .predicate, .fetchRequest:
            return .swiftData
        case .urlRequest, .urlSessionDataTask, .jsonDecode, .jsonEncode, .httpHeader, .httpBody:
            return .network
        case .asyncAwait, .taskBlock, .taskGroup, .withCheckedContinuation, .withCheckedThrowingContinuation, .mainActor, .detachedTask:
            return .async
        case .doTryCatch, .throwError, .catchBlock, .resultSuccess, .resultFailure:
            return .errorHandling
        case .mapOperation, .filterOperation, .reduceOperation, .compactMapOperation, .flatMapOperation, .sortOperation, .firstWhere, .contains, .forEach, .appendToArray, .removeFromArray, .insertIntoArray:
            return .collections
        case .optionalBinding, .nilCoalescing, .optionalChaining, .forceUnwrap:
            return .optionals
        case .stringInterpolation, .stringConcat, .stringSplit, .stringReplace, .stringTrim, .stringLowercase, .stringUppercase:
            return .strings
        case .add, .subtract, .multiply, .divide, .modulo, .power, .squareRoot, .absolute, .round, .floor, .ceil, .random:
            return .math
        case .equal, .notEqual, .lessThan, .greaterThan, .lessOrEqual, .greaterOrEqual:
            return .comparison
        case .andOperator, .orOperator, .notOperator:
            return .logical
        case .currentDate, .dateFormat, .dateComponents, .dateComparison, .timeInterval:
            return .dateTime
        case .print, .comment, .customCode, .functionCall, .closure:
            return .utility
        }
    }

    var canHaveChildren: Bool {
        switch self {
        case .ifStatement, .elseIfStatement, .elseStatement, .guardStatement, .switchStatement, .caseStatement, .defaultCase, .forLoop, .forEachLoop, .whileLoop, .repeatWhileLoop, .doTryCatch, .catchBlock, .taskBlock, .taskGroup, .mainActor, .detachedTask, .closure:
            return true
        default:
            return false
        }
    }

    var iconName: String {
        switch self {
        case .declareVariable, .assignVariable, .declareConstant:
            return "textformat.abc"
        case .ifStatement, .elseIfStatement, .elseStatement:
            return "questionmark.diamond"
        case .guardStatement:
            return "shield"
        case .switchStatement, .caseStatement, .defaultCase:
            return "arrow.triangle.branch"
        case .forLoop, .forEachLoop, .whileLoop, .repeatWhileLoop:
            return "repeat"
        case .breakStatement, .continueStatement:
            return "arrow.uturn.right"
        case .returnStatement:
            return "arrow.turn.up.left"
        case .modelContextInsert, .modelContextDelete, .modelContextSave:
            return "cylinder"
        case .fetchDescriptor, .fetchRequest, .sortDescriptor, .predicate:
            return "magnifyingglass"
        case .urlRequest, .urlSessionDataTask:
            return "network"
        case .jsonDecode, .jsonEncode:
            return "curlybraces"
        case .asyncAwait, .taskBlock, .taskGroup:
            return "clock.arrow.circlepath"
        case .doTryCatch, .throwError, .catchBlock:
            return "exclamationmark.triangle"
        case .mapOperation, .filterOperation, .reduceOperation:
            return "line.3.horizontal.decrease"
        case .print:
            return "text.quote"
        case .comment:
            return "text.bubble"
        case .customCode:
            return "chevron.left.forwardslash.chevron.right"
        default:
            return "square"
        }
    }
}

enum LogicBlockCategory: String, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    case variables
    case controlFlow
    case swiftData
    case network
    case async
    case errorHandling
    case collections
    case optionals
    case strings
    case math
    case comparison
    case logical
    case dateTime
    case utility

    var displayName: String {
        switch self {
        case .variables: return "Variables"
        case .controlFlow: return "Control Flow"
        case .swiftData: return "SwiftData"
        case .network: return "Network"
        case .async: return "Async"
        case .errorHandling: return "Error Handling"
        case .collections: return "Collections"
        case .optionals: return "Optionals"
        case .strings: return "Strings"
        case .math: return "Math"
        case .comparison: return "Comparison"
        case .logical: return "Logical"
        case .dateTime: return "Date & Time"
        case .utility: return "Utility"
        }
    }

    var blocks: [LogicBlockType] {
        LogicBlockType.allCases.filter { $0.category == self }
    }
}
