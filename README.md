# CqrlogAlpha is a clone based on the work of OK2CQR & OK1RR.
## It has over 500 smaller or bigger differences to official Cqrlog.
### I am maintaining this software mainly for my own use, but feel free to use/modify it for your own needs by the rules of Open software licence and HamSprit rules.
----------------------------------------------------------------------------------------------------

See file src/changelog.html for changes

----------------------------------------------------------------------------------------------------

From folder "compiled" you find ready compiled binary files to replace against official Cqrlog.
There is also "newupdate.zip" that includes "newupdate.sh", a script that does Cqrlog backup and then updating for you with selected binary file.
Same folder has also README.md that holds further informations and some other general information files.

----------------------------------------------------------------------------------------------------



What is CQRLOG?
---------------

CQRLOG is an advanced ham radio logger based on MySQL database. Provides radio control 
based on hamlib libraries (currently support all radio types and models Hamlib can support),
DX cluster connection, online callbook, a grayliner, internal QSL manager database support,
remore support for fldigi|wsjt-x|ADIF (n1mm) and a most 
accurate country resolution algorithm based on country tables developed by OK1RR. CQRLOG is 
intended for daily general logging of HF, CW , PHONE & DIGI contacts and strongly focused on easy 
operation and maintenance. 


How to contribute?
------------------

You have to have Lazarus + fpc compiler, MySQL server and clinet installed.
CQRLOG is developed on Ubuntu 20.04, Lazarus and FreePascal are available from https://www.lazarus-ide.org

Compile with make|make cqrlog_qt5|make cqrlog_qt6 and install with make DESTDIR=/home/yourusername/where_you_want_to_have_it install.
If you are going to change the source code, fork the repo, do the changes, commit them and use Pull request.

Dependencies
-------------

Build-Depends: lazarus, lcl, [qt5pas, qt6pas] fp-utils, fp-units-misc, fp-units-gfx, fp-units-gtk2, fp-units-db, fp-units-math, fp-units-net

Depends: libssl-dev, mariadb-server,  mariadb-client, libhamlib2 (>= 1.2.10), libhamlib-utils (>= 1.2.10)

Running build with Docker
-------------------------

If you do not want to install the dependencies into your main machine, you can do the build
in a Docker container.  You need to mount into that Docker container this directory and
also the target directory where you want to put the alpha version of `cqrlog` you are
building.

This also helps if you want to build, e.g., on a Debian Stretch machine.  Attempts at
native builds on that platform have failed.  Using a reasonably recent Ubuntu inside our
Docker-based build environment, makes the build work even on Debian Stretch.

That bad news is, you have to [install Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) (CE is fine).

That done, you can prepare an Ubuntu Docker image with the build tools as follows:

    (cd docker-build && docker build -t this.registry.is.invalid/cqrlog-build .)

(In case you wonder: There is no need to use a Docker registry, so we provide a registry
host that is guaranteed to not exist.)

Then, run the build itself with

    sudo mkdir -p /usr/local/cqrlog-alpha && sudo chown $SUDO_USER /usr/local/cqrlog-alpha &&
    docker run -ti -u root -v $(pwd):/home/cqrlog/build \
      -v /usr/local/cqrlog-alpha:/usr/local/cqrlog-alpha this.registry.is.invalid/cqrlog-build

To use your build, make sure that you have no instance of `cqrlog` running, backup
`$HOME/.config/cqrlog` (if you ever used `cqrlog` before), add
`/usr/local/cqrlog-alpha/usr/bin` to your `$PATH` and start `cqrlog` from there.
