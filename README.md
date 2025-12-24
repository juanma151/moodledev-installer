It only works if using it as nix shell
======================================

*(at the moment)*

## Table of Contents

- [It only works if using it as nix shell](#it-only-works-if-using-it-as-nix-shell)
  - [CREATES A MOODLE INSTANCE](#creates-a-moodle-instance)
  - [OPEN AN EXISTENT MOODLE INSTANCE](#open-an-existent-moodle-instance)
  - [CHANGING THE DEFAULT OPTIONS](#changing-the-default-options)
    - [List of options](#list-of-options)
    - [Example](#example)
    - [Base Dir as positional argument](#base-dir-as-positional-argument)

## CREATES A MOODLE INSTANCE
```
$ nix develop --impure github:juanma151/moodledev-installer

(nix:moodledev-installer-shell-env)$ moodle-install my-moodle
(nix:moodledev-installer-shell-env)$ ./my-moodle/bin/start
... mariadb php and apache will start
... once they are started open http://localhost:8080
... default username admin
... default password moodle-root
```

* `my-moodle` is just the folder where we want to install the moodle data
* inside it there is a `bin` folder with several scripts, including `start` and `stop`

## OPEN AN EXISTENT MOODLE INSTANCE

Imagine we have a moodle instance (installed with `moodle-install`) in `/usr/share/my-moodle`

```
$ nix develop --impure github:juanma151/moodledev-installer
(nix:moodledev-installer-shell-env)$ /usr/share/my-moodle/bin/start
... mariadb php and apache will start
... once they are started open http://localhost:8080 (or the configured servername and port)
```

## CHANGING THE DEFAULT OPTIONS

`moodle-install` can get a bunch of arguments to configure the moodle instance.

### List of options

| argument | desc | default value |
|----------|------|---------------|
| --base-dir | Folder to install the moodle instance | ./moodle-var |
| | | |
| --db-name | DB name | moodle |
| --db-user | DB username | moodle |
| --db-pass | DB password | moodle |
| --db-prefix | DB table prefix | mdl_ |
| --db-root-pass | DB root password (not used atm) | moodle-root |
| | | |
| --site-root | Moodle PHP files | [nix store moodle package] |
| --site-servername | ServerName for apache | `localhost` |
| --site-port | port for apache | 8080 |
| | | |
| --moodle-lang | language | es |
| | | |
| --moodle-admin-user | moodle admin username | admin |
| --moodle-admin-pass | moddle admin password | moodle-root |
| --moodle-admin-email | moodle admin email | `admin@example.com` |
| --moodle-admin-fullname | moodle admin fullname | 'Moodle Dev Admin' |
| --moodle-admin-shortname | moodle admin shortname | ADMIN |

### Example
```
$ nix develop --impure github:juanma151/moodledev-installer
(nix:moodledev-installer-shell-env)$ moodle-install \
  --moodle-admin-user moodle-admin \
  --moodle-admin-pass 'my_secret_pass' \
  --site-port 8090
```

### Base Dir as positional argument
Adding a positional argument to `moodle-install` behaves as `--base-dir`

```
$ nix develop --impure github:juanma151/moodledev-installer
(nix:moodledev-installer-shell-env)$ moodle-install \
  --moodle-admin-user moodle-admin \
  --moodle-admin-pass 'my_secret_pass' \
  --site-port 8090 \
  my_folder
```

If there is a flag argument `--base-dir FOLDER_1` and a psitional argument `FOLDER_2`, the flag will have precedence.

In the following example, the base folder will be `my_flag_folder`

```
$ nix develop --impure github:juanma151/moodledev-installer
(nix:moodledev-installer-shell-env)$ moodle-install \
  --base-dir my_flag_folder \
  --moodle-admin-user moodle-admin \
  --moodle-admin-pass 'my_secret_pass' \
  --site-port 8090 \
  my_folder
```

