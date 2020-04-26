//print("Hello Generics!")

// func sum(_ a:Int, _ b: Int) -> Int {
//     return a + b
// }

// func sum(_ a:String, _ b: String) -> String {
//     return a + b
// }

protocol Sumable {
    static func + (left: Self, right:Self) -> Self
}

func sum<T:Sumable>(_ a:T, _ b: T) -> T {
    let h: T
    h = a + b
    return h
}

extension String: Sumable {
}
extension Int: Sumable {
}

struct Vector1D {
    var x = 10
}

extension Vector1D: Sumable {
    static func + (left: Vector1D, right:Vector1D) -> Vector1D {
        return Vector1D(x: left.x + right.x)
    }
}

let vX = Vector1D()
let vY = Vector1D(x: 10)
let sumV = sum(vX, vY)

print("Sum (Int): \(sum(5, 5))")
print("Sum (String): \(sum("5", "5"))")
print("Sum (Vector1D): \(sumV.x)")


protocol CollectionEquatable {
    associatedtype Element
    var count:Int { get }
    subscript (i:Int) -> Element {get}
}

extension Array : CollectionEquatable {}

class Queue<Item>:CollectionEquatable {
    var items:[Item] // Array<Item> == [Item]
    private var _count: Int
    
    init() {
        items = []
        _count = 0
    }
    
    func insert(item:Item) {
       items.append(item)
       _count += 1
    }
    
    func get() -> Item? {
        if items.count > 0 {
            _count -= 1
            return items.removeFirst()
        }
        
        return nil
    }
    
    subscript (i:Int) -> Item {
        return items[i]
    }
    
    var count:Int {
        // return items.count
        return _count
    }
}

// Да напишем шаблонна функция, която сравнява две колекции, които могат да бъдат сравнявани по следните правила:

// OK: Двете колекции трябва да имплментират протокола CollectionEquatable
// OK: Да имат еднакъв брой елементи
// Всеки елемент да е еднакъв на съответния елемент от другата колекция

func isEqual<T: CollectionEquatable, U:CollectionEquatable>(first: U, second: T) -> Bool where T.Element == U.Element, T.Element:Equatable {
    if first.count == second.count {
        let c = first.count
        for i in 1..<c {
            if first[i] != second[i] {
                return false
            }
        }

        return true
    }

    return false
}

var arr = [1, 2, 3, 4]
var queue = Queue<Int>()
queue.insert(item: 1)
queue.insert(item: 2)
queue.insert(item: 3)


print(isEqual(first: arr, second: queue))


var queueStrings = Queue<String>()
queueStrings.insert(item: "1")
queueStrings.insert(item: "2")
queueStrings.insert(item: "3")
// не е възможно да се изпълни, защото сравянваме Int със String
// print(isEqual(first: arr, second: queueStrings))
