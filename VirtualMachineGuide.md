# Setup macOS Catalina virtual machine

- check below for english version

Инсталацията на виртуалната машина е тествана на компютър със следните характеристики:  Windows 10 Home 64x, i5-7200U CPU 2,50GHz, 8GB RAM, 128GB SSD. Резултатът от инсталацията ще намерите [тук](https://drive.google.com/file/d/12JDjs8VFLUkUQuuCMhSs5BBLbrPr2HsD/view?usp=sharing). Преди да започнете с инсталирането на виртуалната машина бъдете сигурни, че имате достатъчно свободно място на вашния компютър. Подсигурете се поне със свободни 45-50 GB.

### Инсталация

За да инсталирате Catalina macOS следвайте стъпките описани в тази [статия](https://www.intoguide.com/how-to-install-macos-catalina-on-vmware-on-windows-10-on-pc/). В нея е обяснено дейтайлно, как и какво да извъшите, за да инсталирате функционираща виртуална машина. Линк за сваляне на инсталационния файл на операционната система ще намерите също в статията. Следният списък съдържа решения на проблеми, които могат да възникнат по време или след инсталирането на виртуалната машина:
* Ако при опциите за избор на операционна система не варира macOS, то ще ви е нужен unlocker, който може да откриете на следния [линк](https://github.com/paolo-projects/unlocker).
* Ако след инсталацията и стартиране на виртуалната машина нямате активна интернет връзка, гледайте следното [видео](https://www.youtube.com/watch?v=H2j3nyl4muQ ) с решение на този проблем.
* За да инсталирате Xcode, след като вече разполагате с фунцкионираща Catalina и интернет връзка, ще ви е нужен инсталационният файл на програмата. Той може да бъде свален от Apple App Store, но скоростта на сваляне през виртуалната машина е изключително ниска, затова може да свалите файла от [тук](https://developer.apple.com/download/more/). За това ще ви е нужна регистрация с Apple ID. Възможен начин за трансфериране на файла на виртуалната машина е преносима памет (usb stick), на който да го копирате. След като извадите и отново поставите стика в компютъра ви, трябва да изберете опция за прочитането му от предварително стартираната виртуална машина. Стартирайте файла и изчакайте инсталацията да достигне до своя край.
* Възможно е картината на вашата виртуална машина да бъде с квадратна резолюция. За да се насладите на широкоекранна картина прочетете следния [пост](https://www.geekrar.com/how-to-fix-macos-catalina-screen-resolution-on-vmware/) с възможно решение на този проблем. 

Ако по време на инсталацията срешнете проблеми, които не са описани в тази статия, винаги може да потърсите в google. Със сигурност някой преди вас вече е срещнал този проблем, описал го е подобаващо и е получил възможни 2-3 решения.

Приятно кодене на виртуалния ви mac! :)

### Installation

The setup has beed tested at a computer with the following setup: Windows 10 Home 64x, i5-7200U CPU 2,50GHz, 8GB RAM, 128GB SSD. This is the [result](https://drive.google.com/file/d/12JDjs8VFLUkUQuuCMhSs5BBLbrPr2HsD/view?usp=sharing). Please be sure before begin the installation to have enought free space on your pc. You may need around 45-50 GB free space for a proper working macOS virtual machine.

To install Catalina macOS follow this [guide](https://www.intoguide.com/how-to-install-macos-catalina-on-vmware-on-windows-10-on-pc/). It explains in detail what and how to do to setup a proper virtual machine. Download link for the 'Catalina OS' can be found also there. During or after the installation you may face some problems. The following list represents some useful links you may need to fix those:
* The unlocker may be needed if "macOS" is not shown in the list of OS you have to chose from during the setup of the virtual machine. For the installation of the unlocker check this [link](https://github.com/paolo-projects/unlocker).
* If there is any problem with the internet connection on the virtual machine check the following  [video](https://www.youtube.com/watch?v=H2j3nyl4muQ ) with possible solution.
* To install Xcode after you already have the virtual machine and its internet connection fixed you have to download it from the Apple App Store. The download speed on the virtual machine is very, very slow so you can download it on your windows machine and transfer it. You can find the DMGs or XIPs for Xcode and other development tools [here](https://developer.apple.com/download/more/) (requires Apple ID to login). You must login to have a valid session before downloading anything below. A way to transfer the Xcode installation file is to copy the file on usb stick. Then start the virtual machine and put back the stick and choose the option to read it on the virtual machine. Then just install Xcode.
* Normally the screen has a square resolution and shows black bars on left and write (if you use wide-screen). To fix that  check this [post](https://www.geekrar.com/how-to-fix-macos-catalina-screen-resolution-on-vmware/) with possible solution of the problem.
 
If during the installation you face some problems that were not mentioned in this post, feel free to google the errors. You will definetely find someone that already faced the same problem and someone who gave them a possible solution.

Enjoy coding on your new virtual mac! :) 
