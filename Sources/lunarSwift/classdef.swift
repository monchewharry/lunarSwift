//
//  Created by Dingxian Cao on 8/27/24.
//
import Foundation

public class People:ObservableObject {
    var twohourNum: Int {
        (Calendar.current.component(.hour, from: date) + 1) / 2
    }//时辰索引
    
    var isLunarLeapMonth: Bool=false
    
    var godType: String
    var year8Char: String
    var date: Date
    var gender: String

    init(date: Date, godType: String = "8char", year8Char: String = "year", gender:String = "男") {
        self.godType = godType
        self.year8Char = year8Char
        self.date = date
        self.gender = gender
    }
    
    //calculate lunar YMD's int
    var lunarYMD: (Int,Int,Int,Int) {
        getLunarDateNum()
    }
    var lunarYear:Int {return lunarYMD.0}
    var lunarMonth:Int {return lunarYMD.1}
    var lunarDay:Int {return lunarYMD.2}
    var spanDays: Int {return lunarYMD.3}
    
    //find lunar YMD's chinese character
    var lunarYMDCn: (String,String,String) {
        getLunarCn()
    }
    var lunarYearCn:String {return lunarYMDCn.0}
    var lunarMonthCn:String {return lunarYMDCn.1}
    var lunarDayCn:String {return lunarYMDCn.2}
    var lunarbirthday: String {
        return lunarYearCn + "年 " + lunarMonthCn + " " + lunarDayCn + "日 " + twohour8Char.suffix(1) + "时"
    }
    
    //find jieqi
    var solarinfo: (String,[(Int,Int)],Int,Int) {getTodaySolarTerms()}
    var todaySolarTerms: String {solarinfo.0}
    var thisYearSolarTermsDateList:[(Int, Int)] {solarinfo.1}
    var nextSolarNum:Int {solarinfo.2}
    var nextSolarTerm:String {solarTermsNameList[nextSolarNum]}
    var nextSolarTermDate:(Int,Int) {thisYearSolarTermsDateList[nextSolarNum]}
    var nextSolarTermYear:Int {solarinfo.3}
    
    var monthDaysList:[Int] {
        let a = getMonthLeapMonthLeapDays(lunarYear_: lunarYear, lunarMonth_: lunarMonth)
        return [a.0,a.1,a.2]
    }
    
    var lunarMonthLong:Bool {setlunarMonthLong()}
    var _x: Int {getBeginningOfSpringX()} //must before the update of year8Char

    //calculate lunar YMD's BAZI
    //var dayHeavenlyEarthNum:Int {getdayheavenearthnum()} //日柱索引
    var md8Char: (String,String) { // also update year8Char
        getThe8Char()
    }
    var month8Char:String {return md8Char.0}
    var day8Char:String {return md8Char.1}
    var ymd8Char:(String,String,String) {
        let _ = md8Char
        return (year8Char,month8Char,day8Char)
    }
    
    // calculate lunr YMD's BAZI dizhi's index
    var ymdEarthNum: (Int,Int,Int) {//must after the update of year8Char
        getEarthNum()
    }
    var yearEarthNum:Int {return ymdEarthNum.0}
    var monthEarthNum:Int {return ymdEarthNum.1}
    var dayEarthNum:Int {return ymdEarthNum.2}
    // calculate lunr YMD's BAZI tiangan's index
    var ymdHeavenNum: (Int,Int,Int) {
        getHeavenNum()
    }
    var yearHeavenNum:Int {return ymdHeavenNum.0}
    var monthHeavenNum:Int {return ymdHeavenNum.1}
    var dayHeavenNum:Int {return ymdHeavenNum.2}
    
