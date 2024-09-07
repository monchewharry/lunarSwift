import Foundation
public enum hexagramEnum:String, CaseIterable{
    case qian = "乾"
    case kun  = "坤"
    case zun = "屯"
    case meng = "蒙"
    case xu = "需"
    case song = "讼"
    case shi = "师"
    case bi = "比"
    case xiaoChu = "小畜"
    case lv = "履"
    case tai = "泰"
    case pii = "否"
    case tongRen = "同人"
    case daYou = "大有"
    case qian2 = "谦"
    case yu = "豫"
    case sui = "随"
    case gu = "蛊"
    case lin = "临"
    case guan = "观"
    case shiHe = "噬嗑"
    case ben = "贲"
    case bo = "剥"
    case fu = "复"
    case wuWang = "无妄"
    case daChu = "大畜"
    case yi = "颐"
    case daGuo = "大过"
    case kan = "坎"
    case li = "离"
    case xian = "咸"
    case heng = "恒"
    case dun = "遁"
    case daZhuang = "大壮"
    case jin = "晋"
    case mingYi = "明夷"
    case jiaRen = "家人"
    case kui = "睽"
    case jian = "蹇"
    case jie = "解"
    case sun = "损"
    case yi2 = "益"
    case guai = "夬"
    case gou = "姤"
    case cun = "萃"
    case sheng = "升"
    case kun2 = "困"
    case jing = "井"
    case ge = "革"
    case ding = "鼎"
    case zhen = "震"
    case gen = "艮"
    case jian2 = "渐"
    case guiMei = "归妹"
    case feng = "丰"
    case lv2 = "旅"
    case xun = "巽"
    case dui = "兑"
    case huan = "涣"
    case jie2 = "节"
    case zhongFu = "中孚"
    case xiaoGuo = "小过"
    case jiJi = "既济"
    case weiJi = "未济"
}

let binaryArray:[String] = ["111111", "000000", "010001", "100010", "010111", "111010", "000010", "010000", "110111", "111011", "000111", "111000", "111101", "101111", "000100", "001000", "011001", "100110", "000011", "110000", "101001", "100101", "100000", "000001", "111001", "100111", "100001", "011110", "010010", "101101", "011100", "001110", "111100", "001111", "101000", "000101", "110101", "101011", "010100", "001010", "100011", "110001", "011111", "111110", "011000", "000110", "011010", "010110", "011101", "101110", "001001", "100100", "110100", "001011", "001101", "101100", "110110", "011011", "110010", "010011", "110011", "001100", "010101", "101010", ]
let hexagramArray: [hexagramEnum] = [.qian, .kun , .zun, .meng, .xu, .song, .shi, .bi, .xiaoChu, .lv, .tai, .pii, .tongRen, .daYou, .qian2, .yu, .sui, .gu, .lin, .guan, .shiHe, .ben, .bo, .fu, .wuWang, .daChu, .yi, .daGuo, .kan, .li, .xian, .heng, .dun, .daZhuang, .jin, .mingYi, .jiaRen, .kui, .jian, .jie, .sun, .yi2, .guai, .gou, .cun, .sheng, .kun2, .jing, .ge, .ding, .zhen, .gen, .jian2, .guiMei, .feng, .lv2, .xun, .dui, .huan, .jie2, .zhongFu, .xiaoGuo, .jiJi, .weiJi]
let hexagramEnum2binary: [hexagramEnum:String] = Dictionary(uniqueKeysWithValues: zip(hexagramEnum.allCases, binaryArray))
let binary2hexagramEnum: [String:hexagramEnum] = Dictionary(uniqueKeysWithValues: zip(binaryArray , hexagramEnum.allCases))


let hexagramUnicode: [String] = [
    "\u{4DC0}", "\u{4DC1}", "\u{4DC2}", "\u{4DC3}", "\u{4DC4}", "\u{4DC5}", "\u{4DC6}", "\u{4DC7}",
    "\u{4DC8}", "\u{4DC9}", "\u{4DCA}", "\u{4DCB}", "\u{4DCC}", "\u{4DCD}", "\u{4DCE}", "\u{4DCF}",
    "\u{4DD0}", "\u{4DD1}", "\u{4DD2}", "\u{4DD3}", "\u{4DD4}", "\u{4DD5}", "\u{4DD6}", "\u{4DD7}",
    "\u{4DD8}", "\u{4DD9}", "\u{4DDA}", "\u{4DDB}", "\u{4DDC}", "\u{4DDD}", "\u{4DDE}", "\u{4DDF}",
    "\u{4DE0}", "\u{4DE1}", "\u{4DE2}", "\u{4DE3}", "\u{4DE4}", "\u{4DE5}", "\u{4DE6}", "\u{4DE7}",
    "\u{4DE8}", "\u{4DE9}", "\u{4DEA}", "\u{4DEB}", "\u{4DEC}", "\u{4DED}", "\u{4DEE}", "\u{4DEF}",
    "\u{4DF0}", "\u{4DF1}", "\u{4DF2}", "\u{4DF3}", "\u{4DF4}", "\u{4DF5}", "\u{4DF6}", "\u{4DF7}",
    "\u{4DF8}", "\u{4DF9}", "\u{4DFA}", "\u{4DFB}", "\u{4DFC}", "\u{4DFD}", "\u{4DFE}", "\u{4DFF}"
]
let hexagramEnum2UnicodeDict: [hexagramEnum:String] = Dictionary(uniqueKeysWithValues: zip(hexagramEnum.allCases, hexagramUnicode))

