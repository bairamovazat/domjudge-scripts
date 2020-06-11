# Пример использования
./setup-judgehost.sh JUDGEHOST_HOME

где JUDGEHOST_HOME - абсолютный путь, куда будет установлен judgehost (Например /home/ubuntu)

# Установка точного ограничения памяти
Для точного ограничение по памяти (для JVM например) нужно добавить в GRUB_CMDLINE_LINUX_DEFAULT в /etc/default/grub дополнительные парамерты `cgroup_enable=memory swapaccount=1`. Стоит учитывать, что на некоторых машинах (напр. AWS) GRUB_CMDLINE_LINUX_DEFAULT переопределяется в /etc/default/grub.d/

### Пример

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet cgroup_enable=memory swapaccount=1"
```

Далее вполнить update-grub, добавить create-cgroups.service как службу и перезагрузить машину

### Пример

```
sudo cp JUDGEHOST_HOME/domjudge-source/misc-tools/create-cgroups.service /etc/systemd/system/create-cgroups.service
```

# Изменение адреса сервиса с которым работает judgehost

Для изменения адреса сервера (напр. для domserver) нужно отредактировать файл JUDGEHOST_HOME/domjudge/judgehost/etc/restapi.secret.

Если указать 2 сервера, то он будет поочерёдно отправлять запросы на каждый

### Пример

```
# Randomly generated on host azat-desktop, Пт мая  1 01:35:08 MSK 2020
# Format: '<ID> <API url> <user> <password>'
first-server	http://localhost/domjudge/api	judgehost	judgehost
second-server	http://192.168.0.2/domjudge/api	judgehost	judgehost
```


# Использование docker

### Пример использования контейнера от Domjudge

Ссылка на контейнер с инструкцией https://hub.docker.com/r/domjudge/judgehost/

Чтобы контейнер правильно работал нужно так же отредактировать GRUB_CMDLINE_LINUX_DEFAULT, но уже не нужно использовать create-cgroups и создавать службу.

Пример создания контейнера

```
docker pull domjudge/judgehost
docker container create -it --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --restart=always --name judgehost-0 --hostname judgedaemon-0 -e DAEMON_ID=1 -e DOMSERVER_BASEURL=http://localhost/domjudge domjudge/judgehost:latest

```

Где DOMSERVER_BASEURL - путь до domserver. `--restart=always` - можно удалить по усмотрению. Также стоит упомянуть, что я удалил `--link domserver:domserver`.

Для запуска контейнера использовать 

```
docker container start CONTAINER_ID
```

Где CONTAINER_ID - id контейнера, который можно посмотреть с помощью `docker container ls -a`
