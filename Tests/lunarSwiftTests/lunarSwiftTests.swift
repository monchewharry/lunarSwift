import XCTest
@testable import lunarSwift

class testpeople {
    var date: Date
    var lunarbirthdate: String
    var fourPillars: [String]
    var lifePalace: [String]
    var tenGods: [String]
    init(date: Date, lunarbirthdate: String, fourPillars: [String], lifePalace: [String], tenGods: [String]) {
        self.date = date
        self.lunarbirthdate = lunarbirthdate
        self.fourPillars = fourPillars
        self.lifePalace = lifePalace
        self.tenGods = tenGods
    }
}

let p1bench = testpeople(date: DateComponents(calendar: .current, year: 1993, month: 11, day: 22, hour: 4).date!,
                         lunarbirthdate: "一九九三年 十月小 初九日 寅时",
                         fourPillars: ["癸酉", "癸亥", "丁未", "壬寅"],
                         lifePalace: ["丙","辰"],
                         tenGods: ["七杀","七杀","比肩","正官"])

final class lunarSwiftTests: XCTestCase {
    func testLunarDateFormat(){
            // 测试农历日期换算
            let person = People(date: p1bench.date, gender: "男")
            XCTAssertEqual(person.lunarbirthday, p1bench.lunarbirthdate, "Lunar Birthdate should be following the specific format")
            
        }

        func testFourPillarsCalculation() {
                // 测试四柱换算
            let person = People(date: p1bench.date, gender: "男")
            XCTAssertEqual(person.fourPillars, p1bench.fourPillars, "Four pillars should be correctly calculated based on the lunarbirthdate.")
            }
        
}
