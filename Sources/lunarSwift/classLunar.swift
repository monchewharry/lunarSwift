//
//  Created by Dingxian Cao on 8/27/24.
//
import Foundation

open class Lunar:ObservableObject {
    public var twohourNum: Int {
        (Calendar.current.component(.hour, from: date) + 1) / 2
    }//时辰索引
    
    public var isLunarLeapMonth: Bool=false
    
    public var godType: String
    public var year8Char: String
    public var date: Date
    public var gender: String

    public init(date: Date, godType: String = "8char", year8Char: String = "year", gender:String = "") {
        self.godType = godType
        self.year8Char = year8Char
        self.date = date
        self.gender = gender
    }
    
    //calculate lunar YMD's int
    public var lunarYMD: (Int,Int,Int,Int) {
        getLunarDateNum()
    }
    public var lunarYear:Int {return lunarYMD.0}
    public var lunarMonth:Int {return lunarYMD.1}
    public var lunarDay:Int {return lunarYMD.2}
    public var spanDays: Int {return lunarYMD.3}
    
    //find lunar YMD's chinese character
    public var lunarYMDCn: (String,String,String) {
        getLunarCn()
    }
    public var lunarYearCn:String {return lunarYMDCn.0}
    public var lunarMonthCn:String {return lunarYMDCn.1}
    public var lunarDayCn:String {return lunarYMDCn.2}
    public var lunarbirthday: String {
        return lunarYearCn + "年 " + lunarMonthCn + " " + lunarDayCn + "日 " + twohour8Char.suffix(1) + "时"
    }
    
    //find jieqi
    public var solarinfo: (String,[(Int,Int)],Int,Int) {getTodaySolarTerms()}
    public var todaySolarTerms: String {solarinfo.0}
    public var thisYearSolarTermsDateList:[(Int, Int)] {solarinfo.1}
    public var nextSolarNum:Int {solarinfo.2}
    public var nextSolarTerm:String {solarTermsNameList[nextSolarNum]}
    public var nextSolarTermDate:(Int,Int) {thisYearSolarTermsDateList[nextSolarNum]}
    public var nextSolarTermYear:Int {solarinfo.3}
    
    public var monthDaysList:[Int] {
        let a = getMonthLeapMonthLeapDays(lunarYear_: lunarYear, lunarMonth_: lunarMonth)
        return [a.0,a.1,a.2]
    }
    
    public var lunarMonthLong:Bool {setlunarMonthLong()}
    public var _x: Int {getBeginningOfSpringX()} //must before the update of year8Char

    //calculate lunar YMD's BAZI
    //var dayHeavenlyEarthNum:Int {getdayheavenearthnum()} //日柱索引
    public var md8Char: (String,String) { // also update year8Char
        getThe8Char()
    }
    public var month8Char:String {return md8Char.0}
    public var day8Char:String {return md8Char.1}
    public var ymd8Char:(String,String,String) {
        let _ = md8Char
        return (year8Char,month8Char,day8Char)
    }
    
    // calculate lunr YMD's BAZI dizhi's index
    public var ymdEarthNum: (Int,Int,Int) {//must after the update of year8Char
        getEarthNum()
    }
    public var yearEarthNum:Int {return ymdEarthNum.0}
    public var monthEarthNum:Int {return ymdEarthNum.1}
    public var dayEarthNum:Int {return ymdEarthNum.2}
    // calculate lunr YMD's BAZI tiangan's index
    public var ymdHeavenNum: (Int,Int,Int) {
        getHeavenNum()
    }
    public var yearHeavenNum:Int {return ymdHeavenNum.0}
    public var monthHeavenNum:Int {return ymdHeavenNum.1}
    public var dayHeavenNum:Int {return ymdHeavenNum.2}
    
    //时柱
    public var twohour8CharList: [String] {getTwohour8CharList()}
    public var twohour8Char: String {getTwohour8Char()}
    //纳音
    public var nayin: [String] {
        let nayin4list: [String] = [
            halfStemBranchNayinList[(the60HeavenlyEarth.firstIndex(of: year8Char) ?? 0)/2],
            halfStemBranchNayinList[(the60HeavenlyEarth.firstIndex(of: month8Char) ?? 0)/2],
            halfStemBranchNayinList[(the60HeavenlyEarth.firstIndex(of: day8Char) ?? 0)/2],
            halfStemBranchNayinList[(the60HeavenlyEarth.firstIndex(of: twohour8Char) ?? 0)/2]
        ]
        
        return nayin4list
        }

