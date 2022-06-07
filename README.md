# ssh-udp-port-forwarding
UDP remote port forwarding with sshd and socat.

This reposotory is an example of how to forward udp packets from a publicly accessible internet sshd server back to an ssh client machine.  Normal ssh port forwarding only tunnels tcp connections, so this will use socat to convert a bidirectional udp port to tcp on the server and then back to udp on the client.
