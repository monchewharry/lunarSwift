//  config.swift
//  Created by Dingxian Cao on 8/27/24.
// 1901~2100年农历数据表

import Foundation

let startYear = 1901
let monthDayBit = 12
let leapMonthNumBit = 13


/**
 10天干
 */
//public let the10HeavenlyStems = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
public enum the10StemEnum: String,CaseIterable,Equatable {
    case jia  = "甲"
    case yi   = "乙"
    case bing = "丙"
    case ding = "丁"
    case wu   = "戊"
    case ji   = "己"
    case geng = "庚"
    case xin  = "辛"
    case ren  = "壬"
    case gui  = "癸"
}
let the10HeavenlyStems5ElementsList = ["木", "木", "火", "火", "土", "土", "金", "金", "水", "水"]//tian gan wuxing
public let heavenlyStemsToFiveElements: [the10StemEnum: String] = Dictionary(uniqueKeysWithValues: zip(the10StemEnum.allCases, the10HeavenlyStems5ElementsList))
/**
 12地支
 */
//public let the12EarthlyBranches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]//di zhi
let the12EarthlyBranches5ElementsList = ["水", "土", "木", "木", "土", "火", "火", "土", "金", "金", "土", "水"]//di zhi wuxing
let earthlyBranchesToFiveElements: [the12BranchEnum : String] = Dictionary(uniqueKeysWithValues: zip(the12BranchEnum.allCases, the12EarthlyBranches5ElementsList))
public enum the12BranchEnum: String, CaseIterable,Equatable {
  case zi   = "子"
  case chou = "丑"
  case yin  = "寅"
  case mao  = "卯"
  case chen = "辰"
  case si   = "巳"
  case wu   = "午"
  case wei  = "未"
  case shen = "申"
  case you  = "酉"
  case xu   = "戌"
  case hai  = "亥"
}
/**
reorder the 12 branches into palace order
*/
public let palaceFillorder:[the12BranchEnum] = [ .yin , .mao , .chen, .si  , .wu  , .wei , .shen, .you , .xu  , .hai , .zi  , .chou]

/**
 60甲子排序
 */
public struct StemBranch: Equatable { // tuple of (the10StemEnum, the12BranchEnum) is not equatable
    public let stem: the10StemEnum
    public let branch: the12BranchEnum
    public var name: String {
        stem.rawValue+branch.rawValue
    }
}
// Initialize the array of 60 combinations
/**
 ["甲子", "乙丑", "丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉", "甲戌", "乙亥", "丙子", "丁丑", "戊寅", "己卯", "庚辰", "辛巳", "壬午", "癸未", "甲申", "乙酉", "丙戌", "丁亥", "戊子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳", "甲午", "乙未", "丙申", "丁酉", "戊戌", "己亥", "庚子", "辛丑", "壬寅", "癸卯", "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥", "壬子", "癸丑", "甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥"]
 */
public let the60StemBranchEnumArray: [StemBranch] = {
    var combinations = [StemBranch]()
    let num:Int = (12/(12-10) - 1) * 12 //60
    for i in 0..<num {
        let stem = the10StemEnum.allCases[i % 10]
        let branch = the12BranchEnum.allCases[i % 12]
        combinations.append(StemBranch(stem: stem, branch: branch))
    }
    return combinations
}()


/**
 24节气排序 小寒...冬至
 */
let solarTermsNameList:[String] = ["小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋","处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至"]
let eastZodiacList = ["玄枵", "娵訾", "降娄", "大梁", "实沈", "鹑首", "鹑火", "鹑尾", "寿星", "大火", "析木", "星纪"]

/**
 在六十甲子纳音（每个甲子组合对应一个特定的自然象征或物质象征，如海中金）体系中，它代表特定的天干地支组合的属性。
 */
