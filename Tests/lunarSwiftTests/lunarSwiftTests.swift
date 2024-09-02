import XCTest
@testable import lunarSwift

class testpeople {
    var date: Date
    var lunarbirthdate: String
    var fourPillars: [String]
    var lifePalace: [String]
    var tenGods: [String]
    var twelvePalaces: [String]
    init(date: Date, lunarbirthdate: String, fourPillars: [String], lifePalace: [String], tenGods: [String],twelvePalaces:[String]) {
        self.date = date
        self.lunarbirthdate = lunarbirthdate
        self.fourPillars = fourPillars
        self.lifePalace = lifePalace
        self.tenGods = tenGods
        self.twelvePalaces = twelvePalaces
    }
}

let p1bench = testpeople(date: DateComponents(calendar: .current, year: 1993, month: 11, day: 22, hour: 4).date!,
                         lunarbirthdate: "一九九三年 十月小 初九日 寅时",
                         fourPillars: ["癸酉", "癸亥", "丁未", "壬寅"],
                         lifePalace: ["丙","辰"],
                         tenGods: ["七杀","七杀","比肩","正官"],
                         twelvePalaces: ["辛酉","庚申","己未","戊午","丁巳","丙辰","乙卯","甲寅","乙丑","甲子","癸亥","壬戌"]
)

final class lunarSwiftTests: XCTestCase {
    let person = People(date: p1bench.date, gender: "男")
    // 测试农历日期换算
    func testLunarDateFormat(){
        XCTAssertEqual(person.lunarbirthday, p1bench.lunarbirthdate, "Lunar Birthdate should be following the specific format")
    }
    // 测试四柱换算
    func testFourPillarsCalculation() {
        XCTAssertEqual(person.fourPillars, p1bench.fourPillars, "Four pillars should be correctly calculated based on the lunarbirthdate.")
        }
    // 测试十神计算
    func testTenGodsCalculation(){
        XCTAssertEqual(person.tenGods, p1bench.tenGods, "Ten Gods should be correctly calculated based on the lunarbirthdate.")
    }
    // 测试十二宫推演
    func test12PalaceCalculation(){
        var person12palaces: [String] = []
        for key in palaces{
            person12palaces.append( String(person.twelvePalaces[key]!.stem+person.twelvePalaces[key]!.branch) )
        }
        XCTAssertEqual(person12palaces, p1bench.twelvePalaces, "Ten Gods should be correctly calculated based on the lunarbirthdate.")
    }
}
