# inner-shadowsocks #

![img](https://i.v2ex.co/5iP665B4.png)

This is a simple app like `ss-local` in Golang. It is designed for running on a server inside China mainland and connecting a server outside through `shadowsocks`, then you can simply set `SOCKS5` proxy in your Chrome, Telegram etc. without running a client on your laptop or cell phones.

There is a python version of this app: [shadowsocks-with-socks-auth](https://github.com/ihciah/shadowsocks-with-socks-auth), which is just a small modified version of original shadowsocks adding `SOCKS5` auth support. This go version is more efficient and support multi-server balance.

#### Usage:

```shell
docker container run --restart=always -p 1086:1086 -v /root/inner-ss/config.json:/data/config.json -name 'inner-ss' -itd zhenhappy/inner-ss
```

Configure file:

A json string like

```json
{
  "listen": "0.0.0.0",
  "port": 1086,
  "auth": false,
  "username": "username",
  "password": "password",
  "servers": ["ss://RC4-MD5:pass1@ip1:port1", "ss://RC4-MD5:pass2@ip2:port2"],
  "maxfail": 3,
  "recovertime": 600,
  "starttimeout": 3,
  "remotetimeout": 120,
  "insidetimeout": 120,
  "whitelistenable": false,
  "whitelistdomains": [".telegram.org"],
  "whitelistips": ["::/0", "0.0.0.0/0", "91.108.4.0/22", "91.108.8.0/22", "91.108.12.0/22", "91.108.20.0/22", "91.108.36.0/23", "91.108.38.0/23", "91.108.56.0/22", "149.154.160.0/20", "149.154.164.0/22", "149.154.172.0/22", "2001:67c:4e8::/48"]
}
```

The `auth`, `username`, `password`, `maxfail`, `recovertime`, `remotetimeout`, `insidetimeout`, `starttimeout` are optional whose default value are `false`, `""`, `""`, `10`, `600`, `60`, `60`, `8` .

Also, `whitelistenable` is `false` by default. If you want to limit proxy only to some range, you can use `whitelistdomains` and `whitelistips` .

IP should follow CIDR format such as `100.110.120.130/32`. `::/0` means all IPv6, `0.0.0.0/0` means all IPv4. Domains will be matched by the suffix. Any domains has suffix matched in `whitelistdomains` can pass. For example, `www.github.com` will match `.github.com`.

If you set `auth` to `true`, you should provide `username` and `password`. 

You should list your servers in order. If one of them cannot be connected for `maxfail` times, it will be marked as downed-server until `recovertime` seconds later. Please pay attention that you must ensure the password and encryption method is correct. Because we cannot distinguish users' malicious requests and the wrong password of shadowsocks servers, here we judge server status through if we can connect it.

`remotetimeout` is the timeout connecting remote servers, and `insidetimeout` is the one to clients. `starttimeout`  is the timeout of the first communication. A short `starttimeout` can decrease the waiting time of the false packet, long `remotetimeout` and `insidetimeout` can allow long connection, for example to decrease the reconnecting of Telegram.
