# CqrlogAlpha is a clone based on the work of OK2CQR & OK1RR.
## It has over 570 smaller or bigger differences to official Cqrlog.
### I am maintaining this software mainly for my own use, but feel free to use/modify it for your own needs by the rules of Open software licence and HamSprit rules.
### Alpha version changes can be found from [Changelog](https://htmlpreview.github.io/?https://github.com/OH1KH/CqrlogALpha/blob/main/src/changelog.html)  
### Some Cqrlog related videos can be found from  <https://www.youtube.com/channel/UC3yPCVYmfeBzDSwTosOe2fQ>
----------------------------------------------------------------------------------------------------

This folder holds ready compiled binary files of CqrlogAlpha that I am using myself daily.
I call it Alpha version, but that does not mean it is somehow under construction (a testing version).
Compiled binary versions are released after it seems that biggest bugs are found and fixed.

It is mostly compatible with official Cqrlog. Depending what happens to official Cqrlog development it may not be so in future.

## NOTES:

 #### NOTE: Upgrading instructions for using script, manual install or compile from source can be foud below. Just scroll down ...


 #### NOTE: Upgrading to _(125)_ ,or higer, will add database table "cqrlog_common.states" and set version to 7.
 This database upgrade should be backwards compatible (none of old versions are interested in new table created)

 #### NOTE: For now on binaries are compiled using system that has GLIBC version 2.35.
If you can not start Cqrlog after update check your GLIBC version with command console: ***ldd --version***
Update GLIBC if it is below 2.3.5.
If you do not want to do that you can compile this source (see parent folder) with your current OS version and get it running.

 #### NOTE: It may be that some OS versions crash if your desktop uses Wayland. Switching over to X should help.


## ABOUT THESE BINARY FILES:

 Binaries (cqr2,cqr3,cqr5,cqr6 zips) include latest CarlogAlpha versions.
 
 To see updates in this alpha version look at <https://github.com/OH1KH/cqrlog/commits/loc_testing>

 To read about UTF8 special charcters in logs read file UTF8_logs.md
 
 
Alpha BINARIES:
---------
  - **cqr2.zip  holds binary for  64bit systems compiled for GTK2 widgets**
  - **cqr3.zip  holds binary for  32bit systems compiled for GTK2 widgets**
  - **cqr4.zip  holds binary for  64bit Arm (Rpi4) compiled for GTK2 widgets**
  - **cqr5.zip  holds binary for  64bit systems compiled for QT5 widgets (You may need to install libqt5pas1 (Fedora: qt5pas) to run this)**
  - **cqr6.zip  holds binary for  64bit systems compiled for QT6 widgets (You may need to install libqt6pas1 (Fedora: qt6pas) to run this)**

  - **help.tgz  holds latest help files**
  - **newupdate.zip holds the newupdate.sh script for easy update**

**These binary files do not work alone. All binaries must be either copied over complete, working, official installation**
** or used with required dependency packages and with folder /usr/share/cqrlog having all files from official install**


------------------WARNINGS-----------------
===========================================
   
**This is NOT official Cqrlog release !**

   ***ALWAYS !!  FIRST DO BACKUP OF YOUR LOGS AND SETTINGS !!***
   
   If you use script-install (see below) it makes backups for you.
   Otherwise see "manual-install (below).
   
   In some cases it has happen that Alpha compiled using Fedora Linux may not run flawlessly with Ubuntu derivates.
   if you start to get mysterious errors it might be the reason.
   
-----------YOU HAVE BEEN WARNED!------------
============================================


## UPDATE INSTRUCTIONS:



### -------------------SCRIPT-INSTALL--------------------

**There is now new script for update. You need to download only the script and start it.**
**It will do rest of downloads for you and then install updates.**


Use it this way:

Download newupdate.zip from GitHub page.
   - click blue link of newupdate.zip file. New page opens. You see that there is a button "Download" click it.
     Your browser downloads the zip. If it asks where to save, select folder from where you can find the zip.

Open command console. Go to your download directory.

    cd [your download directory path]

Unzip newupdate.zip to find the newupdate.sh script:

    unzip newupdate.zip

Then start newupdate.sh script with command:

    ./newupdate.sh
    
	If you can not start script then check that you can execute newupdate.sh by giving a command:
	    chmod a+x newupdate.sh
	Then try again to start script.

	There has been one case where starting newupdate.sh it complains error at line 5 (arch bracket).
	In that case solution was to start newupdate.sh as:

    bash newupdate.sh

	That (Ubuntu 20) linux obviously did not had bash as default shell.
	
Script checks frist that you have cqrlog installed and that you have some other needed programs.
If they are not found it will stop and tell what you should do before new try.

I have tested this script many times while writing it. How ever it may fail with your setup.

So you USE IT ON YOUR OWN RISK !

Here is a video showing update in use https://www.youtube.com/watch?v=H_QLQhQyFVg&t

Other way to update is to do it manually as follows:

