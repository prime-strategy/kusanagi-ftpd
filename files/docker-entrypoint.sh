# set ftp user password
echo "kusanagi:${KUSANAGIPASS}" | /usr/sbin/chpasswd

if [ -z $1 ]; then
    /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
else
    $@
fi
