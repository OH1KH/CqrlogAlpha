#!/bin/bash
mydate=$(date +"-"%Y%m%d"-"%H%M%S)
help="Y"
clear
#-----------
function MyOut (){
      echo -e $1
      echo -e $1 >> /tmp/newupdate.txt 
 }
 
#-----------
function FindCmd (){
if  command -v $1 &> /dev/null
 then 
    MyOut "Found command: $1   OK!"
 else 
    MyOut "Command $1 is needed!"
    MyOut "Please install it from your linux package manager."
    MyOut "Then try again."
    exit
fi
}
function ManualUpdate(){
MyOut "You have to upgrade manually!"
MyOut "\n\nManual update is rather easy. See the README.md file."
MyOut "\nBasics:"
MyOut "Find the cqrlog executive FILE. Normally it exisit in /usr/bin folder"
MyOut "but it may be elsewhere, Use command : whereis -b cqrlog"
MyOut "When found download one of cqrX.zips (that fits your needs), extract it"
MyOut "and replace fund cqrlog file with one from zip."
MyOut "\n\nUpdating help: Find FOLDER cqrlog. Usually it is in /usr/share folder"
MyOut "When found change to that directory. Then give command:"
MyOut "sudo rm help; sudo tar xf /tmp/help.tgz"
MyOut "\n\nDone!"
MyOut "\nHow ever note that you have to make manual backups first before doing all this.\n"
}
#-----------




MyOut "==================================================="
MyOut " "
MyOut "THANK YOU for reading first the 'compiled' page's README"
MyOut " "
MyOut "==================================================="
MyOut "Press ENTER to continue, Ctrl+C to stop... "
read input
clear
MyOut "==================================================="
MyOut "This command will update your existing and working Cqrlog."
MyOut "It can not install Cqrlog to PC where it does not exist."
MyOut "For that use your packet manager."
MyOut "After that you can run again this update."
MyOut "==================================================="
MyOut "Looking for installed cqrlog."

if [ -r /usr/bin/cqrlog ] ;then
        MyOut "Found file \x2Fusr\x2Fbin\x2Fcqrlog   OK!";
  else
        MyOut "File \x2Fusr\x2Fbin\x2Fcqrlog Not Found !"
        MyOut "If you have working cqrlog it is installed to unknown location!"
        MyOut "Or file may be deleted by previous failed install script."
        ManualUpdate
        exit
fi
if [ -d /usr/share/cqrlog/help ] ;then
        MyOut "Found folder \x2Fusr\x2Fshare\x2Fcqrlog   OK!";
  else
        MyOut "Folder \x2Fusr\x2Fshare\x2Fcqrlog Not Found !"
        MyOut "If you have working cqrlog it is installed to unknown location!"
        MyOut "Or file may be deleted by previous failed install script."
        ManualUpdate
        exit
fi
MyOut "==================================================="
FindCmd "wget"
FindCmd "unzip"
FindCmd "sudo"
MyOut "==================================================="
arc=$((hostnamectl | grep Arc | tr -d " ") 2>&1)
cd /tmp
rm -f cqr*.zip
rm -f help.tgz
MyOut "Cleanup for old downloads in /tmp directory"
MyOut "==================================================="
MyOut "Your linux "$arc
MyOut "==================================================="
MyOut "\n\n\n"
MyOut "!!!! Please expand your command terminal window to full !!!!"
MyOut "!!!! size screen now for better view of update progress !!!!\n\n\n"
MyOut "Press ENTER to continue, Ctrl+C to stop... "
read input
clear

wget --quiet -O /tmp/README.md https://github.com/OH1KH/CqrlogAlpha/raw/refs/heads/main/README.md
if [ $? -ne 0 ]; then
    MyOut "\n\nFailed to download https://github.com/OH1KH/CqrlogAlpha/raw/refs/heads/main/README.md"
    MyOut "\nCheck your internet connection!\n"
    exit