## -------------------MANUAL-INSTALL--------------------
  
  Simplest way to backup everything is to copy whole folder with console command
   
     cp -a ~/.config/cqrlog ~/.config/cqrlog_save

   After doing this, if you ever need to restore old settings and logs, just give console commands
   
     rm -rf ~/.config/cqrlog
     cp -a ~/.config/cqrlog_save  ~/.config/cqrlog
   
  
(you need to become root (sudo) using sudo to do following):

#### -------------INSTALL NEW HELP FILES----------------

Your /usr/share should usually contain folder cqrlog, if so, do install help files.

    cd /usr/share/cqrlog
    sudo tar vxf /your/download/folder/help.tgz


#### ------------THEN INSTALL THE CQRLOG ITSELF---------

    cd /tmp
    unzip /your/download/folder/cqr5.zip  (cqr3.zip or cqr2.zip)


Then just copy '/tmp/cqrlog'  over your existing 'cqrlog' (usually in /usr/bin folder)
when first saving the old one to cqrlog_old that you can copy back if new one does not work.
Then check execution rights.

    sudo cp /usr/bin/cqrlog /usr/bin/cqrlog_old
    sudo cp /tmp/cqrlog /usr/bin/
    sudo chmod a+x /usr/bin/cqrlog  
    

## -------------------MANUAL-COMPILE--------------------


Once you have a running Cqrlog installed you can do update also by making the compile from source code.
For getting source code there are two ways:

clone my whole Git reporsitory using command terminal:

	git clone https://github.com/OH1KH/CqrlogAlpha.git

If you start this command from your user home directory it creates CqrlogAlpha directory to your home directory.

Or go to address:

	https://github.com/OH1KH/CqrlogAlpha

and find green "Code" button. Press it and select "Download ZIP". Using this way you have to extract downloaded zip to somewhere on your computer.

Difference with "git clone" and "Download ZIP" is that cloning downloads full history and also all branches where ZIP gives just the currently open view to source.

Change your command console to CqrlogAlpha folder. If you used "git clone" you can change branch with checkout command.

	git checkout main
	git checkout devel

Main holds the latest release. Devel holds coming next release, but may be unstable.

Good side with "git clone" is that on next time you like to upgrade you just open command console and change directory to "CqrlogAlpha" ("cd CqrlogAlpha") and issue command "git pull" and new updates are applied and you are ready to compile and install again.

Other way is to download just the current version's source with web browser  as ZIP
How ever you can not do new uptates later with "git pull". You have to download the ZIP file web browser again.

Once you have source you need tools to compile. Using command termnal install them.

	sudo apt install lazarus

That will install FreePascal compiler and Lazarus GUI. Issuing that line results a long list of dependencies to install, just say Y (yes) to install them all.

If your Lazarus is very old from package you find latest version from https://www.lazarus-ide.org It is always recommended to use latest version as package versions can be very old, as seen with Cqrlog packages.

When lazarus-ide is installed you need to change to source directory, either git cloned or extracted from zip. ("cd cqrlog")
After that start the compile process, issue:

	make
	
	In case you want QT5 version add cqrlog_qt5 after "make".
	
	make cqrlog_qt5

	In case you want QT6 version add cqrlog_qt6 after "make".
	
	make cqrlog_qt6

When compile has finished install the new Cqrlog with command

	sudo make install


That is all!


Note that if you compile and use QT5 or QT6 vesions you need to install libqt5pas and libqt5pas-devel packets.
and in case of QT6 packet naming changes to libqt6pas and libqt6pas-devel
There may be differences in packet naming dependig on your Linux version.


With some OS "make" result errors. Then usually using the lazarus-ide works.
Start lazarus-ide typing that to command terminal, or start from startup menu icon "lazarus".
At first start it goes through some settings. If all Tabs show OK you are ready to continue.

Lazarus starts first to empty form. Use top menu "Project/Open Project" and navigate to your "CqrlogAlpha" source folder. There you see subfolder "src". Navigate to that folder and you see "cqrlog.lpi".  Open that.

Once opened select top menu "View/Messages" to see compiler messages. Then select top menu "Run/Compile".
Wait and finally you should see a green line on Messages window. It means that compile is over.

You find new cqrlog from folder "src" as file "cqrlog"
You can now try command terminal:

	cd CqrlogAlpha  (this is the source root folder, as before)
	sudo make install

If succeeded you have new version with new help installed. If not, you can just copy file "cqrlog" from folder "src" to "/usr/bin"
There already exists a file named "cqrlog" (that is the old version) you can first copy it somewhere, if you like, before
coping over the new one.
You need "sudo" for this copy.

	sudo cp src/cqrlog /usr/bin




### Alpha version changes can be found from [Changelog](https://htmlpreview.github.io/?https://github.com/OH1KH/CqrlogAlpha/blob/main/src/changelog.html) 
 
### Some Cqrlog related videos can be found from  <https://www.youtube.com/channel/UC3yPCVYmfeBzDSwTosOe2fQ>

All kind of reports are welcome. You can find my address from callbooks.

     
