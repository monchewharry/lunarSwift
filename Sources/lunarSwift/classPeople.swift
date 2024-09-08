//
//  Created by Dingxian Cao on 8/27/24.
//
import Foundation

//class People for divination use
open class People: Lunar{
    public var gender:String
    public init(date: Date, godType: String = "8char", yearPillarType: String = "beginningOfSpring",gender: String = "male") throws{
        self.gender = gender
        try super.init(date:date,godType: godType,yearPillarType: yearPillarType)
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
    public var fiveElements: [[the5wuxing]] {
        matchwuxing(fourPillars:fourPillars)
    }
    /**
     四柱五行统计
     */
    public var fiveElementsCount: [the5wuxing: Int] {
        var elementsCount: [the5wuxing: Int] = [.mu: 0, .huo: 0, .tu: 0, .jin: 0, .shui: 0]
                
                for elements in fiveElements {
                    for element in elements {
                        elementsCount[element, default: 0] += 1
                    }
                }
                return elementsCount
            }
    /**
     四柱五行结果打印
     */
    public var fourPillarsfiveElementsResult: String{
        calculateGanZhiAndWuXing(fourPillars: fourPillars, fiveElements:fiveElements, nayin: nayin)
    }
    /**
     四柱五行平衡分析结果
     */
    public var fourPillarsfiveElementsAnalysis: [String]{
            get{
                return analyzeFiveElementsBalance(fiveElements:fiveElements)
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
        let calculator = twelvePalaceCalculator(monthBranch: month8Char.branch,
                                                hourBranch: twohour8Char.branch)
        let lifePalaceBranch:the12BranchEnum = calculator.findLifePalaceBranch()
        let lifePalaceStem = calculator.generatingStem(lifePalaceBranch:lifePalaceBranch,
                                                       yearStem: year8Char.stem)

        return StemBranch(stem: lifePalaceStem, branch:lifePalaceBranch)
    }
    
    /**
     身宫天干地支
     */
    var bodyPalace: (stem:the10StemEnum,branch:the12BranchEnum) {
        let calculator = twelvePalaceCalculator(monthBranch: month8Char.branch,
                                                hourBranch: twohour8Char.branch)
        let BodyPalaceBranch:the12BranchEnum = calculator.findBodyPalaceBranch()
        let BodyPalaceStem = calculator.generatingStem(lifePalaceBranch:BodyPalaceBranch, 
                                                       yearStem: year8Char.stem)

        return (BodyPalaceStem,BodyPalaceBranch)
    }
    /**
     全部十二宫字典
     */
    var twelvePalaces: [String: StemBranch]{
        let calculator = twelvePalaceCalculator(monthBranch: month8Char.branch,
                                                hourBranch: twohour8Char.branch)
        return calculator.calculateAllPalacesStemsAndBranches(lifePalaceStemBranch: lifePalace,
                                                              yearStem: year8Char.stem)
    }
    /**
     五行局由命宫的天干地支的纳音而定
     */
    var wuxingGame: WuxingGame? {
        let calculator = ZiWeiWuxingGameCalculator(lifePalaceStemBranchArray: lifePalace)
        return calculator.calculateWuxingGame()
    }
    /**
     主星 紫薇星 所有星耀
     */
    var ziweiAllStarArrays:[Star?] {
        let calculator = ZiweiStarCalculator(lunarDayNum: lunarDay, wuxingGameNum: wuxingGame!.num)
        return calculator.setZiweiStars(yearStem: year8Char.stem)

    }
    /**
     主星 天府星 所有星耀
     */
    var tianfuAllStarArrays:[Star?] {
        let calculator = ZiweiStarCalculator(lunarDayNum: lunarDay, wuxingGameNum: wuxingGame!.num)
        return calculator.setTianfuStars(yearStem: year8Char.stem)

    }
    /**
     所有sub star
     */
    var allSubSmallStars: (Substar:[Star], Smallstar: [Star]) {
        let calculator = ZiweiStarCalculator(lunarDayNum: lunarDay, wuxingGameNum: wuxingGame!.num)
        let result = calculator.setOtherRegularSmallStars(tYearPinyin: year8Char.stem,
                                                          dYearPinyin: year8Char.branch,
                                                          shichen: twohour8Char.branch, lunarMonth: lunarMonth)!
        return (result.subStarsArray,result.smallStarsArray)
    }
    

}
