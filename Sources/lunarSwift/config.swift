//  config.swift
//  Created by Dingxian Cao on 8/27/24.
// 1901~2100年农历数据表

import Foundation

public enum gendersEnum: String, CaseIterable, Equatable,LocalizableEnum{
    case male = "男"
    case female = "女"
    case unknowngender = "性别未知"
}
let startYear = 1901
let monthDayBit = 12
let leapMonthNumBit = 13

//MARK:  enums localization protocol
///protocol for enums that have a rawValue of type String, same as adding the method localized to all enum instances.
public protocol LocalizableEnum: RawRepresentable where RawValue == String {}
extension LocalizableEnum {
    // Method to localize rawValue with tableName
    public func localized(in tableName: String) -> String {
        return NSLocalizedString(self.rawValue, tableName: tableName, bundle: .main, value: "", comment: "")
    }
}



//MARK:  define errors for Lunar Class
public enum LunarError: Error {
    case dateOutOfBounds
}

//MARK: the five elements' type
public enum the5wuxingEnum: String,CaseIterable,Equatable,LocalizableEnum {
    case jin   =   "金"
    case mu    =   "木"
    case shui  =   "水"
    case huo   =   "火"
    case tu    =   "土"
}

//MARK: the 10 stems type
public enum the10StemEnum: String,CaseIterable,Equatable,LocalizableEnum {
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
let the10HeavenlyStems5ElementsList:[the5wuxingEnum] = [.mu, .mu, .huo, .huo, .tu, .tu, .jin, .jin, .shui, .shui]//tian gan wuxing
public let heavenlyStemsToFiveElements: [the10StemEnum: the5wuxingEnum] = Dictionary(uniqueKeysWithValues: zip(the10StemEnum.allCases, the10HeavenlyStems5ElementsList))
let the12EarthlyBranches5ElementsList:[the5wuxingEnum] = [.shui, .tu, .mu, .mu, .tu, .huo, .huo, .tu, .jin, .jin, .tu, .shui]//di zhi wuxing
let earthlyBranchesToFiveElements: [the12BranchEnum : the5wuxingEnum] = Dictionary(uniqueKeysWithValues: zip(the12BranchEnum.allCases, the12EarthlyBranches5ElementsList))

//MARK: the 12 branches type
public enum the12BranchEnum: String, CaseIterable,Equatable,LocalizableEnum {
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
* reorder the 12 branches into palace order
* [ "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥","子", "丑"]
*/
public let palaceFillorder:[the12BranchEnum] = [ .yin , .mao , .chen, .si  , .wu  , .wei , .shen, .you , .xu  , .hai , .zi  , .chou]
//public let palaceFillorderDict: [the12BranchEnum: Int] = [
//    .yin: 0, .mao: 1, .chen: 2, .si: 3, .wu: 4, .wei: 5,
//    .shen: 6, .you: 7, .xu: 8, .hai: 9, .zi: 10, .chou: 11
//]

//MARK: protocol for struct that have a rawValue of type String, same as adding the method localized to all enum instances.
public protocol LocalizableStemBranchName {
    var localizationStemKey: String { get }
    var localizationBranchKey: String { get }
    func localName(tableName: String) -> String
}
extension LocalizableStemBranchName {
    public func localName(tableName: String) -> String {
        let stems = NSLocalizedString(localizationStemKey, tableName: tableName, bundle: .main, value: localizationStemKey, comment: "")
        let branchs = NSLocalizedString(localizationBranchKey, tableName: tableName, bundle: .main, value: localizationBranchKey, comment: "")
        return stems+branchs
    }
}
public struct StemBranch: Equatable, LocalizableStemBranchName { // tuple of (the10StemEnum, the12BranchEnum) is not equatable
    public let stem: the10StemEnum
    public let branch: the12BranchEnum
    public var name: String {
        stem.rawValue+branch.rawValue
    }
    
