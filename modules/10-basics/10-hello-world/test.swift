import Foundation
import HexletBasics

let actual = try Process().launch(with: "index.swift")
let expected = "Hello, World!"

print(actual)

// TODO: возможно стоит подключить либу, которая сразу даёт понятный вывод
// чтобы не заниматся рукопашкой
assert(
  actual == expected,
  "\nExpected: \(expected)\nReceived: \(actual)"
)
