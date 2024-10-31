import Foundation

/**
 struct Hexagram(binary:)
 * binary
 * pinyin
 * unicode
 * name
 */


public struct Hexagram: Equatable {
    var binary:String = "000000"
    public init(binary: String) {
        self.binary = binary
    }
    
    public var pinyin:hexagramEnum {
        get{
            binary2hexagramEnum[binary]!
        }
        set{
            binary = hexagramEnum2binary[newValue]!
        }
    }
    var unicode:String?{
        hexagramEnum2unicode[pinyin]
    }
    var name:String {
        pinyin.rawValue
    }
    
    var docString:String {
        getHexagramDocstring()!
    }
    public var paragraphs: (sectionLabels:[String],paragraphsDict:[String:String]){
        getHexagramInfoParts()
    }
    
    /**
     从一个二进制符号，返回卦和他的文档
     */
    func getHexagramDocstring() -> String? {
        guard let fileURL = Bundle.module.url(forResource: "i_\(binary)", withExtension: nil) else {
            print("Resource file not found")
            return nil
        }

        do {
            let docstring = try String(contentsOf: fileURL, encoding: .utf8)
            return docstring
        } catch {
            print("Error reading hexagram doc file: \(error)")
            return nil
        }
    }
    public enum GuaCiSelection: String, CaseIterable {
        case orig = "白话文解释"
        case duanyi = "《断易天机》解"
        case song = "北宋易学家邵雍解"
        case fupeirong = "台湾国学大儒傅佩荣解"
        case chuantong = "传统解卦"
        case zhang = "台湾张铭仁解卦"
    }

    /**
     文档分段:
     * 给定一个卦辞文档，返回文档的段落名顺序列表，段落内容字典
     * 文档分为 x卦原文，白话文解释，《象辞》说，《断易天机》解，北宋易学家邵雍解，台湾国学大儒傅佩荣解，传统解卦，台湾张铭仁解卦
     */
    func getHexagramInfoParts() -> (sectionLabels:[String],paragraphsDict:[String:String]){
        // 定义固定的标签
        let fixedLabels = GuaCiSelection.allCases.compactMap { $0.rawValue }
        var dynamicLabel: String?
        
        // find the first dynamiclabel: x卦原文
        if let match = docString.range(of: ".*卦原文", options: .regularExpression) {
            dynamicLabel = String(docString[match])
        }
        guard let firstLabel = dynamicLabel else {
            print("未能识别第一个标签")
            exit(1)
        }
        
        let labels = [firstLabel] + fixedLabels

        // 定义一个字典来存储段落内容
        var paragraphs: [String: String] = [:]

        // 按照标签拆分文档
        let components = docString.components(separatedBy: "\n")

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
    
}
public let HexagramArray: [Hexagram] = {
    var result = [Hexagram]()
    for b in binaryHexagramArray{
        result.append(Hexagram(binary: b))
    }
    return result
}()

/**
 返回一个随机的6-bit 二进制string
 */
public func getRandomBinary() -> String{
    var randomnums: [Int] = []
    for _ in 1...6 {
        let randomnum = Int.random(in: 0...1)
        randomnums.append(randomnum)
        }
    let binary6:String = randomnums.map { String($0)}.joined()
    
    return binary6
    }


//// 打印结果
//let (labels, paragraphs) = getHexagramInfoParts(getHexagramInfo(for: getRandomBinary()).description)
//
//for label in labels {
//    if let content = paragraphs[label] {
//        print("\(label):\n\(content)\n")
//    }
//}