    public var localizationStemKey: String{
        stem.rawValue
    }
    public var localizationBranchKey: String{
        branch.rawValue
    }
}

//MARK: Initialize the array of 60 combinations

/**
 60甲子排序, the 60 combination of 10 stems and 12 branches
 
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

//MARK: 节气

/**
 *  24节气排序 小寒...冬至
 * https://www.hko.gov.hk/en/gts/time/24solarterms.htm
 */
//let solarTermsNameList:[String] = ["小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至"]
public enum solarTermsEnum:String,CaseIterable,Equatable,LocalizableEnum{
    case xiaohan     = "小寒" 
    case dahan       = "大寒"
    case lichun      = "立春"
    case yushui      = "雨水"
    case jinzhe      = "惊蛰"
    case chunfen     = "春分"
    case qingming    = "清明"
    case guyu        = "谷雨"
    case lixia       = "立夏"
    case xiaoman     = "小满"
    case mangzhong   = "芒种"
    case xiazhi      = "夏至"
    case xiaoshu     = "小暑"
    case dashu       = "大暑"
    case liqiu       = "立秋"
    case chushu      = "处暑"
    case bailu       = "白露"
    case qiufen      = "秋分"
    case hanlu       = "寒露"
    case shuangjiang = "霜降"
    case lidong      = "立冬"
    case xiaoxue     = "小雪"
    case daxue       = "大雪"
    case dongzhi     = "冬至"
    
    case no          = "无"
}


let eastZodiacList = ["玄枵", "娵訾", "降娄", "大梁", "实沈", "鹑首", "鹑火", "鹑尾", "寿星", "大火", "析木", "星纪"]

//MARK: 纳音
/// 在六十甲子纳音（每个甲子组合对应一个特定的自然象征或物质象征，如海中金）体系中，它代表特定的天干地支组合的属性。
let halfStemBranchNayinList = [
    "海中金", "炉中火", "大林木", "路旁土", "剑锋金", "山头火", "涧下水", "城头土", "白蜡金", "杨柳木", "井泉水",
    "屋上土", "霹雳火", "松柏木", "长流水", "砂中金", "山下火", "平地木", "壁上土", "金箔金", "覆灯火", "天河水",
    "大驿土", "钗钏金", "桑柘木", "大溪水", "砂中土", "天上火", "石榴木", "大海水"
]//theHalf60HeavenlyEarth5ElementsList


//MARK: 28宿：星宿被分成四象，每象包含七宿
let the28StarsList:[String] = [
    "角木蛟", "亢金龙", "氐土貉", "房日兔", "心月狐", "尾火虎", "箕水豹", //东方青龙七宿
    "斗木獬", "牛金牛", "女土蝠", "虚日鼠", "危月燕", "室火猪", "壁水貐", //南方朱雀七宿
    "奎木狼", "娄金狗", "胃土雉", "昴日鸡", "毕月乌", "觜火猴", "参水猿", //西方白虎七宿
    "井木犴", "鬼金羊", "柳土獐", "星日马", "张月鹿", "翼火蛇", "轸水蚓" //北方玄武七宿
]

//MARK: 12 生肖
let chineseZodiacNameList:[Character] = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
//MARK: 12值日神
let chinese12DayOfficers:[Character] = Array("建除满平定执破危成收开闭" )
//MARK: 12宫，12长生
let chinese12DayGods:[String] = ["青龙", "明堂", "天刑", "朱雀", "金贵", "天德", "白虎", "玉堂", "天牢", "玄武", "司命", "勾陈"]

//MARK: 方位和八卦的对应
public enum directionEnum:String,CaseIterable,Equatable,LocalizableEnum{
    case n =  "正北"
    case en = "东北"
    case e  = "正东"
    case es = "东南"
    case s  = "正南"
    case sw = "西南"
    case w  = "正西"
    case nw = "西北"
}
let chinese8Trigrams:[Character] = Array("坎艮震巽离坤兑乾")

//MARK: 吉神排序列表
public enum luckgodsNameEnum:String,CaseIterable,Equatable,LocalizableEnum{
    case xi   = "喜神"
    case cai  = "财神"
    case fu   = "福神"
    case yang = "阳贵"
    case yin  = "阴贵"
}
let luckyGodDirection:[Character] = Array("艮乾坤离巽艮乾坤离巽") //吉神,福神，财神，阳贵，阴贵方位
let wealthGodDirection:[Character] = Array("艮艮坤坤坎坎震震离离")
let mascotGodDirection:[Character] = Array("坎坤乾巽艮坎坤乾巽艮")
let sunNobleDirection:[Character] = Array("坤坤兑乾艮坎离艮震巽")
let moonNobleDirection:[Character] = Array("艮坎乾兑坤坤艮离巽震")

//MARK:  胎神
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
//MARK:  时辰经络
let meridiansName = ["胆", "肝", "肺", "大肠", "胃", "脾", "心", "小肠", "膀胱", "肾", "心包", "三焦"]

//MARK: lunar date chinese letters
let lunarMonthNameList = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]
let lunarDayNameList = [
    "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
    "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
    "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"
]

let upperNum = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
let weekDay = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]


