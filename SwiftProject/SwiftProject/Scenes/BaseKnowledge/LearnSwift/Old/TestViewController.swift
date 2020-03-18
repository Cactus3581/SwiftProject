//
//  TestViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/23.
//  Copyright © 2019 cactus. All rights reserved.
//

// MARK:创建一个类，在 class后接类名称来创建一个类,声明子类就在它名字后面跟上父类的名字，用冒号分隔
class TestViewController: BaseViewController {

}
//class TestViewController: BaseViewController {
//
//    // MARK:属性/方法，在类里边声明属性与声明常量或者变量的方法是相同的，唯一的区别的它们在类环境下。同样的，方法和函数的声明也是相同的写法。
//    var ivarNum: Int = 1
//    var ivarNum1 = 2
//    var ivarNum2: Int
//
//    var ivarNum9: Int?
////    var ivarNum10: Int
//    var ivarNum11 = 10
//
//    var ivarString: String = "";
//    var ivarString1: String?;
//
//    // set/get方法
//    var perimeter: Int {
//
//        get {
//            return 3 * ivarNum
//        }
//
//        set {
//            //setter中，新值被隐式地命名为 newValue。可以提供一个显式的名字放在 set 后边的圆括号里。
//            ivarNum = newValue / 3
//        }
//    }
//
//    // set/get方法
//    var perimeter1: Int {
//
//        willSet {
//
//        }
//
//        didSet {
//
//        }
//    }
//
//
//
//    func func2(var1:String , var2:Int) -> String {
//        return var1+String(var2)
//    }
//
//    //子类的方法如果要重写父类的实现，则必须使用 override
//    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//
//        //属性必须在这里（初始化方法）赋值或者在声明的时候
//        //1. 设定子类声明的属性的值；
//        self.ivarNum2 = 2//注意使用 self来区分 name属性还是初始化器里的 name参数
//        self.perimeter1 = 1
//
//        //2.调用父类的初始化器；
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//
//        //3.改变父类定义的属性中的值，以及其他任何使用方法，getter 或者 setter 等需要在这时候完成的内容。
//    }
//
//    // 不知道为什么要写这句
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // 反初始化器 相当于dealloc 在释放对象之前执行一些清理工作
//    deinit {
//
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        ivarNum = 9
//        self.ivarNum = 9
//
//        var a: String
//        var b = 5
//        if b%2 == 1 {
//            a = ""
//        } else {
//            a = "123"
//        }
//
//        view.backgroundColor = UIColor.white
////        let label = UILabel()
////        self.view.addSubview(label)
////        label.center = self.view.center;
////        label.text = "text";
////        label.textColor = UIColor.red
////        label.sizeToFit()
////        simple()
////        control()
////        enumFunc()
////        protocolFunc()
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = BPSubViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//
////        vc.onetitle = "name"
//
//        vc.name = "name"
////        vc.str = "getter4"
////        vc.str1 = "getter5"
////        vc.str2 = "getter6"
//        vc.str3 = "getter7"
////        print(vc.name,vc.str,vc.str1,vc.str2,vc.str3)
//    }
//
//    // 对象方法
//    func objcMethod() -> String {
//        return "A shape with \(ivarNum) sides."
//    }
//
//    func objcMethod1(name: String) -> String {
//        return "A shape with \(ivarNum) sides."
//    }
//
//    // 类方法
//    static func classMethod() -> String {
//        // 类方法不会包含属性
////        return "A shape with \(numberOfSides) sides."
//        return "";
//    }
//
//    class func classMethod1() -> String {
//        // 类方法不会包含属性
////        return "A shape with \(numberOfSides) sides."
//        return "";
//    }
//
//    //MARK: 简单值
//    func simple() {
//
//        /* let来声明一个常量，var来声明一个变量。常量的值在编译时并不要求已知，但是你必须为其赋值一次。这意味着你可以使用常量来给一个值命名，然后一次定义多次使用。
//        */
//
//        var myVariable = 1
//        myVariable = 2
//
//        let myConstant = 1
//        // myConstant = 2; // 编译报错
//
//        print(myVariable,myConstant)
//
//        // 显示指明类型
//        let explicitDouble: Double = 70
//
//        // 类型转换：将数字转换为字符串
//
//        let text = "The width is "
//        let count = 94
//        let text1 = text + String(count)
//        print(text1)
//
//        //把值加入字符串：使用 \() 来把一个浮点计算包含进字符串
//
//        let apples = 3
//        let oranges = 5
//        let appleSummary = "I have \(count) apples."
//        let fruitSummary = "I have \(apples + oranges) pieces of fruit."
//
//        print(appleSummary,fruitSummary)
//
//        //为字符串使用三个双引号（ """ ）来一次输入多行内容。只要每一行的缩进与末尾的引号相同，这些缩进都会被移除。比如说：
//
//
//        let quotation = """
//
//        I said "I have \(apples) apples."
//        And then I said "I have \(apples + oranges) pieces of fruit."
//
//        """
//        print(quotation)
//
//        //使用方括号[]来创建数组或者字典，并且使用方括号来按照序号或者键访问它们的元素。
//
//        var array = ["1", "2", "3"]
//        array[1] = "1-"
//
//        var dict = [
//            "key1": "value1",
//            "key2": "value2",
//        ]
//
//        dict["key1"] = "value1-"
//
//        print(array)
//        print(dict)
//
//        //使用初始化器语法来创建一个空的数组或者字典：指明类型
//        array = [String]()
//        dict = [String: String]()
//
//        // 创建空数组或者字典，如果类型信息能被推断，可以使用下面的方法
//        array = []
//        dict = [:]
//    }
//
//    //MARK: 控制流
//    func control() {
//
//        // if的使用
//        let individualScores = [1, 2, 3]
//        var teamScore = 2
//        for score in individualScores {
//            if score == teamScore {
//                print(teamScore)
//            }
//        }
//
//        // 可选项：指定类型并在后面添加？
//        var optionalString: String? = nil // 默认就是nil
//
//        if optionalString != nil {
//           // 使用 !强制解析/解包：表示"我知道这个可选有值，请使用它。但是强行解包存在着风险，当为nil时，程序运行会崩溃，所以需要判断好是否为nil。
//           print(optionalString!)
//        }else{
//           print("optionalString 值为 nil")
//        }
//    //自动解析：、在声明可选变量时使用感叹号（!）替换问号（?）。这样可选变量在使用时就不需要再加一个感叹号（!）来获取值，它会自动解析。
//        var myString:String!
//        myString = "Hello, Swift!"
//        if myString != nil {
//           print(myString)
//        }else{
//           print("myString 值为 nil")
//        }
//
////可选绑定：使用可选绑定来判断可选类型是否包含值，如果包含值就自动解包，把值赋给一个临时常量或者变量，并返回true，否则返回false。可选绑定可以用在if和while语句中来对可选类型的值进行判断并把值赋给一个常量或者变量。
//        if let yourString = myString {
//           print("你的字符串值为：\(yourString)")
//        }else{
//           print("你的字符串没有值")
//        }
//
//        // 使用 ?? 运算符提供默认值（类似于三目运算符），前面是值类型是可选类型，后面的可是任意
//        let nickName: String? = nil
//        let fullName: String = "John Appleseed"
//        let informalGreeting = "Hi \(nickName ?? fullName)"
//        print(informalGreeting)
//
//        // switch:不需要显式break
//        let vegetable = "red pepper"
//        switch vegetable {
//
//            case "celery":
//                print("Add some raisins and make ants on a log.")
//
//            case "cucumber", "watercress":
//                print("That would make a good tea sandwich.")
//
//            case let x where x.hasSuffix("pepper"):
//                print("Is it a spicy \(x)?")
//
//            default:
//                print("Everything tastes good in soup.")
//        }
//
//        // 集合遍历
//        let interestingNumbers = [
//            "Prime": [2, 3, 5, 7, 11, 13],
//            "Fibonacci": [1, 1, 2, 3, 5, 8],
//            "Square": [1, 4, 9, 16, 25],
//        ]
//        var largest = 0
//        for (kind, numbers) in interestingNumbers {
//            for number in numbers {
//                if number > largest {
//                    largest = number
//                }
//            }
//        }
//        print(largest)
//
//        var n = 2
//        while n < 100 {
//            n = n * 2
//        }
//        print(n)
//
//        var m = 2
//        repeat {
//            m = m * 2
//        } while m < 100
//        print(m)
//
//        //使用 ..<来创建一个不包含最大值的序列区间，使用 ... 来创造一个包含最大值和最小值的序列区间。
//        var total = 0
//        for i in 0..<4 {
//            total += i
//        }
//        print(total)
//    }
//
//    //MARK:函数
//    func func1() {
//
//        // func + 函数名 +（参数）->返回值类型
//        func greet(person: String, day: String) -> String {
//            return "Hello \(person), today is \(day)."
//        }
//        greet(person: "Bob", day: "Tuesday")
//
//        //在形式参数前可以写自定义的实际参数标签，或者使用 _ 来避免使用实际参数标签。
//        func greet1(with person: String, on day: String) -> String {
//            return "Hello \(person), today is \(day)."
//        }
//        greet1(with: "Bob", on: "Tuesday")
//
//        func greet2(_ person: String, _ day: String) -> String {
//            return "Hello \(person), today is \(day)."
//        }
//        greet2("Bob", "Tuesday")
//
//        func greet3(one person: String, two day: String) -> String {
//            return "Hello \(person), today is \(day)."
//        }
//        greet3(one:"Bob", two:"Tuesday")
//
//        //使用元组来创建复合值。比如为了从函数中返回多个值。元组中的元素可以通过名字或者数字调用
//        func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
//
//            var min = scores[0]
//            var max = scores[0]
//            var sum = 0
//
//            for score in scores {
//                if score > max {
//                    max = score
//                } else if score < min {
//                    min = score
//                }
//                sum += score
//            }
//
//            return (min, max, sum)
//        }
//
//        let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
//        print(statistics.sum)
//        print(statistics.2)
//
//        //函数同样可以接收多个参数，然后把它们存放进数组当中
//        func sumOf(numbers: Int...) -> Int {
//            var sum = 0
//            for number in numbers {
//                sum += number
//            }
//            return sum
//        }
//        sumOf()
//        sumOf(numbers: 42, 597, 12)
//
//        //函数可以内嵌。内嵌的函数可以访问外部函数里的变量。可通过使用内嵌函数来组织代码，以避免某个函数太长或者太过复杂
//        func returnFifteen() -> Int {
//            var y = 10
//            func add() {
//                y += 5
//            }
//            add()
//            return y
//        }
//        print(returnFifteen());
//
//        //函数可以作为返回值
//        func makeIncrementer() -> ((Int) -> Int) {
//            func addOne(number: Int) -> Int {
//                return 1 + number
//            }
//            return addOne
//        }
//        var increment = makeIncrementer()
//        increment(7)
//
//        //函数也可以把另外一个函数作为参数进行传递
//        func hasAnyMatches(list: [Int],  condition: @escaping(Int,Int) -> Bool) -> Bool {
//            for item in list {
//                if condition(item,item) {
//                    return true
//                }
//            }
//
//            escape(condition: condition)
//            return false
//        }
//
//        func lessThanTen(number: Int ,number1: Int) -> Bool {
//            return number < 10
//        }
//        var numbers = [20, 19, 7, 12]
//
//        func escape(condition: (Int,Int) -> Bool) {
//
//        }
//
//        func hasAnyMatches1(list: [Int], condition: ()->()) -> Bool {
//            condition()
//            return false
//        }
//
//        func lessThanTen1() {
//        }
//
//        hasAnyMatches1(list: numbers, condition: lessThanTen1)
//
//        //MARK:将下面的函数改为匿名函数
//        func anonymousFunc(){
//        }
//
//        //匿名函数版本
//        let anonymousFunc1 = {
//            () -> () in
//            // ...
//        }
//
//        anonymousFunc1()
//
//        func anonymousFunc2(finished: Bool) -> Bool {
//            return true
//        }
//
//        // 匿名函数版本
//        let anonymousFunc3 = {
//            (finished: Bool) -> Bool in
//            return finished
//        }
//
//        //省略：返回类型、没有参数可以省略in
//        let anonymousFunc4 = {
//            (finished: Bool) in
//            return finished
//        }
//
//        let result1 = anonymousFunc3(true)
//
//        print (result1)
//        print (anonymousFunc3(true))
//
//        //MARK:闭包：本质上是匿名函数，不过闭包可以捕获外部常量/变量。 因为包裹着这些常量/变量，俗称闭包。
//
//        let divide = {(val1: Int, val2: Int) -> Int in
//           return val1 / val2
//        }
//
//        let result = divide(200, 20)
//        print (result)
//
//        //函数其实就是闭包的一种特殊形式：一段可以被随后调用的代码块。闭包中的代码可以访问其生效范围内的变量和函数，就算是闭包在它声明的范围之外被执行——你已经在内嵌函数的栗子上感受过了。你可以使用花括号{}括起一个没有名字的闭包。在闭包中使用 in 来分隔实际参数和返回类型
//
//        numbers.map{
//            (number: Int) -> Int in
//            let result = 3 * number
//            return result
//        }
//
//        //集合类型的高阶函数
//
//        // 通过$0和$1等来表示闭包中的第一个第二个参数，是对闭包中参数的简化写法，并且对应的参数类型会根据函数类型来进行判断
//
//        //将 Int 类型数组（各个元素），转换成 String 类型的数组
//        let prices = [20,30,40]
//        let strs = prices.map({"\($0)"})
//        print(strs)
//
//        // 对一个数组里面的数据进行平方操作
//        let squares = prices.map{$0 * $0}
//        print(squares)
//
//        // map 函数还原：这个尾闭包只有一个参数，即：(value: Int)和 return Int，根据参数value的类型，所以swift可以推断返回值类型。同样，因为map函数只有一个闭包作为参数，所以我们也不需要参数(value: Int)两边的()括号，甚至也不需要return关键字，in关键字用来将闭包的参数和函数体隔开
//        let squares2 = prices.map{
//            (value: Int) -> Int in
//            return value * value
//        }
//
//        // 将公里转化为英里
//        let dict = ["point1":120.0,"point2":50.0,"point3":70.0]
//
//        let kmToPoint = dict.map{key,value in value * 1.6093 }
//        let set: Set = [4.0, 6.2, 8.9]
//        let lengthInFeet = set.map{value in value * 3.2808}
//
//        // 使用$0,$1，参数类型可以自动判断，并且in关键字也可以省略，也就是只用写函数体就可以了。
//        var sortNumbers = prices.sorted{$0 < $1}
//        print("numbers -" + "\(sortNumbers)")
//
//        //不使用$0 $1这些来代替
//        sortNumbers = numbers.sorted(by:{(a, b) -> Bool in
//            return a < b
//        })
//        print("numbers -" + "\(sortNumbers)")
//
//        // flatMap 函数，同 map 方法比较类似，只不过它返回后的数组中自动把 nil 给剔除掉，同时它会把 Optional 解包
//
//        let array = ["Apple", "Orange", "Grape", ""]
//
//        let arr1 = array.map { a -> Int? in
//            let length = a.count
//            guard length > 0 else {
//                return nil
//            }
//            return length
//        }
//        print("arr1:\(arr1)")
//
//        let arr2 = array.flatMap { a -> Int? in
//            let length = a.count
//            guard length > 0 else {
//                return nil
//            }
//            return length
//        }
//        print("arr2:\(arr2)")
//
//        //filter，遍历该集合，将该集合中符合符合条件的元素组成新的数组，过滤掉不符合条件的元素,并返回该新数组
//        let digits = [1, 4, 5, 10, 15]
//        let even = digits.filter{(value) -> Bool in
//            return value % 2 == 0
//        }
//        print(even)// [4, 10]
//
//        let result3 = digits.filter({ $0 > 5 })
//        print(result3)
//    }
//
//    // MARK:枚举和结构体
//    // 枚举也能够包含方法
//    func enumFunc() {
//
//        enum Rank: Int {
//            case ace = 1
//            case two, three, four, five, six, seven, eight, nine, ten
//            case jack, queen, king
//
//            func simpleDescription() -> String {
//                switch self {
//                    case .ace:
//                        return "ace"
//                    case .jack:
//                        return "jack"
//                    case .queen:
//                        return "queen"
//                    case .king:
//                        return "king"
//                    default:
//                        return String(self.rawValue)
//                }
//            }
//        }
//
//        let ace = Rank.ace
//        let three = Rank.three
//        let queen = Rank.queen
//
//        print(ace,three,queen)
//
//        let aceRawValue = ace.rawValue//使用 rawValue 属性来访问枚举成员的原始值。
//        print(aceRawValue)
//
//        if let convertedRank = Rank(rawValue: 3) {
//            let threeDescription = convertedRank.simpleDescription()
//            print(threeDescription)
//        }
//
//        enum Suit {
//            case spades, hearts, diamonds, clubs
//            func simpleDescription() -> String {
//                switch self {
//                    case .spades:
//                        return "spades"
//                    case .hearts:
//                        return "hearts"
//                    case .diamonds:
//                        return "diamonds"
//                    case .clubs:
//                        return "clubs"
//                }
//            }
//        }
//        let hearts = Suit.hearts
//        let heartsDescription = hearts.simpleDescription()
//        print(heartsDescription)
//
//        // 不懂这种写法
//        enum ServerResponse {
//            case result(String, String)
//            case failure(String)
//        }
//
//        let success = ServerResponse.result("6:00 am", "8:09 pm")
//        let failure = ServerResponse.failure("Out of cheese.")
//
//        switch success {
//            case let .result(sunrise, sunset):
//                print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
//            case let .failure(message):
//                print("Failure...  \(message)")
//        }
//
//        // 结构体：使用 struct来创建结构体。结构体提供很多类似与类的行为，包括方法和初始化器。其中最重要的一点区别就是结构体总是会在传递的时候拷贝其自身，而类则会传递引用。
//        struct Card {
//            var rank: Rank
//            var suit: Suit
//            func simpleDescription() -> String {
//                return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
//            }
//        }
//        let threeOfSpades = Card(rank: .three, suit: .spades)
//        let threeOfSpadesDescription = threeOfSpades.simpleDescription()
//        print(threeOfSpadesDescription)
//    }
//
//    // MARK:协议和扩展
//    func protocolFunc() {
//        var a = SimpleClass()
//        a.adjust()
//        let aDescription = a.simpleDescription
//        print(aDescription)
//
//        struct SimpleStructure: ExampleProtocol {
//            var simpleDescription: String = "A simple structure"
//            mutating func adjust() {
//                //mutating关键字用来声明：使用方法可以修改结构体。在 SimpleClass中则不需要这样声明，因为类里的方法总是可以修改其自身属性的。
//                simpleDescription += " (adjusted)"
//            }
//        }
//        var b = SimpleStructure()
//        b.adjust()
//        let bDescription = b.simpleDescription
//        print(bDescription)
//
//        // MARK:extension
//        let number:Int = 7
//        print(number.simpleDescription)
////        let value = number.adjust()
////        print(value)
//
//        // 可以使用协议类就像普通类一样——比如说，创建一个遵循某一个协议的对象的。协议类型可以直接使用协议内定义的方法/属性
//        let protocolValue = a
//        print(protocolValue.simpleDescription)
//        // 以下两个报错
//        print(protocolValue.anotherProperty)
//        protocolValue.adjust()
//    }
//
//    //MARK:错误处理
//    func errorFunc() {
//        //遵循 Error 协议
//        enum PrinterError: Error {
//            case outOfPaper
//            case noToner
//            case onFire
//        }
//
//        //使用 throw 来抛出一个错误并且用 throws 来标记一个可以抛出错误的函数。如果你在函数里抛出一个错误，函数会立即返回并且调用函数的代码会处理错误
//        func send(job: Int, toPrinter printerName: String) throws -> String {
//            if printerName == "Never Has Toner" {
//                throw PrinterError.noToner
//            }
//            return "Job sent"
//        }
//
//        // 错误处理方法1:使用do catch
////        do {
////            let printerResponse = try send(job: 1040, toPrinter: "Never Has Toner")
////            print(printerResponse)
////        } catch {
////            print(error)
////        }
//
//        //可以提供多个 catch 代码块来处理特定的错误。你可以在 catch 后写一个模式，用法和 switch 语句里的 case 一样
//        do {
//            let printerResponse = try send(job: 1440, toPrinter: "Never Has Toner")
//            print(printerResponse)
//        } catch PrinterError.onFire {
//            print("I'll just put this over here, with the rest of the fire.")
//        } catch let printerError as PrinterError {
//            print("Printer error: \(printerError).")
//        } catch {
//            print(error)
//        }
//
//        // 错误处理方法2:使用 try?
//       //使用 try? 来转换结果为可选项。如果函数抛出了错误，那么错误被忽略并且结果为 nil 。否则，结果是一个包含了函数返回值的可选项。
//        let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
//        let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")
//
//        if let success = printerSuccess {
//            print(success)
//        }
//        if let failure = printerFailure {
//            print(failure)
//        }
//
//        // 错误处理方法3:defer 来写在函数返回后也会被执行的代码块，无论是否错误被抛出。你甚至可以在没有错误处理的时候使用 defer ，来简化需要在多处地方返回的函数
//
//        var fridgeIsOpen = false
//        let fridgeContent = ["milk", "eggs", "leftovers"]
//
//        func fridgeContains(_ food: String) -> Bool {
//            fridgeIsOpen = true
//            defer {
//                fridgeIsOpen = false
//            }
//
//            let result = fridgeContent.contains(food)
//            return result
//        }
//        let isContain = fridgeContains("banana")
//        print(fridgeIsOpen,isContain)
//
//        // MARK:泛型，把名字写在尖括号里来创建一个泛型方法或者类型
//        func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
//            var result = [Item]()
//            for _ in 0..<numberOfTimes {
//                result.append(item)
//            }
//            return result
//        }
//
//        let array = makeArray(repeating: "knock", numberOfTimes:4)
//        print(array)
//
//        // 可以从函数和方法同时还有类，枚举以及结构体创建泛型
//        enum OptionalValue<Wrapped> {
//            case none
//            case some(Wrapped)
//        }
//        var possibleInteger: OptionalValue<Int> = .none
//        possibleInteger = .some(100)
//
//        // 在类型名称后紧接 where来明确一系列需求——比如说，来要求类型实现一个协议，要求两个类型必须相同，或者要求类必须继承自特定的父类
//        func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
//            where T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
//                for lhsItem in lhs {
//                    for rhsItem in rhs {
//                        if lhsItem == rhsItem {
//                            return true
//                        }
//                    }
//                }
//                return false
//        }
//        anyCommonElements([1, 2, 3], [3])
//    }
//
//    // MARK:可选项/值
//    func optional() {
//
//        func findStockCode(company: String) -> String? {
//           if (company == "Apple") {
//              return "AAPL"
//           } else if (company == "Google") {
//              return "GOOG"
//           }
//           return nil
//        }
//        var stockCode:String? = findStockCode(company: "Facebook")
//        let text = "Stock Code - "
//        if let stockCode1 = stockCode {
//            let message = text + stockCode1
//            print(message)
//        }
//    }
//
//    // MARK:as
//    func asFunc() {
//
//        class Animal {}
//        class Cat: Animal {}
//        class Dog: Animal {}
//
//        // as----
//        // 从子类转换为基类
//
//        let cat = Cat()
//        let animal = cat as Animal
//
//        //数值类型转换
//        let num1 = 42 as CGFloat
//        let num2 = 42 as Int
////        let num3 = 42.5 as Int
//        let num4 = (42 / 2) as Double
//
//        //switch 语句中进行模式匹配
//        switch animal {
//            case let cat as Cat:
//                print("如果是Cat类型对象，则做相应处理")
//            case let dog as Dog:
//                print("如果是Dog类型对象，则做相应处理")
//            default: break
//        }
//
//        // as!:向下转型时使用。由于是强制类型转换，如果转换失败会报运行错误
//
//        let animal1 :Animal = Cat()
//        let cat1 = animal1 as! Cat
//
//        // as?和 as! 操作符的转换规则完全一样。但 as? 如果转换不成功的时候便会返回一个 nil 对象。成功的话返回可选类型值（optional），需要我们拆包使用。由于 as? 在转换失败的时候也不会出现错误，所以对于如果能确保100%会成功的转换则可使用 as!，否则使用 as?
//
//        if let cat = animal1 as? Cat {
//            print("cat is not nil")
//        } else {
//            print("cat is nil")
//        }
//
//
//
//    }
//}

// MARK:协议和扩展
// 使用 protocol来声明协议
protocol ExampleProtocol {
    var simpleDescription: String {
        get}
    mutating func adjust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += "  Now 100% adjusted."
    }
}

//使用 extension(扩展)来给现存的类型增加功能(新方法/属性)
extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    mutating func adjust() {
        self += 42
    }
}
