# How to install Swift 5 on Windows?

1. Install Ubuntu shell. More info can be found [here](https://ubuntu.com/tutorials/tutorial-ubuntu-on-windows#1-overview).
2. Check which version of Ubuntu is running:
    * Open Ubuntu terminal and execute

        ```lsb_release -a```
3. Download the correct version of Swift. Use the following command.
    >If you don't have `wget` you can install it with the following commnad `sudo apt-get install wget`.

    ```wget https://swift.org/builds/swift-5.1.4-release/ubuntu1804/swift-5.1.4-RELEASE/swift-5.1.4-RELEASE-ubuntu18.04.tar.gz```
    > This link should be updated once a more recent version is released.

4. You have to extract the archive.

    ```tar -xvzf swift-5.1.4-RELEASE-ubuntu18.04.tar.gz ```
    
5. You can rename the folder, so it can be easily accessed to `swift-5.1` for example
    
    ```mv swift-5.1.4-RELEASE-ubuntu18.04 swift-5.1```

At this point you will have `swift` installed on your Windows in your `Ubuntu` shell. To run it
you have to use the full path to `swift` binary, which probably will be:
```~/swift-5.1/usr/bin/swift```

> For best results, you can try to merge the content of `swift-5.1` directory with the files in `/usr`.

    sudo cp -r ~/swift-5.1/usr /

> If you do that, please use the correct `full` path in the next section, which should be `/usr/bin/sourcekit-lsp` and `/usr/bin`.

# How to use VSCode to write and run easily swift?

1. You have to install VSCode from [here](https://code.visualstudio.com)
2. Open the `Ubuntu` shell and write

        code hello.swift

    __This will start `VSCode` in special mode called `WSL: Ubuntu`. You should install all extensions in that very mode!__ If the extensions are not installed in that mode, they can't be used from your `Ubuntu` shell.
3. This will open VSCode in special mode (WSL: Ubuntu) so it knows it has been started from the `Ubuntu` shell.
4. Install the following plugins:
    * ```SourceKit-LSP Visual Studio Code``` and configure it with correct values (my user is called `emil`, yours is probably something else):
    
    __In both options you need to add the full path.__
        
        Server Path: /home/emil/swift-5.1/usr/bin/sourcekit-lsp
        Toolchain Path: /home/emil/swift-5.1/usr/bin

    [more info](https://github.com/apple/sourcekit-lsp/tree/master/Editors)
    
    
    * ```Code Runner``` and configure it with the following value in Execcutor Map By File Extension if you have installed swift toolchain in your home directory. (`code-runner.executorMapByFileExtension`).

            "code-runner.executorMap": {
                "swift": "/home/emil/swift-5.1/usr/bin/swift",
            }
    > Don't forget to update the full path to `swift` binary.

    You can use ```Ctrl + Alt + N``` to `Run` a file with `.swift` extension. 

## FAQ

When I try to run `swift` compiler I see some strange errors:

1. For example: 

    
        /home/geoeg/swift-5.1/usr/bin/swift: error while loading shared libraries: libatomic.so.1: cannot open shared object file: No such file or directory

    This ususally means that some libraries are not installed in your Ubuntu distribution (shell). You have to figure out which are the missing packages. Google can be your friend. In the example above you have to search for: `error while loading shared libraries: libatomic.so.1: cannot open shared object file: No such file or directory` and look for a solution that works. Here is one that works. (This will isntall libatomic1 package on your computer.)

        sudo apt-get update
        sudo apt-get install libatomic1

    Another similar problem:

        /home/ivanln/swift5.1/usr/bin/swift: error while loading shared libraries: libtinfo.so.5: cannot open shared object file: No such  file or directory
    
    Again - the best advice is to search for solution. One that might work from the results returned by Google:

        sudo ln -s /usr/lib/libtinfo.so /usr/lib/libtinfo.so.5