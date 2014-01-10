#!/bin/bash

std='echo -en \033[0m';
style='echo -en \033[0;37m';
red='echo -en \033[31m';

_header=1;
project=$1;
name=$1;

function header()
{
    echo "##";
    echo "## Makefile for $project in `pwd`";
    echo "##";
    echo "## Made by $USER";
    echo "## Login   <$USER@epitech.eu>";
    echo "##";
    echo "## Started on  `date +'%a %_d %b %H:%M:%S %Y'` $USER";
    echo -n "## Last ";
    echo "update `date +'%a %_d %b %H:%M:%S %Y'` $USER";
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
}

function body()
{
    echo;
    echo;
    echo "OBJS	= \$(SRCS:.c=.o)";
    echo;
    echo "NAME	= $name";
    echo;
    echo "CFLAGS	+= -W -Wall -Wextra -pedantic -ansi"
    echo;
    echo "RM	= rm -f"
    echo;
    echo "all:	\$(NAME)";
    echo;
    echo "\$(NAME):	\$(OBJS)";
    echo "	cc -o \$(NAME) \$(OBJS)";
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

echo -n > Makefile;
if [ $_header -eq 1 ]
then
    header >> Makefile;
fi
sources >> Makefile;
body >> Makefile;
