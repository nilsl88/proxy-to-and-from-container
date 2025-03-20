# A simple proxy to and from container 

🚀 How to Use

1️⃣ Make the script executable:

chmod +x proxy-port.sh

2️⃣ Run with proper arguments:
```
./proxy-port.sh <from_port> <to_port> <tcp|udp|tcp & udp>
```
Examples:
```
./proxy-port.sh 8080 9090 tcp          # Proxy TCP
./proxy-port.sh 5353 5354 udp          # Proxy UDP
./proxy-port.sh 8000 9000 "tcp & udp"  # Proxy both TCP & UDP
```
3️⃣ Check running proxies:
```
ps aux | grep socat
```
4️⃣ Stop all proxies:
```
pkill -f "socat"
```


## Container 


1️⃣ Build the Docker Image
```
alias docker=podman 
docker build -t proxy-container .
```

2️⃣ Run the Container

To start the TCP/UDP proxy, run:
```
docker run -d --name proxy \
    --network host \
    proxy-container 8080 9090 "tcp & udp"

    The --network host flag allows direct port binding without extra Docker NAT.
    Modify 8080 and 9090 for different ports as needed.
```
3️⃣ Verify the Proxy is Running

Check running socat processes:
```
docker logs proxy
```
4️⃣ Stop the Proxy
```
docker stop proxy && docker rm proxy
```
