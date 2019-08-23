export PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin

function env2cert {
    file=$1
    var="$2"
    (echo "$var" | sed 's/"//g' | grep '^-----' > /dev/null) &&
    (echo "$var" | sed -e 's/"//g' -e 's/\r//g' | sed -e 's/- /-\n/g' -e 's/ -/\n-/g' | sed -e '2s/ /\n/g' > $file) &&
    echo -n $file || echo -n
}

[ "x$SSL_CERT" != "x" -a ! -f "$SSL_CERT" ] && SSL_CERT=$(env2cert /etc/vsftpd/default.pem "$SSL_CERT")
[ "x$SSL_KEY" != "x" -a ! -f "$SSL_KEY" ] && SSL_KEY=$(env2cert /etc/vsftpd/default.key "$SSL_KEY")

if [ "x$FTP_OVER_SSL" = "x1" ]; then
	sed -e 's/^ssl_enable=NO.*/ssl_enable=YES/' /etc/vsftpd/vsftpd.conf > /etc/vsftpd/vsftpd.conf.new
	mv -f /etc/vsftpd/vsftpd.conf.new /etc/vsftpd/vsftpd.conf
else
	sed -e 's/^ssl_enable=YES.*/ssl_enable=NO/' /etc/vsftpd/vsftpd.conf > /etc/vsftpd/vsftpd.conf.new
	mv -f /etc/vsftpd/vsftpd.conf.new /etc/vsftpd/vsftpd.conf
fi

# set ftp user password
echo "kusanagi:${KUSANAGIPASS}" | /usr/sbin/chpasswd

if [ -z $1 ]; then
    /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
else
    $@
fi
