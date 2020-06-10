# Пример использования
./setup-judgehost.sh JUDGEHOST_HOME

где JUDGEHOST_HOME - абсолютный путь, куда будет установлен judgehost (Например /home/ubuntu)

## ВНИМАНИЕ!
Для точного ограничение по памяти (для JVM например) нужно обновить GRUB_CMDLINE_LINUX_DEFAULT в /etc/default/grub, выполнить update-grub и перезагрузиться.
После запустить JUDGEHOST_HOME/domjudge-source/misc-tools/create_cgroups
