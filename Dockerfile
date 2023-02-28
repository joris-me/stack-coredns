FROM golang:latest AS coredns-builder

# Download coredns to /go/coredns.
WORKDIR /go
RUN git clone https://github.com/coredns/coredns

# Update plugin.cfg to include the "alternate" plugin before the "forward" plugin.
WORKDIR /go/coredns
RUN sed -i "s/forward:forward/alternate:github.com\/coredns\/alternate\\nforward:forward/" plugin.cfg



# Build the coredns binary.
RUN make