
import Foundation

// 64卦顺序列表
public let hexagramNames: [String] = [
    "乾", "坤", "屯", "蒙", "需", "讼", "师", "比", 
    "小畜", "履", "泰", "否", "同人", "大有", "谦", "豫",
    "随", "蛊", "临", "观", "噬嗑", "贲", "剥", "复", 
    "无妄", "大畜", "颐", "大过", "坎", "离", "咸", "恒",
    "遁", "大壮", "晋", "明夷", "家人", "睽", "蹇", "解", 
    "损", "益", "夬", "姤", "萃", "升", "困", "井",
    "革", "鼎", "震", "艮", "渐", "归妹", "丰", "旅", 
    "巽", "兑", "涣", "节", "中孚", "小过", "既济", "未济"
]

// 定义六十四卦0:阴爻, 1:阳爻
// 64卦的二进制表示，按与hexagramNames相同的顺序排列,先上爻后下爻
public let guaCi: [String: (name: String, symbol: String, description: String)] = [
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
    "000000": ("坤", "坤为地", "柔顺伸展")
]

public let matchedBinary = hexagramNames.compactMap { name in
    guaCi.first { $0.value.name == name }?.key
}//order binary by hexagramNames