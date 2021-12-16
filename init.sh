#!/usr/bin/bash
cp .env.default .env
echo "$(openssl rand -base64 20)" > .vault-pass