let halfStemBranchNayinList = [
    "海中金", "炉中火", "大林木", "路旁土", "剑锋金", "山头火", "涧下水", "城头土", "白蜡金", "杨柳木", "井泉水",
    "屋上土", "霹雳火", "松柏木", "长流水", "砂中金", "山下火", "平地木", "壁上土", "金箔金", "覆灯火", "天河水",
    "大驿土", "钗钏金", "桑柘木", "大溪水", "砂中土", "天上火", "石榴木", "大海水"
]//theHalf60HeavenlyEarth5ElementsList

/**
 28宿：星宿被分成四象，每象包含七宿
 */
let the28StarsList:[String] = [
    "角木蛟", "亢金龙", "氐土貉", "房日兔", "心月狐", "尾火虎", "箕水豹", //东方青龙七宿
    "斗木獬", "牛金牛", "女土蝠", "虚日鼠", "危月燕", "室火猪", "壁水貐", //南方朱雀七宿
    "奎木狼", "娄金狗", "胃土雉", "昴日鸡", "毕月乌", "觜火猴", "参水猿", //西方白虎七宿
    "井木犴", "鬼金羊", "柳土獐", "星日马", "张月鹿", "翼火蛇", "轸水蚓" //北方玄武七宿
]

/**
 生肖
 */
let chineseZodiacNameList:[Character] = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
/**
 12值日神
 */
let chinese12DayOfficers:[Character] = Array("建除满平定执破危成收开闭" )
/**
 12宫，12长生
 */
let chinese12DayGods:[String] = ["青龙", "明堂", "天刑", "朱雀", "金贵", "天德", "白虎", "玉堂", "天牢", "玄武", "司命", "勾陈"]

//方位和八卦的对应
let directionList:[String] = ["正北", "东北", "正东", "东南", "正南", "西南", "正西", "西北"]
let chinese8Trigrams:[Character] = Array("坎艮震巽离坤兑乾")
/**
 吉神排序列表
 */
public let listofluckgods:[String] = ["喜神","财神","福神","阳贵","阴贵"]
let luckyGodDirection:[Character] = Array("艮乾坤离巽艮乾坤离巽") //吉神,福神，财神，阳贵，阴贵方位
let wealthGodDirection:[Character] = Array("艮艮坤坤坎坎震震离离")
let mascotGodDirection:[Character] = Array("坎坤乾巽艮坎坤乾巽艮")
let sunNobleDirection:[Character] = Array("坤坤兑乾艮坎离艮震巽")
let moonNobleDirection:[Character] = Array("艮坎乾兑坤坤艮离巽震")

/**
 胎神
 */
let fetalGodList = [
    "碓磨门外东南", "碓磨厕外东南", "厨灶炉外正南", "仓库门外正南", "房床厕外正南", "占门床外正南",
    "占碓磨外正南", "厨灶厕外西南", "仓库炉外西南", "房床门外西南", "门碓栖外西南", "碓磨床外西南",
    "厨灶碓外西南", "仓库厕外西南", "房床厕外正南", "房床炉外正西", "碓磨栖外正西", "厨灶床外正西",
    "仓库碓外西北", "房床厕外西北", "占门炉外西北", "碓磨门外西北", "厨灶栖外西北", "仓库床外西北",
    "房床碓外正北", "占门厕外正北", "碓磨炉外正北", "厨灶门外正北", "仓库栖外正北", "占房床房内北",
    "占门碓房内北", "碓磨门房内北", "厨灶炉房内北", "仓库门房内北", "房床栖房内中", "占门床房内中",
    "占碓磨房内南", "厨灶厕房内南", "仓库炉房内南", "房床门房内南", "门鸡栖房内东", "碓磨床房内东",
    "厨灶碓房内东", "仓库厕房内东", "房床炉房内东", "占大门外东北", "碓磨栖外东北", "厨灶床外东北",
    "仓库碓外东北", "房床厕外东北", "占门炉外东北", "碓磨门外正东", "厨灶栖外正东", "仓库床外正东",
    "房床碓外正东", "占门厕外正东", "碓磨炉外东南", "仓库栖外东南", "占房床外东南", "占门碓外东南"
]
/**
 时辰经络
 */
let meridiansName = ["胆", "肝", "肺", "大肠", "胃", "脾", "心", "小肠", "膀胱", "肾", "心包", "三焦"]

