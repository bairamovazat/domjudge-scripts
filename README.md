# Пример использования
./setup-judgehost.sh  /home/ubuntu
где /home/ubuntu - абсалютный путь, куда будет установлен judgehost

В конце процесса, нужно изменить GRUB_CMDLINE_LINUX_DEFAULT в /etc/default/grub на:  
GRUB_CMDLINE_LINUX_DEFAULT="quiet cgroup_enable=memory swapaccount=1"