    //----------methods
    public func getBeginningOfSpringX() -> Int {
        
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

    public func getLunarYearCN() -> String { //wrong
        var _upper_year: String=""
        for char in String(lunarYear) {
            _upper_year += upperNum[Int(String(char))!]
        }
        return _upper_year
    }
    public func setlunarMonthLong() -> Bool{ //set lunarMonthLong
        let thisLunarMonthDays = isLunarLeapMonth ? monthDaysList[2] : monthDaysList[0]
        let v = thisLunarMonthDays >= 30
        return v
    }
    public func getLunarMonthCN() -> String {
        var lunarMonth = lunarMonthNameList[(lunarMonth - 1) % 12]
        if isLunarLeapMonth {
            lunarMonth = "闰" + lunarMonth
        }

        let size = lunarMonthLong ? "大" : "小"
        return lunarMonth + size
    }

    public func getLunarCn() -> (String, String, String) {
        return (getLunarYearCN(), getLunarMonthCN(), lunarDayNameList[(lunarDay - 1) % 30])
    }

    public func getPhaseOfMoon() -> String {
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
    public func getTodaySolarTerms() -> (String,[(Int,Int)],Int,Int) {//bad call
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
    public func getNextNum(findDate: (Int, Int), solarTermsDateList: [(Int, Int)]) -> Int {
        let nextSolarNum = solarTermsDateList.filter { $0 <= findDate }.count % 24
        return nextSolarNum
    }
    public func getSolarTermsDateList(year: Int) -> [(Int, Int)] {
        let solarTermsList = getTheYearAllSolarTermsList(year: year) //function from solar24
        var solarTermsDateList: [(Int, Int)] = []

        for i in 0..<solarTermsList.count {
            let day = solarTermsList[i]
            let month = i / 2 + 1
            solarTermsDateList.append((month, day))
        }

        return solarTermsDateList
    }

    public func getEarthNum() -> (Int, Int, Int) {
        //地支索引
        let yearEarthNum = the12EarthlyBranches.firstIndex(of: String(ymd8Char.0.suffix(1))) ?? -1
        let monthEarthNum = the12EarthlyBranches.firstIndex(of: String(ymd8Char.1.suffix(1))) ?? -1
        let dayEarthNum = the12EarthlyBranches.firstIndex(of: String(ymd8Char.2.suffix(1))) ?? -1
        
        return (yearEarthNum, monthEarthNum, dayEarthNum)
    }
    public func getHeavenNum() -> (Int, Int, Int) {
        let yearHeavenNum = the10HeavenlyStems.firstIndex(of: String(ymd8Char.0.prefix(1))) ?? -1
        let monthHeavenNum = the10HeavenlyStems.firstIndex(of: String(ymd8Char.1.prefix(1))) ?? -1
        let dayHeavenNum = the10HeavenlyStems.firstIndex(of: String(ymd8Char.2.prefix(1))) ?? -1
        
        return (yearHeavenNum, monthHeavenNum, dayHeavenNum)
    }
    

    public func getLunarDateNum() -> (Int, Int, Int,Int) {
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
    public func getMonthLeapMonthLeapDays(lunarYear_:Int,lunarMonth_:Int) -> (Int,Int,Int) {
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

    public func getThe8Char() -> (String, String) {
        year8Char = getYear8Char() // update the property year8Char here
        return (getMonth8Char(), getDay8Char())
    }
    public func getYear8Char() -> String {
        // 立春年干争议算法
        return the60HeavenlyEarth[((lunarYear - 4) % 60) - _x]
    }
    public func getMonth8Char() -> String {
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
    public var dayHeavenlyEarthNum:Int {
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
    public func getDay8Char() -> String {
        //日柱
        return the60HeavenlyEarth[dayHeavenlyEarthNum]
    }
    
    public func getSeason() -> (Int,Int,String){
        let seasonType = monthEarthNum % 3
        let seasonNum = pythonModulo((monthEarthNum - 2) , 12) / 3
        
        let seasonTypes = ["仲", "季", "孟"]
        let seasons = ["春", "夏", "秋", "冬"]
        
        let lunarSeason = seasonTypes[seasonType] + seasons[seasonNum]
        
        return (seasonType,seasonNum,lunarSeason)
    }
    
    public func getTwohour8CharList() -> [String] {
        // Calculate the start index
        let begin = (the60HeavenlyEarth.firstIndex(of: day8Char)! * 12) % 60
        
        // Combine the array with itself and extract the relevant slice
        let extendedList = the60HeavenlyEarth + the60HeavenlyEarth
        let twohour8CharList = Array(extendedList[begin..<(begin + 13)])
        return twohour8CharList
    }
    public func getTwohour8Char() -> String {
        return twohour8CharList[twohourNum % 12]
    }
    
    public func getToday12DayOfficer() -> (String, String) {
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
    
    public func getWeekDayCn() -> String {
        return weekDay[Calendar.current.component(.weekday, from: date) - 1]
    }
    public var luckygodsdirectionlist:[String:String]{
        getLuckyGodsDirection()
    }
    public func getLuckyGodsDirection() -> [String:String] {
        //吉神方位
        let todayNum = dayHeavenNum
        //let listofluckgods:[String] = ["喜神","财神","福神","阳贵","阴贵"]
        let direction = [
            directionList[chinese8Trigrams.firstIndex(of: luckyGodDirection[todayNum])!],
            directionList[chinese8Trigrams.firstIndex(of: wealthGodDirection[todayNum])!],
            directionList[chinese8Trigrams.firstIndex(of: mascotGodDirection[todayNum])!],
            directionList[chinese8Trigrams.firstIndex(of: sunNobleDirection[todayNum])!],
            directionList[chinese8Trigrams.firstIndex(of: moonNobleDirection[todayNum])!]
        ]
        let result = Dictionary(uniqueKeysWithValues:zip(listofluckgods,direction))
        return result
    }
    public func getThe28Stars() -> String {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2019, month: 1, day: 17))!
        
        // Calculate the difference in days between the current date and the reference date
        let apart = calendar.dateComponents([.day], from: referenceDate, to: date).day!
        
        // Assuming `the28StarsList` is an array of strings representing the 28 stars
        return the28StarsList[apart % 28]
    }
}

