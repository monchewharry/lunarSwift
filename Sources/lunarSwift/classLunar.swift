//
//  Created by Dingxian Cao on 8/27/24.
//
import Foundation

/**
 The class Lunar initiated with a Date() object. It will store and calculate all relavant information of that specific date in the literature of Chinese Lunar Calendar.
 */
open class Lunar:ObservableObject {
    public var twohourNum: Int {
        (Calendar.current.component(.hour, from: date) + 1) / 2
    }
    public var isLunarLeapMonth: Bool=false
    public var godType: String
    public var yearPillarType: String
    public var date: Date

    public init(date: Date, godType: String = "8char", yearPillarType: String = "beginningOfSpring" )throws {
        //date range check
        if date >= Date.minAllowedDate && date <= Date.maxAllowedDate {
                    self.date = date
        } else {
            print("Date input: \(date) is out of the allowed range Year (1901-2100).")
            throw LunarError.dateOutOfBounds
        }
        
        self.godType = godType
        self.yearPillarType = yearPillarType
    }
    
    
    private var lunarYMD: (lunarYear:Int,lunarMonth:Int,lunarDay:Int,spanDays:Int) {
        getLunarDateNum()
    }
    public var lunarYear:Int {return lunarYMD.lunarYear}
    public var lunarMonth:Int {return lunarYMD.lunarMonth}
    public var lunarDay:Int {return lunarYMD.lunarDay}
    public var spanDays: Int {return lunarYMD.spanDays}
    
    //find lunar YMD's chinese character
    private var lunarYMDCn: (lunarYearCn:String,lunarMonthCn:String,lunarDayCn:String) {
        getLunarCn()
    }
    public var lunarYearCn:String {return lunarYMDCn.lunarYearCn}
    public var lunarMonthCn:String {return lunarYMDCn.lunarMonthCn}
    public var lunarDayCn:String {return lunarYMDCn.lunarDayCn}
    public var lunarbirthday: String {
        return lunarYearCn + "年 " + lunarMonthCn + " " + lunarDayCn + "日 " + twohour8Char.branch.rawValue + "时"
    }
    
    //find jieqi
    public var solarinfo: (solarTermsEnum,[(Int,Int)],Int,Int) {getTodaySolarTerms()}
    public var todaySolarTerms: solarTermsEnum {solarinfo.0}
    public var thisYearSolarTermsDateList:[(Int, Int)] {solarinfo.1}
    public var nextSolarNum:Int {solarinfo.2}
    public var nextSolarTerm:solarTermsEnum {Array(solarTermsEnum.allCases.dropLast())[nextSolarNum]}
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
    private var ymd8Char: (year:StemBranch,
                          month:StemBranch,
                          day:StemBranch) { // also update year8Char
        getThe8Char()
    }
    public var year8Char:StemBranch {return ymd8Char.year}
    public var month8Char:StemBranch {return ymd8Char.month}
    public var day8Char:StemBranch {return ymd8Char.day}
    
    // calculate lunr YMD's BAZI dizhi's index
    private var ymdEarthNum: (Int,Int,Int) {//must after the update of year8Char
        getEarthNum()
    }
    public var yearEarthNum:Int {return ymdEarthNum.0}
    public var monthEarthNum:Int {return ymdEarthNum.1}
    public var dayEarthNum:Int {return ymdEarthNum.2}
    // calculate lunr YMD's BAZI tiangan's index
    private var ymdHeavenNum: (Int,Int,Int) {
        getHeavenNum()
    }
    public var yearHeavenNum:Int {return ymdHeavenNum.0}
    public var monthHeavenNum:Int {return ymdHeavenNum.1}
    public var dayHeavenNum:Int {return ymdHeavenNum.2}
    
    //时柱
    public var twohour8CharList: [StemBranch] {getTwohour8CharList()}
    public var twohour8Char: StemBranch {getTwohour8Char()}
    //纳音
    public var nayin: [String] {
        let nayin4list: [String] = [
            halfStemBranchNayinList[(the60StemBranchEnumArray.firstIndex(of: year8Char)!)/2],
            halfStemBranchNayinList[(the60StemBranchEnumArray.firstIndex(of: month8Char)!)/2],
            halfStemBranchNayinList[(the60StemBranchEnumArray.firstIndex(of: day8Char)!)/2],
            halfStemBranchNayinList[(the60StemBranchEnumArray.firstIndex(of: twohour8Char)!)/2]
        ]
        
        return nayin4list
        }
    public var luckygodsdirectionlist:[luckgodsNameEnum:directionEnum]{
        getLuckyGodsDirection()
    }
    
