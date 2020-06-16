# Swift Package Manager (SPM)

## Property wrappers - Обвивки

Когато използваме пропъртита, които представляват състояние, много често имаме асоциирана логика, която се изпълнява всеки път при промяна в стойността им. 

Например, бихме могли да валидираме всяка нова стойност на базата на правила, да я трансформираме по някакъв начин или да нотифицираме наблюдатели, които следят за промяна в стойността.

В тези ситуации на помощ идват Обвивките (Property wrappers), въведени със Swift 5.1. Позволяват ни да прикрепим и енкапсулираме тази логика директно към нашите пропъртита, което от своя страна означава нови възможности за преизползваемост и енкапсулация.

Името подсказва, че това е тип, който обвива дадена стойност, добавяйки допълнителна логика. Може да се имплементира, използвайки структура (`struct`) или клас (`class`), които са анотирани с @propertyWrapper атрибута. Единственото изискване е всяка обвивка да има променлива/пропърти на име `wrappedValue`, което подсказва на Swift коя и каква стойност бива обвита/обгърната.

### Трансформация на стойности чрез обвивки
```swift
@propertyWrapper
struct Truncated {
    var value: Double
    let precision: Int

    init(wrappedValue value: Double, _ precision: Int) {
        self.value = value
        self.precision = precision
    }

    var wrappedValue: Double {
        get { value }
        set { value = truncated(newValue) }
    }
    
    private func truncated(_ value: Double) -> Double {
        guard precision > 0, precision < 16 else { return value }
        let divisor = pow(10.0, Double(precision))
        return (value * divisor).rounded(.towardZero) / divisor
    }
}

@propertyWrapper
struct Rounded {
    var value: Double
    let precision: Int

    init(wrappedValue value: Double, _ precision: Int) {
        self.value = value
        self.precision = precision
    }

    var wrappedValue: Double {
        get { value }
        set { value = truncated(newValue) }
    }
    
    private func rounded(_ value: Double) -> Double {
        guard precision > 0, precision < 16 else { return value }
        let divisor = pow(10.0, Double(precision))
        return (value * divisor).rounded() / divisor
    }
}
```

### Ограничаване на стойности чрез Обвивки
```swift
@propertyWrapper
struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>

    init(initialValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}
```
Може да използваме `@Clamping`, за да гарантираме стойността на променлива, която представлява киселинност на разтвор в диапазона 0 – 14.

```swift
struct Solution {
    @Clamping(0...14) var pH: Double = 7.0
}

let carbonicAcid = Solution(pH: 4.68) // 1 mM в нормални условия
При стойности под 0 и над 14, стойността се променя

let ultraAcid = Solution(pH: -1)
ultraAcid.pH // 0
```

Може да използваме ги използваме, за да създаваме други Обвивки. Например `UnitInterval` използва `@Clamping`, за да ограничи стойностите между 0 и 1 (включително).
```swift
@propertyWrapper
struct UnitInterval<Value: FloatingPoint> {
    @Clamping(0...1)
    var wrappedValue: Value = .zero

    init(initialValue value: Value) {
        self.wrappedValue = value
    }
}
```

Бихме могли да го използваме при създаване на RGB цветове, използвайки @UnitInterval Обвивката, за да ограничим интензитета на червено, зелено и сньо в проценти.

```swift
struct RGB {
    @UnitInterval var red: Double
    @UnitInterval var green: Double
    @UnitInterval var blue: Double
}

let cornflowerBlue = RGB(red: 0.392, green: 0.584, blue: 0.929) //#6495ed - 39.0/255, 58.0/255, 93.0/255
```

## Modules - Модули
В Swift кодът се организира в модули. Всеки модул дефинира именно пространсто (namespace) и налага контрол на достъпа до всяка една част от кода извън модула.

Една програма може да се състои само от един модул, но и може да внася/използва и други модули като зависимости. Освен системните модули Darwin в macOS или Glibc в Linux, повечето зависимости изискват свалянето на код и компилирането му, за да се използват.

При отделянето на код, решаващ определен проблем в модул, той става преизползваем. Например модул, който предоставя функционалност за достъпване на интернет ресурси, който да се ползна едновременно в приложение за прогнозата за времето или приложение за споделяне на снимки. Използвайки модули от други програмисти, можем да спестим време и ресурси, вместо да имплементираме функционалността сами.

### Packages - Пакети
Пакетите в Swift са сбор от сорс-код файлове и манифест файл. Манифестът, наречен Package.swift, дефинира името на пакета, неговото съдържание и зависимости чрез модула PackageDescription.

Един пакет има една или повече програми/цели (targets), като всяка описва продукт и може да дефинира една или повече зависимости.

### Products - Продукти
От една програма/цел (target) продуктът може да е библиотека или изпълнимо приложение. Библиотеката съдърга модул, който може да бъде влагам в друг Swift код, а изпълнимото приложение да се изпълнява от операционната система.