let lunarMonthNameList = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]
let lunarDayNameList = [
    "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
    "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
    "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"
]

let upperNum = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
let weekDay = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]

/**
 1901-2100年二十节气最小数序列 向量压缩法
 */
let encVectorList:[Int] = [4, 19, 3, 18, 4, 19, 4, 19, 4, 20, 4, 20, 6, 22, 6, 22, 6, 22, 7, 22, 6, 21, 6, 21]

/**
 * 1901-2100年香港天文台公布二十四节气按年存储16进制，1个16进制为4个2进制记录了一年的24节气日期.
 * unZipSolarTermsList(data:solarTermsDataList[0]) -> [6, 21, 4, 19, 6, 21, 5, 21, 6, 22, 6, 22, 8, 23, 8, 24, 8, 24, 9, 24, 8, 23, 8, 22]
 * 1901年的小寒为1月6日，大寒为1月21日，立春为2月4日，以此类推。。。
 * cross validation: http://cn.nongli.info/years/index.php?year=1901
 */
let solarTermsDataList: [Int] = [
    0x6aaaa6aa9a5a, 0xaaaaaabaaa6a, 0xaaabbabbafaa, 0x5aa665a65aab, 0x6aaaa6aa9a5a,     // 1901 ~ 1905
        0xaaaaaaaaaa6a, 0xaaabbabbafaa, 0x5aa665a65aab, 0x6aaaa6aa9a5a, 0xaaaaaaaaaa6a,
        0xaaabbabbafaa, 0x5aa665a65aab, 0x6aaaa6aa9a56, 0xaaaaaaaa9a5a, 0xaaabaabaaeaa,
        0x569665a65aaa, 0x5aa6a6a69a56, 0x6aaaaaaa9a5a, 0xaaabaabaaeaa, 0x569665a65aaa,
        0x5aa6a6a65a56, 0x6aaaaaaa9a5a, 0xaaabaabaaa6a, 0x569665a65aaa, 0x5aa6a6a65a56,
        0x6aaaa6aa9a5a, 0xaaaaaabaaa6a, 0x555665665aaa, 0x5aa665a65a56, 0x6aaaa6aa9a5a,
        0xaaaaaabaaa6a, 0x555665665aaa, 0x5aa665a65a56, 0x6aaaa6aa9a5a, 0xaaaaaaaaaa6a,
        0x555665665aaa, 0x5aa665a65a56, 0x6aaaa6aa9a5a, 0xaaaaaaaaaa6a, 0x555665665aaa,
        0x5aa665a65a56, 0x6aaaa6aa9a5a, 0xaaaaaaaaaa6a, 0x555665655aaa, 0x569665a65a56,
        0x6aa6a6aa9a56, 0xaaaaaaaa9a5a, 0x5556556559aa, 0x569665a65a55, 0x6aa6a6a65a56,
        0xaaaaaaaa9a5a, 0x5556556559aa, 0x569665a65a55, 0x5aa6a6a65a56, 0x6aaaa6aa9a5a,
        0x5556556555aa, 0x569665a65a55, 0x5aa665a65a56, 0x6aaaa6aa9a5a, 0x55555565556a,
        0x555665665a55, 0x5aa665a65a56, 0x6aaaa6aa9a5a, 0x55555565556a, 0x555665665a55,
        0x5aa665a65a56, 0x6aaaa6aa9a5a, 0x55555555556a, 0x555665665a55, 0x5aa665a65a56,
        0x6aaaa6aa9a5a, 0x55555555556a, 0x555665655a55, 0x5aa665a65a56, 0x6aa6a6aa9a5a,
        0x55555555456a, 0x555655655a55, 0x5a9665a65a56, 0x6aa6a6a69a5a, 0x55555555456a,
        0x555655655a55, 0x569665a65a56, 0x6aa6a6a65a56, 0x55555155455a, 0x555655655955,
        0x569665a65a55, 0x5aa6a5a65a56, 0x15555155455a, 0x555555655555, 0x569665665a55,
        0x5aa665a65a56, 0x15555155455a, 0x555555655515, 0x555665665a55, 0x5aa665a65a56,
        0x15555155455a, 0x555555555515, 0x555665665a55, 0x5aa665a65a56, 0x15555155455a,
        0x555555555515, 0x555665665a55, 0x5aa665a65a56, 0x15555155455a, 0x555555555515,
        0x555655655a55, 0x5aa665a65a56, 0x15515155455a, 0x555555554515, 0x555655655a55,
        0x5a9665a65a56, 0x15515151455a, 0x555551554515, 0x555655655a55, 0x569665a65a56,
        0x155151510556, 0x555551554505, 0x555655655955, 0x569665665a55, 0x155110510556,
        0x155551554505, 0x555555655555, 0x569665665a55, 0x55110510556, 0x155551554505,
        0x555555555515, 0x555665665a55, 0x55110510556, 0x155551554505, 0x555555555515,
        0x555665665a55, 0x55110510556, 0x155551554505, 0x555555555515, 0x555655655a55,
        0x55110510556, 0x155551554505, 0x555555555515, 0x555655655a55, 0x55110510556,
        0x155151514505, 0x555555554515, 0x555655655a55, 0x54110510556, 0x155151510505,
        0x555551554515, 0x555655655a55, 0x14110110556, 0x155110510501, 0x555551554505,
        0x555555655555, 0x14110110555, 0x155110510501, 0x555551554505, 0x555555555555,
        0x14110110555, 0x55110510501, 0x155551554505, 0x555555555555, 0x110110555,
        0x55110510501, 0x155551554505, 0x555555555515, 0x110110555, 0x55110510501,
        0x155551554505, 0x555555555515, 0x100100555, 0x55110510501, 0x155151514505,
        0x555555555515, 0x100100555, 0x54110510501, 0x155151514505, 0x555551554515,
        0x100100555, 0x54110510501, 0x155150510505, 0x555551554515, 0x100100555,
        0x14110110501, 0x155110510505, 0x555551554505, 0x100055, 0x14110110500,
        0x155110510501, 0x555551554505, 0x55, 0x14110110500, 0x55110510501,
        0x155551554505, 0x55, 0x110110500, 0x55110510501, 0x155551554505,
        0x15, 0x100110500, 0x55110510501, 0x155551554505, 0x555555555515
]