    // if the yearPillarType = "beginningOfSpring", calculate the year pillar by 24 jieqi
    private func getBeginningOfSpringX() -> Int {
        
        let isBeforeBeginningOfSpring = nextSolarNum < 3
        let isBeforeLunarYear = spanDays < 0
        var x = 0

        if yearPillarType != "beginningOfSpring" {
            return x
        }
        
        if isBeforeLunarYear {
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
    func setlunarMonthLong() -> Bool{
        let thisLunarMonthDays = isLunarLeapMonth ? monthDaysList[2] : monthDaysList[0]
        let v = thisLunarMonthDays >= 30
        return v
    }
    func getLunarMonthCN() -> String {
        assert(lunarMonthNameList.count == 12, "lunarMonthNameList count not equal to 12")
        var lunarMonth = lunarMonthNameList[(lunarMonth - 1) % 12]
        if isLunarLeapMonth {
            lunarMonth = "闰" + lunarMonth
        }

        let size = lunarMonthLong ? "大" : "小"
        return lunarMonth + size
    }

    func getLunarCn() -> (String, String, String) {
        assert(lunarDayNameList.count == 30, "lunarDayNameList count not equal to 30")
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
    /**
     返回 (今日节气，今年节气列表[(month,day)]，下一个节气索引，下一个节气年):  帮助确定年柱，月柱
     - Returns: <#description#>
     */
    func getTodaySolarTerms() -> (solarTermsEnum,[(Int,Int)],Int,Int) {
        var year:Int = Calendar.current.component(.year, from: date)
        var solarTermsDateList:[(Int,Int)] = getSolarTermsDateList(year: year)
        let thisYearSolarTermsDateList:[(Int,Int)] = solarTermsDateList

        let findDate:(Int,Int) = (Calendar.current.component(.month, from: date), Calendar.current.component(.day, from: date))
        let nextSolarNum:Int = getNextNum(findDate: findDate, solarTermsDateList: solarTermsDateList)

        let todaySolarTerm: solarTermsEnum
        if let index = solarTermsDateList.firstIndex(where: { $0 == findDate }) {
            assert(solarTermsEnum.allCases.count == (24+1), "solarTermsEnum count not equal to 24+1")
            todaySolarTerm = Array(solarTermsEnum.allCases.dropLast())[index]
        } else {
            todaySolarTerm = solarTermsEnum.no
        }

        // 次年节气
        if let _a = solarTermsDateList.last {
            if (findDate.0 == _a.0) && (findDate.1 >= _a.1) {
                year += 1
                solarTermsDateList = getSolarTermsDateList(year: year)
            }
        }
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
        assert(solarTermsList.count == 24, "solartermslist length not equal to 24")
        for i in 0..<solarTermsList.count {
            let day = solarTermsList[i]
            let month = i / 2 + 1
            solarTermsDateList.append((month, day))
        }

        return solarTermsDateList
    }

    func getEarthNum() -> (Int, Int, Int) {
        //地支索引
        let yearEarthNum:Int = the12BranchEnum.allCases.firstIndex(of: year8Char.branch)!
        let monthEarthNum:Int = the12BranchEnum.allCases.firstIndex(of: month8Char.branch)!
        let dayEarthNum:Int = the12BranchEnum.allCases.firstIndex(of: day8Char.branch)!
        
        return (yearEarthNum, monthEarthNum, dayEarthNum)
    }
    func getHeavenNum() -> (Int, Int, Int) {
        let yearHeavenNum = the10StemEnum.allCases.firstIndex(of: year8Char.stem)!
        let monthHeavenNum = the10StemEnum.allCases.firstIndex(of: month8Char.stem)!
        let dayHeavenNum = the10StemEnum.allCases.firstIndex(of: day8Char.stem)!
        return (yearHeavenNum, monthHeavenNum, dayHeavenNum)
    }
    
    /**
     * The funtction  calculate the number representation of lunar year,month,day
     * 返回 (lunarYear_, lunarMonth_, lunarDay_,spanDays)，
     * 返回的月份，高4bit为闰月月份，低4bit为其它正常月份
     *  注意这里的立春时间只精确到日，立春日全天都算立春
     * - Returns: <#description#>
     */
    func getLunarDateNum() -> (Int, Int, Int,Int) {
        // 给定公历日期，计算农历日期
        var lunarYear_:Int = Calendar.current.component(.year, from: date)
        precondition(lunarYear_ < 2100, "solar year number exceed 2100")
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
    /// Calculate leap month's index and its days number
    /// - Parameters:
    ///   - lunarYear_: <#lunarYear_ description#>
    ///   - lunarMonth_: <#lunarMonth_ description#>
    /// - Returns: <#description#>
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

    func getThe8Char() -> (year:StemBranch,
                           month:StemBranch,
                           day:StemBranch) {
        return (getYear8Char(),getMonth8Char(), getDay8Char())
    }
    func getYear8Char() -> StemBranch {
        // 立春年干争议算法
        return the60StemBranchEnumArray[((lunarYear - 4) % 60) - _x]
    }
    
    /**
     * 已知2019/01/05 小寒 为甲子月, 且月柱60一循环（和年柱类似），可以从基准年月推算.
     * 比如2019/01/05 小寒 为甲子月，加上当前过了几个节气(共24个,每个公历月有两个节气)除以2
     * 原理和五虎遁法效果相同
     * 注意这里的月份精确度只在日，节气分割日当天都为该节气日并开始下一个月干，不精确到时
     * - Returns: <#description#>
     */
    func getMonth8Char() -> StemBranch {
        var nextNum:Int = nextSolarNum //下一个节气在节气列表中的索引
        if nextNum == 0 && Calendar.current.component(.month, from: date) == 12 {
            //若今天就是某节气，且当前月份为12月
            nextNum = 24
        }
        
        let apartNum:Int = (nextNum + 1) / 2 //距离下一个节气相差多少个由24节气分割的月份
        let yeardiffmonth: Int = (Calendar.current.component(.year, from: date) - 2019) * 12
        let _index:Int = pythonModulo((yeardiffmonth + apartNum) , 60)
        assert(the60StemBranchEnumArray.count == 60, "the60StemBranchEnumArray count not equal to 60")
        let month8Char = the60StemBranchEnumArray[_index]//2019/01/05 小寒为甲子月
        return month8Char
    }
    public var dayHeavenlyEarthNum:Int {
        //日柱索引需要注意计算和标准日差的时候的精确度
        let baseDate = DateComponents(calendar: Calendar.current, year: 2019, month: 1, day: 29).date!
        let baseDayStemBranch = StemBranch(stem:.bing, branch:.yin)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let date2 = Calendar.current.date(from: dateComponents)! //remove hour info: default = 0
        
        let apart = Calendar.current.dateComponents([.day], from: baseDate, to: date2).day! // 12 hour accuracy
        var baseNum = the60StemBranchEnumArray.firstIndex(of: baseDayStemBranch)! // baseNum==2
        
        // 超过23点算第二天，为防止溢出，在baseNum上操作+1
        if twohourNum == 12 {
            baseNum += 1
        }
        return pythonModulo((apart + baseNum) , 60)
    }
    func getDay8Char() -> StemBranch {
        //日柱
        return the60StemBranchEnumArray[dayHeavenlyEarthNum]
    }
    
    func getSeason() -> (Int,Int,String){
        let seasonType = monthEarthNum % 3
        let seasonNum = pythonModulo((monthEarthNum - 2) , 12) / 3
        
        let seasonTypes = ["仲", "季", "孟"]
        let seasons = ["春", "夏", "秋", "冬"]
        
        let lunarSeason = seasonTypes[seasonType] + seasons[seasonNum]
        
        return (seasonType,seasonNum,lunarSeason)
    }
    
    func getTwohour8CharList() -> [StemBranch] {
        // Calculate the start index
        let begin = (the60StemBranchEnumArray.firstIndex(of: day8Char)! * 12) % 60
        
        // Combine the array with itself and extract the relevant slice
        let extendedList = the60StemBranchEnumArray + the60StemBranchEnumArray
        let twohour8CharList = Array(extendedList[begin..<(begin + 13)])
        return twohour8CharList
    }
    func getTwohour8Char() -> StemBranch {
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
    /**
     返回吉神方位
     - Returns: <#description#>
     */
    func getLuckyGodsDirection() -> [luckgodsNameEnum:directionEnum] {
        let todayNum = dayHeavenNum
        //let listofluckgods:[String] = ["喜神","财神","福神","阳贵","阴贵"]
        let direction = [
            directionEnum.allCases[chinese8Trigrams.firstIndex(of: luckyGodDirection[todayNum])!],
            directionEnum.allCases[chinese8Trigrams.firstIndex(of: wealthGodDirection[todayNum])!],
            directionEnum.allCases[chinese8Trigrams.firstIndex(of: mascotGodDirection[todayNum])!],
            directionEnum.allCases[chinese8Trigrams.firstIndex(of: sunNobleDirection[todayNum])!],
            directionEnum.allCases[chinese8Trigrams.firstIndex(of: moonNobleDirection[todayNum])!]
        ]
        let result = Dictionary(uniqueKeysWithValues:zip(luckgodsNameEnum.allCases,direction))
        return result
    }
    /**
     返回28宿
     - Returns: <#description#>
     */
    func getThe28Stars() -> String {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2019, month: 1, day: 17))!
        
        // Calculate the difference in days between the current date and the reference date
        let apart = calendar.dateComponents([.day], from: referenceDate, to: date).day!
        
        // Assuming `the28StarsList` is an array of strings representing the 28 stars
        assert(the28StarsList.count == 28, "the28StarsList count not equal to 28")
        return the28StarsList[apart % 28]
    }
}

