import XCTest
@testable import baguaSwift 

class testgua {
    var binary6: String
    var guaname: String
    var guades: String
    var guadestitles: [String]
    init(binary6:String, guaname:String, guades:String,guadestitles:[String]) {
        self.binary6 = binary6
        self.guaname = guaname
        self.guades = guades 
        self.guadestitles = guadestitles
    }
}
let titles = [
    "乾卦原文",
    "白话文解释",
    "《断易天机》解",
    "北宋易学家邵雍解",
    "台湾国学大儒傅佩荣解",
    "传统解卦",
    "台湾张铭仁解卦"
]
let guabench = testgua(binary6: "111111", guaname: "乾",guades: "乾卦原文",guadestitles:titles)


final class baguaSwiftTests: XCTestCase {
    func testGuaNameMatch(){
        let gua = guaBinary[guabench.binary6]
        XCTAssertEqual(gua?.name, guabench.guaname, "should be following the specific format")
        }
    func testGuaFilehandles(){
        let gua = getHexagramInfo(for: guabench.binary6)!
        let guades = String(gua.description.prefix(4))
        let (labels, paragraphs) = getHexagramInfoParts(getHexagramInfo(for: guabench.binary6)!.description)
        let paraExpected = "乾卦：大吉大利，吉利的贞卜。\n《象辞》说：天道刚健，运行不已。君子观此卦象，从而以天为法，自强不息。"
        
        XCTAssertEqual(guades, guabench.guades, "should be following the specific format")
        XCTAssertEqual(labels, titles, "should be following the specific format")
        XCTAssertEqual(paragraphs["白话文解释"],paraExpected,"should be following the specific format")
        }

}