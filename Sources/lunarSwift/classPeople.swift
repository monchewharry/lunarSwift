//
//  Created by Dingxian Cao on 8/27/24.
//
import Foundation

//class People for divination use
public class People: Lunar{


    }

public extension People{
    //--------------BaZi property
    var fourPillars: [String] {
        [ymd8Char.0,ymd8Char.1,ymd8Char.2,twohour8Char]
    }
    var fiveElements: [[String]] {
        matchwuxing(fourPillars:fourPillars)
    }
    var fiveElementsCount: [String: Int] {
                var elementsCount: [String: Int] = ["木": 0, "火": 0, "土": 0, "金": 0, "水": 0]
                
                for elements in fiveElements {
                    for element in elements {
                        elementsCount[element, default: 0] += 1
                    }
                }
                return elementsCount
            }
    var fourPillarsfiveElementsResult: String{
        calculateGanZhiAndWuXing(fourPillars: fourPillars, fiveElements:fiveElements, nayin: nayin)
    }
    
    var fourPillarsfiveElementsAnalysis: [String]{
            get{
                return analyzeFiveElementsBalance(fiveElements:fiveElements)
            }
        }
}
