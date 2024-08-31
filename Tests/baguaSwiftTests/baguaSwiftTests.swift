import XCTest
@testable import baguaSwift 

class testgua {
    var binary6: String
    var guaname: String
    var guades: String
    init(binary6:String, guaname:String, guades:String) {
        self.binary6 = binary6
        self.guaname = guaname
        self.guades = guades 
    }
}
let guabench = testgua(binary6: "111111", guaname: "乾",guades: "乾卦原文")


final class baguaSwiftTests: XCTestCase {
    func testGuaNameMatch(){
        let gua = guaCi[guabench.binary6]
        XCTAssertEqual(gua?.name, guabench.guaname, "should be following the specific format")
        }
    func testGuaFile(){
        let gua = getHexagramInfo(for: guabench.binary6)!
        let guades = String(gua.description.prefix(4))
        XCTAssertEqual(guades, guabench.guades, "should be following the specific format")


        }

}