### Dependencies - Зависимости
Зависимостите са модули, необходими за компилирането на кода в пакета. Зависимостта се съсоти от релативни или абсолютни пътища и URL-и към сорс-кода на пакета и набор от изисквания за версията му. Полята на мениджъра на пакети е да намали усилията, необходими за координирането на зависимостите чрез автоматизирано сваляне и компилиране на зависимостите в даден проект. Този процес е рекурсивен - една зависимост, сама по себе си, може да има други зависимости и т.н., оформяйки граф на зависимостите. Мениджърът на пакети сваля и компилира всичко необходимо, за да изпълни този граф.

### Какво е манифест на пакет?

Това е файл, който описва пакета. Посредством този пакет, SPM може да намери всички необходими външни зависимости и да компилира успешно текущия модул. Това позволява създаването на сложни пакети и модули в тях, които използват множество външни пакети.

## Какви видове модули можем да правим със SPM?

Чрез `package` командата можем да видим различните видове пакети (които имат поне един модул), които можем да създаваме със `SPM`.

```shell
    swift package init --help

    Резулта:
    OVERVIEW: Initialize a new package

OPTIONS:
  --name   Provide custom package name
  --type   empty|library|executable|system-module|manifest
```

Ще разгледаме няколко от основните типове - библиотека, изпълним файл, празен пакет и техните основни характеристики.

### Пакет библиотека

Това е пакет на Swift, който можем да използваме в други проекти. Този пакет има поне един модул, който може да дефинира различни типове от данни, функции и дори и по-сложен набор от интерфейси, класове, типове, т.е. Framework за разработка на софтуер. 

Можем да създадем пакет от тип библиотека със следната команда:

> Не забравяйте да направите нова директория за съответния `swift` модул. Когато сте в тази директория, спокойно може да използвате следващите команди.
>```shell
>mkdir myLibrary
>cd myLibrary
>```

```shell
swift package init --name MySwiftLibrary --type library
```

Тази команда генерира следната структура от файлове и директории:

```
.
├── Package.swift   - основен описател на пакета
├── README.md       - файл, където можем да опишем проекта. 
│                     Доста полезен, когато публикуваме проекта в github 
├── Sources         - тук се съхраняват всички модули  
│   └── MySwiftLibrary - директория с кода, 
│       │                   който ще е част от съответния модул и пакет
│       └── MySwiftLibrary.swift - примерен файл
└── Tests           - тук се съдържат тестовете към пакета. Те са в друг модул.
    ├── LinuxMain.swift - стартов файл, нужен за стартиране на тестовете под Linux.
    └── MySwiftLibraryTests
        ├── MySwiftLibraryTests.swift   - Тестове за Linux
        └── XCTestManifests.swift       - Тестове за macOS

```

Ето и съдържанието на `Package.swift` - така нарченият манифест или описател на нашия пакет.

```swift
// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MySwiftLibrary",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MySwiftLibrary",
            targets: ["MySwiftLibrary"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MySwiftLibrary",
            dependencies: []),
        .testTarget(
            name: "MySwiftLibraryTests",
            dependencies: ["MySwiftLibrary"]),
    ]
)
```

Файлът започва с коментар, който определя версията на компилатора използван за създаването на пакета. Често, това е минималната версия, необходима за да може да се компилира успешно съответния модул. 

```swift
// swift-tools-version:5.2
```
В текущия случай е използвана версия 5.2.1 на `swift`. Следва стандартния импорт:
`import PackageDescription` и после се създава константен `package`.

Тя е от тип `Package`. Има си име `name`, коeто съвпада с избраното от нас по-рано - `MySwiftLibrary`. Има и следните три ключови елемента:

1. `products` - списък на продуктите - резултата, който ще се генерира след успешно компилиране на текущия пакет. В текущия случай това е библиотека, която може да се използва в други продукти или модули.
1. `dependencies` - списък на външните зависимости, които SPM трябва да изтегли, компилира и свърже с текущия пакет. Използва се кратка нотация за всяка зависимост с адрес (публичен или локален - от файловата система) и версия:
    ```swift
    .package(name: /*package-name*/, url: /* package url */, from: "1.0.0")
    ```
    > Не забравяйте, че можете да създавате локални пакети и да ги свързвате по между си. Тогава трябва да иползвате адрес, който е валиден път във вашата файлова система.

1. `targets` - списък от таргети (продукти/ модули). Таргетите изграждат пакетите. Това са добре познатите ни модули. Можем да описваме и модули за тестове.
Ето и текущия пример:

    ```swift
    .target(
        name: "MySwiftLibrary",
        dependencies: []),
    ```
    Продуктът си има име, което съвпада с името на пакета (и директорията, където трябва да се съхранява кода на модула). Има и списък от имената на вънщни зависимости. Т.е. тук можем да добавим имената на външни зависимости, които сме добавил в предишната секция `dependencies`.

