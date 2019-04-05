# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    02.sh                                              :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: juriot <marvin@42.fr>                      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/03/29 15:53:02 by juriot            #+#    #+#              #
#    Updated: 2019/03/29 16:01:15 by juriot           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

LIST=$(cat /etc/passwd | awk -F: '/home/ {print "\t- "$1}')
YOU=$(whoami)
OK="bad"
QUIT="S"
EXIT="****************************** EXIT ****************************"
END="\t\t\t\t\t\t[\e[1;31mEND OF PROCESS\e[0m]"
SUCCESS="\t\t\t\t\t\t      [\e[1;32mSUCCESS\e[0m]"
DONE="\t\t\t\t\t\t\t   [\e[1;32mOK\e[0m]"
OOPS="\t\t\t\t\t\t  [\e[1;31mINVALID USER\e[0m]"
FOUND="\t\t\t\t\t\t   [\e[1;32mVALID USER\e[0m]"

echo "****************************************************************"
echo "*        Hello!                                                *"
echo "*     You just asked to delete a user.                         *"
echo "****************************************************************\n"

read -p "Do you want to continue ? (Y/N) : " SURE

if [ "$SURE" = "Y" ]; then
	echo "\nNote that you are :\e[1;34m ${YOU}\e[0m"
	echo "Here is the list of the existing users : "
	echo "${LIST}\n"
	until [ ${OK} = good ]
	do
		read -p "Which user do you want to delete ? " USER_NAME
		cat /etc/passwd | grep home | grep $USER_NAME | cut -d ":" -f1 && {
			echo "${FOUND}"
			sudo killall -u $USER_NAME
			echo "\t      ${USER_NAME}'s session has successfully been interrupted."
			echo "${DONE}"
			sudo deluser $USER_NAME
			echo "\t\t\t    ${USER_NAME} has successfully been deleted."
			echo "${DONE}"
			echo "${SUCCESS}"
			echo "Here is the list of the remaining users :"
			LIST=$(cat /etc/passwd | awk -F: '/home/ {print "\t- "$1}')
			echo "${LIST}\n"
			echo "${EXIT}"
			OK="good"
		} || {
			echo "${OOPS}"
			echo "\e[1;31muser not found\e[0m, please try again :"
			if [ "$QUIT" != "Q" ]; then
				echo "                 you can also quit by typing Q,"
				echo "                 or continue by typing any other key."
				read -p  "what do you want to do ? (Q to quit) : " QUIT
				if [ "$QUIT" = "Q" ]; then
					echo "${END}"
					echo "${EXIT}"
					break
				fi
			fi
		}
	done
else
	echo "${END}"
	echo "${EXIT}"
fi
