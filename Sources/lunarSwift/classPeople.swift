//
//  Created by Dingxian Cao on 8/27/24.
//
import Foundation

//class People for divination use
open class People: Lunar{
    /**
     四柱八字
     */
    public var fourPillars: [String] {
        [ymd8Char.0,ymd8Char.1,ymd8Char.2,twohour8Char]
    }
    /**
     四柱五行
     */
    public var fiveElements: [[String]] {
        matchwuxing(fourPillars:fourPillars)
    }
    /**
     四柱五行统计
     */
    public var fiveElementsCount: [String: Int] {
                var elementsCount: [String: Int] = ["木": 0, "火": 0, "土": 0, "金": 0, "水": 0]
                
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
        fourPillars.map { calculateTenGods(pillarStem: the10StemEnum(rawValue: String($0.prefix(1)))!,
                                           dayStem: the10StemEnum(rawValue:    String(day8Char.prefix(1)))!)
        }
    }
    
    /**
     * 命宫 天干地支
     * https://www.douban.com/note/833981956/?_i=4646542gC9k0WR,4655583gC9k0WR
     * https://www.iztro.com/learn/astrolabe.html
     */
    var lifePalace: (stem:the10StemEnum,branch:the12BranchEnum) {
        let calculator = twelvePalaceCalculator(monthBranch: the12BranchEnum(rawValue: String(month8Char.suffix(1)))!,
                                                hourBranch: the12BranchEnum(rawValue: String(twohour8Char.suffix(1)))!)
        let lifePalaceBranch:the12BranchEnum = calculator.findLifePalaceBranch()
        let lifePalaceStem = calculator.generatingStem(lifePalaceBranch:lifePalaceBranch,
                                                       yearStem: the10StemEnum(rawValue: String(year8Char.prefix(1)))!)

        return (lifePalaceStem,lifePalaceBranch)
    }
    
    /**
     身宫天干地支
     */
    var bodyPalace: (the10StemEnum,the12BranchEnum) {
        let calculator = twelvePalaceCalculator(monthBranch: the12BranchEnum(rawValue: String(month8Char.suffix(1)))!,
                                                hourBranch: the12BranchEnum(rawValue: String(twohour8Char.suffix(1)))!)
        let BodyPalaceBranch:the12BranchEnum = calculator.findBodyPalaceBranch()
        let BodyPalaceStem = calculator.generatingStem(lifePalaceBranch:BodyPalaceBranch, 
                                                       yearStem: the10StemEnum(rawValue: String(year8Char.prefix(1)))!)

        return (BodyPalaceStem,BodyPalaceBranch)
    }
    /**
     全部十二宫字典
     */
    var twelvePalaces: [String: (stem: the10StemEnum, branch: the12BranchEnum)]{
        let calculator = twelvePalaceCalculator(monthBranch: the12BranchEnum(rawValue: String(month8Char.suffix(1)))!,
                                                hourBranch: the12BranchEnum(rawValue: String(twohour8Char.suffix(1)))!)
        return calculator.calculateAllPalacesStemsAndBranches(lifePalaceStemBranch: lifePalace,
                                                              yearStem: the10StemEnum(rawValue: String(ymd8Char.0.prefix(1)))!)
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
        return calculator.setZiweiStars(yearStem: the10StemEnum(rawValue:String(year8Char.prefix(1)))!)

    }
    /**
     主星 天府星 所有星耀
     */
    var tianfuAllStarArrays:[Star?] {
        let calculator = ZiweiStarCalculator(lunarDayNum: lunarDay, wuxingGameNum: wuxingGame!.num)
        return calculator.setTianfuStars(yearStem: the10StemEnum(rawValue:String(year8Char.prefix(1)))!)

    }
    /**
     所有sub star
     */
    var allSubSmallStars: (Substar:[Star], Smallstar: [Star]) {
        let calculator = ZiweiStarCalculator(lunarDayNum: lunarDay, wuxingGameNum: wuxingGame!.num)
        let result = calculator.setOtherRegularSmallStars(tYearPinyin: the10StemEnum(rawValue: String(year8Char.prefix(1)))!,
                                                          dYearPinyin: the12BranchEnum(rawValue: String(year8Char.suffix(1)))!,
                                                          shichen: the12BranchEnum(rawValue: String(twohour8Char.suffix(1)))!, lunarMonth: lunarMonth)!
        return (result.subStarsArray,result.smallStarsArray)
    }
    

}
