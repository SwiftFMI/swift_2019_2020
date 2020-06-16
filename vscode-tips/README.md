# VSCode Tips

Ето един кратък съвет, как да можете да стартирате по-лесно проектите си от VSCode.

1. Трябва да добавите нова задача Task. Това става от менюто ``
`Terminal` -> `Configure Tasks...`

След това трябва да промените съдържанието като добавите нов `Task`. Следва пример как да направите това. Задачата се казва `Swift Run`. Съществената част е стойността на ключа `command`.

```json
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Swift Run",
            "type": "shell",
            "command": "/swift/swift-5.2.1/usr/bin/swift run",
            "problemMatcher": [],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
```
> Не забравяйте да промените пътя до `swift` в зависимост къде се намира на файловата система.

След като добавите тази конфигурация, ще може да стартирате `Ctrl + Shift + B`, което ще стартира текущия ви проект (тук има значение от коя папка сте стртирали VSCode или коя папка сте отвори като основна) във нов терминал вътре във VSCode.