/**
 闰几月 闰月日数  12-1 月份农历日数 0=29天 1=30天
 */
let lunarMonthData: [Int] = [
    0x00752, 0x00ea5, 0x0ab2a, 0x0064b, 0x00a9b, 0x09aa6, 0x0056a, 0x00b59, 0x04baa, 0x00752,  // 1901 ~ 1910
        0x0cda5, 0x00b25, 0x00a4b, 0x0ba4b, 0x002ad, 0x0056b, 0x045b5, 0x00da9, 0x0fe92, 0x00e92,  // 1911 ~ 1920
        0x00d25, 0x0ad2d, 0x00a56, 0x002b6, 0x09ad5, 0x006d4, 0x00ea9, 0x04f4a, 0x00e92, 0x0c6a6,  // 1921 ~ 1930
        0x0052b, 0x00a57, 0x0b956, 0x00b5a, 0x006d4, 0x07761, 0x00749, 0x0fb13, 0x00a93, 0x0052b,  // 1931 ~ 1940
        0x0d51b, 0x00aad, 0x0056a, 0x09da5, 0x00ba4, 0x00b49, 0x04d4b, 0x00a95, 0x0eaad, 0x00536,  // 1941 ~ 1950
        0x00aad, 0x0baca, 0x005b2, 0x00da5, 0x07ea2, 0x00d4a, 0x10595, 0x00a97, 0x00556, 0x0c575,  // 1951 ~ 1960
        0x00ad5, 0x006d2, 0x08755, 0x00ea5, 0x0064a, 0x0664f, 0x00a9b, 0x0eada, 0x0056a, 0x00b69,  // 1961 ~ 1970
        0x0abb2, 0x00b52, 0x00b25, 0x08b2b, 0x00a4b, 0x10aab, 0x002ad, 0x0056d, 0x0d5a9, 0x00da9,  // 1971 ~ 1980
        0x00d92, 0x08e95, 0x00d25, 0x14e4d, 0x00a56, 0x002b6, 0x0c2f5, 0x006d5, 0x00ea9, 0x0af52,  // 1981 ~ 1990
        0x00e92, 0x00d26, 0x0652e, 0x00a57, 0x10ad6, 0x0035a, 0x006d5, 0x0ab69, 0x00749, 0x00693,  // 1991 ~ 2000
        0x08a9b, 0x0052b, 0x00a5b, 0x04aae, 0x0056a, 0x0edd5, 0x00ba4, 0x00b49, 0x0ad53, 0x00a95,  // 2001 ~ 2010
        0x0052d, 0x0855d, 0x00ab5, 0x12baa, 0x005d2, 0x00da5, 0x0de8a, 0x00d4a, 0x00c95, 0x08a9e,  // 2011 ~ 2020
        0x00556, 0x00ab5, 0x04ada, 0x006d2, 0x0c765, 0x00725, 0x0064b, 0x0a657, 0x00cab, 0x0055a,  // 2021 ~ 2030
        0x0656e, 0x00b69, 0x16f52, 0x00b52, 0x00b25, 0x0dd0b, 0x00a4b, 0x004ab, 0x0a2bb, 0x005ad,  // 2031 ~ 2040
        0x00b6a, 0x04daa, 0x00d92, 0x0eea5, 0x00d25, 0x00a55, 0x0ba4d, 0x004b6, 0x005b5, 0x076d2,  // 2041 ~ 2050
        0x00ec9, 0x10f92, 0x00e92, 0x00d26, 0x0d516, 0x00a57, 0x00556, 0x09365, 0x00755, 0x00749,  // 2051 ~ 2060
        0x0674b, 0x00693, 0x0eaab, 0x0052b, 0x00a5b, 0x0aaba, 0x0056a, 0x00b65, 0x08baa, 0x00b4a,  // 2061 ~ 2070
        0x10d95, 0x00a95, 0x0052d, 0x0c56d, 0x00ab5, 0x005aa, 0x085d5, 0x00da5, 0x00d4a, 0x06e4d,  // 2071 ~ 2080
        0x00c96, 0x0ecce, 0x00556, 0x00ab5, 0x0bad2, 0x006d2, 0x00ea5, 0x0872a, 0x0068b, 0x10697,  // 2081 ~ 2090
        0x004ab, 0x0055b, 0x0d556, 0x00b6a, 0x00752, 0x08b95, 0x00b45, 0x00a8b, 0x04a4f,
]
/**
 春节月  春节日
 */
