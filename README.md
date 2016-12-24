# concourse-resource-samba

[concourse.ci](https://concourse.ci/ "concourse.ci Homepage") [resource](https://concourse.ci/implementing-resources.html "Implementing a resource") for persisting build artifacts on a shared storage location with samba.

- inspired by [concourse-rsync-resource](https://github.com/mrsixw/concourse-rsync-resource)

##Config
* `server`: *Required* Server on which to persist artifacts.
* `share`: *Required* Share name on `Server` in which to place the artifacts
* `path`: *Required* Base directory in which to place the artifacts
* `user`: *Required* User credential for login using ssh
* `password`: *Required* password for the specified user

All config required for each of the `in`, `out` and `check` behaviors.

###Example

``` yaml
resource_types:
- name: samba-resource
  type: docker-image
  source:
      repository: airtonix/concourse-resource-samba
      tag: latest

resources:
- name: samba-resource
  type: samba-resource
  source:
    server: my-server.lan
    share: storage
    user : user
    password: {{ samba_password_from_env }}

jobs:
-name: the-big-payback
  plan:
    get: samba-resource
      params: {"path" : "directory-name-we-want-to-fetch" }
    put: samba-resource
      params: {"path" : "directory-name-we-want-to-create" }
```

## Behavior

### `check` : Check for new versions of artifacts
- using smbclient, uses tar to backup `//server/share/path/$params.path` as `$params.path`
- generate an md5sum hash of the tarball as `version`

### `in` : retrieve a given artifacts from `server`
- same as `check`, but inspects `check.version` against `version`
- if it's different, Unpacks the tarball to current concourse workingd directory.

### `out` : place a new artifact on `server`
- archives the working directory into a tarball
- generates a md5sum hash of the tarball as the new `version`
- uploads and unpacks it via smb to `//server/share/path/$params.path`
- outputs the `version`

#### Parameters

* `path`: *Optional.* Directory to be bundled.