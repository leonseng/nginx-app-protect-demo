# Demo

To verify App Protect is working, use [Nikto](https://cirt.net/Nikto2) to run a test against the NGINX server

```
perl nikto.pl -h $(terraform output -raw nplus_public_ip)
```

App Protect should log the requests in `/var/log/nginx/app_protect/nginx-security.log`