fi
head -n23 /tmp/README.md
MyOut "\n\nPress ENTER to continue, Ctrl+C to stop... "
read input
clear
MyOut "Select Cqrlog version you want to use for update:\n"
MyOut "==================================================="
#MyOut "----------Official versions----------"
#MyOut "1) 64bit Official version Cqrlog for x86_64 with Gtk2 widgets"
#MyOut "\x20\x20(compiled with Mint20 from latest official source )\n"
#MyOut "2) 32bit Official version Cqrlog for x86_64 with Gtk2 widgets"
#MyOut "\x20\x20(compiled with Ubuntu 18.04.5 LTS from latest official source )\n"
#MyOut "3) Arm Official version Cqrlog for Raspberry Pi with Gtk2 widgets"
#MyOut "\x20\x20(compiled with Rpi4b from latest official source )\n"
MyOut "---------Alpha versions:---------"
MyOut "1) 64bit Alpha version Cqrlog for x86_64 with Gtk2 widgets"
MyOut "\x20\x20(this is the most commonly used Alpha test version )\n"
MyOut "2) 64bit Alpha version Cqrlog for x86_64 with QT5 widgets"
MyOut "\x20\x20(you need libqt5pas installed to run this Alpha test version)\n"
MyOut "3) 64bit Alpha version Cqrlog for x86_64 with QT6 widgets"
MyOut "\x20\x20(you need libqt6pas installed to run this Alpha test version)\n"
MyOut "4) 32bit Alpha Cqrlog for x86 with Gtk2 widgets"
MyOut "\x20\x20(Alpha test version for old PCs )\n"
MyOut "5) 64bit Alpha Cqrlog for Arm  with Gtk2 widgets"
MyOut "\x20\x20(64bit RaspberryPi bookworm )\n"

MyOut "==================================================="
MyOut "\x20\x20\x20Make your selection:"
options=(
#"64bit Official Gtk2"
#"32bit Official Gtk2"
#"Arm Official Gtk2"
#
#
"64bit Alpha Gtk2 version"
"64bit Alpha QT5 version"
"64bit Alpha QT6 version"
"32bit Alpha Gtk2 version"
"64bit Arm Alpha version"
"Quit now without update"
)
select opt in "${options[@]}"
do
    case $opt in
#        "64bit Official Gtk2")
#            cqr=0
#            break
#            ;;
#        "32bit Official Gtk2")
#            cqr=1
#            break
#            ;;
#        "Arm Official Gtk2")
#            cqr=4
#            break
#            ;;
#
            
        "64bit Alpha Gtk2 version")
            cqr=2
            break
            ;;
	"64bit Alpha QT5 version")
            cqr=5
            break
            ;;
	"64bit Alpha QT6 version")
            cqr=6
            break
            ;;
	"32bit Alpha Gtk2 version")
            cqr=3
            break
            ;;
	"64bit Arm Alpha version")
            cqr=4
            break
            ;;
	"Quit now without update")
            exit
            break
            ;;
        *) echo "invalid option $REPLY";;
    
    esac
done


wget -q  https://github.com/OH1KH/CqrlogAlpha/raw/compiled/cqr$cqr.zip
if [ $? -ne 0 ]; then
    MyOut "\n\nFailed to download https://github.com/OH1KH/CqrlogAlpha/raw/compiled/cqr$cqr.zip"
    MyOut "\nCheck your internet connection!\n"
    exit
fi
MyOut "\n\nUpdating also latest help files.\n"
wget -q  https://github.com/OH1KH/CqrlogAlpha/raw/compiled/help.tgz
if [ $? -ne 0 ]; then
    MyOut "\n\nFailed to download https://github.com/OH1KH/CqrlogAlpha/raw/compiled/help.tgz"
    MyOut "\nCheck your internet connection!\n"
    exit
fi
MyOut "==================================================="
MyOut "Until now we have not touched your filesystem, execpt downloading install files."
MyOut "Now this script will write and delete some files."
MyOut "If you are unsure you can stop this script now  pressing Ctrl+C instead of ENTER"
MyOut "Press ENTER to continue, Ctrl+C to stop... "
read input
MyOut "==================================================="
MyOut "Doing backups:\n"
MyOut "File: \x2Fusr\x2Fbin\x2Fcqrlog is copied to  \x2Fusr\x2Fbin\x2Fcqrlog$mydate"
MyOut "Folder: \x2Fusr\x2Fshare\x2Fcqrlog\x2Fhelp is copied to  \x2Fusr\x2Fshare\x2Fcqrlog\x2Fhelp$mydate"
MyOut "Your settings and log folder:\n \x7E\x2F.config\x2Fcqrlog is copied to \x7e\x2F.config\x2Fcqrlog$mydate\n"
MyOut "Some of next operations need root privileges.\nCommand sudo may now ask password for your username.\n"
sudo cp /usr/bin/cqrlog /usr/bin/cqrlog$mydate 
if [ $? -eq 0 ]; then
    MyOut "Copy of \x2Fusr\x2Fbin\x2Fcqrlog$mydate OK !"
    MyOut "If you need to restore old cqrlog back give command:"
    MyOut "\x20\x20 sudo mv \x2Fusr\x2Fbin\x2Fcqrlog$mydate \x2Fusr\x2Fbin\x2Fcqrlog"
