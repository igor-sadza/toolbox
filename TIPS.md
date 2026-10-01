
#### Corporate network
```sh
sudo tee /etc/apt/apt.conf.d/80proxy >/dev/null <<'EOF'
Acquire::http::Proxy "http://<ENDPOINT>:<PORT>";
Acquire::https::Proxy "http://<ENDPOINT>:<PORT>";
EOF
```
