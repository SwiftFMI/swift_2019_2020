## Второ задание за самостоятелна домашна работа

Решениятo на всяка задача ще трябва да качите в нашия портал на следния адрес - [http://swiftfmi.apposestudio.com/](http://swiftfmi.apposestudio.com/register)

Всеки __ТРЯБВА__ да се регистрира с факултетния си номер.

![Как се регистрираме?](assets/register.png)

За всяка задача, ще имате определена страница, където ще може да видите колко точки получавате.

![Как добавяме решение?](assets/task1.png)

Трябва да свалите шаблона и да попълните решението в него. Не оставяйте ненужни `print` извиквания във вашето решение. Системата няма да може да оцени некоректни решения и ще покаже съответната икона.

![Как добавяме решение?](assets/task1_template.png)

Ако имате някакви въпроси за системата, моля пишете на имейла за контакт.

Крайният срок за качване на решенията е _05.06.2020_!


## Задачи:

Дадени са следните протоколи (интерфейси):

`Visual`

```swift
    protocol Visual {
        var text: String { get }
        func render()
    }
```

`VisualComponent`

```swift

    protocol VisualComponent {
        //минимално покриващ правоъгълник
         var boundingBox: Rect { get }
         var parent: VisualComponent? { get }
        func draw()
    }
```
`VisualGroup`

```swift
    protocol VisualGroup: VisualComponent {
        //броят деца
         var numChildren: Int { get }
         //списък от всички деца
        var children: [VisualComponent] { get }
        //добавяне на дете
        func add(child: VisualComponent)
        //премахване на дете
        func remove(child: VisualComponent)
        //премахване на дете от съответния индекс - 0 базиран
        func removeChild(at: Int)
    }
```
и следните помощни структури

```swift    
    struct Point {
        var x: Double
        var y: Double
    }
    
    struct Rect {
        //top-left
        var top:Point
        var width: Double
        var height: Double
        
        init(x: Double, y: Double, width: Double, height: Double) {
            top = Point(x: x, y: y)
            self.width = width
            self.height = height
        }
    }
```
1. Да се имплементират следните класове (или структури, _по избор_):
    * `Triangle: VisualComponent, Visual `
        *     коструктор `Trinagle(a: Point, b: Point, c: Point)`
    * `Rectangle: VisualComponent, Visual `
        *     коструктор `Rectangle(x: Int, y: Int, width: Int, height: Int)`         
    * `Circle: VisualComponent, Visual `
        *  конструктор `Circle(x: Int, y:Int, r: Double)`
    *  `Path: VisualComponent, Visual `
        *  конструктор `Path(points: [Point])`
    * `HGroup: VisualGroup, Visual `
        *  конструктор `HGroup()`
    * `VGroup: VisaulGroup, Visual `
        *  конструктор `VGroup()`

2.  Да се напише функция, която намира най-малкия покриващ правоъгълник на `VisualComponent`.

        `func cover(root: VisualComponent?) -> Rect`
        
        Пример:
        
            Ако    
            root = 
                HGroup
                    VGroup
                        Circle (x:0, y:0, r:1)
            тогава
            cover(root: roоt) трябва да оцени до Rect(x: -1, y: 1, width: 2, height: 2)

3. Да се имплементира шаблонен свързан списък със съответния интерфейс. 
```swift 
    class List<T> {
        var value: T
        var next: List<T>?
        
        init(_ items: Any...) {
            //
        }
    }

    extension List {
        subscript(index: Int) -> T? {
        //TODO: implementation
        }
    }

    extension List {
        var length: Int {
        //TODO: implementation
        }
    }

    extension List {
        func reverse() {
        //TODO: implementation
        }
    }
```
4. Да се имплемнтира функция, която от списък от вложени списъци (може да решите задачата и за произволно ниво на влагане) генерира списък с всички елементи.

```swift 
        extension List {
            func flatten() -> List {
            //TODO: implementation
            }
        }
```
Пример:
```swift 
    List<Any>(List<Int>(2, 2), 21, List<Any>(3, List<Int>(5, 8))).flatten()

    List(2, 2, 21, 3, 5, 8)
```

## Въпроси за системата за автоматично оценяване

1. Защо нямам оценка?
     
     > Вероятно кода, който сте предали не е .swift файл или самият той не може да се компилира. Възможно е да крашва и при подбраните от нас входни данни.
     
     Как да се справя с проблема?
     
     >Моля, пишете ни, ако не успявате да се справите с проблема.
     
2. Трябва ли решението да отпечатва нещо?

    > Решението **не** трябва да отпечатва нищо в конзолата, защото няма да може да бъде обработено от системата за автоматично оценяване. 
    
3. Ако нямам оценка, това 0 точки ли означава?

    > **Не**. Когато системата не е успяла да Ви оцени, трябва да разгледаме решението Ви отделно.
    
4. Може ли да добавите примерен файл, който работи при качване в системата.
    
    > Да. В задачите има връзка към такъв.

5. Имам проблеми със ситемата, но не намирам логично обяснение. Какво да правя?
    
    > Пишете ни. Екипът работи над подобрение на текущата системата. 
    
6. А кой е e-mail-a?

    > Трябва да го знаете вече.

7. Не трява ли задачите да са по-ясно дефинирани и да имаме повече примери, с които да тестваме. Системата не ме оценява правилно, а аз съм сигурен, че решението ми е супер вярно. Какво да правя?

> Условията на задачите не са формални, за да позволят интерпретация. Ние смятаме, че свободата в интерпретацията ви подготвя по-добре за реалните задачи след този курс. Не получавате оценкта в системата, защото пропускате случаи от решението (често това са край случаи, но валидни) или защото сте намерили проблем в системата (по-малко вероятно, но възможно). Моля, свържете се с нас, за да ви помогнем с насоки. 