else
    MyOut  "Copy FAILED!"
    MyOut  "You have to upgrade manually!";
    exit
fi

if [[ $help =~ ^[Yy]$ ]]
then
    MyOut "==================================================="
    sudo cp -a /usr/share/cqrlog/help /usr/share/cqrlog/help$mydate 
    if [ $? -eq 0 ]; then
	MyOut  "Copy of \x2Fusr\x2Fshare\x2Fcqrlog\x2Fhelp$mydate OK!"
	MyOut  "If you need to restore help back give commands:"
	MyOut  "\x20\x20 sudo rm -rf \x2Fusr\x2Fshare\x2Fcqrlog\x2Fhelp"
	MyOut  "\x20\x20 sudo mv \x2Fusr\x2Fshare\x2Fcqrlog\x2Fhelp$mydate \x2Fusr\x2Fshare\x2Fcqrlog\x2Fhelp"
    else
	MyOut  "Copy FAILED!"
	MyOut  "You have to upgrade manually!";
	exit
    fi
fi
MyOut  "========="
MyOut  "= WAIT! ="
MyOut  "========="
MyOut  "Copying log and settings. This might take a while if you have large logs"
cp -a ~/.config/cqrlog ~/.config/cqrlog$mydate
if [ $? -eq 0 ]; then
    MyOut   "Copy of ~\x2F.config\x2Fcqrlog$mydate OK!"
    MyOut  "If you need to restore your logs and settings give commands:"
    MyOut  "\x20\x20 sudo rm -rf ~\x2F.config\x2Fcqrlog\nsudo mv ~\x2F.config\x2Fcqrlog$mydate ~\x2F.config\x2Fcqrlog"
else
    MyOut  Copy FAILED!
    MyOut  "You have to upgrade manually!";
    exit
fi    
MyOut "==================================================="
MyOut  "Backups are now done OK !"
du -hcs /usr/bin/cqrlo*
du -hcs /usr/share/cqrlog/hel*
du -hcs ~/.config/cqrlo*
MyOut  "You can now compare that backup sizes are same as origins"
MyOut "Press ENTER to continue, Ctrl+C to stop... "
read input
clear
MyOut "==================================================="
MyOut "Install new  cqrlog to \x2Fusr\x2Fbin\n"
sudo unzip  -o /tmp/cqr$cqr.zip -d /usr/bin
if [ $? -eq 0 ]; then
  MyOut "Installing new cqrlog DONE !"
  sudo chmod a+x /usr/bin/cqrlog
 else
    MyOut "Install of new cqrlog FAILED!"
    ManualUpdate
    exit
fi
if [[ $help =~ ^[Yy]$ ]]
then
    MyOut "==================================================="
    MyOut "Install new help to \x2Fusr\x2Fshare\x2Fcqrlog\n"
    cd /usr/share/cqrlog
    sudo rm -rf help
    if [ $? -eq 0 ]; then
	MyOut "Removing old help DONE !"
     else
	MyOut "Remove of old help FAILED!"
	ManualUpdate
	exit
    fi
    sudo tar xf /tmp/help.tgz
    if [ $? -eq 0 ]; then
    MyOut "Installing new help DONE !"
    sudo chmod -R a+r help
    else
	MyOut "install of new help FAILED!"
	ManualUpdate
	exit
    fi
fi
cd /tmp
MyOut "==================================================="
MyOut "   ALL DONE ! You may now start cqrlog !\n"
MyOut "\nIf you want to delete all backups that were made by this script give commands:"
MyOut "\x20\x20 rm -rf ~\x2F.config\x2Fcqrlog-20*"
MyOut "\x20\x20 sudo rm -rf \x2Fusr\x2Fshare\x2Fcqrlog\x2Fhelp-20*"
MyOut "\x20\x20 sudo rm \x2Fusr\x2Fbin\x2Fcqrlog-20*"
MyOut "\n BUT ! Only after you have tested that everything works!\n"
MyOut "Install log is in file /tmp/newupdate.txt"
