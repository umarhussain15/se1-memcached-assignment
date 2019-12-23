import os
import stat

def prepare_exp(SSHHost, SSHPort, REMOTEROOT, optpt):
    f = open("config", 'w')
    f.write("Host benchmark\n")
    f.write("   Hostname %s\n" % SSHHost)
    f.write("   IdentityFile ~/ubuntu_ssh/ssh_host_rsa_key\n")
    f.write("   StrictHostKeyChecking no\n")
    f.write("   Port %d\n" % SSHPort)
    f.close()
    

    f = open("run-experiment.sh", 'w')
    f.write("#!/bin/bash\n")
    f.write("set -x\n\n")

    # adjust this line to properly start memcached
    f.write("ssh -F config benchmark \"nohup memcached -u ubuntu -p 11211 -P memcached.pid > memcached.out 2> memcached.err &\"\n")
    
    f.write("RESULT=`ssh -F config benchmark \"pidof memcached\"`\n")

    f.write("sleep 5\n")

    f.write("if [[ -z \"${RESULT// }\" ]]; then echo \"memcached process not running\"; CODE=1; else CODE=0; fi\n")

    rate = optpt["noRequests"]
    # concurrency = 100
    concurrency = optpt["concurrency"]
    # start mcperf with given arguments
    f.write("mcperf --conn-rate=%d --num-calls=%d --num-conns=%d --call-rate=%d  -s %s &> stats.log\n\n" % (150, rate*20, concurrency, rate, SSHHost))

    # add a few lines to extract the "Response rate" and "Response time \[ms\]: av and store them in $REQPERSEC and $LATENCY"
    f.write("REQPERSEC=`cat stats.log | grep \"Response rate\" | cut -f 2 -d \":\" | cut -f 2 -d \" \"`\n")
    f.write("LATENCY=`cat stats.log | grep \"Response time \\[ms\\]: avg\" | cut -f 2 -d \":\" | cut -f 3 -d \" \"`\n")

    f.write("ssh -F config benchmark \"xargs kill -9 < memcached.pid\"\n")

    f.write("echo \"requests latency\" > stats.csv\n")
    f.write("echo \"$REQPERSEC $LATENCY\" >> stats.csv\n")
    
    f.write("scp -F config benchmark:~/memcached.* .\n")

    f.write("if [[ $(wc -l <stats.csv) -le 1 ]]; then CODE=1; fi\n\n")
    
    f.write("exit $CODE\n")

    f.close()
    
    os.chmod("run-experiment.sh", stat.S_IRWXU) 
