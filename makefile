#!/bin/bash

std='echo -en \033[0m';
style='echo -en \033[0;37m';
red='echo -en \033[31m';
yellow='echo -en \033[33m';

_header=1;
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
    if [ "${av[$i]}" == "--compiler" ] || [ "${av[$i]}" == "-c" ]
    then
	compiler=${av[`expr $i + 1`]};
    elif [ "${av[$i]}" == "--flag" ] || [ "${av[$i]}" == "-f" ]
    then
	cflag[${#cflag[@]}]=${av[`expr $i + 1`]};
    elif [ "${av[$i]}" == "--login" ] || [ "${av[$i]}" == "-l" ]
    then
	login=${av[`expr $i + 1`]};
    elif [ "${av[$i]}" == "--name" ] || [ "${av[$i]}" == "-n" ]
    then
	name=${av[`expr $i + 1`]};
    elif [ "${av[$i]}" == "--project" ] || [ "${av[$i]}" == "p" ]
    then
	project=${av[`expr $i + 1`]};
    elif [ "${av[$i]}" == "--include" ] || [ "${av[$i]}" == "i" ]
    then
	include=${av[`expr $i + 1`]};
    elif [ "${av[$i]}" == "--header" ]
    then
	if [ "${av[`expr $i + 1`]}" == "no" ] || [ "${av[`expr $i + 1`]}" == "n" ]
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
	echo "  --header yes/no	Print or not the epitech header. Default is yes"
	echo "  --help		Display this help"
	echo "  -i, --include		Change the includes directory"
	echo "  -l, --login		Change the login. Default is $USER"
	echo "  -n, --name		Change the executable name. Default is a.out"
	echo "  -p, --project		Change the project name"
    fi
    i=`expr $i + 1`;
done

rm -f Makefile;
if [ $_header -eq 1 ]
then
    header >> Makefile;
fi
sources >> Makefile;
body >> Makefile;
