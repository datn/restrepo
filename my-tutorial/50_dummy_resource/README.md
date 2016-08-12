50 - Dummy resource
===================

This section includes a pipeline using a new resource called `dummy`.

Failing to find new resource
----------------------------

```
./50_*/run.sh
```

Will include an error that looks like:

```
no workers satisfying: resource type 'dummy'

available workers:
  - platform 'linux'
errored
```

Your concourse does not yet have a resource registered called `dummy`.

Create dummy resource
---------------------

```
vagrant ssh
```

Change to root user:

```
sudo su -
```

In `/var/vcap/packages` create `dummy` and copy another resource package (a rootfs) into it and create a `opt/resources/out`

```
cd /var/vcap/packages
mkdir dummy
cp -r time_resource/* dummy/
cd dummy/opt/resource
rm *
```

Now create the `in`, `out`, and `check` files. For now, put the following in all the files:

```bash
#!/bin/sh

echo '{"version": {"ref": "123"}}'
```

And make them executable:

```
chmod +x *
```

Add new resource type into worker
---------------------------------

```
vi /var/vcap/jobs/groundcrew/config/worker.json
```

The top-level of this JSON are the keys: `platform`, `tags`, `addr`, and `resource_types`. We want to add our new resource type to the latter's list.

Add to the tail:

```
,{"image":"/var/vcap/packages/dummy","type":"dummy"}]}
```

Exit and restart the `beacon` monit process (see `/var/vcap/jobs/groundcrew/monit` for definition):

```
monit restart beacon
```

From the host machine, the new resource type will now be registered with Concourse ATC's API:

```
curl http://192.168.100.4:8080/api/v1/workers
```

Run a job that uses resource type
---------------------------------

The simplest pipeline to use this new resource type is:

```yaml
jobs:
- name: job-dummy
  public: true
  serial: true
  plan:
  - put: resource-dummy
resources:
- name: resource-dummy
  type: dummy
```

Deploy the pipeline:

```
fly -t tutorial configure -c pipeline.yml job-dummy --paused=false
```

*What to do if your pipeline deploys in the paused state*

In some cases, even if you deploy with the `--paused=false` flag, the pipeline will deploy in the paused state. When this happens, you will see the following:

```
$ fly -t tutorial configure -c pipeline.yml job-dummy --paused=false
resources:
  resource resource-dummy has been added:
    name: resource-dummy
    type: dummy
    source: {}

jobs:
  job job-dummy has been added:
    name: job-dummy
    public: true
    serial: true
    plan:
    - put: resource-dummy

apply configuration? (y/n): y
pipeline created!
you can view your pipeline here: http://192.168.100.4:8080/pipelines/job-dummy

the pipeline is currently paused. to unpause, either:
  - run again with --paused=false
  - click play next to the pipeline in the web ui
```

Even if you run the command again with the `--paused=false` flag, the pipeline will remain in the paused state. This can only be resolved by going to the UI (note the blue banner, indicating the pipeline is paused):

![Paused pipeline](https://s3.amazonaws.com/f.cl.ly/items/3X302y3h0f2H151S211o/Initial_deploy_pause.png)

To unpause the pipeline you must open the menu in the upper left corner and click the blue play icon next to the pipeline name:

![Pause/play button](https://s3.amazonaws.com/f.cl.ly/items/290Q0H0y2v3F2U2m0A1C/Initial_deploy_menu_button.png)

Note that clicking the pause/play button next to the job name will not unpause the pipeline. Once the pipeline is unpaused, it will look like this:

![Unpaused pipeline](https://s3.amazonaws.com/f.cl.ly/items/2R1B1y2T3J470V2D0Q3E/Pipeline_run_unpaused.png)

Once the pipeline is unpaused, you can either click the (+) icon in the UI or run the pipeline from the CLI:

```
curl http://192.168.100.4:8080/pipelines/job-dummy/jobs/job-dummy/builds -X POST
```

![dummy](http://cl.ly/image/3N292T3b2a0g/dummy_resource.png)
