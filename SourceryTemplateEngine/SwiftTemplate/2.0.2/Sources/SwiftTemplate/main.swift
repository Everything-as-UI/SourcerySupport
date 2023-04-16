import Foundation
import SourceryRuntime

let context = ProcessInfo().context!
let types = context.types
let functions = context.functions
let type = context.types.typesByName
let argument = context.argument

print("\n", terminator: "");
 import TemplateKit 
print("\n\n", terminator: "");
print("\( render(with: context, imports: ["@testable import TemplateEngine_Example"]) )", terminator: "");
print("\n", terminator: "");