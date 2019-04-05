# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    03.sh                                              :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: juriot <marvin@42.fr>                      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/03/29 15:53:09 by juriot            #+#    #+#              #
#    Updated: 2019/03/29 15:53:11 by juriot           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

HEADER="\e[1;32m*****************************************************************\n*\t\t\t\t\t\t\t\t*\n*\t\t\e[0mWelcome!\t\t\t\t\t\e[1;32m*\n*\t\t\e[0mThis is a searching tool for lyrics!\e[1;32m\t\t*\n*\t\t\t\t\t\t\t\t*\n*****************************************************************\e[0m"
SURE="N"
CONTINUE="S"

echo "${HEADER}"

displayheader() {
	clear
	echo "$HEADER"
}

asktitle () {
	read -p "Which song do you want to know the lyrics of ? " NEWTITRE
	TITRE=$(echo $NEWTITRE | tr -d "'" | tr -d "."| sed "s/ /-/g")
}

askartist () {
	read -p "Who performs $NEWTITRE ? " NEWARTIST
	ARTIST=$(echo $NEWARTIST | tr -d "'" | sed "s/ /-/g")
}

askconfo () {
	echo "you chose to search the lyrics of \e[1;34m$NEWTITRE\e[0m by \e[1;34m$NEWARTIST\e[0m."
	read -p "Is it correctly spelled ? (Y/N) " SURE
}

askinfos () {
	while [ "$SURE" != "Y" ]
	do
		asktitle
		askartist
		askconfo
	done
}

buildurl () {
	URL="http://www.metrolyrics.com/$TITRE-lyrics-$ARTIST.html"
	NEWFILE="./pages/${TITRE}-$ARTIST-new.txt"
	FILE="./pages/${TITRE}-${ARTIST}.txt"
}

createfiles () {
	rm -rf ${NEWFILE}
	rm -rf ${FILE}
	touch ${NEWFILE}
	touch ${FILE}
}

fillit () {
	lynx -dump -nolist $URL > $NEWFILE
	cat $NEWFILE | sed -e "1,/highlight/d" | sed -e '/Song Discussions is protected by U.S./,$d' | grep -v "*" | grep -v "+" | grep -v "contain explicit language" | grep -v "Related" | grep -v "Photos" | grep -v "       " | grep -A1 . | grep -v "\-\-" > $FILE
	rm -rf $NEWFILE
}

displaylyrics () {
	echo "\nYou asked for the lyrics of \e[1;34m$NEWTITRE\e[0m by \e[1;34m${NEWARTIST}\e[0m : \n"
	cat $FILE
}

errortext () {
	displayheader
	echo "\noopsy! We didn't find the song you were looking for..."
	read -p "do you want to try again ? (Y/N) " CONTINUE
}

testandact () {
	if curl --output /dev/null --silent --head --fail "$URL"; then
		createfiles
		fillit
		displayheader
		displaylyrics
	else
		errortext
		SURE="N"
	fi
}

while [ "$CONTINUE" != "N" ]
do
	displayheader
	askinfos
	buildurl
	testandact
done