let lunarNewYearList: [Int] = [
    0x53, 0x48, 0x3d, 0x50, 0x44, 0x39, 0x4d, 0x42, 0x36, 0x4a,  // 1901 ~ 1910
        0x3e, 0x52, 0x46, 0x3a, 0x4e, 0x43, 0x37, 0x4b, 0x41, 0x54,  // 1911 ~ 1920
        0x48, 0x3c, 0x50, 0x45, 0x38, 0x4d, 0x42, 0x37, 0x4a, 0x3e,  // 1921 ~ 1930
        0x51, 0x46, 0x3a, 0x4e, 0x44, 0x38, 0x4b, 0x3f, 0x53, 0x48,  // 1931 ~ 1940
        0x3b, 0x4f, 0x45, 0x39, 0x4d, 0x42, 0x36, 0x4a, 0x3d, 0x51,  // 1941 ~ 1950
        0x46, 0x3b, 0x4e, 0x43, 0x38, 0x4c, 0x3f, 0x52, 0x48, 0x3c,  // 1951 ~ 1960
        0x4f, 0x45, 0x39, 0x4d, 0x42, 0x35, 0x49, 0x3e, 0x51, 0x46,  // 1961 ~ 1970
        0x3b, 0x4f, 0x43, 0x37, 0x4b, 0x3f, 0x52, 0x47, 0x3c, 0x50,  // 1971 ~ 1980
        0x45, 0x39, 0x4d, 0x42, 0x54, 0x49, 0x3d, 0x51, 0x46, 0x3b,  // 1981 ~ 1990
        0x4f, 0x44, 0x37, 0x4a, 0x3f, 0x53, 0x47, 0x3c, 0x50, 0x45,  // 1991 ~ 2000
        0x38, 0x4c, 0x41, 0x36, 0x49, 0x3d, 0x52, 0x47, 0x3a, 0x4e,  // 2001 ~ 2010
        0x43, 0x37, 0x4a, 0x3f, 0x53, 0x48, 0x3c, 0x50, 0x45, 0x39,  // 2011 ~ 2020
        0x4c, 0x41, 0x36, 0x4a, 0x3d, 0x51, 0x46, 0x3a, 0x4d, 0x43,  // 2021 ~ 2030
        0x37, 0x4b, 0x3f, 0x53, 0x48, 0x3c, 0x4f, 0x44, 0x38, 0x4c,  // 2031 ~ 2040
        0x41, 0x36, 0x4a, 0x3e, 0x51, 0x46, 0x3a, 0x4e, 0x42, 0x37,  // 2041 ~ 2050
        0x4b, 0x41, 0x53, 0x48, 0x3c, 0x4f, 0x44, 0x38, 0x4c, 0x42,  // 2051 ~ 2060
        0x35, 0x49, 0x3d, 0x51, 0x45, 0x3a, 0x4e, 0x43, 0x37, 0x4b,  // 2061 ~ 2070
        0x3f, 0x53, 0x47, 0x3b, 0x4f, 0x45, 0x38, 0x4c, 0x42, 0x36,  // 2071 ~ 2080
        0x49, 0x3d, 0x51, 0x46, 0x3a, 0x4e, 0x43, 0x38, 0x4a, 0x3e,  // 2081 ~ 2090
        0x52, 0x47, 0x3b, 0x4f, 0x45, 0x39, 0x4c, 0x41, 0x35, 0x49,  // 2091 ~ 2100
]


