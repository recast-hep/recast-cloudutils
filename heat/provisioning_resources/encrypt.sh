#!/bin/sh
cat /dev/stdin|openssl aes-256-cbc -base64 -e -pass "pass:$1"
