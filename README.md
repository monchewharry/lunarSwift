# lunarSwift is a pkg for Swift

## Basics

```Swift
import lunarSwift
import baguaSwift

class PeopleApp:People{

}
// calendar and BaZi
var p1 = PeopleApp(date: Date(), year8Char: "beginningOfSpring")
print(p1.date)//solar date
print(p1.lunarYMDCn)//lunar date in chinese character
print(p1.lunarbirthday)//lunar date to display
print(p1.ymd8Char)//BaZi
print(p1.nayin)//nayin 

//ZhouYi 64 Gua
let getAbinary = getRandomBinary()
let guaInfo = getHexagramInfo(for: getAbinary)

let (labels, paragraphs) = getHexagramInfoParts(guaInfo)!.description)

for label in labels {
    if let content = paragraphs[label] {
        print("\(label):\n\(content)\n")
    }
}

```

## Notice

The year pillar is adjusted based on the beginningOfSpring. 年柱计算已经由立春日修改.

