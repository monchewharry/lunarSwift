//  config.swift
//  Created by Dingxian Cao on 8/27/24.

import Foundation

public let starZodiacName = ["摩羯座", "水瓶座", "双鱼座", "白羊座", "金牛座", "双子座", "巨蟹座", "狮子座", "处女座", "天秤座", "天蝎座", "射手座"]
public let starZodiacDate = [(1, 20), (2, 19), (3, 21), (4, 21), (5, 21), (6, 22), (7, 23), (8, 23), (9, 23), (10, 23), (11, 23), (12, 23)]

public let startYear = 1901
public let monthDayBit = 12
public let leapMonthNumBit = 13

public let stc = "小寒大寒立春雨水惊蛰春分清明谷雨立夏小满芒种夏至小暑大暑立秋处暑白露秋分寒露霜降立冬小雪大雪冬至" //24节气顺序
public let solarTermsNameList:[String] = stride(from: 0, to: stc.count, by: 2).map { index -> String in
    let startIndex = stc.index(stc.startIndex, offsetBy: index)
    let endIndex = stc.index(startIndex, offsetBy: 2)
    return String(stc[startIndex..<endIndex])
}

//天干地支五行
public let eastZodiacList = ["玄枵", "娵訾", "降娄", "大梁", "实沈", "鹑首", "鹑火", "鹑尾", "寿星", "大火", "析木", "星纪"]
public let the10HeavenlyStems = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]//tian gan
public let the10HeavenlyStems5ElementsList = ["木", "木", "火", "火", "土", "土", "金", "金", "水", "水"]//tian gan wuxing
public let the12EarthlyBranches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]//di zhi
public let the12EarthlyBranches5ElementsList = ["水", "土", "木", "木", "土", "火", "火", "土", "金", "金", "土", "水"]//di zhi wuxing
public let earthlyBranchesToFiveElements: [String: String] = Dictionary(uniqueKeysWithValues: zip(the12EarthlyBranches, the12EarthlyBranches5ElementsList))
public let heavenlyStemsToFiveElements: [String: String] = Dictionary(uniqueKeysWithValues: zip(the10HeavenlyStems, the10HeavenlyStems5ElementsList))
public let the60HeavenlyEarth: [String] = {
    var combinations = [String]()
    for i in 0..<60 {
        let stem = the10HeavenlyStems[i % 10]
        let branch = the12EarthlyBranches[i % 12]
        combinations.append("\(stem)\(branch)")
    }
    return combinations
}()//60 甲子

//在六十甲子纳音（每个甲子组合对应一个特定的自然象征或物质象征，如海中金）体系中，它代表特定的天干地支组合的属性。
public let theHalf60HeavenlyEarth5ElementsList = [
    "海中金", "炉中火", "大林木", "路旁土", "剑锋金", "山头火", "涧下水", "城头土", "白蜡金", "杨柳木", "井泉水",
    "屋上土", "霹雳火", "松柏木", "长流水", "砂中金", "山下火", "平地木", "壁上土", "金箔金", "覆灯火", "天河水",
    "大驿土", "钗钏金", "桑柘木", "大溪水", "砂中土", "天上火", "石榴木", "大海水"
]


public let the28StarsList = [
    "角木蛟", "亢金龙", "氐土貉", "房日兔", "心月狐", "尾火虎", "箕水豹", //东方青龙七宿
    "斗木獬", "牛金牛", "女土蝠", "虚日鼠", "危月燕", "室火猪", "壁水貐", //南方朱雀七宿
    "奎木狼", "娄金狗", "胃土雉", "昴日鸡", "毕月乌", "觜火猴", "参水猿", //西方白虎七宿
    "井木犴", "鬼金羊", "柳土獐", "星日马", "张月鹿", "翼火蛇", "轸水蚓" //北方玄武七宿
]//28宿：星宿被分成四象，每象包含七宿

public let pengTatooList = [
    "甲不开仓 财物耗散", "乙不栽植 千株不长", "丙不修灶 必见灾殃", "丁不剃头 头必生疮", "戊不受田 田主不祥",
    "己不破券 二比并亡", "庚不经络 织机虚张", "辛不合酱 主人不尝", "壬不泱水 更难提防", "癸不词讼 理弱敌强",
    "子不问卜 自惹祸殃", "丑不冠带 主不还乡", "寅不祭祀 神鬼不尝", "卯不穿井 水泉不香", "辰不哭泣 必主重丧",
    "巳不远行 财物伏藏", "午不苫盖 屋主更张", "未不服药 毒气入肠", "申不安床 鬼祟入房", "酉不会客 醉坐颠狂",
    "戌不吃犬 作怪上床", "亥不嫁娶 不利新郎"
]//彭祖百忌

