//
//  Created by Dingxian Cao on 8/27/24.
//
import Foundation

//class People for divination use
open class People: Lunar{
    public var gender: gendersEnum
    public init(date: Date, godType: String = "8char", yearPillarType: String = "beginningOfSpring",gender:gendersEnum = .male) {
        self.gender = gender
        super.init(date:date,godType: godType,yearPillarType: yearPillarType)
    }
    /**
     四柱八字
     */
    public var fourPillars: [StemBranch] {
        [year8Char,month8Char,day8Char,twohour8Char]
    }
    /**
     四柱五行
     */
    public var fiveElements: [[the5wuxingEnum]] {
        matchwuxing(fourPillars:fourPillars)
    }
    /**
     四柱五行统计
     */
    public var fiveElementsCount: [the5wuxingEnum: Int] {
        var elementsCount: [the5wuxingEnum: Int] = [.mu: 0, .huo: 0, .tu: 0, .jin: 0, .shui: 0]
                
                for elements in fiveElements {
                    for element in elements {
                        elementsCount[element, default: 0] += 1
                    }
                }
                return elementsCount
            }
    
    // MARK: cache calculators
    /// setup calculator for 12 palaces to avoid duplicate calls
    private var cachedtwelvePalaceCalculator:twelvePalaceCalculator?
    private var PalaceCalculator: twelvePalaceCalculator {
        print("\n=== PalaceCalculator Access ===")
        print("Month Branch:", month8Char.branch)
        print("Hour Branch:", twohour8Char.branch)
        if let cached = cachedtwelvePalaceCalculator {
            return cached
            } else {
                let calculated = twelvePalaceCalculator(monthBranch: month8Char.branch,
                                                        hourBranch: twohour8Char.branch)
                cachedtwelvePalaceCalculator = calculated
                return calculated
            }
        }
    /// 对宫 四合位
    public var duiPalacePairs:  [the12BranchEnum : the12BranchEnum] {
        PalaceCalculator.duiPalaceDict
    }
    /// 三合宫 三方位
    public var sanhePalacePairs:  [the12BranchEnum : (forward4: the12BranchEnum, backward4: the12BranchEnum)] {
        PalaceCalculator.SanHePosition
    }
    /// 暗合宫
    public var anhePalacePairs:[the12BranchEnum:the12BranchEnum]{
        PalaceCalculator.anhePalacePosition
    }
    /// 来因宫
    
    /// setup calculator for ziweistar to avoid duplicate calls
    private var cachedZiweiStarCalculator:ZiweiStarCalculator?
    private var ziweistarCalculator: ZiweiStarCalculator {
            if let cached = cachedZiweiStarCalculator {
                return cached
            } else {
                let calculated = ZiweiStarCalculator(lunarDayNum: lunarDay, wuxingGameNum: wuxingGame!.num)
                cachedZiweiStarCalculator = calculated
                return calculated
            }
        }
}

public extension People{
    /**
     十神
     */
    var tenGods:[String] {
        fourPillars.map { calculateTenGods(pillarStem: $0.stem, dayStem: day8Char.stem)
        }
    }
    
    /**
     * 命宫 天干地支
     * https://www.douban.com/note/833981956/?_i=4646542gC9k0WR,4655583gC9k0WR
     * https://www.iztro.com/learn/astrolabe.html
     */

    var lifePalace: StemBranch {
        let calculator = PalaceCalculator
        let lifePalaceBranch:the12BranchEnum = calculator.findLifePalaceBranch()
        let lifePalaceStem = calculator.generatingStem(lifePalaceBranch:lifePalaceBranch,
                                                       yearStem: year8Char.stem)

        return StemBranch(stem: lifePalaceStem, branch:lifePalaceBranch)
    }
    
    /**
     身宫天干地支:身宫是星盘主人个性的 变化趋势
     */
    var bodyPalace: (stem:the10StemEnum,branch:the12BranchEnum) {
        let calculator = PalaceCalculator
        let BodyPalaceBranch:the12BranchEnum = calculator.findBodyPalaceBranch()
        let BodyPalaceStem = calculator.generatingStem(lifePalaceBranch:BodyPalaceBranch, 
                                                       yearStem: year8Char.stem)

        return (BodyPalaceStem,BodyPalaceBranch)
    }
    /**
     全部十二宫字典
     */
    var twelvePalaces: [palacesEnum: StemBranch]{
        let calculator = PalaceCalculator
        return calculator.calculateAllPalacesStemsAndBranches(lifePalaceStemBranch: lifePalace,
                                                              yearStem: year8Char.stem)
    }
    /**
     五行局由命宫的天干地支的纳音而定: 五行局是紫微斗数里决定几岁开始起运的依据
     */
    var wuxingGame: WuxingGame? {
        let calculator = ZiWeiWuxingGameCalculator(lifePalaceStemBranchArray: lifePalace)
        return calculator.calculateWuxingGame()
    }
    /**
     主星 紫薇星 所有星耀
     */
    var ziweiAllStarArrays:[Star?] {
        let calculator = ziweistarCalculator
        return calculator.setZiweiStars(yearStem: year8Char.stem)

    }
    /**
     主星 天府星 所有星耀
     */
    var tianfuAllStarArrays:[Star?] {
        let calculator = ziweistarCalculator
        return calculator.setTianfuStars(yearStem: year8Char.stem)

    }
    /**
     所有辅星，杂星 sub star， smallstars
     */
    var allSubSmallStars: (Substar:[Star], Smallstar: [Star]) {
        let calculator = ziweistarCalculator
        let result = calculator.setOtherRegularSmallStars(tYearPinyin: year8Char.stem,
                                                          dYearPinyin: year8Char.branch,
                                                          shichen: twohour8Char.branch, lunarMonth: lunarMonth)!
        return (result.subStarsArray,result.smallStarsArray)
    }
    /// a list of 12 palace cube information: palace name stembranch starsarray...
    var twelvePalaceCubes:[ZiweiPalaceCube]{
        get12ZiweiPalaceCube(
            twelvePalaces,
            mainStarsArray: ziweiAllStarArrays + tianfuAllStarArrays,
            subStarsArray: allSubSmallStars.Substar,
            smallStarsArray: allSubSmallStars.Smallstar
        )
    }
    

}
