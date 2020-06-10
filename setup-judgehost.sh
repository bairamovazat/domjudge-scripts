#!/bin/bash

package_check_and_install() {
    pachage_name=$1

    package_check "$pachage_name";

    if [ "$package_check_result" -eq 0 ]; then
	    printf "Установка пакета $pachage_name \n\n"
	    sudo apt install $pachage_name
    fi

}

package_check() {
	pachage_name=$1
	
	dpkg -s $pachage_name &> /dev/null;

	if [ $? -eq 0 ]; then
    	echo "Пакет $pachage_name установлен!"
    	package_check_result=1;
	else
    	echo "Пакет $pachage_name не установлен!"
    	package_check_result=0;
	fi
}

replace_text() {
	regex=$1
	new_text=$2
	input_file=$3
	output_file=$4
	sed -e s+$1+$2+g $3 > $4
}

current_dir=$(pwd)

echo "Начало установки judgehost"

if [ -z "$1" ]; then
	echo "Первым аргументом нужно указать путь до папки с judgehost";
	exit
fi

echo "Обновление системы..."

sudo apt update

echo "Обновление зависимостей..."

sudo apt install -y zip unzip mariadb-server apache2 \
    php7.2 php7.2-fpm php7.2-cli \
    php7.2-gd php7.2-curl php7.2-mysql php7.2-json \
    php7.2-xml php7.2-intl php7.2-mbstring \
    php7.2-zip composer ntp \
    make autoconf automake \
    python3-sphinx python3-sphinx-rtd-theme \
    texlive-latex-recommended texlive-latex-extra \
    texlive-fonts-recommended texlive-lang-european \
    python-pygments libcgroup-dev libcurl4-openssl-dev \
    libjsoncpp-dev


FILE=/tmp/domjudge-7.1.3.tar.gz
if ! [ -f "$FILE" ]; then
	echo "Загрузка domjudge"
    wget -P /tmp https://www.domjudge.org/releases/domjudge-7.1.3.tar.gz
fi

echo "Разархивация domjudge"

tar -C "$1" -xzf /tmp/domjudge-7.1.3.tar.gz

mv "$1"/domjudge-7.1.3 "$1"/domjudge-source

chmod -R a+rwx "$1"/domjudge-source

cd "$1"/domjudge-source

echo "Сборка domjudge"

make dist

./configure --prefix="$1"/domjudge --with-baseurl=http://localhost:80/domjudge

make judgehost

cp $current_dir/restapi.secret "$1"/domjudge-source/etc/restapi.secret 

sudo make install-judgehost

sudo chmod -R a+rwx "$1"/domjudge

if ! [[ -n $(id -u domjudge-run 2>/dev/null) ]]; then
	echo "Создание пользователя domjudge-run"
    sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run
fi

sudo cp ./etc/sudoers-domjudge /etc/sudoers.d/sudoers-domjudge



