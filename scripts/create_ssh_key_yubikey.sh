#!/bin/bash

# SSH with FIDO2 authentification

# https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html

# Using Non discoverable key instruction for higher security
ssh-keygen -t ecdsa-sk -f sebastianyue_key_yue

