FROM coredns/coredns:1.11.1

COPY Corefile /Corefile

ENTRYPOINT ["/coredns", "-conf", "/Corefile"]
