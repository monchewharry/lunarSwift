import XCTest
@testable import lunarSwift

class testpeople {
    var date: Date
    var lunarbirthdate: String
    var fourPillars: [String]
    var lifePalace: [String]
    var tenGods: [String]
    var twelvePalaces: [String]
    var bodyPalace: String
    var wuxinggame: String
    var ziweiAllStardict:[String:the12BranchEnum] // starname:starbranch

    init(date: Date, lunarbirthdate: String, fourPillars: [String], lifePalace: [String], tenGods: [String]
         ,twelvePalaces:[String],bodyPalace:String,wuxinggame:String, ziweiAllStardict:[String:the12BranchEnum]) {
        self.date = date
        self.lunarbirthdate = lunarbirthdate
        self.fourPillars = fourPillars
        self.lifePalace = lifePalace
        self.tenGods = tenGods
        self.twelvePalaces = twelvePalaces
        self.bodyPalace = bodyPalace
        self.wuxinggame = wuxinggame
        self.ziweiAllStardict = ziweiAllStardict 
    }
}

let p1bench = testpeople(date: DateComponents(calendar: .current, year: 1993, month: 11, day: 22, hour: 4).date!,
                         //    https://www.ziweishe.com/?sex=1&date_type=1&year=1993&month=11&day=22&hour=4
                         lunarbirthdate: "一九九三年 十月小 初九日 寅时",
                         fourPillars: ["癸酉", "癸亥", "丁未", "壬寅"],
                         lifePalace: ["丙","辰"],
                         tenGods: ["七杀","七杀","比肩","正官"],
                         twelvePalaces: ["辛酉","庚申","己未","戊午","丁巳","丙辰","乙卯","甲寅","乙丑","甲子","癸亥","壬戌"],
                         bodyPalace: "乙丑",
                         wuxinggame: "木三局",
                         ziweiAllStardict: ["紫微":the12BranchEnum.chen,"天机":the12BranchEnum.mao,"天府":the12BranchEnum.zi,"太阴":the12BranchEnum.chou]
)

/// Helper function to create a valid People instance
func createValidPerson() throws -> People {
    return try People(date: p1bench.date, gender: "male")
}

final class lunarSwiftTests: XCTestCase {
    func testconfigs(){
        XCTAssertEqual(the10StemEnum.allCases.count, 10)
        XCTAssertEqual(the12BranchEnum.allCases.count, 12)
        }
    func testValidDateInitialization() throws {
            // Given: A valid date within the allowed range
            let validDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1))!
            
            // When: We create a People instance
            let person = try People(date: validDate)
            
            // Then: The instance should be created successfully
            XCTAssertEqual(person.gender, "male") // Default gender is "male"
            XCTAssertEqual(person.date, validDate) // The date should match the one passed
            XCTAssertEqual(person.godType, "8char") // Default godType is "8char"
            XCTAssertEqual(person.yearPillarType, "beginningOfSpring") // Default yearPillarType is "beginningOfSpring"
        }
    func testOutOfBoundsDateThrowsError() {
           // Given: An invalid date before 1901
           let invalidDate = Calendar.current.date(from: DateComponents(year: 1899, month: 12, day: 31))!
           
           // Then: The initializer should throw a LunarError.dateOutOfBounds error
           XCTAssertThrowsError(try People(date: invalidDate)) { error in
               XCTAssertEqual(error as? LunarError, LunarError.dateOutOfBounds)
           }
           
           // Given: An invalid date after 2100
           let futureDate = Calendar.current.date(from: DateComponents(year: 2115, month: 1, day: 1))!
           
           // Then: The initializer should throw a LunarError.dateOutOfBounds error
           XCTAssertThrowsError(try People(date: futureDate)) { error in
               XCTAssertEqual(error as? LunarError, LunarError.dateOutOfBounds)
           }
       }
    
    // 测试农历日期换算
    func testLunarDateFormat()throws{
        let person = try createValidPerson()
        XCTAssertEqual(person.lunarbirthday, p1bench.lunarbirthdate, "Lunar Birthdate should be following the specific format")
    }
    // 测试四柱换算
    func testFourPillarsCalculation() throws{
        let person = try createValidPerson()
        XCTAssertEqual(person.fourPillars.map {$0.name}, p1bench.fourPillars, "Four pillars should be correctly calculated based on the lunarbirthdate.")
        }
    // 测试十神计算
    func testTenGodsCalculation()throws{
        let person = try createValidPerson()
        XCTAssertEqual(person.tenGods, p1bench.tenGods, "Ten Gods should be correctly calculated based on the lunarbirthdate.")
    }
    // 测试十二宫推演
    func test12PalaceCalculation()throws{
        let person = try createValidPerson()
        var person12palaces: [String] = []
        for key in palacesArray{
            person12palaces.append( String(person.twelvePalaces[key]!.stem.rawValue + person.twelvePalaces[key]!.branch.rawValue) )
        }
        XCTAssertEqual(person12palaces, p1bench.twelvePalaces, "Ten Gods should be correctly calculated based on the lunarbirthdate.")
        XCTAssertEqual(person.bodyPalace.stem.rawValue+person.bodyPalace.branch.rawValue, p1bench.bodyPalace, "body palace should be correctly calculated based on the lunarbirthdate.")
    }
    // 测试五行局
    func testWuXingGameCalculation()throws{
        let person = try createValidPerson()
        XCTAssertEqual(person.wuxingGame?.name , p1bench.wuxinggame, "Wuxing Game should be correctly calculated based on the lunarbirthdate.")
    }

    /**
    测试紫薇天府
    */
    func testStarBranch()throws{
        let person = try createValidPerson()
        if let ziwei = person.ziweiAllStarArrays.first(where: {$0?.pinyin == StarsEnum.ziwei })??.palaceBranch,
           let tianji = person.ziweiAllStarArrays.first(where: {$0?.pinyin == StarsEnum.tianji})??.palaceBranch,
           let taiyin = person.ziweiAllStarArrays.first(where: {$0?.pinyin == StarsEnum.taiyin})??.palaceBranch,
           let tianfu = person.tianfuAllStarArrays.first(where: {$0?.pinyin == StarsEnum.tianfu})??.palaceBranch{
               let testdict = ["紫微":ziwei,"天机":tianji,"天府":tianfu,"太阴":taiyin]
               XCTAssertEqual(testdict,p1bench.ziweiAllStardict,"")
           } else {
           } 
    }
}
