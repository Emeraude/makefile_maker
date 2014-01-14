#!/bin/bash
v=14

std='echo -en \033[0m';
style='echo -en \033[0;37m';
red='echo -en \033[31m';
green='echo -en \033[32m';
yellow='echo -en \033[33m';

_header=1;
_update=1;
verbose=0;
include=".";
login=$USER
project="";
src=".";
files=".c";
name="a.out";
compiler="cc";
warning="-W -Wall -Wextra -pedantic -ansi";
cflag=();
dir=`pwd`;

function check_update()
{
    wget -q -t 1 -T 1 -O check https://raw.github.com/Emeraude/makefile_maker/master/makefile;
    if [ $? -ne 0 ]
    then
	if [ $verbose -eq 1 ]
	then
	    echo "Unable to check for a new version. Please make sure you are connected to the internet.";
	fi
	rm -f check;
	return 0;
    fi
    version=`head check -n 2 | tail -n 1 | cut -d "=" -f2`;
    if [ $v -lt $version ]
    then
	$green;
	echo "A new version of Makefile_maker is available !";
	$style;
	rm -f check;
	return 1;
    elif [ $verbose -eq 1 ]
    then
	echo "No new version available.";
    fi
    rm -f check;
    return 2;
}

function upgrade()
{
    check_update;
    a=$?
    if [ $a -eq 1 ]
    then
	if [ `whoami` == "root" ]
	then
	    echo "Downloading...";
	    wget -q -t 1 -T 1 -O .exec_maj https://raw.github.com/Emeraude/makefile_maker/master/makefile;
	    x=$?;
	    wget -q -t 1 -T 1 -O .man_maj https://raw.github.com/Emeraude/makefile_maker/master/makefile;
	    y=$?;
	    if [ $x -eq 0 ] && [ $y -eq 0 ]
	    then
		echo "Putting the rights to execute the script...";
		chmod 755 .exec_maj;
		echo "Putting script in /usr/bin...";
		mv .exec_maj /usr/bin/makefile;
		echo "Putting manpage in /usr/share/man/man1";
		mv .man_maj /usr/share/man/man1;
		echo "Done."
	    else
		$red;
		echo "Unable to download the new files. Please make sure you are connected to the internet.";
	    fi
	else
	    $red;
	    echo "You need to be root to upgrade correctly the makefile_maker script.";
	fi
    elif [ $a -eq 2 ]
    then
	echo "No new version available.";
    else
	$red;
	echo "Unable to check for a new version. Please make sure you are connected to the internet.";
    fi
    $std;
    exit 0;
}

function header()
{
    echo "##";
    echo "## Makefile for $project in $dir";
    echo "##";
    echo "## Made by $login";
    echo "## Login   <$login@epitech.eu>";
    echo "##";
    echo "## Started on  `date +'%a %_d %b %H:%M:%S %Y'` $login";
    echo -n "## Last ";
    echo "update `date +'%a %_d %b %H:%M:%S %Y'` $login";
    echo "##";
    echo;
}