//----------十神
/**
 * 计算十神规则：以日干为命主（我），结合天干的五行生克与阴阳属性，计算与其他三柱天干的关系
 * - 生我者为印绶(正印、偏印)；
 * - 我生者为食伤(食神、伤官)；
 * - 克我者为官煞(正官、七杀)；
 * - 我克者为妻财(正财、偏财)；
 * - 同类者为比劫(比肩、劫财)。
 * - 再按照天干的阴阳性选择
 */
public func generateTenGods(for dayStem: the10StemEnum) -> [the10StemEnum: String] {
    let yinYang: [the10StemEnum: String] = [
        .jia: "阳", .yi: "阴",
        .bing: "阳", .ding: "阴",
        .wu: "阳", .ji: "阴",
        .geng: "阳", .xin: "阴",
        .ren: "阳", .gui: "阴"
        ]
    let dayelement = heavenlyStemsToFiveElements[dayStem]! //日主为命主：日干
    var relationships = [the10StemEnum: String]()

    for (stem, stemElement) in heavenlyStemsToFiveElements {//结合五行生克关系以及阴阳属性
        if dayelement == stemElement {
            relationships[stem] = dayStem == stem ? "比肩" : "劫财"
        } else if dayelement == "木" && stemElement == "火" ||
                    dayelement == "火" && stemElement == "土" ||
                    dayelement == "土" && stemElement == "金" ||
                    dayelement == "金" && stemElement == "水" ||
                    dayelement == "水" && stemElement == "木" {
            relationships[stem] = yinYang[stem] == yinYang[dayStem] ? "食神" : "伤官"
        } else if dayelement == "木" && stemElement == "土" || //dayElement destroy stemElement
                    dayelement == "火" && stemElement == "金" ||
                    dayelement == "土" && stemElement == "水" ||
                    dayelement == "金" && stemElement == "木" ||
                    dayelement == "水" && stemElement == "火" {
            relationships[stem] = yinYang[stem] == yinYang[dayStem] ? "偏财" : "正财"
        } else if dayelement == "木" && stemElement == "金" || //stemElement destroy dayElement
                    dayelement == "火" && stemElement == "水" ||
                    dayelement == "土" && stemElement == "木" ||
                    dayelement == "金" && stemElement == "火" ||
                    dayelement == "水" && stemElement == "土" {
            relationships[stem] = yinYang[stem] == yinYang[dayStem] ? "七杀" : "正官"
        } else if dayelement == "木" && stemElement == "水" || //stemElement generate dayElement
                    dayelement == "火" && stemElement == "木" ||
                    dayelement == "土" && stemElement == "火" ||
                    dayelement == "金" && stemElement == "土" ||
                    dayelement == "水" && stemElement == "金" {
            relationships[stem] = yinYang[stem] == yinYang[dayStem] ? "偏印" : "正印"
        }
    }

    return relationships
}

