//print("Hello Swift!")

func sum(a first:Int, b second:Int) -> Int {
    return first + second
}

var f:(Int, Int) -> Int = sum

// f = { (x, y) in
//         x * y    
//     }
f = { $0 * $1 }

//print(sum(a: 1, b: 1))
print("Извикване през променлива от тип функция: \(f(2, 2))")

func printMe(i: Int) {
    print("Print Me: \(i)")
}

func printMeFancy(i: Int) {
    print("Print Me =>> \(i) <<=")
}

func smartPrint(printFunction:(Int)->()) {
    let list = [1,2,3,4,5,6,7,8,9,10]

    for item in list {
        printFunction(item)
    }
}
//тук
func smartPrint2(list:[Int]) {
    //тук
    func printMeNested(_ i:Int) {

        //тук
        print("Print Nested *** \(i) ***")
    }

    for item in list {
        printMeNested(item)
    }
}



// smartPrint(printFunction:printMe)
// smartPrint(printFunction:printMeFancy)
//smartPrint2(list:[1,2,3,4,5,6,7,8,9,10])
//printMeNested(17)


// smartPrint(printFunction: { (a) -> () in
//     print(" *** \(a) ***")
// }

// smartPrint() {print(" *** \($0) ***")}


// func createGen(start: Int, modify: @escaping (Int) -> Int ) -> ()->(Int) {
    
//     var myStart = start
    
//     return {
//         myStart = modify(myStart)
//         return myStart
//     }
    
// }

// var next = createGen(start: 0) {
//     $0 + 2
// }

// print(next()) //2
// print(next()) //4
// print(next()) //6
// print(next()) //8


// var handlers:[()->Void] = []
// //трябва да добавим атрибута @escaping иначе няма да се компилира
// func escapingClosure(f: @escaping ()->Void) {
//     print("escapingClosure - start")
//     // handlers.append(f) 
//     f()
//     print("escapingClosure - end")
// }

// handlers.append {
//     print("test")
// }

// escapingClosure {
//     print("test 2")
// }

// //активираме всички функции
// for f in handlers {
//     f()
// }


// func someFunctionWithEscapingClosure(closure: @escaping () -> Void) {
//     closure()
// }

// func someFunctionWithNonescapingClosure(closure: () -> Void) {
//     closure()
// }

// class SomeClass {
//     var x = 10
//     func doSomething() {
//         someFunctionWithEscapingClosure { self.x = 100 }
//         someFunctionWithNonescapingClosure { x = 200 }
//     }
// }

// var someObject = SomeClass()
// someObject.doSomething()


func funcAutoclosure(pred: @autoclosure @escaping () -> Bool) {
    print("Begin")
    if pred() {
        print("It's true")
    } else {
        print("It's NОТ true")
    }
}

// funcAutoclosure(pred: 11 > 12) // It's NОТ true
// funcAutoclosure(pred: { () -> Bool in 
// print("Execute!")
// return 2 > 1
// }()
// )

//допълнителен пример
func funcAutoclosureComplex(pred: @autoclosure () -> ()) {
    print("body of \(#function)")
}


func funcAutoclosureComplexVoid(pred:()) {
    print("body of \(#function)")
}

// funcAutoclosureComplex(pred: print("the function is wrapped in a closure and it's never called."))

// funcAutoclosureComplexVoid(pred: print("the function print() is called"))
//Това е изходът от горния код:
//body of funcAutoclosureComplex(pred:)
//the function print() is called
//body of funcAutoclosureComplexVoid(pred:)