    //四季信息
//    var season3: (Int,Int,String){
//        getSeason()
//    }
//    var seasonType:Int {return season3.0}
//    var seasonNum:Int {return season3.1}
//    var lunarSeason:String {return season3.2}
    //时柱
    var twohour8CharList: [String] {getTwohour8CharList()}
    var twohour8Char: String {getTwohour8Char()}

//    var today12:(String,String){getToday12DayOfficer()}
//    var today12DayOfficer: String {today12.0}
//    var today12DayGod:String {today12.1}
    
//    var zodiacresults:(String,String,String,[String],String) {getChineseZodiacClash()}
//    var zodiacMark6: String { zodiacresults.0}
//    var zodiacWin: String { zodiacresults.1}
//    var zodiacLose: String { zodiacresults.2}
//    var zodiacMark3List:[String] {zodiacresults.3}
//    var chineseZodiacClash: String {zodiacresults.4}
//    var chineseYearZodiac: String {getChineseYearZodiac()}
    
    
//    optional properties
//    var phaseOfMoon:String {getPhaseOfMoon()}
//    var weekDayCn: String {getWeekDayCn()}
//    var starZodiac: String {getStarZodiac()}
//    var todayEastZodiac: String {getEastZodiac()}
//    var thisYearSolarTermsDic: [String: Date] {Dictionary(uniqueKeysWithValues: zip(solarTermsNameList, getThisYearSolarTermsDateList()))}
//    var today28Star: String {getThe28Stars()}
//    var content: String = ""
//    var angelDemon: String {getAngelDemon()}
//    var meridians: String {meridiansName[twohourNum % 12]}

    //----------methods
    func getBeginningOfSpringX() -> Int {
        
        let isBeforeBeginningOfSpring = nextSolarNum < 3
        let isBeforeLunarYear = spanDays < 0
        var x = 0

        if year8Char != "beginningOfSpring" {
            return x
        }
        
        if isBeforeLunarYear {
            //现在节气在立春之前 且 已过完农历年(农历小于3月作为测试判断)，年柱需要减1
            if !isBeforeBeginningOfSpring {
                x = -1
            }
        } else {
            if isBeforeBeginningOfSpring {
                x = 1
            }
        }

        return x
    }

    func getLunarYearCN() -> String { //wrong
        var _upper_year: String=""
        for char in String(lunarYear) {
            _upper_year += upperNum[Int(String(char))!]
        }
        return _upper_year
    }
    func setlunarMonthLong() -> Bool{ //set lunarMonthLong
        let thisLunarMonthDays = isLunarLeapMonth ? monthDaysList[2] : monthDaysList[0]
        let v = thisLunarMonthDays >= 30
        return v
    }
    func getLunarMonthCN() -> String {
        var lunarMonth = lunarMonthNameList[(lunarMonth - 1) % 12]
        if isLunarLeapMonth {
            lunarMonth = "闰" + lunarMonth
        }

        let size = lunarMonthLong ? "大" : "小"
        return lunarMonth + size
    }

    func getLunarCn() -> (String, String, String) {
        return (getLunarYearCN(), getLunarMonthCN(), lunarDayNameList[(lunarDay - 1) % 30])
    }

    func getPhaseOfMoon() -> String {
        //月相
        switch lunarDay {
        case 1:
            return "朔"
        case 15 where !lunarMonthLong:
            return "望"
        case 7...8:
            return "上弦"
        case 22...23:
            return "下弦"
        default:
            return ""
        }
    }
    //返回今日节气
    func getTodaySolarTerms() -> (String,[(Int,Int)],Int,Int) {//bad call
        var year:Int = Calendar.current.component(.year, from: date)
        var solarTermsDateList:[(Int,Int)] = getSolarTermsDateList(year: year)
        let thisYearSolarTermsDateList:[(Int,Int)] = solarTermsDateList

        let findDate:(Int,Int) = (Calendar.current.component(.month, from: date), Calendar.current.component(.day, from: date))
        let nextSolarNum:Int = getNextNum(findDate: findDate, solarTermsDateList: solarTermsDateList)

        let todaySolarTerm: String
        if let index = solarTermsDateList.firstIndex(where: { $0 == findDate }) {
            todaySolarTerm = solarTermsNameList[index]
        } else {
            todaySolarTerm = "无"
        }

        // 次年节气
        if let _a = solarTermsDateList.last {
            if (findDate.0 == _a.0) && (findDate.1 >= _a.1) {
                year += 1
                solarTermsDateList = getSolarTermsDateList(year: year)
            }
        }

        //nextSolarTerm = solarTermsNameList[nextSolarNum]
        //nextSolarTermDate = solarTermsDateList[nextSolarNum]
        let nextSolarTermYear:Int = year

        return (todaySolarTerm,thisYearSolarTermsDateList,nextSolarNum,nextSolarTermYear)
    }
    func getNextNum(findDate: (Int, Int), solarTermsDateList: [(Int, Int)]) -> Int {
        let nextSolarNum = solarTermsDateList.filter { $0 <= findDate }.count % 24
        return nextSolarNum
    }
    func getSolarTermsDateList(year: Int) -> [(Int, Int)] {
        let solarTermsList = getTheYearAllSolarTermsList(year: year) //function from solar24
        var solarTermsDateList: [(Int, Int)] = []

        for i in 0..<solarTermsList.count {
            let day = solarTermsList[i]
            let month = i / 2 + 1
            solarTermsDateList.append((month, day))
        }

        return solarTermsDateList
    }

