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
        fourPillars.map { calculateTenGods(for: String($0.prefix(1)), dayPillars: ymd8Char.2) }
    }
    
    /**
     * 命宫 天干地支
     * https://www.douban.com/note/833981956/?_i=4646542gC9k0WR,4655583gC9k0WR
     * https://www.iztro.com/learn/astrolabe.html
     */
    var lifePalace: [String] {
        let calculator = twelvePalaceCalculator(monthBranch: String(month8Char.suffix(1)), hourBranch: String(twohour8Char.suffix(1)))
        let lifePalaceBranch:String = calculator.findLifePalaceBranch()
        let lifePalaceStem = calculator.generatingStem(lifePalaceBranch:lifePalaceBranch, yearPillars: ymd8Char.0)

        return [lifePalaceStem ?? "未知",lifePalaceBranch]
    }
    
    /**
     身宫天干地支
     */
    var bodyPalace: [String] {
        let calculator = twelvePalaceCalculator(monthBranch: String(month8Char.suffix(1)), hourBranch: String(twohour8Char.suffix(1)))
        let BodyPalaceBranch:String = calculator.findBodyPalaceBranch()
        let BodyPalaceStem = calculator.generatingStem(lifePalaceBranch:BodyPalaceBranch, yearPillars: ymd8Char.0)

        return [BodyPalaceStem ?? "未知",BodyPalaceBranch]
    }
    /**
     全部十二宫字典
     */
    var twelvePalaces: [String: (stem: String, branch: String)]{
        let calculator = twelvePalaceCalculator(monthBranch: String(month8Char.suffix(1)), hourBranch: String(twohour8Char.suffix(1)))
        return calculator.calculateAllPalacesStemsAndBranches(lifePalaceStemBranch: (lifePalace[0],lifePalace[1]), yearStem: String(ymd8Char.0.prefix(1)))
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
        return calculator.setZiweiStars(yearStem: String(year8Char.prefix(1)))

    }
    /**
     主星 天府星 所有星耀
     */
    var tianfuAllStarArrays:[Star?] {
        let calculator = ZiweiStarCalculator(lunarDayNum: lunarDay, wuxingGameNum: wuxingGame!.num)
        return calculator.setTianfuStars(yearStem: String(year8Char.prefix(1)))

    }
    /**
     所有sub star
     */
    var allSubSmallStars: (Substar:[Star], Smallstar: [Star]) {
        let calculator = ZiweiStarCalculator(lunarDayNum: lunarDay, wuxingGameNum: wuxingGame!.num)
        let result = calculator.setOtherRegularSmallStars(tYearPinyin: getTianganPinyin(String(year8Char.prefix(1)))!,
                                                          dYearPinyin: getDizhiPinyin(String(year8Char.suffix(1)))!,
                                                    shichen: twohour8Char, lunarMonth: lunarMonth)!
        return (result.subStarsArray,result.smallStarsArray)
    }
    

}
