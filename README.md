## Apache httpd docker image

This image is based on official `apache2` package for debian and is built on top of [clover/common](https://hub.docker.com/r/clover/common/).

### Enviroment variables

| Name | Default value | Description
| ---- | ------------- | -----------
| `PUID` | _not set_ | desired user id of the process owner
| `PGID` | _not set_ | desired group id of the process pwner (primary group of the `PUID` user)
| `PUSER` | _not set_ | desired `PUID` user name
| `PGROUP` | _not set_ | desired `PGID` group name
| `CHOWN` | _not set_ | space-separated list of directories to change ownership to `PUID`/`PGID` during container startup
| `CRON` | _not set_ (`0`) | will start _cron_ inside the container if set to `1`
| `TZ` / `TIMEZONE` | _not set_ (`UTC`) | desired container timezone

### Configuration files

| Location | Description
| -------- | -----------
| `/etc/apache2/apache2.conf` | Main apache configuration file
| `/etc/apache2/sites-available/` | Extra apache configuration files - available sites
| `/etc/apache2/sites-enabled/` | Extra apache configuration files - enabled sites (usually symlincs to available sites)
| `/etc/apache2/conf-available/` | Extra apache configuration files - available configurations
| `/etc/apache2/conf-enabled/` | Extra apache configuration files - enabled configurations (usually symlincs to available configurations)
| `/etc/apache2/mods-available/` | Extra apache configuration files - available modules
| `/etc/apache2/mods-enabled/` | Extra apache configuration files - enabled modules (usually symlincs to available modules)

### Supported platforms

 * `linux/amd64`;
 * `linux/386`;
 * `linux/arm/v7`;
 * `linux/arm64/v8`;
 * `linux/ppc64le`;
 * `linux/s390x`;