//MARK: lunar calendar dataset
/// 1901-2100年二十节气最小数序列 向量压缩法
let encVectorList:[Int] = [4, 19, 3, 18, 4, 19, 4, 19, 4, 20, 4, 20, 6, 22, 6, 22, 6, 22, 7, 22, 6, 21, 6, 21]

/// limit date range 1901-2100
extension Date {
    static var minAllowedDate: Date {
        var components = DateComponents()
        components.year = 1901
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components)!
    }

    static var maxAllowedDate: Date {
        var components = DateComponents()
        components.year = 2100
        components.month = 12
        components.day = 31
        return Calendar.current.date(from: components)!
    }
}


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

/// 闰几月 闰月日数  12-1 月份农历日数 0=29天 1=30天
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
/// 春节月  春节日
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


//MARK: 十神

/**
 * 计算十神规则：以日干为命主（我），结合天干的五行生克与阴阳属性，计算与其他三柱天干的关系
 * - 生我者为印绶(正印、偏印)；
 * - 我生者为食伤(食神、伤官)；
 * - 克我者为官煞(正官、七杀)；
 * - 我克者为妻财(正财、偏财)；
 * - 同类者为比劫(比肩、劫财)。
 * - 再按照天干的阴阳性选择
 * - Parameter dayStem: the stem of dayPillar
 * - Returns: the array of stems of the ten god for each pillar
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
        } else if dayelement == .mu && stemElement == .huo || // dayElement generate stemElement
                    dayelement == .huo && stemElement == .tu ||
                    dayelement == .tu && stemElement == .jin ||
                    dayelement == .jin && stemElement == .shui ||
                    dayelement == .shui && stemElement == .mu {
            relationships[stem] = yinYang[stem] == yinYang[dayStem] ? "食神" : "伤官"
        } else if dayelement == .mu && stemElement == .tu || //dayElement destroy stemElement
                    dayelement == .huo && stemElement == .jin ||
                    dayelement == .tu && stemElement == .shui ||
                    dayelement == .jin && stemElement == .mu ||
                    dayelement == .shui && stemElement == .huo {
            relationships[stem] = yinYang[stem] == yinYang[dayStem] ? "偏财" : "正财"
        } else if dayelement == .mu && stemElement == .jin || //stemElement destroy dayElement
                    dayelement == .huo && stemElement == .shui ||
                    dayelement == .tu && stemElement == .mu ||
                    dayelement == .jin && stemElement == .huo ||
                    dayelement == .shui && stemElement == .tu {
            relationships[stem] = yinYang[stem] == yinYang[dayStem] ? "七杀" : "正官"
        } else if dayelement == .mu && stemElement == .shui || //stemElement generate dayElement
                    dayelement == .huo && stemElement == .mu ||
                    dayelement == .tu && stemElement == .huo ||
                    dayelement == .jin && stemElement == .tu ||
                    dayelement == .shui && stemElement == .jin {
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
]
//public var tianGanRelationships: [the10StemEnum: [the10StemEnum: String]] = {
//    the10StemEnum.allCases.reduce(into: [the10StemEnum: [the10StemEnum: String]]()) {
//        $0[$1] = generateTenGods(for: $1)
//    }
//}()

//MARK: 五行局
public struct WuxingGame {
    public let name: String
    public let num: Int
}

public let wuxingGameArray:[WuxingGame] = [
        WuxingGame(name: "金四局", num: 4),
        WuxingGame(name: "水二局", num: 2),
        WuxingGame(name: "火六局", num: 6),
        WuxingGame(name: "土五局", num: 5),
        WuxingGame(name: "木三局", num: 3)
    ]

//MARK: 十二宫
/**
 命宫地支参考顺序：命盘顺序 寅...丑
 */

/// 十二宫排序array
public let palacesArray = [
    "命宫",    // Destiny Palace
    "兄弟宫",  // Siblings Palace
    "夫妻宫",  // Spouse Palace
    "子女宫",  // Children Palace
    "财帛宫",  // Wealth Palace
    "疾厄宫",  // Misfortune Palace
    "迁移宫",  // Travel Palace
    "交友宫",  // Friend Palace
    "仕途宫",  // Career Palace
    "田宅宫",  // Property Palace
    "福德宫",  // Blessings Palace
    "父母宫",  // Parents Palace
]

/**
 * 生成五虎遁月歌 年干与十二宫天干对应数据表:
 * https://www.douban.com/note/833981956/?_i=5298526gC9k0WR
 */