    func getChineseYearZodiac() -> String {
        return chineseZodiacNameList[(lunarYear - 4) % 12 - _x]
    }

    func getChineseZodiacClash() -> (String,String,String,[String],String) {
        let zodiacNum = dayEarthNum
        let zodiacClashNum = (zodiacNum + 6) % 12
        let zodiacMark6:String = chineseZodiacNameList[pythonModulo((25 - zodiacNum) , 12)]
        let zodiacMark3List:[String] = [
            chineseZodiacNameList[(zodiacNum + 4) % 12],
            chineseZodiacNameList[(zodiacNum + 8) % 12]
        ]
        let zodiacWin:String = chineseZodiacNameList[zodiacNum]
        let zodiacLose:String = chineseZodiacNameList[zodiacClashNum]
        
        let clashresult:String = zodiacWin + "日冲" + zodiacLose
        return (zodiacMark6,zodiacWin,zodiacLose,zodiacMark3List,clashresult)
    }
    func getEarthNum() -> (Int, Int, Int) {
        //地支索引
        let yearEarthNum = the12EarthlyBranches.firstIndex(of: String(ymd8Char.0.suffix(1))) ?? -1
        let monthEarthNum = the12EarthlyBranches.firstIndex(of: String(ymd8Char.1.suffix(1))) ?? -1
        let dayEarthNum = the12EarthlyBranches.firstIndex(of: String(ymd8Char.2.suffix(1))) ?? -1
        
        return (yearEarthNum, monthEarthNum, dayEarthNum)
    }
    func getHeavenNum() -> (Int, Int, Int) {
        let yearHeavenNum = the10HeavenlyStems.firstIndex(of: String(ymd8Char.0.prefix(1))) ?? -1
        let monthHeavenNum = the10HeavenlyStems.firstIndex(of: String(ymd8Char.1.prefix(1))) ?? -1
        let dayHeavenNum = the10HeavenlyStems.firstIndex(of: String(ymd8Char.2.prefix(1))) ?? -1
        
        return (yearHeavenNum, monthHeavenNum, dayHeavenNum)
    }
    

