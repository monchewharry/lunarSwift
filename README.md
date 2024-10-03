# lunarSwift is a pkg for Swift

This Swift package will calculate lunar calendar from solar calendar. Based on the four pillars derived from the lunar calendar, the package also provide some functionality to support traditional Dividation.

**Current Features**

- lunar calendar(农历换算)
- BaZib(生辰八字)
- ZiWei (紫微斗数排盘)
- ZhouYi(周易占卜)

## Basics

```Swift
import lunarSwift

class PeopleApp:People{

}
// calendar and BaZi
var p1 = PeopleApp(date: Date(), year8Char: "beginningOfSpring")
print(p1.date) //solar date
print(p1.lunarbirthday) //农历日期
print(p1.ymd8Char) //八字
print(p1.nayin) //纳音

//ZiWei
print(p1.lifePalace) //命宫
print(p1.twelvePalaces) //十二宫
print("\(p1.wuxingGame?.name ?? "unknown")") //五行局
print(p1.starsBranchDict) //星耀

import baguaSwift
//ZhouYi 64 Gua
let binarystr= getRandomBinary() // 随机卦象二进制string
let theHexagram = getHexagram(for: binarystr) //卦全解

let (labels, paragraphs) = theHexagram.paragraphs.paragraphsDict

for label in labels {
    if let content = paragraphs[label] {
        print("\(label):\n\(content)\n")
    }
}

```

## Notice & Disclosure

The year pillar is adjusted based on the beginningOfSpring. 年柱计算已经由立春日修改，且月干分割点也以24节气为准。
>确定一年的干支要以立春为分界线，比如立春前出生且正月初一在立春后，就以上一年农历年计算年柱。月柱也以节气作为分界点，但可以通过“五虎遁”推算。年柱和月柱基于24节气日的精确度到日，具体天象的时刻并没有包含。所以当一个人出生在某年的立春日，其年干等于下一天的年干。又或者一个人出生在惊蛰日，其月干等于下一天的月干。

## Acknowledgements & Reference

Many inspiration from the multiple Python projects.
- [OPN48/cnlunar](https://github.com/OPN48/cnlunar) : 农历换算，四柱八字
- [natal-chart](https://github.com/haibolian/natal-chart) : 紫微斗数排盘
- [rockyCheung/godwill](https://github.com/rockyCheung/godwill) : 周易占卜

1. 中华绝学-中国历代方术大关, 雒启坤, 1998年, 青海人民出版社
2. http://www.ziweicn.com/ziweirumen/ziweijichu/3083.html
3. [紫微研习社](https://www.iztro.com/)
    - [紫微斗数基础](https://www.iztro.com/learn/basis.html)
