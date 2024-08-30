# lunarSwift is a pkg for Swift

## Basics

```Swift
import lunarSwift

class PeopleApp:People{

}
var p1 = PeopleApp(date: Date(), year8Char: "beginningOfSpring")
print(p1.date)//solar date
print(p1.lunarYMDCn)//lunar date in chinese character
print(p1.lunarbirthday)//lunar date to display
print(p1.ymd8Char)//BaZi
```