public let chineseZodiacNameList = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]//生肖
public let chinese12DayOfficers = "建除满平定执破危成收开闭" //12值日神
public let chinese12DayGods = ["青龙", "明堂", "天刑", "朱雀", "金贵", "天德", "白虎", "玉堂", "天牢", "玄武", "司命", "勾陈"] //12宫，12长生

public let directionList = ["正北", "东北", "正东", "东南", "正南", "西南", "正西", "西北"]
public let chinese8Trigrams = "坎艮震巽离坤兑乾"//方位和八卦的对应

public let luckyGodDirection = "艮乾坤离巽艮乾坤离巽" //吉神方位
public let wealthGodDirection = "艮艮坤坤坎坎震震离离"
public let mascotGodDirection = "坎坤乾巽艮坎坤乾巽艮"
public let sunNobleDirection = "坤坤兑乾艮坎离艮震巽"
public let moonNobleDirection = "艮坎乾兑坤坤艮离巽震"

public let fetalGodList = [
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
]//胎神
public let meridiansName = ["胆", "肝", "肺", "大肠", "胃", "脾", "心", "小肠", "膀胱", "肾", "心包", "三焦"]//时辰经络

public let lunarMonthNameList = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]
public let lunarDayNameList = [
    "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
    "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
    "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"
]

public let upperNum = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
public let weekDay = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]

//1901-2100年二十节气最小数序列 向量压缩法
public let encVectorList:[Int] = [4, 19, 3, 18, 4, 19, 4, 19, 4, 20, 4, 20, 6, 22, 6, 22, 6, 22, 7, 22, 6, 21, 6, 21]

