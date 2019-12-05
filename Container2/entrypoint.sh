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

# copy this container's ssh public key to given path, which will be bind to server container. This will allow this
# container to ssh to server container
cat  "${HOME}/ubuntu_ssh/ssh_host_rsa_key.pub" >> "${HOME}/share_pkey/authorized_keys"

# clone dude source
hg clone https://bitbucket.org/db7/dude

cd dude || exit

# install dude
python setup.py install --home="${HOME}/local"

echo "dude installed"

# keep this container running
tail -f /dev/null