FROM golang:latest AS builder

# Download coredns to /go/coredns.
WORKDIR /go
RUN git clone https://github.com/coredns/coredns
WORKDIR /go/coredns

# Enable "alternate" plugin, before the "forward" plugin.
RUN sed -i "s/forward:forward/alternate:github.com\/coredns\/alternate\\nforward:forward/" plugin.cfg

# Enable "records" plugin, after the "hosts" plugin. (Used for mocking).
RUN sed -i "s/hosts:hosts/hosts:hosts\\nrecords:github.com\/coredns\/records/" plugin.cfg

# Build the coredns binary.
RUN make

# Copy the coredns binary to its own image.
FROM alpine:latest AS coredns
COPY --from=builder /go/coredns/coredns /usr/bin/coredns
RUN mkdir -p /etc/coredns

# Include a blank whois Corefile.
COPY Corefile /etc/coredns/Corefile
ENTRYPOINT [ "coredns", "-conf", "/etc/coredns/Corefile" ]