/**
 天干十神关系表，详见generateTenGods()
 */
public let tianGanRelationships: [the10StemEnum: [the10StemEnum: String]] = [
    .jia : generateTenGods(for: .jia ),
    .yi  : generateTenGods(for: .yi  ),
    .bing: generateTenGods(for: .bing),
    .ding: generateTenGods(for: .ding),
    .wu  : generateTenGods(for: .wu  ),
    .ji  : generateTenGods(for: .ji  ),
    .geng: generateTenGods(for: .geng),
    .xin : generateTenGods(for: .xin ),
    .ren : generateTenGods(for: .ren ),
    .gui : generateTenGods(for: .gui )
]//Donary(uniqueKeysWithValues: tianGan.map { ($0, generateTenGods(for: $0)) })

//-----------十二宫
/**
 命宫地支参考顺序：命盘顺序 寅...丑
 */

/**
 十二宫排序array
 */
public let palacesArray = [
    "命宫",    // Destiny Palace
    "兄弟宫",  // Siblings Palace
    "夫妻宫",  // Spouse Palace
    "子女宫",  // Children Palace
    "财帛宫",  // Wealth Palace
    "疾厄宫",  // Misfortune Palace
    "迁移宫",  // Travel Palace
    "交友宫",
    "仕途宫",  // Career Palace
    "田宅宫",  // Property Palace
    "福德宫",  // Blessings Palace
    "父母宫",  // Parents Palace
]

/**
 * 生成五虎遁月歌 年干与十二宫天干对应数据表:
 * https://www.douban.com/note/833981956/?_i=5298526gC9k0WR
 */
func rotateArrayToLeft(_ array: [String] = ["戊", "己", "庚", "辛", "壬", "癸", "甲", "乙", "丙", "丁"], by steps: Int) -> [String] {
    let count = array.count
    let effectiveSteps = steps % count  // Ensure the steps don't exceed the array length
    let rotatedleftarray=Array(array[effectiveSteps...] + array[0..<effectiveSteps])//rotate by steps
    return rotatedleftarray.suffix(2) + rotatedleftarray
}
var array = ["戊", "己", "庚", "辛", "壬", "癸", "甲", "乙", "丙", "丁"]
let rotatedLeft0 = rotateArrayToLeft(array, by: 0*2)
let rotatedLeft1 = rotateArrayToLeft(array, by: 1*2)
let rotatedLeft2 = rotateArrayToLeft(array, by: 2*2)
let rotatedLeft3 = rotateArrayToLeft(array, by: 3*2)
let rotatedLeft4 = rotateArrayToLeft(array, by: 4*2)

/**
 The match between year's stem to 12 palaces' stem ordered by 12 palaces' branch' order (diZhi2)
 */
let yearStemToSequence: [the10StemEnum : [String]] = [
    //columns are [ "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥","子", "丑"]
    .jia : rotatedLeft0,
    .yi  : rotatedLeft1,
    .bing: rotatedLeft2,
    .ding: rotatedLeft3,
    .wu  : rotatedLeft4,
    .ji  : rotatedLeft0,
    .geng: rotatedLeft1,
    .xin : rotatedLeft2,
    .ren : rotatedLeft3,
    .gui : rotatedLeft4,
]

