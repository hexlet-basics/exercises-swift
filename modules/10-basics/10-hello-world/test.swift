import Foundation
import HexletBasics

// TODO: Вывод тестов непонятный
let output = try Process().launch(with: "index.swift")
print(output)
assert(
  output == "Hello, World!",
  "Failed to compare output, received \(output)"
)
