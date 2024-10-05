//  Created by Dingxian Cao on 8/27/24.
import Foundation

/**
 Revise Swift’s modulo operation to Python behavior a % n
 */
public func pythonModulo(_ x: Int, _ n: Int) -> Int {
    return (x % n + n) % n
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
    /// palace order clockwise from .yin: [ "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥","子", "丑"]
    let fillorder:[the12BranchEnum] = palaceFillorder
    // MARK:  三方四正是4个宫位的统称，其中包含 本宫，对宫（也叫 四正位），三合宫（也叫三方位）
    /// 对宫(四正位)：是 本宫 序号 加6 所在的位置(四正位), 本宫位对角线上的宫位
    public let duiPalaceDict: [the12BranchEnum: the12BranchEnum]
    
    ///三合位: 是指 本宫 和本宫的序号 加减4 所在的两个位置
    let SanHePosition: [the12BranchEnum: (forward4:the12BranchEnum, backward4:the12BranchEnum)]
    
    ///暗合宫: 把紫微斗数星盘从中间纵向分开，左右镜像宫位即是暗合宫位
    let palaceBranchArray1:[the12BranchEnum] = [.si,.wu,.wei,.shen,.chen,.you,.mao,.xu,.yin,.chou,.zi,.hai]
    let anhePalacePosition: [the12BranchEnum: the12BranchEnum] = [
        .si:.shen,.wu:.wei,.wei:.wu,.shen:.si,
        .chen:.you,.mao:.xu,.you:.chen,.xu:.mao,
        .yin:.hai,.chou:.zi,.zi:.chou,.hai:.yin
    ]
    
    /// Initializer
    public init(monthBranch: the12BranchEnum, hourBranch: the12BranchEnum) {
        self.monthBranch = monthBranch
        self.hourBranch = hourBranch
        
        self.duiPalaceDict = twelvePalaceCalculator
            .createCyclicDictionary(from: fillorder, forwardBy: 6)
        self.SanHePosition = twelvePalaceCalculator.combineDictionaries(
            forward: twelvePalaceCalculator.createCyclicDictionary(from: fillorder, forwardBy: 4),
            backward: twelvePalaceCalculator.createCyclicDictionary(from: fillorder, forwardBy: -4)
        )
    }
    private static func createCyclicDictionary(from fillorder: [the12BranchEnum], forwardBy:Int) -> [the12BranchEnum: the12BranchEnum] {
            var cyclicDict: [the12BranchEnum: the12BranchEnum] = [:]
            let count = fillorder.count
            for (index, element) in fillorder.enumerated() {
                // Calculate the index 6 positions forward, wrapping around using modulo
                let nextIndex = (index + forwardBy + count) % count
                cyclicDict[element] = fillorder[nextIndex]
            }
            return cyclicDict
        }
    /// Combine two dictionaries (forward and backward)
    private static func combineDictionaries(forward: [the12BranchEnum: the12BranchEnum], backward: [the12BranchEnum: the12BranchEnum]) -> [the12BranchEnum: (forward4: the12BranchEnum, backward4: the12BranchEnum)] {
        var combined: [the12BranchEnum: (forward4: the12BranchEnum, backward4: the12BranchEnum)] = [:]
        
        for (key, forwardValue) in forward {
            let backwardValue = backward[key] ?? key
            combined[key] = (forwardValue, backwardValue)
        }
        return combined
    }

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
    // TODO: 对宫, 三合位,暗合宫(https://www.iztro.com/learn/basis.html#宫位)
    
    /// from current palace branch to its duiPalace's branch
    func findDuiPalace(currentPalceBranch:the12BranchEnum) -> the12BranchEnum {
        return duiPalaceDict[currentPalceBranch]!
    }
    
    
    
}


//---------------------------------------------------五行局计算器
/**
 五行局计算器
 */