    func getLunarDateNum() -> (Int, Int, Int,Int) {
        //返回的月份，高4bit为闰月月份，低4bit为其它正常月份
        // 给定公历日期，计算农历日期
        var lunarYear_:Int = Calendar.current.component(.year, from: date)
        var lunarMonth_:Int = 1
        var lunarDay_:Int = 1
        let _codeYear = lunarNewYearList[lunarYear_ - startYear]
        
        // 获取当前日期与当年春节的差日
        ///(二进制右移5位) 和 0x3 取bitwise and
        let (thisSpringM, thisSpringD) : (Int,Int) = (Int((_codeYear >> 5) & 0x3), Int((_codeYear >> 0) & 0x1f))
        let referdate = DateComponents(calendar: .current, year: Int(lunarYear_), month: thisSpringM, day: thisSpringD).date!
        let _spanSeconds = date.timeIntervalSince(referdate)
        
        var _spanDays = Int(_spanSeconds / (24 * 3600))//days
        let spanDays = _spanDays
        //新年后推算日期，差日依序减月份天数，直到不足一个月，剪的次数为月数，剩余部分为日数
        if _spanDays >= 0 {
            // Calculate the lunar date after the New Year
            var (_monthDays, _leapMonth, _leapDay) = getMonthLeapMonthLeapDays(lunarYear_: lunarYear_, lunarMonth_: lunarMonth_)
            while _spanDays >= _monthDays {
                _spanDays -= _monthDays
                if lunarMonth_ == _leapMonth {
                    _monthDays = _leapDay
                    if _spanDays < _monthDays {
                        isLunarLeapMonth = true //update property
                        break
                    }
                    _spanDays -= _monthDays
                }
                lunarMonth_ += 1
                _monthDays = getMonthLeapMonthLeapDays(lunarYear_: lunarYear_, lunarMonth_: lunarMonth_).0
            }
            lunarDay_ += _spanDays
            return (lunarYear_, lunarMonth_, lunarDay_,spanDays)
        } else {
            // 新年前倒推去年日期
            lunarMonth_ = 12
            lunarYear_ -= 1
            var (_monthDays, _leapMonth, _leapDay) = getMonthLeapMonthLeapDays(lunarYear_: lunarYear_, lunarMonth_: lunarMonth_)
            while abs(_spanDays) > _monthDays {
                _spanDays += _monthDays
                lunarMonth_ -= 1
                if lunarMonth_ == _leapMonth {
                    _monthDays = _leapDay
                    if abs(_spanDays) <= _monthDays {
                        isLunarLeapMonth = true
                        break
                    }
                    _spanDays += _monthDays
                }
                _monthDays = getMonthLeapMonthLeapDays(lunarYear_: lunarYear_, lunarMonth_: lunarMonth_).0
            }
            lunarDay_ += (_monthDays + _spanDays)
            return (lunarYear_, lunarMonth_, lunarDay_,spanDays)
        }
    }
    func getMonthLeapMonthLeapDays(lunarYear_:Int,lunarMonth_:Int) -> (Int,Int,Int) {
        // 计算阴历月天数
        var (leapMonth,leapDay,monthDay) = (0,0,0)

        // 获取16进制数据 12-1月份农历日数 0=29天 1=30天
        let tmp = lunarMonthData[lunarYear_ - startYear]

        // 获取当前月份的布尔值
        if tmp & (1 << (lunarMonth_ - 1)) != 0 {
            monthDay = 30
        } else {
            monthDay = 29
        }

        // Determine the leap month and its number of days
        leapMonth = Int((tmp >> leapMonthNumBit) & 0xf) //1 或 0
        if leapMonth != 0 {
            if tmp & (1 << monthDayBit) != 0 {
                leapDay = 30
            } else {
                leapDay = 29
            }
        }

        // Store the result in a list (optional)
        //monthDaysList = [monthDay, leapMonth, leapDay]

        // Return the month day, leap month, and leap day as a tuple
        return (monthDay, leapMonth, leapDay)
    }


    func getStarZodiac() -> String {
        let monthDay = (Calendar.current.component(.month, from: date), Calendar.current.component(.day, from: date))
        let zodiacIndex = starZodiacDate.filter { $0 <= monthDay }.count % 12
        return starZodiacName[zodiacIndex]
    }

    func getEastZodiac() -> String {
        let index = pythonModulo((solarTermsNameList.firstIndex(of: self.nextSolarTerm)! - 1) , 24) / 2
        let todayEastZodiac = eastZodiacList[index]
        return todayEastZodiac
    }

    func getThe8Char() -> (String, String) {
        year8Char = getYear8Char() // update the property year8Char here
        return (getMonth8Char(), getDay8Char())
    }
    func getYear8Char() -> String {
        // 立春年干争议算法
        return the60HeavenlyEarth[((lunarYear - 4) % 60) - _x]
    }
    func getMonth8Char() -> String {
        var nextNum = nextSolarNum
        // 2019年正月为丙寅月
        if nextNum == 0 && Calendar.current.component(.month, from: date) == 12 {
            nextNum = 24
        }
        let apartNum = (nextNum + 1) / 2
        // (year-2019)*12+apartNum每年固定差12个月回到第N年月柱，2019小寒甲子，加上当前过了几个节气除以2+(nextNum-1)//2，减去1
        let _index = pythonModulo(((Calendar.current.component(.year, from: date) - 2019) * 12 + apartNum) , 60) // could be <0
        let month8Char = the60HeavenlyEarth[_index]
        return month8Char
    }
    var dayHeavenlyEarthNum:Int {
        //日柱索引需要注意计算和标准日差的时候的精确度
        let baseDate = DateComponents(calendar: Calendar.current, year: 2019, month: 1, day: 29).date!
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let date2 = Calendar.current.date(from: dateComponents)! //remove hour info: default = 0
        
        let apart = Calendar.current.dateComponents([.day], from: baseDate, to: date2).day! // 12 hour accuracy
        var baseNum = the60HeavenlyEarth.firstIndex(of: "丙寅")! // baseNum==2
        
        // 超过23点算第二天，为防止溢出，在baseNum上操作+1
        if twohourNum == 12 {
            baseNum += 1
        }
        return pythonModulo((apart + baseNum) , 60)
    }
    func getDay8Char() -> String {
        //日柱
        return the60HeavenlyEarth[dayHeavenlyEarthNum]
    }
    
