# masscanbot
Automating masscan to process domains in parrallel

# filename with IPs or domains
rangefile=filename.txt 

#take top XX from nmap, as masscan doesn't knowwhat is top-ports
ports=40

#Maximum number of threads. Will sleep for 2 secs if reached
threads=10

# Masscan rate
mrate=1000

# Maximum time to resolve 1 DNS record while host operation
timeout=3

# Log file )
logfile=log.txt
