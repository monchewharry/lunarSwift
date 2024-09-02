//  Created by Dingxian Cao on 8/27/24.

import Foundation

/**
 Revise Swift’s modulo operation to Python behavior
 */
public func pythonModulo(_ a: Int, _ n: Int) -> Int {
    let result = a % n
    return result >= 0 ? result : result + n
}

/**
 两个List合并对应元素相加或者相减，a[i]+b[i]*(type=1) a[i]-b[i]*(type=-1)
 */
func abListMerge(a: [Int], b: [Int] = encVectorList, type: Int = 1) -> [Int] {
    zip(a,b).map {$0 + $1 * type}
}

/**
 删除可能的元素
 */
public func rfRemove<T:Hashable>(l: inout [T], removeList: [T]) {
    let removeSet = Set(removeList)
    l.removeAll { removeSet.contains($0) }
}

/**
 增加没有的元素
 */
public func rfAdd<T:Hashable>(l: [T], addList: [T]) -> [T] {
    return Array(Set(l).union(Set(addList)))
}

/**
 判断字符串是否非空并且不全是空白字符
 */
public func notEmpty(_ s: String?) -> String? {
    guard let s = s else {
        return nil
    }
    let trimmedString = s.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedString.isEmpty ? nil : trimmedString
}



/**
 * 24节气模块\节气数据16进制加解密
 * 解压缩16进制用
 */
public func unZipSolarTermsList(data: Any, rangeEndNum: Int = 24, charCountLen: Int = 2) -> [Int] {
    var list2: [Int] = []
    var intData: Int
    
    // 判断 data 类型并进行转换
    if let strData = data as? String {
        guard let convertedData = Int(strData, radix: 16) else {
            return []  // 如果转换失败，返回空列表
        }
        intData = convertedData
    } else if let intDataValue = data as? Int {
        intData = intDataValue
    } else {
        intData = 0
        return []  // 如果 data 既不是字符串也不是整数，返回空列表
    }
    
    for i in 1...rangeEndNum {
        let right = charCountLen * (rangeEndNum - i)
        let x = intData >> right  // 将数据右移以获得当前节气的数据
        let c = 1 << charCountLen  // 计算掩码值，即 2^charCountLen
        list2.insert(x % c, at: 0)  // 将当前节气数据插入到列表的开头
    }
    
    return abListMerge(a:list2)
}

/**
 采集压缩用
 */
public func zipSolarTermsList(inputList: [Int], charCountLen: Int = 2) -> (hex: String, length: Int) {
    let tempList = abListMerge(a: inputList, type: -1)
    var data: UInt64 = 0
    var num = 0
    for i in tempList {
        data += UInt64(i) << (charCountLen * num)
        num += 1
    }
    return (String(format: "%llx", data), tempList.count)
}

/**
 获取某一年的所有节气列表
 */
public func getTheYearAllSolarTermsList(year: Int) -> [Int] {
    return unZipSolarTermsList(data: solarTermsDataList[year - startYear]) // UInt64
}
//getTheYearAllSolarTermsList(1993) == [5, 20, 4, 18, 5, 20, 5, 20, 5, 21, 6, 21, 7, 23, 7, 23, 7, 23, 8, 23, 7, 22, 7, 22]



//------------------------------------------------五行
/**
 match Wuxing to four pillars
 */
func matchwuxing(fourPillars:[String])->[[String]]{
    var fiveElementsList: [[String]] = []
    for item in fourPillars {
        // 提取天干和地支
        let heavenlyStem:String = String(item.prefix(1)) // 天干
        let earthlyBranch: String = String(item.suffix(1)) // 地支
        
        // 获取对应的五行属性
        if let stemElement = heavenlyStemsToFiveElements[heavenlyStem], let branchElement = earthlyBranchesToFiveElements[earthlyBranch] {
            fiveElementsList.append([stemElement, branchElement])
        }
    }
    return fiveElementsList
}
/**
 四柱五行报告+纳音
 */
public func calculateGanZhiAndWuXing(fourPillars:[String],fiveElements:[[String]],nayin:[String]) -> String{
    let pillarnames:[String]=["年柱","月柱","日柱","时柱"]
    var report:String="四柱: 干支 五行 纳音\n\n"
    for (index,pillarname) in pillarnames.enumerated() {
        report += "\(pillarname): \(fourPillars[index]) \(fiveElements[index][0])\(fiveElements[index][1]) \(nayin[index])\n"
    }
    return report
}
/**
 五行均衡性分析
 */
public func analyzeFiveElementsBalance(fiveElements:[[String]]) -> [String] {
    // 统计五行的数量
    var elementsCount: [String: Int] = ["木": 0, "火": 0, "土": 0, "金": 0, "水": 0]
    
    // 遍历五行属性列表，统计每个五行的数量
    for elements in fiveElements {
        for element in elements {
            elementsCount[element, default: 0] += 1
        }
    }
    
    // wuxing hist
    var analysisResult1:String = ""
    for (element, count) in elementsCount {
        analysisResult1 += "\(element): \(count)\n"
    }
    
    // 分析五行平衡
    var analysisResult2:String = ""
    guard let maxElement = elementsCount.max(by: { $0.value < $1.value })?.key,
          let minElement = elementsCount.min(by: { $0.value < $1.value })?.key else {
        return [analysisResult1,"五行分析失败：未能找到最大或最小五行元素。"]
    }
    
    
    // 判断平衡情况
    if elementsCount.values.allSatisfy({ $0 > 0 }) {
        analysisResult2 += "五行均衡，无需特别补充\n"
    } else {
        analysisResult2 += "五行不平衡。\n"
        
        // 分析是否某五行过旺或过弱
        analysisResult2 += "最旺的五行: \(maxElement)\n"
        analysisResult2 += "最弱的五行: \(minElement)\n"
        
        // 建议的喜用神
        if elementsCount[minElement]! < 2 {
            analysisResult2 += "建议补充: \(minElement)\n"
        } else {
            analysisResult2 += "建议控制: \(maxElement) 的旺势\n"
        }
    }
    
    return [analysisResult1,analysisResult2]
}

