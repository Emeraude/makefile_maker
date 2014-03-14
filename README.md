Makefile_maker
==============

A script that create a makefile, with the epitech header.

To install it, you have to run the following command :

	sudo ./installer.sh

The makefile command will be put in /usr/bin.  
Some options have been implemented :  
You can change the compiler, display or not the header, change the login in the header, the executable name, the project name, the source files, the include directory, the sources directory, modify the compilation line or add compilation flags. You also can compile your project with a library and add your own variables and your own rules. More details with this command :

	makefile --help

You also can read the man. ;)  
The script check automatically if a new version is available. In that event, you can upgrade the script by running the following command :

	sudo makefile --upgrade

You can change the default values if you modify the following file :

	~/.makerc

Makefile_maker v2.2  
Developped by Emeraude.
