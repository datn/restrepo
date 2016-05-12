s3-backup Cookbook
==================
back up db streams or given directories

Requirements
------------
#### packages
- `yum`
- `s3fs`

Attributes
----------
e.g.
#### s3_backup::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>[':s3_backup'][':backuppath']</tt></td>
    <td>string</td>
    <td>path for backups</td>
    <td><tt>/backups</tt></td>
  </tr>
  <tr>
    <td><tt>[':s3_backup'][':postgres']</tt></td>
    <td>string</td>
    <td>postgres dbs to back up (mysql assumes all dbs)</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>[':s3_backup'][':dirs']</tt></td>
    <td>string</td>
    <td>space-separated list of directories to back up</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>[':s3_backup'][':splitsize']</tt></td>
    <td>string</td>
    <td>filesize for db streams -- 5G max for S3</td>
    <td><tt>5G</tt></td>
  </tr>
</table>

node.default[:s3_backup][:backuppath]="/backups"
node.default[:s3_backup][:postgres][:dbs]="postgres"
node.default[:s3_backup][:dirs]=""
node.default[:s3_backup][:splitsize]="5G"


Usage
-----
#### s3_backup::default

Include `s3_backup` in your node's `run_list` and set appropriate attribs:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[s3_backup]"
  ]
}
```


License and authors
-------------------
Authors: Dan Shick
License: CC BY-SA 4.0
