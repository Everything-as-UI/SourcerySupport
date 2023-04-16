//
//  File.swift
//  
//
//  Created by Denis Koryttsev on 15.04.23.
//

import Foundation
import DocumentUI
import SwiftLangUI
import SourceryRuntime

public func render(with context: TemplateContext, imports: [String]) -> String {
    guard let decl = context.types.protocols.first else { return "" }
    return "\(Mock(decl: decl, imports: imports))"
}


struct Mock: TextDocument {
    let decl: SourceryProtocol
    let imports: [String]

    var modifiers: [Keyword] {
        decl.modifiers.map(\.name).compactMap(Keyword.init(rawValue:))
    }

    var textBody: some TextDocument {
        Joined(separator: String.newline, elements: imports).endingWithNewline(2)
        Mark(name: decl.name + "Mock").endingWithNewline(2)
        DeclWithBody(decl: TypeDecl(name: decl.name + "Mock", modifiers: modifiers + [.final, .class], inherits: [decl.name])) {
            ForEach(decl.methods, separator: .newline) { fun in
                let name = fun.callName.startsUppercased()
                spyVars(for: fun, with: name).endingWithNewline()
                DeclWithBody(decl: fun.withModifiers(modifiers)) {
                    Joined(separator: String.newline) {
                        "invoked\(name) = true"
                        "invoked\(name)Count += 1"
                        if !fun.nonClosureParameters.isEmpty {
                            "invoked\(name)Parameters = \(fun.nonClosureArgsTuple)".endingWithNewline()
                            "invoked\(name)ParametersList += [\(fun.nonClosureArgsTuple)]"
                        }
                        ForEach(fun.closureArgs, separator: .newline) { (closureName, closure) in
                            if closure.args.isEmpty {
                                "if shouldInvoke\(name)\(closureName.startsUppercased()) { \(closureName)() }"
                            } else {
                                "if let args = stubbed\(name)\(closureName.startsUppercased())Args { \(closureName)(args) }"
                            }
                        }
                        if fun.throws {
                            "if let error = stubbed\(name)Error { throw error }"
                        }
                        if !fun.returnTypeName.isVoid {
                            "return stubbed\(name)Result"
                        }
                    }
                }
            }
        }
    }

    @TextDocumentBuilder
    func spyVars(for fun: SourceryRuntime.Method, with name: String) -> some TextDocument {
        Joined(separator: String.newline) {
            "var invoked\(name): Bool = false"
            "var invoked\(name)Count: Int = 0"
            if !fun.nonClosureParameters.isEmpty {
                """
                var invoked\(name)Parameters: \(fun.nonClosureArgsTupleDecl)?
                var invoked\(name)ParametersList = [\(fun.nonClosureArgsTupleDecl)]()
                """
            }
            ForEach(fun.closureArgs, separator: .newline) { (closureName, closure) in
                if closure.args.isEmpty {
                    "var shouldInvoke\(name)\(closureName.startsUppercased()) = false"
                } else {
                    "var stubbed\(name)\(closureName.startsUppercased())Args: \(closure.nonClosureArgsTupleDecl)?"
                }
            }
            if fun.throws {
                "var stubbed\(name)Error: Error!"
            }
            if !fun.returnTypeName.isVoid {
                "var stubbed\(name)Result: \(fun.returnTypeName.name)!"
            }
        }
    }
}

extension SourceryRuntime.Method {
    var nonClosureParameters: some Collection<MethodParameter> {
        parameters.lazy.filter { !$0.isClosure }
    }

    var nonClosureArgsTuple: some TextDocument {
        ForEach(nonClosureParameters, separator: .commaSpace, content: { $0.name })
            .parenthical(.round)
    }

    var nonClosureArgsTupleDecl: some TextDocument {
        let args = nonClosureParameters
        return Brackets(parenthesis: .round) {
            if args.count > 1 {
                ForEach(args, separator: .commaSpace, content: { "\($0.argumentLabel ?? $0.name): \($0.typeName.name)" })
            } else {
                args.first.map(\.typeName.description)
            }
        }
    }

    var closureArgs: [(name: String, closure: ClosureDecl)] {
        parameters.compactMap { arg -> (String, ClosureDecl)? in
            guard let closure = arg.typeName.closure else { return nil }
            let closureArgs = closure.parameters.map({ ClosureDecl.Arg(name: $0.argumentLabel ?? $0.name ?? "", type: $0.typeName.name) })
            return (arg.name, ClosureDecl(args: closureArgs, result: closure.returnTypeName.name))
        }
    }

    func withModifiers(_ modifiers: [Keyword]) -> Self {
        self
    }
}

extension SourceryRuntime.Method: TextDocument {
    var traits: [String] {
        var traits: [String] = []
        if `throws` {
            traits.append("throws")
        }
        if `rethrows` {
            traits.append("rethrows")
        }
        if isAsync {
            traits.append("async")
        }
        return traits
    }

    public var textBody: some TextDocument {
        ForEach(attributes, separator: .newline, content: { "@\($0.key)" }).endingWithNewline()
        ForEach(modifiers, separator: .space, content: { $0.asSource }).suffix(String.space)
        "func "
        shortName
        parameters.asSource
        ForEach(traits, separator: .space, content: { $0 }).prefix(String.space)
        if !returnTypeName.isVoid {
            returnTypeName.name.prefix(String.space + .arrow + .space)
        }
    }
}

extension ClosureDecl {
    var nonClosureArgsTuple: some TextDocument {
        let args = args.lazy.filter {
            $0.type.range(of: String.arrow) == nil
        }
        return ForEach(args, separator: .commaSpace, content: { $0.name })
    }

    var nonClosureArgsTupleDecl: some TextDocument {
        let args = args.lazy.filter {
            $0.type.range(of: String.arrow) == nil
        }
        return Brackets(parenthesis: .round) {
            if args.count > 1 {
                ForEach(args, separator: .commaSpace, content: { $0 })
            } else {
                args.first.map(\.type)
            }
        }
    }

    var closureArgs: [(name: String, closure: ClosureDecl)] {
        args.compactMap { arg -> (String, ClosureDecl)? in
            let parts = arg.type.components(separatedBy: "->")
            guard parts.count > 1 else { return nil }
            let closureArgs = parts[0].trimmingCharacters(in: .whitespaces.union(CharacterSet(charactersIn: "()")))
                .components(separatedBy: ",")
                .map({ $0.trimmingCharacters(in: .whitespaces) })
                .compactMap({ $0.isEmpty ? nil : Arg(type: $0) })
            let result = parts[1].trimmingCharacters(in: .whitespaces)
            return (arg.name, ClosureDecl(args: closureArgs, result: result))
        }
    }
}
