FROM clover/base AS base

RUN groupadd \
        --gid 50 \
        --system \
        www \
 && useradd \
        --home-dir /var/www \
        --no-create-home \
        --system \
        --shell /bin/false \
        --uid 50 \
        --gid 50 \
        www

FROM library/debian:stable-slim AS build

ENV LANG=C.UTF-8 \
    SANDBOX_ROOT=/

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y wget openssl ca-certificates

ADD https://github.com/alemax-xyz/misc-tools.git#main /usr/local/bin/

RUN mkdir -p /build /rootfs

WORKDIR /build

COPY build/ .

COPY --from=clover/common:latest /var/lib/packages/ var/lib/packages/

RUN apt-sandbox --install --verstamp \
        --apt-config \
            APT::Install-Recommends=false \
            APT::Get::Upgrade==false \
        --repository . \
        --keyring . \
        --installed var/lib/packages \
        --obsolete packages.obsolete \
        --required packages.required

WORKDIR /rootfs
RUN rm -rf \
        etc/apache2/sites-available/* \
        etc/apache2/conf-available/* \
        etc/apache2/envvars \
        etc/cron* \
        etc/default \
        etc/gss/mech.d/README \
        etc/init.d \
        etc/logrotate.d \
        etc/ufw \
        usr/lib/systemd \
        usr/sbin/a2* \
        usr/sbin/apache2ctl \
        usr/sbin/apachectl \
        usr/sbin/check_forensic \
        usr/sbin/split-logfile \
        usr/share/apache2/build \
        usr/share/apache2/default-site \
        usr/share/apache2/error/README \
        usr/share/apache2/icons/README* \
        usr/share/apache2/apache2-maintscript-helper \
        usr/share/apache2/ask-for-passphrase \
        usr/share/apport \
        usr/share/bash-completion \
        usr/share/bug \
        usr/share/lintian \
        usr/share/locale \
        usr/share/doc \
        usr/share/man \
        var/www/html \
 && mkdir -p var/lock/apache2 run/apache2 \
 && ln -s /dev/stderr var/log/apache2//error.log \
 && ln -s /dev/stdout var/log/apache2/access.log \
 && find \
        etc/apache2/*.conf \
        etc/apache2/mods-available/*.conf \
    | xargs -I % sed -i -r \
        -e 's,[$][{]APACHE_PID_FILE[}],/var/run/apache2/apache2.pid,g' \
        -e 's,[$][{]APACHE_LOCK_DIR[}],/var/lock/apache2,g' \
        -e 's,[$][{]APACHE_RUN_DIR[}],/var/run/apache2,g' \
        -e 's,[$][{]APACHE_LOG_DIR[}],/var/log/apache2,g' \
        -e 's,[$][{]APACHE_RUN_USER[}],#${PUID},g' \
        -e 's,[$][{]APACHE_RUN_GROUP[}],#${PGID},g' \
        % \
 && ln -s ../conf-available/charset.conf etc/apache2/conf-enabled/charset.conf \
 && ln -s ../conf-available/log-format.conf etc/apache2/conf-enabled/log-format.conf \
 && ln -s ../conf-available/security.conf etc/apache2/conf-enabled/security.conf \
 && ln -s ../conf-available/tuning.conf etc/apache2/conf-enabled/tuning.conf \
 && ln -s ../sites-available/000-default.conf etc/apache2/sites-enabled/000-default.conf \
 && ln -s ../mods-available/access_compat.load etc/apache2/mods-enabled/access_compat.load \
 && ln -s ../mods-available/actions.load etc/apache2/mods-enabled/actions.load \
 && ln -s ../mods-available/alias.load etc/apache2/mods-enabled/alias.load \
 && ln -s ../mods-available/allowmethods.load etc/apache2/mods-enabled/allowmethods.load \
 && ln -s ../mods-available/auth_basic.load etc/apache2/mods-enabled/auth_basic.load \
 && ln -s ../mods-available/auth_digest.load etc/apache2/mods-enabled/auth_digest.load \
 && ln -s ../mods-available/authn_core.load etc/apache2/mods-enabled/authn_core.load \
 && ln -s ../mods-available/authn_file.load etc/apache2/mods-enabled/authn_file.load \
 && ln -s ../mods-available/authz_groupfile.load etc/apache2/mods-enabled/authz_groupfile.load \
 && ln -s ../mods-available/authz_core.load etc/apache2/mods-enabled/authz_core.load \
 && ln -s ../mods-available/authz_host.load etc/apache2/mods-enabled/authz_host.load \
 && ln -s ../mods-available/authz_user.load etc/apache2/mods-enabled/authz_user.load \
 && ln -s ../mods-available/deflate.load etc/apache2/mods-enabled/deflate.load \
 && ln -s ../mods-available/dir.load etc/apache2/mods-enabled/dir.load \
 && ln -s ../mods-available/env.load etc/apache2/mods-enabled/env.load \
 && ln -s ../mods-available/expires.load etc/apache2/mods-enabled/expires.load \
 && ln -s ../mods-available/ext_filter.load etc/apache2/mods-enabled/ext_filter.load \
 && ln -s ../mods-available/filter.load etc/apache2/mods-enabled/filter.load \
 && ln -s ../mods-available/headers.load etc/apache2/mods-enabled/headers.load \
 && ln -s ../mods-available/ident.load etc/apache2/mods-enabled/ident.load \
 && ln -s ../mods-available/include.load etc/apache2/mods-enabled/include.load \
 && ln -s ../mods-available/mime.load etc/apache2/mods-enabled/mime.load \
 && ln -s ../mods-available/mime.conf etc/apache2/mods-enabled/mime.conf \
 && ln -s ../mods-available/mpm_event.load etc/apache2/mods-enabled/mpm_event.load \
 && ln -s ../mods-available/mpm_event.conf etc/apache2/mods-enabled/mpm_event.conf \
 && ln -s ../mods-available/proxy.load etc/apache2/mods-enabled/proxy.load \
 && ln -s ../mods-available/proxy_fcgi.load etc/apache2/mods-enabled/proxy_fcgi.load \
 && ln -s ../mods-available/ratelimit.load etc/apache2/mods-enabled/ratelimit.load \
 && ln -s ../mods-available/remoteip.load etc/apache2/mods-enabled/remoteip.load \
 && ln -s ../mods-available/reqtimeout.load etc/apache2/mods-enabled/reqtimeout.load \
 && ln -s ../mods-available/reqtimeout.conf etc/apache2/mods-enabled/reqtimeout.conf \
 && ln -s ../mods-available/request.load etc/apache2/mods-enabled/request.load \
 && ln -s ../mods-available/rewrite.load etc/apache2/mods-enabled/rewrite.load \
 && ln -s ../mods-available/setenvif.load etc/apache2/mods-enabled/setenvif.load \
 && ln -s ../mods-available/vhost_alias.load etc/apache2/mods-enabled/vhost_alias.load

COPY --from=base /etc/group /etc/gshadow /etc/passwd /etc/shadow etc/
COPY rootfs/ .

WORKDIR /


FROM clover/common

ENV LANG=C.UTF-8

COPY --from=build /rootfs /

EXPOSE 80 443
