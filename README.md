# Ruby DNS Tunnel
This is incomplete proof of concept work to show how one can send data via crafted DNS requests.

We delegate a subdomain e.g tun.greg.com to be served by our bogus DNS server.

tun.greg.com. IN  A   10.10.10.10
tun.greg.com. IN  NS  tun.greg.com.

Requests contain a 6 char random string to prevent issues with cached requests.

I ran this on port 5351 locally because DNSmasq was using 53. If you want this to work
over the public nets you should use port 53.

You are responsible for your own actions, you should not misuse DNS in this way.
