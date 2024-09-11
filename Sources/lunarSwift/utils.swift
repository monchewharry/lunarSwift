//  Created by Dingxian Cao on 8/27/24.
import Foundation

/**
 Revise Swift’s modulo operation to Python behavior a % n
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
func rfRemove<T:Hashable>(l: inout [T], removeList: [T]) {
    let removeSet = Set(removeList)
    l.removeAll { removeSet.contains($0) }
}

/**
 增加没有的元素
 */
func rfAdd<T:Hashable>(l: [T], addList: [T]) -> [T] {
    return Array(Set(l).union(Set(addList)))
}

/**
 判断字符串是否非空并且不全是空白字符
 */
func notEmpty(_ s: String?) -> String? {
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
func unZipSolarTermsList(data: Any, rangeEndNum: Int = 24, charCountLen: Int = 2) -> [Int] {
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
func zipSolarTermsList(inputList: [Int], charCountLen: Int = 2) -> (hex: String, length: Int) {
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
func getTheYearAllSolarTermsList(year: Int) -> [Int] {
    return unZipSolarTermsList(data: solarTermsDataList[year - startYear]) // UInt64
}
//getTheYearAllSolarTermsList(1993) == [5, 20, 4, 18, 5, 20, 5, 20, 5, 21, 6, 21, 7, 23, 7, 23, 7, 23, 8, 23, 7, 22, 7, 22]



//------------------------------------------------五行
/**
 match Wuxing to four pillars
 */
func matchwuxing(fourPillars:[StemBranch])->[[the5wuxingEnum]]{
    assert(the10StemEnum.allCases.count == 10, "the count enum the10StemEnum is not 10")
    var fiveElementsList: [[the5wuxingEnum]] = []
    for item in fourPillars {
        // 提取天干和地支
        let heavenlyStem:the10StemEnum = item.stem // 天干
        let earthlyBranch:the12BranchEnum = item.branch // 地支
        
        // 获取对应的五行属性
        if let stemElement:the5wuxingEnum = heavenlyStemsToFiveElements[heavenlyStem],
           let branchElement:the5wuxingEnum = earthlyBranchesToFiveElements[earthlyBranch] {
            fiveElementsList.append([stemElement, branchElement])
        }
    }
    return fiveElementsList
}

//---------------------------------------------------十神
/**
 以日干为基础，与年柱、月柱、时柱中的天干进行比较
 */
func calculateTenGods(pillarStem: the10StemEnum, dayStem: the10StemEnum) -> String {
    return tianGanRelationships[dayStem]?[pillarStem] ?? "未知"
}

//---------------------------------------------------十二宫计算器

/**
 十二宫定位计算器
 */
public struct twelvePalaceCalculator {
    let monthBranch, hourBranch: the12BranchEnum
    let fillorder:[the12BranchEnum] = palaceFillorder

    /**
     * 命宫地支：寅宫顺时针到生月，然后逆时针到生的时辰
     *  refer: https://github.com/haibolian/natal-chart/blob/main/README.md
     */
    func findLifePalaceBranch()-> the12BranchEnum{
        let a:Int = fillorder.firstIndex(of: monthBranch)!
        let b:Int = the12BranchEnum.allCases.firstIndex(of: hourBranch)!
        
        let lifePalaceBranch2:the12BranchEnum = fillorder[pythonModulo((a - b),12)]
        return lifePalaceBranch2
    }
    
    /**
     * 身宫地支：寅宫顺时针到生月，然后顺时针到生的时辰
     *  refer: https://github.com/haibolian/natal-chart
     */
    func findBodyPalaceBranch()->the12BranchEnum{
        let a:Int = fillorder.firstIndex(of: monthBranch)!
        let b:Int = the12BranchEnum.allCases.firstIndex(of: hourBranch)!
        
        let bodyPalaceBranch2 = fillorder[pythonModulo((a + b),12)]
        return bodyPalaceBranch2
    }
    
    /**
     命宫天干 by 五虎遁月歌
     */
    func generatingStem(lifePalaceBranch: the12BranchEnum, yearStem:the10StemEnum) -> the10StemEnum {
        let fillorder:[the12BranchEnum] = palaceFillorder//["寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥", "子", "丑"] //命盘左下角地支排序
        let sequence = yearStemToSequence[yearStem]!
        let index = fillorder.firstIndex(of: lifePalaceBranch)!
        let lifePalaceStem = sequence[index]
        return lifePalaceStem
    }
    
    /**
     十二宫天干从命宫推出
     返回 dict 宫名: (天干，地支)
     */
    func calculateAllPalacesStemsAndBranches(lifePalaceStemBranch: StemBranch, yearStem: the10StemEnum) -> [String: StemBranch] {
        let stemsOrder:[the10StemEnum] = yearStemToSequence[yearStem]!
        var palaces12:[String:StemBranch] = [:]

        // Find the index of the life palace branch in the order
        if let lifeBranchIndex = palaceFillorder.firstIndex(of: lifePalaceStemBranch.branch) {
            var currentBranchIndex:Int = lifeBranchIndex
            assert(palacesArray.count == 12, "palacesArray count not equal to 12")
            for key in palacesArray {
                let branch:the12BranchEnum = palaceFillorder[currentBranchIndex]
                let stem:the10StemEnum = stemsOrder[currentBranchIndex]
                palaces12[key] = StemBranch(stem: stem, branch: branch)
                // (anticlockwise)
                currentBranchIndex = (currentBranchIndex + 11) % 12
            }
        }
        return palaces12
    }
}


//---------------------------------------------------五行局计算器
public struct WuxingGame {
    public let name: String
    public let num: Int
}
/**
 五行局计算器
 */
public struct ZiWeiWuxingGameCalculator {
    let lifePalaceStemBranchArray: StemBranch
    
    let wuxingGameArray:[WuxingGame] = [
        WuxingGame(name: "金四局", num: 4),
        WuxingGame(name: "水二局", num: 2),
        WuxingGame(name: "火六局", num: 6),
        WuxingGame(name: "土五局", num: 5),
        WuxingGame(name: "木三局", num: 3)
    ]
    /**
     * 根据命宫天干地支，计算五行局
     * js code https://github.com/haibolian/natal-chart/blob/main/src/views/natal-chart/utils/Person.js#L123
     */
    func calculateWuxingGame() -> WuxingGame? {
            // 获取天干索引
        guard let tIndex = the10StemEnum.allCases.firstIndex(of: lifePalaceStemBranchArray.stem) else { return nil }
            // 获取地支索引
        guard let dIndex = the12BranchEnum.allCases.firstIndex(of: lifePalaceStemBranchArray.branch) else { return nil }
            
            // 天干决定五行局的起点
            let t2Index = tIndex / 2
            
            // 根据天干计算五行局范围
            var dCalcDep = Array(wuxingGameArray[t2Index..<min(t2Index + 3, wuxingGameArray.count)])
            let dif = 3 - dCalcDep.count
            if dif > 0 {
                dCalcDep += wuxingGameArray.prefix(dif)
            }
            // 根据地支确定具体的五行局
            let d2Index = dIndex / 2
            
            return dCalcDep[d2Index > 2 ? d2Index - 3 : d2Index]
    }
}

//---------------------------------------------------星耀安放

/**
 一个星耀的信息，名字，拼音，四化，宫位地支
 */
public struct Star: Hashable {
    public let pinyin: StarsEnum
    public var name:String {
        pinyin.rawValue
    }
    public var sihua: sihuaEnum? = nil
    public var palaceBranch: the12BranchEnum? = nil
}

/**
 Calculator includes every thing about star  in 紫微斗数命盘
 */
public struct ZiweiStarCalculator {
    var lunarDayNum: Int //农历日数
    var wuxingGameNum:Int //五行局数
    private let fillOrder:[the12BranchEnum] = palaceFillorder //["寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥", "子", "丑"]//虎口 for 整除
    /**
     * 紫薇星 的地支
     */
    func getZiweiIndex() -> (index: Int, dizhi: the12BranchEnum) {
        let num = wuxingGameNum //3
        var jumpNum = Double(lunarDayNum) / Double(num) // 22/3
        
        func isInt(_ num: Double) -> Bool {
            return num == floor(num)
        }
        
        func isEvenNum(_ num: Int) -> Bool {
            return num % 2 == 0
        }
        
        if !isInt(jumpNum) { //检查是否余数为零
            var r = 1
            var s = jumpNum
            
            while !isInt(s) {
                if r * num < lunarDayNum {
                    r += 1               //8
                } else {
                    s = Double(r * num) //24
                }
            }
            let lend = Int(s) - lunarDayNum //2
            jumpNum = isEvenNum(lend) ? Double(r + lend) : Double(r - lend) //8+2
        }
        
        let index = Int(jumpNum) - 1 //9
        let dizhiIndex = index < 0 ? index + 12 : index // pythonmodule(index, 12)
        let dizhi = fillOrder[dizhiIndex] //亥
        return (index, dizhi)
    }
    /**
     基于年干，确定紫薇主星的四化. 排星 -> 确定紫薇 ，逆时针依次，天机 ->空格 ->太阳 ->武曲 ->天同 -> 空两格 -> 廉贞
     */
    func getMainStarsWithZiwei(for yearStem: the10StemEnum) -> [Star?] {
        return [
            Star(pinyin: .ziwei, sihua: sihuaMap[yearStem]?[.ziwei]),
            Star(pinyin: .tianji, sihua: sihuaMap[yearStem]?[.tianji]),
            nil,
            Star(pinyin: .taiyang, sihua: sihuaMap[yearStem]?[.taiyang]),
            Star(pinyin: .wuqu, sihua: sihuaMap[yearStem]?[.wuqu]),
            Star(pinyin: .tiantong, sihua: sihuaMap[yearStem]?[.tiantong]),
            nil,
            nil,
            Star(pinyin: .lianzhen, sihua: sihuaMap[yearStem]?[.lianzhen])
        ]
    }

    /**
     给出主星紫薇主星的地支
     */
    func setZiweiStars(yearStem: the10StemEnum) -> [Star?] {
            let ziweiIndex = getZiweiIndex().index
            var stars = getMainStarsWithZiwei(for: yearStem)

            for (index, star) in stars.enumerated().reversed() { //逆序
                guard let _ :Star = star else { continue } //skip nil
                let palaceIndex = pythonModulo((ziweiIndex - index),12)
                let palacebranch = fillOrder[palaceIndex] //宫支
                stars[index]?.palaceBranch = palacebranch
            }
            return stars
        }
    
    /**
     天府星地支
     */
    func getTianfuIndex() -> (index: Int, dizhi:the12BranchEnum){
        let tianfuindex = 12 - getZiweiIndex().index
        return (tianfuindex, fillOrder[tianfuindex])
    }
    
    /**
     基于年干，确定天府主星的四化. 天府星 ：紫薇斜对角（右上到左下）顺时针： 天府星 ->太阴 -> 贪狼 -> 巨门 ->天相 ->天梁 -> 七杀 -> 空三格 -> 破军
     */
    func getMainStarsWithTianfu(for yearStem: the10StemEnum) -> [Star?] {
        return [
            Star(pinyin: .tianfu, sihua: sihuaMap[yearStem]?[.tianfu]),
            Star(pinyin: .taiyin, sihua: sihuaMap[yearStem]?[.taiyin]),
            Star(pinyin: .tanlang, sihua: sihuaMap[yearStem]?[.tanlang]),
            Star(pinyin: .jumen, sihua: sihuaMap[yearStem]?[.jumen]),
            Star(pinyin: .tianxiang, sihua: sihuaMap[yearStem]?[.tianxiang]),
            Star(pinyin: .tianliang, sihua: sihuaMap[yearStem]?[.tianliang]),
            Star(pinyin: .qisha, sihua: sihuaMap[yearStem]?[.qisha]),
            nil, 
            nil,
            nil,
            Star(pinyin: .pojun, sihua: sihuaMap[yearStem]?[.pojun])
        ]
    }
    /**
     给出主星天府主星的地支
     */
    func setTianfuStars(yearStem: the10StemEnum) -> [Star?] {
            let tianfuIndex = getTianfuIndex().index
            var stars = getMainStarsWithTianfu(for: yearStem)

            for (index, star) in stars.enumerated().reversed() { //逆序
                guard let _ :Star = star else { continue } //skip nil
                let palaceIndex = pythonModulo((tianfuIndex + index),12)
                let palacebranch = fillOrder[palaceIndex] //宫支
                stars[index]?.palaceBranch = palacebranch
            }
            return stars
        }
}

public extension ZiweiStarCalculator {
    /**
     次星规则属性
     */
    struct SmallStarConfig {
        let isSub: Bool
        let rule: (startPalaceCode:the12BranchEnum,startDizhi:the12BranchEnum?,clockwise:Bool?,endDizhi:the12BranchEnum?) // The rule for placing the star
        let star: Star
    //    let cb: ((Palace) -> Void)? = nil  // Optional callback
    }
    
    /**
     Function to determine 天魁 (Tiankui) and 天钺 (Tianyue)
     t == true ? 天魁 ： 天钺
     */

    func getTiankuiTianyue(t: Bool) -> [the10StemEnum: the12BranchEnum] {
        let r1 = t ? the12BranchEnum.chou : the12BranchEnum.wei
        let r2 = t ? the12BranchEnum.zi : the12BranchEnum.shen
        let r3 = t ? the12BranchEnum.hai : the12BranchEnum.you
        let r4 = t ? the12BranchEnum.yin : the12BranchEnum.wu
        let r5 = t ? the12BranchEnum.mao : the12BranchEnum.si

        return [
            .jia: r1, .wu: r1, .geng: r1,
            .yi: r2, .ji: r2,
            .bing: r3, .ding: r3,
            .xin: r4,
            .ren: r5, .gui: r5
        ]
    }
    
    
    // set smallstar config
    func getSmallStarsConfig(tYearPinyin:the10StemEnum,dYearPinyin:the12BranchEnum,shichen:the12BranchEnum,lunarMonth:Int) -> [SmallStarConfig] {
        return [
            SmallStarConfig(
                isSub: true,
                rule: (lucunRule[tYearPinyin]!,nil,nil,nil),
                star: Star(pinyin: .lucun)
            ),
            SmallStarConfig(
                isSub: false,
                rule: (tianma[(dYearPinyin)]!,nil,nil,nil),
                star: Star(pinyin: .tianma)
            ),
            SmallStarConfig(
                isSub: false,
                rule: (huoxing[dYearPinyin]!, .zi, true, shichen),
                star: Star(pinyin: .huoxing)
            ),
            SmallStarConfig(
                isSub: false,
                rule: (.hai, .zi, false, shichen),
                star: Star(pinyin: .dikong)
            ),
            SmallStarConfig(
                isSub: false,
                rule: (.hai, .zi, true, shichen),
                star: Star(pinyin: .dijie)
            ),
            SmallStarConfig(
                isSub: false,
                rule: (lingxing[dYearPinyin]!, .zi, true, shichen),
                star: Star(pinyin: .lingxing)
            ),
            SmallStarConfig(
                isSub: false,
                rule: (.mao, .zi, false, dYearPinyin),
                star: Star(pinyin: .hongluan)
            ),
            SmallStarConfig(
                isSub: false,
                rule: (.you, .zi, false, dYearPinyin),
                star: Star(pinyin: .tianxi)
            ),
            SmallStarConfig(
                isSub: false,
                rule: (.chou, .zi, true, the12BranchEnum.allCases[lunarMonth - 1]),
                star: Star(pinyin: .tiantao)
            ),
            SmallStarConfig(
                isSub: false,
                rule: (xianchi[dYearPinyin]!,nil,nil,nil),
                star: Star(pinyin: .xianchi)
            ),
            SmallStarConfig(
                isSub: false,
                rule: (.you, .zi, true, the12BranchEnum.allCases[lunarMonth - 1]),
                star: Star(pinyin: .tianxing)
            ),
            SmallStarConfig(
                isSub: true,
                rule: (.chen, .zi, true, the12BranchEnum.allCases[lunarMonth - 1]),  // Modify as per dizhi lookup
                star: Star(pinyin: .zuofu, sihua: sihuaMap[tYearPinyin]?[.zuofu])
            ),
            SmallStarConfig(
                isSub: true,
                rule: (.xu, .zi, false, the12BranchEnum.allCases[lunarMonth - 1]),
                star: Star(pinyin: .youbi, sihua: sihuaMap[tYearPinyin]?[.youbi])
            ),
            SmallStarConfig(
                isSub: true,
                rule: (.chen, .zi, true, shichen),
                star: Star(pinyin: .wenqu, sihua: sihuaMap[tYearPinyin]?[.wenqu])
            ),
            SmallStarConfig(
                isSub: true,
                rule: (.xu, .zi, false, shichen),
                star: Star(pinyin: .wenchang, sihua: sihuaMap[tYearPinyin]?[.wenchang])
            ),
            SmallStarConfig(
                isSub: true,
                rule: (getTiankuiTianyue(t: true)[tYearPinyin]!,nil,nil,nil),
                star: Star(pinyin: .tiankui)
            ),
            SmallStarConfig(
                isSub: true,
                rule: (getTiankuiTianyue(t: false)[tYearPinyin]!,nil,nil,nil),
                star: Star(pinyin: .tianyue)
            )
        ]
    }
    
    /**
     返回终点宫支pinyin
     */
    func getMovePalace(startPalaceBranchPinyin: the12BranchEnum, shichenBranch: the12BranchEnum, direction: Bool, endDizhi: the12BranchEnum?) -> the12BranchEnum? {
        // 获取起始宫
        let startPalaceBranchIndex:Int = fillOrder.firstIndex(of: startPalaceBranchPinyin)!
        
        // 获取从那个地支开始的数组
        let shichenIndex:Int = the12BranchEnum.allCases.firstIndex(of: shichenBranch)!
        
//        let newArr:[String] = Array(the12EarthlyBranches[shichenIndex...]) + Array(the12EarthlyBranches[..<shichenIndex]) // CnChar
        let newArr:[the12BranchEnum] = Array(the12BranchEnum.allCases[shichenIndex...] + the12BranchEnum.allCases[..<shichenIndex])

        // 到达目标地支的索引
        guard let _ = endDizhi,
              let scIndex:Int = newArr.firstIndex(of: endDizhi!) else {
            print("cannot find endDizhi = nil")
            return nil
        }
        // 根据起始宫的位置顺逆到达目标宫
        let endPalaceIndex = direction
            ? startPalaceBranchIndex + scIndex  // Forward direction
            : startPalaceBranchIndex - scIndex  // Backward direction
        
        // Get and return the target palace branch
        return fillOrder[pythonModulo(endPalaceIndex,12)]
    }
    

    /**
     get all other stars info
     */
    func setOtherRegularSmallStars(tYearPinyin:the10StemEnum,dYearPinyin:the12BranchEnum,shichen:the12BranchEnum,lunarMonth:Int) -> (subStarsArray:[Star], smallStarsArray:[Star])? {
        let smallStarsConfig = getSmallStarsConfig(tYearPinyin:tYearPinyin,dYearPinyin:dYearPinyin,shichen:shichen,lunarMonth: lunarMonth)
        var subStarsArray:[Star] = []
        var smallStarsArray:[Star] = []
        var palaceBranchPinyin: the12BranchEnum? //palace branch pinyin
        
        for config in smallStarsConfig {
            // determine palace branch
            if config.rule.startDizhi == nil  { // only one rule element
                palaceBranchPinyin = config.rule.startPalaceCode
            } else if (config.rule.startDizhi != nil) && (config.rule.clockwise != nil) { // four rule element
                // Use getMovePalace with the rule as an array
                let (startPalacePinyin,shichenBranch,direction,endDizhi) = config.rule
                palaceBranchPinyin = getMovePalace(startPalaceBranchPinyin: startPalacePinyin, shichenBranch: shichenBranch!,
                                                   direction: direction!, endDizhi: endDizhi)
            } else {
                print("cannot find palace for this small star config of the star \(config.star.name)")
                palaceBranchPinyin = nil
            }
            // place the star at palaceBranchPinyin
            if config.isSub {
                subStarsArray.append(Star(pinyin: config.star.pinyin,
                                          palaceBranch: palaceBranchPinyin
                                          )
                )
                if config.star.name == "禄存", let palaceBranchPinyin = palaceBranchPinyin {
                    let prev_palace = pythonModulo(fillOrder.firstIndex(of: palaceBranchPinyin)! - 1, 12)
                    smallStarsArray.append(Star(pinyin: .tuoluo, palaceBranch: fillOrder[prev_palace]))
                    let next_palace = pythonModulo(fillOrder.firstIndex(of: palaceBranchPinyin)! + 1, 12)
                    smallStarsArray.append(Star(pinyin: .qingyang, palaceBranch: fillOrder[next_palace]))
                }
            } else {
                smallStarsArray.append(Star(pinyin: config.star.pinyin,
                                            palaceBranch: palaceBranchPinyin))
            }
        } // end for loop
        
     return (subStarsArray, smallStarsArray)
    }
    
}
