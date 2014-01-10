#!/bin/bash

std='echo -en \033[0m';
style='echo -en \033[0;37m';
red='echo -en \033[31m';
yellow='echo -en \033[33m';

_header=1;
verbose=0;
include=".";
login=$USER
project="";
name="a.out";
compiler="cc";
cflag=();

function header()
{
    echo "##";
    echo "## Makefile for $project in `pwd`";
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
    ls_c=(`ls *.c 2> /dev/null`);
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
    echo "CFLAGS	+= -W -Wall -Wextra -pedantic -ansi";
    if [ $include != "." ]
    then
	echo "CFLAGS	+= -I $include";
    fi
    for i in "$cflag"
    do
	echo -n "CFLAGS	+= ";
	echo $i;
    done
    echo;
    echo "RM	= rm -f"
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

i=0;
av=("$@");
while [ $i -lt $# ]
do
    param=${av[$i]}
    if [ "$param" == "--compiler" ] || [ "$param" == "-c" ]
    then
	compiler=${av[`expr $i + 1`]};
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
    elif [ "$param" == "--verbose" ] || [ "$param" == "-v" ]
    then
	verbose=1;
    elif [ "$param" == "--include" ] || [ "$param" == "-i" ]
    then
	include=${av[`expr $i + 1`]};
    elif [ `echo $param | cut -d '=' -f1` == "--header" ]
    then
	choice=`echo $param | cut -d '=' -f2`
	if [ $choice == "no" ] || [ $choice == "n" ]
	then
	    _header=0;
	else
	    _header=1;
	fi
    elif [ "${av[$i]}" == "--help" ]
    then
	echo "Usage: makefile [options]..."
	echo "Create a makefile"
	echo "  -c, --compiler	Change the compiler. Default is cc"
	echo "  -f, --flag		Add a compilation flag"
	echo "  --header=yes/no	Print or not the epitech header. Default is yes"
	echo "  --help		Display this help"
	echo "  -i, --include		Change the includes directory"
	echo "  -l, --login		Change the login. Default is $USER"
	echo "  -n, --name		Change the executable name. Default is a.out"
	echo "  -p, --project		Change the project name"
	echo "  -v, --verbose		Enable verbose mode"
    fi
    i=`expr $i + 1`;
done

if [ -e Makefile ]
then
    if [ $verbose -eq 1 ]
    then
	echo "Removing old Makefile..."
	rm -f Makefile
    fi
fi
if [ $verbose -eq 1 ]
then
    echo "Creating Makefile..."
fi
touch Makefile;
if [ $_header -eq 1 ]
then
    if [ $verbose -eq 1 ]
    then
	echo "Adding epitech header : "
	echo "  login : $login"
	echo "  project name : $project"
    fi
    header >> Makefile;
fi
if [ $verbose -eq 1 ]
then
    echo "Adding source files to Makefile..."
fi
sources >> Makefile;
if [ $verbose -eq 1 ]
then
    echo "Executable name : $name"
    echo "Adding rules to Makefile..."
fi
body >> Makefile;
