
mkdir "${HOME}/ubuntu_ssh"
ssh-keygen -t rsa -f "${HOME}/ubuntu_ssh/ssh_host_rsa_key" -q -N ''
# create sshd service config to start ssh server
echo "Port ${PORT}
HostKey ${HOME}/ubuntu_ssh/ssh_host_rsa_key
AuthorizedKeysFile  .ssh/authorized_keys
ChallengeResponseAuthentication no
UsePrivilegeSeparation no
UsePAM yes
Subsystem   sftp    /usr/lib/openssh/sftp-server
PidFile ${HOME}/ubuntu_ssh/sshd.pid" > "${HOME}/ubuntu_ssh/sshd_config"

# start ssh server with custom config
/usr/sbin/sshd -f "${HOME}/ubuntu_ssh/sshd_config"
#memcached -u ubuntu -l 127.0.0.1 -p 11211
#
#echo "memcached started"

tail -f /dev/null