import Foundation

/**
 返回一个随机的 “111111”
 */
public func getRandomBinary() -> String{
    //6爻的随机二进制
    var randomnums: [Int] = []
    for _ in 1...6 {
        let randomnum = Int.random(in: 0...1)
        randomnums.append(randomnum)
        }
    let binary6 = randomnums.map { String($0)}.joined()
    
    return binary6
    }
/**
 从一个二进制符号，返回卦和他的文档
 */
public func getHexagramInfo(for binary: String) -> (hexagram:Hexagram?, description: String)? {
    //获取相应卦象的名字，文档
    guard binary.count == 6 else {
        print("Invalid binary string length")
        return nil
    }
    
    guard let theHexagram:Hexagram = HexagramArray.first(where: {$0.binary == binary}) else {
        return nil
    }

    // 获取卦辞文档，文档分为 x卦原文，白话文解释，《象辞》说，《断易天机》解，北宋易学家邵雍解，台湾国学大儒傅佩荣解，传统解卦，台湾张铭仁解卦
    guard let fileURL = Bundle.module.url(forResource: "i_\(binary)", withExtension: nil) else {
        print("Resource file not found")
        return nil
    }

    do {
        let description = try String(contentsOf: fileURL, encoding: .utf8)
        return (hexagram: theHexagram, description: description)
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

/**
 文档分段:
 给定一个卦辞文档，返回文档的段落名顺序列表，段落内容字典
 */
public func getHexagramInfoParts(_ document:String) -> ([String],[String:String]){
    
    // 定义固定的标签
    let fixedLabels = [
        "白话文解释",
        "《断易天机》解",
        "北宋易学家邵雍解",
        "台湾国学大儒傅佩荣解",
        "传统解卦",
        "台湾张铭仁解卦"
    ]
    var dynamicLabel: String? = nil
    if let match = document.range(of: ".*卦原文", options: .regularExpression) {
        dynamicLabel = String(document[match])
    }
    guard let firstLabel = dynamicLabel else {
        print("未能识别第一个标签")
        exit(1)
    }
    let labels = [firstLabel] + fixedLabels

    // 定义一个字典来存储段落内容
    var paragraphs: [String: String] = [:]

    // 按照标签拆分文档
    let components = document.components(separatedBy: "\n")

    var currentLabel: String? = nil

    for line in components {
        if labels.contains(line) {
            currentLabel = line
            paragraphs[currentLabel!] = ""
        } else if let label = currentLabel {
            paragraphs[label]! += (paragraphs[label]!.isEmpty ? "" : "\n") + line
        }
    }
    
    return (labels, paragraphs)
}



//// 打印结果
//let (labels, paragraphs) = getHexagramInfoParts(getHexagramInfo(for: getRandomBinary()).description)
//
//for label in labels {
//    if let content = paragraphs[label] {
//        print("\(label):\n\(content)\n")
//    }
//}