function sources()
{
    if [ $src != "." ]
    then
	if [ "${src: -1}" == "/" ]
	then
	    ls_c=(`ls $src*$files 2> /dev/null`);
	else
	    ls_c=(`ls $src/*$files 2> /dev/null`);
	fi
    else
	ls_c=(`ls *$files 2> /dev/null`);
    fi
    size_c=${#ls_c[*]};
    echo -n "SRCS	= ";
    i=0;
    while [ $i -lt $size_c ]
    do
	if [ $i -eq 0 ]
	then
	    echo -n ${ls_c[$i]};
	else
	    echo -n "	  ${ls_c[$i]}";
	fi
	i=`expr $i + 1`;
	if [ $i -ne $size_c ]
	then
	    echo " \\";
	fi
    done
    echo;
    echo;
}

function body()
{
    echo "OBJS	= \$(SRCS:.c=.o)";
    echo;
    echo "NAME	= $name";
    echo;
    echo "CC	= $compiler";
    echo;
    echo "CFLAGS	+= $warning";
    if [ $include != "." ]
    then
	echo "CFLAGS	+= -I $include";
    fi
    i=0;
    while [ $i -lt ${#cflag[@]} ]
    do
	echo "CFLAGS	+= ${cflag[$i]}";
	i=`expr $i + 1`;
    done
    echo;
    echo "RM	= rm -f";
    echo;
    echo "all:	\$(NAME)";
    echo;
    echo "\$(NAME):	\$(OBJS)";
    echo "	\$(CC) -o \$(NAME) \$(OBJS)";
    echo;
    echo "clean:";
    echo "	\$(RM) \$(OBJS)";
    echo;
    echo "fclean:	clean";
    echo "	\$(RM) \$(NAME)";
    echo;
    echo "re:	fclean all";
    echo;
    echo ".PHONY:	all clean fclean re";
}

$style;
i=0;
av=("$@");
while [ $i -lt $# ]
do
    param=${av[$i]}
    if [ "$param" == "--compiler" ] || [ "$param" == "-c" ]
    then
	compiler=${av[`expr $i + 1`]};
    elif [ "$param" == "--directory" ] || [ "$param" == "-d" ]
    then
	dir=${av[`expr $i + 1`]};
    elif [ "$param" == "--files" ]
    then
	files=${av[`expr $i + 1`]};
    elif [ "$param" == "--flag" ] || [ "$param" == "-f" ]
    then
	cflag[${#cflag[@]}]=${av[`expr $i + 1`]};
    elif [ "$param" == "--login" ] || [ "$param" == "-l" ]
    then
	login=${av[`expr $i + 1`]};
    elif [ "$param" == "--name" ] || [ "$param" == "-n" ]
    then
	name=${av[`expr $i + 1`]};
    elif [ "$param" == "--project" ] || [ "$param" == "-p" ]
    then
	project=${av[`expr $i + 1`]};
    elif [ "$param" == "--src" ] || [ "$param" == "-s" ]
    then
	src=${av[`expr $i + 1`]};
    elif [ "`echo $param | cut -d '=' -f1`" == "-u" ] || [ "`echo $param | cut -d '=' -f1`" == "--update" ]
    then
	choice=`echo $param | cut -d '=' -f2`;
	if [ $choice == "no" ] || [ $choice == "n" ]
	then
	    _update=0;
	else
	    _update=1;
	fi
    elif [ "$param" == "--upgrade" ]
    then
	upgrade;
    elif [ "$param" == "--verbose" ] || [ "$param" == "-v" ]
    then
	verbose=1;
    elif [ "$param" == "--warning" ] || [ "$param" == "-w" ]
    then
	warning=${av[`expr $i + 1`]};
    elif [ "$param" == "--include" ] || [ "$param" == "-i" ]
    then
	include=${av[`expr $i + 1`]};
    elif [ "`echo $param | cut -d '=' -f1`" == "--header" ]
    then
	choice=`echo $param | cut -d '=' -f2`;
	if [ $choice == "no" ] || [ $choice == "n" ]
	then
	    _header=0;
	else
	    _header=1;
	fi
    elif [ "${av[$i]}" == "--help" ]
    then
	echo "Usage: makefile [options]...";
	echo "Create a makefile";
	echo "  -c, --compiler	Change the compiler. Default is cc";
	echo "  -d, --directory	Change directory in the epitech header. Default is ."
	echo "  --files		Change the extension of source files. Default is .c";
	echo "  -f, --flag		Add a compilation flag";
	echo "  --header=yes/no	Print or not the epitech header. Default is yes";
	echo "  --help		Display this help";
	echo "  -i, --include		Change the includes directory";
	echo "  -l, --login		Change the login. Default is $USER";
	echo "  -n, --name		Change the executable name. Default is a.out";
	echo "  -p, --project		Change project name in the epitech header";
	echo "  -s, --src		Change the sources directory. Default is .";
	echo "  -u, --update=yes/no	Enable/disable the online check of new version. Default is yes"
	echo "  --upgrade	Check if a new version is available, and install it if it is possible"
	echo "  -v, --verbose		Enable verbose mode";
	echo "  -w, --warning		Change warnings flag. Default are -W -Wall -Wextra -pedantic -ansi";
	exit 0;
    fi
    i=`expr $i + 1`;
done

if [ $_update -eq 1 ]
then
    if [ $verbose -eq 1 ]
    then
	echo "Checking for a new version...";
    fi
    check_update;
fi

if [ -e Makefile ]
then
    if [ $verbose -eq 1 ]
    then
	echo "Removing old Makefile...";
    fi
    rm -f Makefile;
fi
if [ $verbose -eq 1 ]
then
    echo "Creating Makefile...";
fi
touch Makefile;
if [ $_header -eq 1 ]
then
    if [ $verbose -eq 1 ]
    then
	echo "Adding epitech header : ";
	echo "  login : $login";
	echo "  project name : $project";
    fi
    header >> Makefile;
fi
if [ $verbose -eq 1 ]
then
    echo "Adding source files to Makefile...";
fi
sources >> Makefile;
if [ $verbose -eq 1 ]
then
    echo "Executable name : $name";
    echo "Adding rules to Makefile...";
fi
body >> Makefile;
