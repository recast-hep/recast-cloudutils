#!/bin/sh
cat /dev/stdin|base64 -d|openssl aes-256-cbc -d -pass "pass:$1"