public struct ZiWeiWuxingGameCalculator {
    let lifePalaceStemBranchArray: StemBranch
    
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
        let dizhiIndex = index < 0 ? index + 12 : index // pythonmodulo(index, 12)
        let dizhi = fillOrder[dizhiIndex] //亥
        return (index, dizhi)
    }
    // MARK: 主星
    /**
     基于年干，确定紫薇主星的四化. 排星 -> 确定紫薇 ，逆时针依次，天机 ->空格 ->太阳 ->武曲 ->天同 -> 空两格 -> 廉贞
     */
    func getMainStarsWithZiwei(for yearStem: the10StemEnum) -> [Star?] {
        return [
            Star(
                pinyin: .mainStars(.ziwei(.ziwei)),
                sihua: sihuaMap[yearStem]?[.mainStars(.ziwei(.ziwei))]
            ),
            Star(
                pinyin: .mainStars(.ziwei(.tianji)),
                sihua: sihuaMap[yearStem]?[.mainStars(.ziwei(.tianji))]
            ),
            nil, // Some missing star
            Star(
                pinyin: .mainStars(.ziwei(.taiyang)),
                sihua: sihuaMap[yearStem]?[.mainStars(.ziwei(.taiyang))]
            ),
            Star(
                pinyin: .mainStars(.ziwei(.wuqu)),
                sihua: sihuaMap[yearStem]?[.mainStars(.ziwei(.wuqu))]
            ),
            Star(
                pinyin: .mainStars(.ziwei(.tiantong)),
                sihua: sihuaMap[yearStem]?[.mainStars(.ziwei(.tiantong))]
            ),
            nil, // Some missing star
            nil, // Some missing star
            Star(
                pinyin: .mainStars(.ziwei(.lianzhen)),
                sihua: sihuaMap[yearStem]?[.mainStars(.ziwei(.lianzhen))]
            )
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
        let tianfuindex = pythonModulo((12 - getZiweiIndex().index), 12)
        return (tianfuindex, fillOrder[tianfuindex])
    }
    
    /**
     基于年干，确定天府主星的四化. 天府星 ：紫薇斜对角（右上到左下）顺时针： 天府星 ->太阴 -> 贪狼 -> 巨门 ->天相 ->天梁 -> 七杀 -> 空三格 -> 破军
     */
    func getMainStarsWithTianfu(for yearStem: the10StemEnum) -> [Star?] {
        return [
            Star(
                pinyin: .mainStars(.tianfu(.tianfu)),
                sihua: sihuaMap[yearStem]?[.mainStars(.tianfu(.tianfu))]
            ),
            Star(
                pinyin: .mainStars(.tianfu(.taiyin)),
                sihua: sihuaMap[yearStem]?[.mainStars(.tianfu(.taiyin))]
            ),
            Star(
                pinyin: .mainStars(.tianfu(.tanlang)),
                sihua: sihuaMap[yearStem]?[.mainStars(.tianfu(.tanlang))]
            ),
            Star(
                pinyin: .mainStars(.tianfu(.jumen)),
                sihua: sihuaMap[yearStem]?[.mainStars(.tianfu(.jumen))]
            ),
            Star(
                pinyin: .mainStars(.tianfu(.tianxiang)),
                sihua: sihuaMap[yearStem]?[.mainStars(.tianfu(.tianxiang))]
            ),
            Star(
                pinyin: .mainStars(.tianfu(.tianliang)),
                sihua: sihuaMap[yearStem]?[.mainStars(.tianfu(.tianliang))]
            ),
            Star(
                pinyin: .mainStars(.tianfu(.qisha)),
                sihua: sihuaMap[yearStem]?[.mainStars(.tianfu(.qisha))]
            ),
            nil, // Some missing stars
            nil, // Some missing stars
            nil, // Some missing stars
            Star(
                pinyin: .mainStars(.tianfu(.pojun)),
                sihua: sihuaMap[yearStem]?[.mainStars(.tianfu(.pojun))]
            )
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
    struct minorStarConfig {
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
    
    
    /// set 14-2=12 minorStars and 5 adjStars config, exclude .minorStars(.bad(.tuoluo)), .minorStars(.bad(.qingyang))
    func getSmallStarsConfig(tYearPinyin:the10StemEnum,dYearPinyin:the12BranchEnum,shichen:the12BranchEnum,lunarMonth:Int) -> [minorStarConfig] {
        return [
            // 2 help stars
            minorStarConfig(
                isSub: true,
                rule: (lucunRule[tYearPinyin]!,nil,nil,nil),
                star: Star(pinyin: .minorStars(.help(.lucun)))
            ),
            minorStarConfig(
                isSub: false,
                rule: (tianma[(dYearPinyin)]!,nil,nil,nil),
                star: Star(pinyin: .minorStars(.help(.tianma)))
            ),
            // 6bad stars, exclude .minorStars(.bad(.tuoluo)), .minorStars(.bad(.qingyang))
            minorStarConfig(
                isSub: false,
                rule: (huoxing[dYearPinyin]!, .zi, true, shichen),
                star: Star(pinyin: .minorStars(.bad(.huoxing)))
            ),
            minorStarConfig(
                isSub: false,
                rule: (.hai, .zi, false, shichen),
                star: Star(pinyin: .minorStars(.bad(.dikong)))
            ),
            minorStarConfig(
                isSub: false,
                rule: (.hai, .zi, true, shichen),
                star: Star(pinyin: .minorStars(.bad(.dijie)))
            ),
            minorStarConfig(
                isSub: false,
                rule: (lingxing[dYearPinyin]!, .zi, true, shichen),
                star: Star(pinyin: .minorStars(.bad(.lingxing)))
            ),
            // 5adj stars
            minorStarConfig(
                isSub: false,
                rule: (.mao, .zi, false, dYearPinyin),
                star: Star(pinyin: .adjStars(.hongluan))
            ),
            minorStarConfig(
                isSub: false,
                rule: (.you, .zi, false, dYearPinyin),
                star: Star(pinyin: .adjStars(.tianxi))
            ),
            minorStarConfig(
                isSub: false,
                rule: (.chou, .zi, true, the12BranchEnum.allCases[lunarMonth - 1]),
                star: Star(pinyin: .adjStars(.tiantao))
            ),
            minorStarConfig(
                isSub: false,
                rule: (xianchi[dYearPinyin]!,nil,nil,nil),
                star: Star(pinyin: .adjStars(.xianchi))
            ),
            minorStarConfig(
                isSub: false,
                rule: (.you, .zi, true, the12BranchEnum.allCases[lunarMonth - 1]),
                star: Star(pinyin: .adjStars(.tianxing))
            ),
            // 6good stars
            minorStarConfig(
                isSub: true,
                rule: (.chen, .zi, true, the12BranchEnum.allCases[lunarMonth - 1]),
                star: Star(
                    pinyin: .minorStars(.good(.zuofu)),
                    sihua: sihuaMap[tYearPinyin]?[.minorStars(.good(.zuofu))]
                )
            ),
            minorStarConfig(
                isSub: true,
                rule: (.xu, .zi, false, the12BranchEnum.allCases[lunarMonth - 1]),
                star: Star(
                    pinyin: .minorStars(.good(.youbi)),
                    sihua: sihuaMap[tYearPinyin]?[.minorStars(.good(.youbi))]
                )
            ),
            minorStarConfig(
                isSub: true,
                rule: (.chen, .zi, true, shichen),
                star: Star(
                    pinyin: .minorStars(.good(.wenqu)),
                    sihua: sihuaMap[tYearPinyin]?[.minorStars(.good(.wenqu))]
                )
            ),
            minorStarConfig(
                isSub: true,
                rule: (.xu, .zi, false, shichen),
                star: Star(
                    pinyin: .minorStars(.good(.wenchang)),
                    sihua: sihuaMap[tYearPinyin]?[.minorStars(.good(.wenchang))]
                )
            ),
            minorStarConfig(
                isSub: true,
                rule: (getTiankuiTianyue(t: true)[tYearPinyin]!,nil,nil,nil),
                star: Star(pinyin: .minorStars(.good(.tiankui)))
            ),
            minorStarConfig(
                isSub: true,
                rule: (getTiankuiTianyue(t: false)[tYearPinyin]!,nil,nil,nil),
                star: Star(pinyin: .minorStars(.good(.tianyue)))
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
        let endPalaceBranch = fillOrder[pythonModulo(endPalaceIndex,12)]
        return endPalaceBranch
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
                    smallStarsArray.append(Star(pinyin: .minorStars(.bad(.tuoluo)), palaceBranch: fillOrder[prev_palace]))
                    let next_palace = pythonModulo(fillOrder.firstIndex(of: palaceBranchPinyin)! + 1, 12)
                    smallStarsArray.append(Star(pinyin: .minorStars(.bad(.qingyang)), palaceBranch: fillOrder[next_palace]))
                }
            } else {
                smallStarsArray.append(Star(pinyin: config.star.pinyin,
                                            palaceBranch: palaceBranchPinyin))
            }
        } // end for loop
        
     return (subStarsArray, smallStarsArray)
    }
    
}
