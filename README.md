# Пример использования
./setup-judgehost.sh JUDGEHOST_HOME

где JUDGEHOST_HOME - абсолютный путь, куда будет установлен judgehost (Например /home/ubuntu)

## ВНИМАНИЕ!
Для точного ограничение по памяти (для JVM например) нужно добавить в GRUB_CMDLINE_LINUX_DEFAULT в /etc/default/grub дополнительные парамерты `cgroup_enable=memory swapaccount=1`

### Пример

` GRUB_CMDLINE_LINUX_DEFAULT="quiet cgroup_enable=memory swapaccount=1" `

Выполнить update-grub и перезагрузиться.
После запустить JUDGEHOST_HOME/domjudge-source/misc-tools/create_cgroups

Стоит учитывать, что на некоторых машинах (напр. AWS) GRUB_CMDLINE_LINUX_DEFAULT переопределяется в /etc/default/grub.d/
