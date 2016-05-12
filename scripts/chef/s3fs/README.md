s3fs Cookbook
==================
installs and configures s3fs and mounts a given bucket at a given mountpoint 

Requirements
------------

Attributes
----------

e.g.
#### s3fs::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['s3fs']['mountpoint']</tt></td>
    <td>String</td>
    <td>absolute path to mount point</td>
    <td><tt>"/mnt/doesntexist"</tt></td>
  </tr>
  <tr>
    <td><tt>['s3fs']['bucket']</tt></td>
    <td>String</td>
    <td>s3 bucket</td>
    <td><tt>"NONE"</tt></td>
  </tr>
</table>

Usage
-----
#### s3fs::default

Just include `s3fs` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[s3fs]"
  ]
}
```

or you can write a wrapper setting the atrributes and including the s3fs::default recipe.

License and Authors
-------------------
Authors: Dan Shick
