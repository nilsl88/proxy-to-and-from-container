#!/bin/bash

# Ensure socat is installed
if ! command -v socat &>/dev/null; then
    echo "Error: socat is not installed. Install it and try again."
    exit 1
fi

# Function to display usage information
usage() {
    echo "Usage: $0 <from_port> <to_port> <tcp|udp|tcp & udp>"
    echo
    echo "Example:"
    echo "  $0 8080 9090 tcp         # Proxy TCP from port 8080 to 9090"
    echo "  $0 5353 5354 udp         # Proxy UDP from port 5353 to 5354"
    echo "  $0 8000 9000 \"tcp & udp\"  # Proxy both TCP and UDP"
    echo
    echo "Notes:"
    echo "- Ensure socat is installed on your system."
    echo "- Use 'ps aux | grep socat' to check running proxies."
    echo "- To stop all proxies, use: pkill -f \"socat\""
    exit 1
}

# Validate input arguments
if [ "$#" -ne 3 ]; then
    echo "Error: Incorrect number of arguments."
    usage
fi

FROM_PORT=$1
TO_PORT=$2
PROTOCOL=$3

# Validate port numbers
if ! [[ "$FROM_PORT" =~ ^[0-9]+$ ]] || ! [[ "$TO_PORT" =~ ^[0-9]+$ ]]; then
    echo "Error: Ports must be numeric."
    usage
fi

# Function to start a proxy
start_proxy() {
    local from=$1
    local to=$2
    local proto=$3

    case "$proto" in
        "tcp")
            echo "Starting TCP proxy from port $from to port $to..."
            socat TCP-LISTEN:$from,fork TCP:127.0.0.1:$to &
            ;;
        "udp")
            echo "Starting UDP proxy from port $from to port $to..."
            socat UDP-LISTEN:$from,fork UDP:127.0.0.1:$to &
            ;;
        "tcp & udp")
            echo "Starting TCP & UDP proxy from port $from to port $to..."
            socat TCP-LISTEN:$from,fork TCP:127.0.0.1:$to &
            socat UDP-LISTEN:$from,fork UDP:127.0.0.1:$to &
            ;;
        *)
            echo "Error: Invalid protocol. Use 'tcp', 'udp', or 'tcp & udp'."
            usage
            ;;
    esac
}

# Start the proxy
start_proxy "$FROM_PORT" "$TO_PORT" "$PROTOCOL"

echo "✅ Proxy running in the background. Use 'ps aux | grep socat' to check."
echo "🛑 To stop the proxy, use: pkill -f \"socat\""