Със следната команда можем да компилираме пакета:

```
swift build
```

За да публикуваме този пакет дори и локално, трябва да използваме git. Със следните команди, можем да създадем локално репозитори:

```shell
git init
git add .
git commit -m "initial commit"
git tag 1.0.0
```

`git init` - създава локално репозитори
`git add .` - добавя всички файлове към repo-то. Тук се проверява, дали няма специални правила в `.gitignore` файла. Там са описани изключенията. Повече може да се прочете [тук](https://git-scm.com/docs/gitignore)
`git commit -m "initial commit"` - съхраняване на добавените файлове в git
`git tag 1.0.0` - публикуване на текущата версия на репото, като tag с име `1.0.0`. Важно е да имаме правилно именуван таг, защото SPM използва таговете, за да може да тегли правилната версия на всеки пакет при подготвяне на зависимостите.

> Не забравяйте да маркирате всички типове данни (класове, структури, изброени типове, функции) с правилните нива на видимост. В случая, когато искате те да са достъпни в други пакети, тогава трябва да ползвате `public` или `open`. Повече за тях по-късно или може да прочете повече [тук](https://docs.swift.org/swift-book/LanguageGuide/AccessControl.html).


### Изпълним пакет (конзолно приложение)?

Това е модул, който позволява стартиране на модула от конзолата (терминала) на операционната система. Възможна е комуникация с операционната система чрез модулът отговорен за конзолните приложения. 
Отличава се с наличието на `main.swift`. Това е началната (входната) точка на този модул. След успешно компилиране, резултатът е изпълним файл, който може да бъде стартиран на съответната операционна система (Linux, macOS и дори Windows).

Ето как можем да създадем такъв модул:

> Трябва да сме сигурни, че можем да стартираме `swift package` в Ubuntu shell-a. Ако имаме проблеми или затруднения, може да разгледате допълнителния материал, който дава наюални насоки, как да инсталирате Swift toolchain на Windows използвайки Ubuntu shell. - [тук](https://github.com/SwiftFMI/swift_2019_2020/blob/master/How_to_install_Swift5_on_Windows10.md).

> Преди да изпълните следващите команди, трябва да сте добавили `swift` компилатора в `PATH` променливата на оперционната система или да знаете пълния път до компилатора.

> Не забравяйте да направите нова директория за съответния `swift` модул. Когато сте в тази директория, спокойно може да използвате следващите команди.
>```shell
>mkdir myApp
>cd myApp
>```

```shell
swift package init --name MySwiftApp --type executable
```

Тази команда генерира следната структура от файлове и директории:

```
.
├── Package.swift
├── README.md
├── Sources
│   └── MySwiftApp
│       └── main.swift - входна точка на изпълнимия модул
└── Tests
    ├── LinuxMain.swift
    └── MySwiftAppTests
        ├── MySwiftAppTests.swift
        └── XCTestManifests.swift
```

### Как да свържем двата пакета, които създадохме?

Първо нека да редактираме `MySwiftLibrary`. Отваряме файла `myLibrary/Sources/MySwiftLibrary/MySwiftLibrary.swift`.

Редактираме го както следва:

```swift
public struct MySwiftLibrary {
   ///
   /// Public constructor
   /// 
   public init(text: String = "") {
       self.text = text
   }
   
   /// Make this property public accessible
   public var text = "Hello, World!"

   public let version = "alpha-1"
}
```

След това трябва да се добавят новите промени в git-a и да се създаде нов таг. Не забравяйте, че това е правилния начин за публикуване на нова версия, на пакета, която да може да се ползва от SPM.

> Не е нужно да компилирате библиотеката, но е добре да знаете, че може да се компилира успешно и че работи правилно.

Ето ги и нужните команди:
```shell
git add .
git commit -m "extend the library"
git tag 1.0.2
```
На кратко - добавяне на новите промени. Публикуването им в локалното git repository и създаване на таг с име 1.0.2.

Сега се прехвърляме в изпълнимия проект `MySwiftApp`. Тук отваряме манифеста `Package.swift` и го променяме както следва:

```swift
// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MySwiftApp",
    dependencies: [
        // свързване с библиотеката, която създадохме по-рано
        //! не забравяйте да коригирате пътя - url параметъра. Той зависи
        // от това къде сте създали съответно двата пакета на swift
        // в примера myLibrary и myApp се намират в обща директория
        //.
        //├── myApp
        //└── myLibrary
        .package(name: "MySwiftLibrary", url: "../myLibrary", from: "1.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MySwiftApp",
            //тук добавяме името на външния пакет
            dependencies: ["MySwiftLibrary"]),
        .testTarget(
            name: "MySwiftAppTests",
            dependencies: ["MySwiftApp"]),
    ]
)
```

После отваряме `myApp/Sources/MySwiftApp/main.swift` и го редактираме както следва:

```swift
import MySwiftLibrary

let lib = MySwiftLibrary(text: "Hello from the library")

print(lib.text)

print(lib.version)

```

Запазваме промените и извикваме следната команда за стартиране на изпълнимия проект:

```shell
swift run
```

SPM ще намери нашата библиотека. Ще потърси правилната версия, която е `1.0.2`. Това го обявихме още, когато редактирахме `Package.swift`. Ще свали кода й и ще я компилира. После ще се опита да компилира и текущия модул (target). След успешна компилация, ще опита да го стартира. 

Трябва да видите следния резултат на вашите екрани:

```
[7/7] Linking MySwiftApp
Hello from the library
alpha-1
```

Първият ред не е част от нашата програма, а е остатъчен резултат от изпълнените действия от SPM и Swift компилатора.

> Къде можем да намерим изпълнимия файл? Понеже сме използвали swift да създаде debug версия (и ако изпозлваме Linux (shell)), тогава можем да намерим самото конзолно приложение на следното място `.build/x86_64-unknown-linux-gnu/debug/MySwiftApp`.

> Със следната команда можем да създадем `release` версия:
```
swift build -c release
```
> И съответно приложението ще можем да намери тук `.build/release/MySwiftApp` и да го стартираме. Очаквано резултатът е същия.

> Кратко резюме: До тук се научихме как да създаваме библиотека чрез `SPM`. Можем спокойно да добавяме различни класове, структури, функции, и други типове данни към нея и да публикуваме версии локално чрез `git`. (По-долу може да прочетете как да публикувате ваша библиотека написан на `swift` в `github`.) Също така, можем да създадем изпълнимо приложение, което да ползва външни пакети, публикувани локално на нашата файлова система или в публичното пространство (еднствената разлика е в `url`-a на пакета).

### Празен пакет 

Това е най-базовия модул. Той може да бъде използван и разширен в посока на вече познатите ни модули - библиотека или изпълним. 

Той има следната структура:

```
.
├── Package.swift
├── README.md
├── Sources
└── Tests
```

Като няма допълнителни файлове. Също така липсват и основните елементи в `Package.swift` файла. Следва пример:

```swift
// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MySwiftEmptyPackage",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ]
)
```

## Как да публикуваме Swift пакет от локално git репо в github?

Предполагаме, че вече имате github акаунт. Тогава трябва да създаде публично или частно repo от интерфейса на github.

След това трябва да изпълните следните няколко git команди в основната директория на вашия пакет. Нека да приемем, че искаме да публикуваме `MySwiftLibrary` и всички версии.

> Не забравяйте да промените пътя до вашето repo в следващите команди. Ако не го направите, ще видите съобщение за грешка от git.

> Ако имате активиран 2FA (Two Factor Authentication - дву-факторна аутентикация) трябва да използвате или токен вместо вашата парола или частен ключ, за да може да къмитвате файлове в [github](https://help.github.com/en/github/authenticating-to-github/accessing-github-using-two-factor-authentication).

```
git remote add origin https://github.com/swiftfmi/MySwiftLibrary.git
git push -u origin master
git push origin --tags
```
Ако искате само определена версия, може да използвате следната команда.
```
git push origin 1.0.2
```

## Какви команди можем да използваме?

### Swift 

```
swift --help
```

```
swift run
```


```
swift build
```

### SPM

```
swift package
```

TBD (Кратък списък на командите)
### Git

```
git -h
```

```
git init
```

```
git add file/to/be/added
```

```
git commit -m "message"
```

```
git push 
```
> Само, ако има `origin` - външно репо, с което да се синхронизира.

## Как да си организираме проекта?

Тук е добре да следваме следната добра практика. Приложението, което трябва да комуникира с операционната система, трябва да е минимално. Т.е. трябва всичко да е в различни модули и дори пакети, а изпълнимото приложение (модул) да използва другите модули като зависимости. Това ще позволи - по-високо ново на преизползване на кода. По-добра структура, която позволява минимално "триене" със спецификите на OS-a. Тези специфики, остават изолирани само в модула, който комуникира с OS-a.

## Нива на видимост на кода (повторение)

Тук е добре да си припомним петте нива на видимост, които има Swift и да направим ясно разграничение, кога е добре да ползваме `open` и `public`. Няма да задълбаваме в нивата с по-малко ниво на видимост от `internal` понеже те нямат отношение към външните модули.

Какво ни дава `public` - Видимост на типове и функции от други модули и приложения (същината на модула - API, който да се използва)
Какво ни дава `open` - Възможност за наследяване и разширяване на класовете от модула.
