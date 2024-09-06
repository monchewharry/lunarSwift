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
    var ziweiAllStardict:[String:String] // starname:starbranch

    init(date: Date, lunarbirthdate: String, fourPillars: [String], lifePalace: [String], tenGods: [String]
         ,twelvePalaces:[String],bodyPalace:String,wuxinggame:String, ziweiAllStardict:[String:String]) {
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
                         ziweiAllStardict: ["紫微":"辰","天机":"卯","天府":"子","太阴":"丑"]
)

final class lunarSwiftTests: XCTestCase {
    let person = People(date: p1bench.date, gender: "男")
    func testconfigs(){
        XCTAssertEqual(the10StemEnum.allCases.count, 10)
        XCTAssertEqual(the12BranchEnum.allCases.count, 12)
        }
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
        for key in palacesArray{
            person12palaces.append( String(person.twelvePalaces[key]!.stem.rawValue + person.twelvePalaces[key]!.branch.rawValue) )
        }
        XCTAssertEqual(person12palaces, p1bench.twelvePalaces, "Ten Gods should be correctly calculated based on the lunarbirthdate.")
        XCTAssertEqual(person.bodyPalace.stem.rawValue+person.bodyPalace.branch.rawValue, p1bench.bodyPalace, "body palace should be correctly calculated based on the lunarbirthdate.")
    }
    // 测试五行局
    func testWuXingGameCalculation(){
        XCTAssertEqual(person.wuxingGame?.name , p1bench.wuxinggame, "Wuxing Game should be correctly calculated based on the lunarbirthdate.")
    }

    /**
    测试紫薇天府
    */
    func testStarBranch(){
        if let ziwei = person.ziweiAllStarArrays.first(where: {$0?.name == "紫微"})??.palaceBranch,
           let tianji = person.ziweiAllStarArrays.first(where: {$0?.name == "天机"})??.palaceBranch, 
           let taiyin = person.ziweiAllStarArrays.first(where: {$0?.name == "太阴"})??.palaceBranch, 
           let tianfu = person.tianfuAllStarArrays.first(where: {$0?.name == "天府"})??.palaceBranch{
               let testdict = ["紫微":ziwei,"天机":tianji,"天府":tianfu,"太阴":taiyin]
               XCTAssertEqual(testdict,p1bench.ziweiAllStardict,"")
           } else {
           } 
    }
}
