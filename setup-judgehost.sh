#!/bin/bash
print_spaces() {
    printf "      "
}

print_line() {
    echo "////////////////////////////////////////"
}

print_in_frame() {
	print_line
    print_spaces
    echo "$1"
    print_line
}

replace_text() {
	regex=$1
	new_text=$2
	input_file=$3
	output_file=$4
	sed -e s+$1+$2+g $3 > $4
}

current_dir=$(pwd)


print_in_frame "Начало установки judgehost"


if [ -z "$1" ]; then
	print_in_frame "Первым аргументом нужно указать путь до папки с judgehost";
	exit
fi

print_in_frame "Обновление системы..."

sudo apt update

print_in_frame "Обновление зависимостей..."

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
    libjsoncpp-dev make sudo debootstrap libcgroup-dev lsof \
    php-cli php-curl php-json php-xml php-zip procps \
    gcc g++ default-jre-headless default-jdk-headless \
    ghc fp-compiler


FILE=/tmp/domjudge-7.1.3.tar.gz
if ! [ -f "$FILE" ]; then
	print_in_frame "Загрузка domjudge"
    wget -P /tmp https://www.domjudge.org/releases/domjudge-7.1.3.tar.gz
fi

print_in_frame "Разархивация domjudge"

tar -C "$1" -xzf /tmp/domjudge-7.1.3.tar.gz

mv "$1"/domjudge-7.1.3 "$1"/domjudge-source

chmod -R a+rwx "$1"/domjudge-source

cd "$1"/domjudge-source

print_in_frame "Сборка domjudge"

make dist

./configure --prefix="$1"/domjudge --with-baseurl=http://localhost:80/domjudge

make judgehost

cp $current_dir/restapi.secret "$1"/domjudge-source/etc/restapi.secret 

sudo make install-judgehost

sudo chmod -R a+rwx "$1"/domjudge

if ! [[ -n $(id -u domjudge-run 2>/dev/null) ]]; then
	print_in_frame "Создание пользователя domjudge-run"
    sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run
fi

print_in_frame "Применение chroot"

sudo "$1"/domjudge/judgehost/bin/dj_make_chroot

sudo cp ./etc/sudoers-domjudge /etc/sudoers.d/sudoers-domjudge

print_in_frame "Завершение установки. ВНИМАНИЕ! Не забудьте обновить /etc/default/grub"


