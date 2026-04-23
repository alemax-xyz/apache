#!/bin/sh

export PUID PGID PUSER PGROUP
exec apache2 -D FOREGROUND
