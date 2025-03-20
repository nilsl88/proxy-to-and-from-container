#!/bin/bash

# Ensure socat is installed
if ! command -v socat &>/dev/null; then
    echo "Error: socat is not installed. Install it and try again."
    exit 1
fi

# Function to display usage information
usage() {
    echo "Usage: $0 <from_server> <from_port> <to_server> <to_port> <tcp|udp|tcp & udp>"
    echo
    echo "Example:"
    echo "  $0 0.0.0.0 8080 192.168.1.10 9090 tcp          # Proxy TCP from all interfaces to 192.168.1.10"
    echo "  $0 192.168.1.100 5353 10.0.0.5 5354 udp        # Proxy UDP from specific IP"
    echo "  $0 0.0.0.0 8000 127.0.0.1 9000 \"tcp & udp\"    # Proxy both TCP & UDP locally"
    echo
    echo "Notes:"
    echo "- Ensure socat is installed on your system."
    echo "- Use 'ps aux | grep socat' to check running proxies."
    echo "- To stop all proxies, use: pkill -f \"socat\""
    exit 1
}

# Validate input arguments
if [ "$#" -ne 5 ]; then
    echo "Error: Incorrect number of arguments."
    usage
fi

FROM_SERVER=$1
FROM_PORT=$2
TO_SERVER=$3
TO_PORT=$4
PROTOCOL=$5

# Validate port numbers
if ! [[ "$FROM_PORT" =~ ^[0-9]+$ ]] || ! [[ "$TO_PORT" =~ ^[0-9]+$ ]]; then
    echo "Error: Ports must be numeric."
    usage
fi

# Function to start a proxy
start_proxy() {
    local from_server=$1
    local from_port=$2
    local to_server=$3
    local to_port=$4
    local proto=$5

    case "$proto" in
        "tcp")
            echo "Starting TCP proxy from $from_server:$from_port to $to_server:$to_port..."
            socat TCP-LISTEN:$from_port,bind=$from_server,fork TCP:$to_server:$to_port &
            ;;
        "udp")
            echo "Starting UDP proxy from $from_server:$from_port to $to_server:$to_port..."
            socat UDP-LISTEN:$from_port,bind=$from_server,fork UDP:$to_server:$to_port &
            ;;
        "tcp & udp")
            echo "Starting TCP & UDP proxy from $from_server:$from_port to $to_server:$to_port..."
            socat TCP-LISTEN:$from_port,bind=$from_server,fork TCP:$to_server:$to_port &
            socat UDP-LISTEN:$from_port,bind=$from_server,fork UDP:$to_server:$to_port &
            ;;
        *)
            echo "Error: Invalid protocol. Use 'tcp', 'udp', or 'tcp & udp'."
            usage
            ;;
    esac
}

# Start the proxy
start_proxy "$FROM_SERVER" "$FROM_PORT" "$TO_SERVER" "$TO_PORT" "$PROTOCOL"

echo "✅ Proxy running in the background. Use 'ps aux | grep socat' to check."
echo "🛑 To stop the proxy, use: pkill -f \"socat\""
