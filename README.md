# Пример использования
./setup-judgehost.sh JUDGEHOST_HOME

где JUDGEHOST_HOME - абсолютный путь, куда будет установлен judgehost (Например /home/ubuntu)

# Установка точного ограничения памяти
Для точного ограничение по памяти (для JVM например) нужно добавить в GRUB_CMDLINE_LINUX_DEFAULT в /etc/default/grub дополнительные парамерты `cgroup_enable=memory swapaccount=1`. Стоит учитывать, что на некоторых машинах (напр. AWS) GRUB_CMDLINE_LINUX_DEFAULT переопределяется в /etc/default/grub.d/

### Пример

` GRUB_CMDLINE_LINUX_DEFAULT="quiet cgroup_enable=memory swapaccount=1" `

Далле вполнить update-grub, добавить create-cgroups.service как службу и перезагрузить машину

### Пример

`sudo cp JUDGEHOST_HOME/domjudge-source/misc-tools/create-cgroups.service /etc/systemd/system/create-cgroups.service`


