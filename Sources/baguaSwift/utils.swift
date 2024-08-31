import Foundation

public func getRandomBinary() -> String{
    var randomnums: [Int] = []
    for _ in 1...6 {
        let randomnum = Int.random(in: 0...1)
        randomnums.append(randomnum)
        }
    return randomnums.map { String($0)}.joined()
    }

public func getHexagramInfo(for binary: String) -> (name: String, description: String)? {
    guard binary.count == 6 else {
        print("Invalid binary string length")
        return nil
    }
    
    guard let hexagramInfo = guaCi[binary] else {
        print("Hexagram not found")
        return nil
    }

    // Access the resource using Bundle.module
    guard let fileURL = Bundle.module.url(forResource: "i_\(binary)", withExtension: nil) else {
        print("Resource file not found")
        return nil
    }

    do {
        let description = try String(contentsOf: fileURL, encoding: .utf8)
        return (name: hexagramInfo.name, description: description)
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}