func rotateArrayToLeft(_ array: [the10StemEnum], by steps: Int) -> [the10StemEnum] {
    let count = array.count
    let effectiveSteps = steps % count  // Ensure the steps don't exceed the array length
    let rotatedleftarray=Array(array[effectiveSteps...] + array[0..<effectiveSteps])//rotate by steps
    return rotatedleftarray.suffix(2) + rotatedleftarray
}

var array:[the10StemEnum] = [.wu, .ji, .geng, .xin, .ren, .gui, .jia, .yi, .bing, .ding]
let rotatedLeft0 = rotateArrayToLeft(array, by: 0*2)
let rotatedLeft1 = rotateArrayToLeft(array, by: 1*2)
let rotatedLeft2 = rotateArrayToLeft(array, by: 2*2)
let rotatedLeft3 = rotateArrayToLeft(array, by: 3*2)
let rotatedLeft4 = rotateArrayToLeft(array, by: 4*2)

/// The match between year's stem to 12 palaces' stem ordered by 12 palaces' branch' order (diZhi2)
let yearStemToSequence: [the10StemEnum : [the10StemEnum]] = [
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

//MARK: 星耀安放
// https://www.ziweishe.com/?sex=1&date_type=1&year=1993&month=11&day=22&hour=4

public enum StarsEnum: String, CaseIterable, LocalizableEnum{
    //tianfu main stars
    case tianfu    = "天府"
    case taiyin    = "太阴"
    case tanlang   = "贪狼"
    case jumen     = "巨门"
    case tianxiang = "天相"
    case tianliang = "天梁"
    case qisha     = "七杀"
    case pojun     = "破军"
    //ziwei main stars
    case ziwei     = "紫微"
    case tianji    = "天机"
    case taiyang   = "太阳"
    case wuqu      = "武曲"
    case tiantong  = "天同"
    case lianzhen  = "廉贞"
    
    //other smallstars with sihua
    case wenchang  = "文昌"
    case youbi     = "右弼"
    case wenqu     = "文曲"
    case zuofu     = "左辅"
    // no sihua smallstars
    case lucun    = "禄存"
    case tianma    = "天马"
    case huoxing    = "火星"
    case dikong    = "地空"
    case dijie    = "地劫"
    case lingxing    = "铃星"
    case hongluan    = "红鸾"
    case tianxi    = "天喜"
    case tiantao    = "天姚"
    case xianchi    = "咸池"
    case tianxing    = "天刑"
    case tiankui     = "天魁"
    case tianyue     = "天钺"
    case tuoluo      = "陀罗"
    case qingyang    = "擎羊"

}
public enum sihuaEnum: String, CaseIterable,LocalizableEnum{
    case lu      = "禄"
    case quan    = "权"
    case ke      = "科"
    case ji      = "忌"
}


/**
 * 四种重要的星曜变化(四化)：禄、权、科、忌
 * 四化的确定依赖于个人的出生信息（尤其是年柱中的天干），并根据固定的对照表来分配
 */
public let sihuaMap: [the10StemEnum: [StarsEnum: sihuaEnum]] = [
    .jia: [
        .lianzhen: .lu,
        .pojun: .quan,
        .wuqu: .ke,
        .taiyang: .ji
    ],
    .yi: [
        .tianji: .lu,
        .tianliang: .quan,
        .ziwei: .ke,
        .taiyin: .ji
    ],
    .bing: [
        .tiantong: .lu,
        .tianji: .quan,
        .wenchang: .ke,
        .lianzhen: .ji
    ],
    .ding: [
        .taiyin: .lu,
        .tiantong: .quan,
        .tianji: .ke,
        .jumen: .ji
    ],
    .wu: [
        .tanlang: .lu,
        .taiyin: .quan,
        .youbi: .ke,
        .tianji: .ji
    ],
    .ji: [
        .wuqu: .lu,
        .tanlang: .quan,
        .tianliang: .ke,
        .wenqu: .ji
    ],
    .geng: [
        .taiyang: .lu,
        .wuqu: .quan,
        .taiyin: .ke,
        .tiantong: .ji
    ],
    .xin: [
        .jumen: .lu,
        .taiyang: .quan,
        .wenqu: .ke,
        .wenchang: .ji
    ],
    .ren: [
        .tianliang: .lu,
        .ziwei: .quan,
        .zuofu: .ke,
        .wuqu: .ji
    ],
    .gui: [
        .pojun: .lu,
        .jumen: .quan,
        .taiyin: .ke,
        .tanlang: .ji
    ]
]

//MARK:  次星规则

/// 禄存 规则
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
/// 天马 规则
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
/// 火星 规则
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
/// 铃星 规则
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
/// 咸池 规则
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
