import Foundation

public struct ProcessError: Swift.Error {
    public let terminationStatus: Int32
    /// The raw error buffer data, as returned through `STDERR`
    public let errorData: Data
    /// The raw output buffer data, as returned through `STDOUT`
    public let outputData: Data
    /// The error message as a UTF8 string, as returned through `STDERR`
    public var message: String { return errorData.utfOutput() }
    /// The output of the command as a UTF8 string, as returned through `STDOUT`
    public var output: String { return outputData.utfOutput() }
}

extension ProcessError: CustomStringConvertible {
    public var description: String {
        return """
        Process encountered an error
        Status code: \(terminationStatus)
        Message: "\(message)"
        Output: "\(output)"
        """
    }
}

extension ProcessError: LocalizedError {
    public var errorDescription: String? {
        return description
    }
}

public extension Process {
    @available(macOS 10.13, *)
    @discardableResult func launch(
        with filename: String
    ) throws -> String {
        executableURL = URL(fileURLWithPath: "/usr/local/swift/usr/bin/swift")
        self.arguments = [filename]

        // Because FileHandle's readabilityHandler might be called from a
        // different queue from the calling queue, avoid a data race by
        // protecting reads and writes to outputData and errorData on
        // a single dispatch queue.
        let outputQueue = DispatchQueue(label: "process-output-queue")

        var outputData = Data()
        var errorData = Data()

        let outputPipe = Pipe()
        standardOutput = outputPipe

        let errorPipe = Pipe()
        standardError = errorPipe

        try run()

#if os(Linux)
        outputQueue.sync {
            outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        }
#endif

        waitUntilExit()

        // Block until all writes have occurred to outputData and errorData,
        // and then read the data back out.
        return try outputQueue.sync {
            if terminationStatus != 0 {
                throw ProcessError(
                    terminationStatus: terminationStatus,
                    errorData: errorData,
                    outputData: outputData
                )
            }

            return outputData.utfOutput()
        }
    }
}

private extension Data {
    func utfOutput() -> String {
        guard let output = String(data: self, encoding: .utf8) else {
            return ""
        }

        guard !output.hasSuffix("\n") else {
            let endIndex = output.index(before: output.endIndex)
            return String(output[..<endIndex])
        }

        return output
    }
}