//---------------------------------星耀安放
// https://www.ziweishe.com/?sex=1&date_type=1&year=1993&month=11&day=22&hour=4
/**
 * 四种重要的星曜变化(四化)：禄、权、科、忌
 * 四化的确定依赖于个人的出生信息（尤其是年柱中的天干），并根据固定的对照表来分配
 */
let sihuaMap: [the10StemEnum: [String: String]] = [
    .jia: [
        "lianzhen": "禄",
        "pojun": "权",
        "wuqu": "科",
        "taiyang": "忌"
    ],
    .yi: [
        "tianji": "禄",
        "tianliang": "权",
        "ziwei": "科",
        "taiyin": "忌"
    ],
    .bing: [
        "tiantong": "禄",
        "tianji": "权",
        "wenchang": "科",
        "lianzhen": "忌"
    ],
    .ding: [
        "taiyin": "禄",
        "tiantong": "权",
        "tianji": "科",
        "jumen": "忌"
    ],
    .wu: [
        "tanlang": "禄",
        "taiyin": "权",
        "youbi": "科",
        "tianji": "忌"
    ],
    .ji: [
        "wuqu": "禄",
        "tanlang": "权",
        "tianliang": "科",
        "wenqu": "忌"
    ],
    .geng: [
        "taiyang": "禄",
        "wuqu": "权",
        "taiyin": "科",
        "tiantong": "忌"
    ],
    .xin: [
        "jumen": "禄",
        "taiyang": "权",
        "wenqu": "科",
        "wenchang": "忌"
    ],
    .ren: [
        "tianliang": "禄",
        "ziwei": "权",
        "zuofu": "科",
        "wuqu": "忌"
    ],
    .gui: [
        "pojun": "禄",
        "jumen": "权",
        "taiyin": "科",
        "tanlang": "忌"
    ]
]

// ----------------------- 次星规则

/**
 禄存
 */
let lucunRule: [the10StemEnum: the12BranchEnum] = [
   .jia: .yin,
   .yi: .mao,
   .bing: .si,
   .wu: .si,
   .ding: .wu,
   .ji: .wu,
   .geng: .shen,
   .xin: .you,
   .ren: .hai,
   .gui: .zi
]
/**
 天马
 */
let tianma: [the12BranchEnum: the12BranchEnum] = [
    .shen: .yin,
    .zi: .yin,
    .chen: .yin,
    .yin: .shen,
    .wu: .shen,
    .xu: .shen,
    .hai: .si,
    .mao: .si,
    .wei: .si,
    .si: .hai,
    .you: .hai,
    .chou: .hai
]
/**
 火星: yearBranch: branch
 */
let huoxing: [the12BranchEnum: the12BranchEnum] = [
    .yin: .chou,
    .wu: .chou,
    .xu: .chou,
    .shen: .yin,
    .zi: .yin,
    .chen: .yin,
    .si: .mao,
    .you: .mao,
    .chou: .mao,
    .hai: .you,
    .mao: .you,
    .wei: .you
]
/**
 铃星
 */
let lingxing: [the12BranchEnum: the12BranchEnum] = [
    .yin: .mao,
    .wu: .mao,
    .xu: .mao,
    .shen: .xu,
    .zi: .xu,
    .chen: .xu,
    .si: .xu,
    .you: .xu,
    .chou: .xu,
    .hai: .xu,
    .mao: .xu,
    .wei: .xu
]
/**
 咸池
 */
let xianchi: [the12BranchEnum: the12BranchEnum] = [
    .yin: .mao,
    .wu: .mao,
    .xu: .mao,
    .shen: .you,
    .zi: .you,
    .chen: .you,
    .si: .wu,
    .you: .wu,
    .chou: .wu,
    .hai: .zi,
    .mao: .zi,
    .wei: .zi
]