//---------------------------------------------------十神
/**
 以日干为基础，与年柱、月柱、时柱中的天干进行比较
 */
func calculateTenGods(for pillar: String, dayPillars:String) -> String {
    let heavenlyStem = String(pillar.prefix(1))
    return tianGanRelationships[String(dayPillars.prefix(1))]?[heavenlyStem] ?? "未知"
}

//---------------------------------------------------十二宫

//public func findLifePalaceBranch_decommissioned(monthPillars:String,hourPillars:String)->String{
//    //命宫地支,not accurate
//    let monthBranch = String(monthPillars.suffix(1))
//    let hourBranch = String(hourPillars.suffix(1))
//    
//    let a:Int = diZhi2.firstIndex(of: monthBranch) ?? 0
//    let b:Int = diZhi2.firstIndex(of: hourBranch) ?? 0
//    let condition:Int = a+b
//    var branchindex:Int
//    if condition < 12 {
//        branchindex = (12 - condition)-1
//    } else{
//        branchindex = (24 - condition)-1
//    }
//    
//    let lifePalaceBranch2 = diZhi2[branchindex]
//    return lifePalaceBranch2
//}

/**
 * 命宫地支：寅宫顺时针到生月，然后逆时针到生的时辰
 *  refer: https://github.com/haibolian/natal-chart/blob/main/README.md
 */
func findLifePalaceBranch(monthPillars:String,hourPillars:String)->String{
    //命宫地支
    let monthBranch = String(monthPillars.suffix(1))
    let hourBranch = String(hourPillars.suffix(1))
    
    let a:Int = diZhi2.firstIndex(of: monthBranch) ?? 0 //lunar month index
    let b:Int = the12EarthlyBranches.firstIndex(of: hourBranch) ?? 0 //hour index
    
    let lifePalaceBranch2 = diZhi2[pythonModulo((a - b),12)]
    return lifePalaceBranch2
}
/**
 * 身宫地支：寅宫顺时针到生月，然后顺时针到生的时辰
 *  refer: https://github.com/haibolian/natal-chart
 */
func findBodyPalaceBranch(monthPillars:String,hourPillars:String)->String{
    //命宫地支
    let monthBranch = String(monthPillars.suffix(1))
    let hourBranch = String(hourPillars.suffix(1))
    
    let a:Int = diZhi2.firstIndex(of: monthBranch) ?? 0 //lunar month index
    let b:Int = the12EarthlyBranches.firstIndex(of: hourBranch) ?? 0 //hour index
    
    let bodyPalaceBranch2 = diZhi2[pythonModulo((a + b),12)]
    return bodyPalaceBranch2
}

/**
 命宫天干 by 五虎遁月歌
 */
func generatingStem(lifePalaceBranch: String, yearPillars:String) -> String? {
    let yearStem = yearPillars.prefix(1)
    guard let sequence = yearStemToSequence[String(yearStem)],
          let index = diZhi2.firstIndex(of: lifePalaceBranch) else {
        return "未知"
    }
    let lifePalaceStem = sequence[index]
    return lifePalaceStem
}

/**
 十二宫天干从命宫推出
 */
func calculateAllPalacesStemsAndBranches(lifePalaceStemBranch: (stem: String, branch: String), yearStem: String) -> [String: (stem: String, branch: String)] {
    let branchesOrder = ["寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥", "子", "丑"] //命盘左下角地支排序
    let stemsOrder:[String] = yearStemToSequence[yearStem] ?? [""] //stem mapped,ordered by branch

    var palaces12 = [
        "命宫": lifePalaceStemBranch,
        "兄弟宫": ("", ""),
        "夫妻宫": ("", ""),
        "子女宫": ("", ""),
        "财帛宫": ("", ""),
        "疾厄宫": ("", ""),
        "迁移宫": ("", ""),
        "交友宫": ("", ""),
        "官禄宫": ("", ""),
        "田宅宫": ("", ""),
        "福德宫": ("", ""),
        "父母宫": ("", "")
    ]

    // Find the index of the life palace branch in the order
    if let lifeBranchIndex = branchesOrder.firstIndex(of: lifePalaceStemBranch.branch) {
        var currentBranchIndex:Int = lifeBranchIndex
        
        for key in palaces {
            let branch = branchesOrder[currentBranchIndex]
            let stem = stemsOrder[currentBranchIndex]
            palaces12[key] = (stem, branch)
            // (anticlockwise)
            currentBranchIndex = (currentBranchIndex + 11) % 12
        }
    }

    return palaces12
}