//1901-2100年香港天文台公布二十四节气按年存储16进制，1个16进制为4个2进制记录了一年的24节气日期
public let solarTermsDataList: [Int] = [
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

//  闰几月 闰月日数  12-1 月份农历日数 0=29天 1=30天
public let lunarMonthData: [Int] = [
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
//春节月  春节日
public let lunarNewYearList: [Int] = [
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
//let twohourLuckyTimeList: [Int] = [
//    0x2d3, 0xcb4, 0x32d, 0x4cb, 0xd32, 0xb4c, 0x2d3, 0xcb4, 0x32d, 0x4cb, 0xd22, 0xb5c,
//        0x2d3, 0xcb4, 0x32d, 0x4cb, 0xd3a, 0xb4d, 0x2d3, 0xcb4, 0x32d, 0x4cb, 0xd32, 0xb4c,
//        0x2d3, 0xcb5, 0x32d, 0x4cb, 0xd32, 0xb4c, 0x2d3, 0xcb4, 0x32d, 0x4cb, 0xd32, 0xb4c,
//        0x2d3, 0xcb4, 0x32d, 0x4db, 0xd32, 0xb5c, 0x2d7, 0xcb4, 0x32d, 0x4cb, 0xd32, 0xb5c,
//        0x2d3, 0xcb4, 0x32d, 0x4cb, 0xd32, 0xb4c, 0x2d3, 0xcb4, 0x30d, 0x4cb, 0xd32, 0xb4c
//]

//民用三十七事
public let thingsSort:[String] = [
    "祭祀", "出行", "移徙", "结婚姻", "宴会", "嫁娶", "安床", "沐浴", "剃头", "修造",
    "求医疗病", "上表章", "上官", "入学", "冠带", "进人口", "裁衣", "竖柱上梁", "经络",
    "开市", "立券", "交易", "纳财", "修置产室", "开渠", "穿井", "安碓硙", "扫舍宇",
    "平治道涂", "破屋坏垣", "伐木", "捕捉", "畋猎", "栽种", "牧养", "破土", "安葬", "启攒"
]
// 神煞宜忌准备
public let bujiang = ["壬寅壬辰辛丑辛卯辛巳庚寅庚辰丁丑丁卯丁巳戊寅戊辰", "辛丑辛卯庚子庚寅庚辰丁丑丁卯丙子丙寅丙辰戊子戊寅戊辰", "辛亥辛丑辛卯庚子庚寅丁亥丁丑丁卯丙子丙寅戊子戊寅",
                      "庚戌庚子庚寅丁亥丁丑丙戌丙子丙寅乙亥乙丑戊戌戊子戊寅", "丁酉丁亥丁丑丙戌丙子乙酉乙亥乙丑甲戌甲子戊戌戊子", "丁酉丁亥丙申丙戌丙子乙酉乙亥甲申甲戌甲子戊申戊戌戊子",
                      "丙申丙戌乙未乙酉乙亥甲申甲戌癸未癸酉癸亥戊申戊戌", "乙未乙酉甲午甲申甲戌癸未癸酉壬午壬申壬戌戊午戊申戊戌", "乙巳乙未乙酉甲午甲申癸巳癸未癸酉壬午壬申戊午戊申",
                      "甲辰甲午甲申癸巳癸未壬辰壬午壬申辛巳辛未戊辰戊午戊申", "癸卯癸巳癸未壬辰壬午辛卯辛巳辛未庚辰庚午戊辰戊午", "癸卯癸巳壬寅壬辰壬午辛卯辛巳庚寅庚辰庚午戊寅戊辰戊午"]

public let officerThings: [String: ([String], [String])] = [
    "建": (["施恩", "招贤", "举正直", "出行", "上官", "临政"], []),
    "除": (["解除", "沐浴", "整容", "剃头", "整手足甲", "求医疗病", "扫舍宇"], []),
    "满": (["进人口", "裁制", "竖柱上梁", "经络", "开市", "立券交易", "纳财", "开仓", "塞穴", "补垣"],
           ["施恩", "招贤", "举正直", "上官", "临政", "结婚姻", "纳采", "求医疗病"]),
    "平": (["修饰垣墙", "平治道涂"],
           ["祈福", "求嗣", "上册", "上表章", "颁诏", "施恩", "招贤", "举正直", "宣政事", "布政事", "庆赐", "宴会", "冠带", "出行", "安抚边境", "选将",
            "出师", "上官", "临政", "结婚姻", "纳采", "嫁娶", "进人口", "搬移", "安床", "解除", "求医疗病", "裁制", "营建", "修宫室", "缮城郭",
            "筑堤防", "修造", "竖柱上梁", "修仓库", "鼓铸", "经络", "酝酿", "开市", "立券交易", "纳财", "开仓", "修置产室", "开渠", "穿井", "栽种",
            "牧养", "纳畜", "破土", "安葬", "启攒"]),
    "定": (["冠带"], []),
    "执": (["捕捉"], []),
    "破": (["求医疗病"], []),
    "危": (["安抚边境", "选将", "安床"], []),
    "成": (["入学", "安抚边境", "搬移", "筑堤防", "开市"], []),
    "收": (["进人口", "纳财", "捕捉", "纳畜"],
           ["祈福", "求嗣", "上册", "上表章", "颁诏", "施恩", "招贤", "举正直", "宣政事", "布政事", "庆赐", "宴会", "冠带", "出行", "安抚边境", "选将",
            "出师", "上官", "临政", "结婚姻", "纳采", "嫁娶", "搬移", "安床", "解除", "求医疗病", "裁制", "营建", "修宫室", "缮城郭", "筑堤防", "修造",
            "竖柱上梁", "鼓铸", "经络", "酝酿", "开市", "立券交易", "开仓", "修置产室", "开渠", "穿井", "破土", "安葬", "启攒"]),
    "开": (
        ["祭祀", "祈福", "求嗣", "上册", "上表章", "颁诏", "覃恩", "施恩", "招贤", "举正直", "恤孤茕", "宣政事", "雪冤", "庆赐", "宴会", "入学",
         "出行", "上官", "临政", "搬移", "解除", "求医疗病", "裁制", "修宫室", "缮城郭", "修造", "修仓库", "开市", "修置产室", "开渠", "穿井", "安碓硙", "栽种",
         "牧养"], []),
    "闭": (["筑堤防", "塞穴", "补垣"],
           ["上册", "上表章", "颁诏", "施恩", "招贤", "举正直", "宣政事", "布政事", "庆赐", "宴会", "出行", "出师", "上官", "临政", "结婚姻", "纳采",
            "嫁娶", "进人口", "搬移", "安床", "求医疗病", "疗目", "营建", "修宫室", "修造", "竖柱上梁", "开市", "开仓", "修置产室", "开渠", "穿井"])
]

public let day8CharThing: [String: ([String], [String])] = [
    "甲": ([], ["开仓"]),
    "乙": ([], ["栽种"]),
    "丁": ([], ["整容", "剃头"]),
    "庚": ([], ["经络"]),
    "辛": ([], ["酝酿"]),
    "壬": ([], ["开渠", "穿井"]),
    "子": (["沐浴"], []), //亥子日宜沐浴
    "丑": ([], ["冠带"]),
    "寅": ([], ["祭祀"]),
    "卯": ([], ["穿井"]),
    "酉": ([], ["宴会"]),
    "巳": ([], ["出行"]),
    "午": ([], ["苫盖"]),
    "未": ([], ["求医疗病"]),
    "申": ([], ["安床"]),
    "亥": (["沐浴"], ["嫁娶"])//亥子日宜沐浴
]