    func getSeason() -> (Int,Int,String){
        let seasonType = monthEarthNum % 3
        let seasonNum = pythonModulo((monthEarthNum - 2) , 12) / 3
        
        let seasonTypes = ["仲", "季", "孟"]
        let seasons = ["春", "夏", "秋", "冬"]
        
        let lunarSeason = seasonTypes[seasonType] + seasons[seasonNum]
        
        return (seasonType,seasonNum,lunarSeason)
    }
    
    func getTwohour8CharList() -> [String] {
        // Calculate the start index
        let begin = (the60HeavenlyEarth.firstIndex(of: day8Char)! * 12) % 60
        
        // Combine the array with itself and extract the relevant slice
        let extendedList = the60HeavenlyEarth + the60HeavenlyEarth
        let twohour8CharList = Array(extendedList[begin..<(begin + 13)])
        return twohour8CharList
    }
    func getTwohour8Char() -> String {
        return twohour8CharList[twohourNum % 12]
    }
    
    func getToday12DayOfficer() -> (String, String) {
        let men: Int
        if godType == "cnlunar" {
            // Using lunar month and Eight Characters day pillar to calculate gods
            let lmn = lunarMonth
            men = (lmn - 1 + 2) % 12
        } else {
            // Using Eight Characters month pillar and day pillar to calculate gods
            men = monthEarthNum
        }

        let thisMonthStartGodNum = men % 12
        let apartNum = dayEarthNum - thisMonthStartGodNum
        let today12DayOfficer = String(Array(chinese12DayOfficers)[pythonModulo(apartNum , 12)])
        
        let eclipticGodNum = pythonModulo((dayEarthNum - [8, 10, 0, 2, 4, 6, 8, 10, 0, 2, 4, 6][men]) , 12)
        let today12DayGod = chinese12DayGods[eclipticGodNum % 12]
        //let dayName = (0...1).contains(eclipticGodNum) || (4...5).contains(eclipticGodNum) || eclipticGodNum == 7 || eclipticGodNum == 10 ? "黄道日" : "黑道日"

        return (today12DayOfficer, today12DayGod)//, dayName)
    }
    
    func getWeekDayCn() -> String {
        return weekDay[Calendar.current.component(.weekday, from: date) - 1]
    }
    
    func getAngelDemon() -> String {
        // Logic for computing angel demon
        //too long so miss
        return "unknown"
    }

    func getThisYearSolarTermsDateList() -> [Date] {
        // Logic to compute solar terms date list
        return []
    }

    func getThe28Stars() -> String {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2019, month: 1, day: 17))!
        
        // Calculate the difference in days between the current date and the reference date
        let apart = calendar.dateComponents([.day], from: referenceDate, to: date).day!
        
        // Assuming `the28StarsList` is an array of strings representing the 28 stars
        return the28StarsList[apart % 28]
    }
}

//class extension

public extension People{
    //--------------MingLi
    var fourPillars: [String] {
        [ymd8Char.0,ymd8Char.1,ymd8Char.2,twohour8Char]
    }
    var fiveElements: [[String]] {
        matchwuxing(fourPillars:fourPillars)
    }
    var fiveElementsCount: [String: Int] {
                var elementsCount: [String: Int] = ["木": 0, "火": 0, "土": 0, "金": 0, "水": 0]
                
                for elements in fiveElements {
                    for element in elements {
                        elementsCount[element, default: 0] += 1
                    }
                }
                return elementsCount
            }
    var fourPillarsfiveElementsResult: String{
        calculateGanZhiAndWuXing(fourPillars: fourPillars, fiveElements:fiveElements)
    }
    var fourPillarsfiveElementsAnalysis: [String]{
            get{
                return analyzeFiveElementsBalance(fiveElements:fiveElements)
            }
        }
}