public struct Hexagram: Equatable {
    public let pinyin:hexagramEnum
    public var binary:String? {
        hexagramEnum2binary[pinyin]
    }
    public var unicode:String?{
        hexagramEnum2UnicodeDict[pinyin]
    }
    public var name:String {
        pinyin.rawValue
    }
}

public let HexagramArray: [Hexagram] = {
    var result = [Hexagram]()
    for hexa in hexagramEnum.allCases{
        result.append(Hexagram(pinyin: hexa))
    }
    return result
}()

// 定义六十四卦0:阴爻, 1:阳爻
// 64卦的二进制表示，按与hexagramCnChar相同的顺序排列,先上爻后下爻
public let binary2Hexagram: [String: (name: String, longname: String, description: String)] = [
    "111111": ("乾", "乾为天", "刚健中正"),
    "111011": ("履", "天泽履", "脚踏实地"),
    "111101": ("同人", "天火同人", "上下和同"),
    "111001": ("无妄", "天雷无妄", "无妄而得"),
    "111110": ("姤", "天风姤", "天下有风"),
    "111010": ("讼", "天水讼", "慎争戒讼"),
    "111100": ("遁", "天山遁", "遁世救世"),
    "111000": ("否", "天地否", "不交不通"),
    "011111": ("夬", "泽天夬", "决而能和"),
    "011011": ("兑", "兑为泽", "刚内柔外"),
    "011101": ("革", "泽火革", "顺天应人"),
    "011001": ("随", "泽雷随", "随时变通"),
    "011110": ("大过", "泽风大过", "非常行动"),
    "011010": ("困", "泽水困", "困境求通"),
    "011100": ("咸", "泽山咸", "相互感应"),
    "011000": ("萃", "泽地萃", "荟萃聚集"),
    "101111": ("大有", "火天大有", "顺天依时"),
    "101011": ("睽", "火泽睽", "异中求同"),
    "101101": ("离", "离为火", "附和依托"),
    "101001": ("噬嗑", "火雷噬嗑", "刚柔相济"),
    "101110": ("鼎", "火风鼎", "稳重图变"),
    "101010": ("未济", "火水未济", "事业未竟"),
    "101100": ("旅", "火山旅", "依义顺时"),
    "101000": ("晋", "火地晋", "求进发展"),
    "001111": ("大壮", "雷天大壮", "壮勿妄动"),
    "001011": ("归妹", "雷泽归妹", "立家兴业"),
    "001101": ("丰", "雷火丰", "日中则斜"),
    "001001": ("震", "震为雷", "临危不乱"),
    "001110": ("恒", "雷风恒", "恒心有成"),
    "001010": ("解", "雷水解", "柔道致治"),
    "001100": ("小过", "雷山小过", "行动有度"),
    "001000": ("豫", "雷地豫", "顺时依势"),
    "110111": ("小畜", "风天小畜", "蓄养待进"),
    "110011": ("中孚", "风泽中孚", "诚信立身"),
    "110101": ("家人", "风火家人", "诚威治业"),
    "110001": ("益", "风雷益", "损上益下"),
    "110110": ("巽", "巽为风", "谦逊受益"),
    "110010": ("涣", "风水涣", "拯救涣散"),
    "110100": ("渐", "风山渐", "渐进蓄德"),
    "110000": ("观", "风地观", "观下瞻上"),
    "010111": ("需", "水天需", "守正待机"),
    "010011": ("节", "水泽节", "万物有节"),
    "010101": ("既济", "水火既济", "盛极将衰"),
    "010001": ("屯", "水雷屯", "起始维艰"),
    "010110": ("井", "水风井", "求贤若渴"),
    "010010": ("坎", "坎为水", "行险用险"),
    "010100": ("蹇", "水山蹇", "险阻在前"),
    "010000": ("比", "水地比", "诚信团结"),
    "100111": ("大畜", "山天大畜", "止而不止"),
    "100011": ("损", "山泽损", "损益制衡"),
    "100101": ("贲", "山火贲", "饰外扬质"),
    "100001": ("颐", "山雷颐", "纯正以养"),
    "100110": ("蛊", "山风蛊", "振疲起衰"),
    "100010": ("蒙", "山水蒙", "启蒙奋发"),
    "100100": ("艮", "艮为山", "动静适时"),
    "100000": ("剥", "山地剥", "顺势而止"),
    "000111": ("泰", "地天泰", "应时而变"),
    "000011": ("临", "地泽临", "教民保民"),
    "000101": ("明夷", "地火明夷", "晦而转明"),
    "000001": ("复", "地雷复", "寓动于顺"),
    "000110": ("升", "地风升", "柔顺谦虚"),
    "000010": ("师", "地水师", "行险而顺"),
    "000100": ("谦", "地山谦", "内高外低"),
    "000000": ("坤", "坤为地", "柔顺伸展"),
]
