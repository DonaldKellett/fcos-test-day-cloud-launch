# fcos-test-day-cloud-launch

Automated, hassle-free launch of FCOS instances with Ignition config on selected public clouds, for FCOS [test days](https://fedoraproject.org/wiki/QA/Test_Days)

**Disclaimer: by following instructions in this repo, you acknowledge that you are solely responsible for any and all monetary costs incurred as a result of utilizing public cloud services.**

## Getting started

To make the most out of this repo, you need [Terraform](https://www.terraform.io/) installed. Then, clone this repo and make it your working directory:

```bash
$ git clone https://github.com/DonaldKellett/fcos-test-day-cloud-launch.git
$ cd fcos-test-day-cloud-launch
```

## The Ignition config

`fcos-test-day.ign` is generated from the equivalent Butane config `fcos-test-day.bu` with [Butane](https://coreos.github.io/butane/). It configures the FCOS instance with:

- A single user `clouduser` with password `clouduser` and passwordless `sudo`
- Password login via SSH enabled

Needless to say, this is insecure and should not be used in production. But for the use case of FCOS test days where such instances are created and destroyed quickly, it should not be too much of a security concern. If you're still worried that an attacker might log in to your instance in the meantime, you may customize the Ignition config with your SSH public key and disable password login with SSH for maximum security.

For more information on [configuring users](https://docs.fedoraproject.org/en-US/fedora-coreos/authentication/) with Ignition config, refer to the FCOS docs.

## Cloud launch

### AWS

It is assumed you have [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) installed and configured with an IAM user with sufficient permissions to manage EC2-related resources.

Make this project your working directory. Now move into the `aws` directory:

```bash
$ cd aws
```

Initialize the project:

```bash
$ terraform init
```

Now make note of the latest AMI for the [FCOS `next` stream](https://getfedora.org/en/coreos/download?tab=cloud_launchable&stream=next&arch=x86_64), and export it to an environment variable `FCOS_AMI_ID`:

```bash
$ export FCOS_AMI_ID="ami-XXXXXXXXXXXXXXXXX"
```

Apply the Terraform config with this AMI and answer `yes` when prompted:

```bash
$ terraform apply -var fcos_ami="$FCOS_AMI_ID"
```

This launches a `t2.micro` instance by default using the AMI provided. I chose `t2.micro` since it is free-tier eligible, so if your free tier has not expired yet then hopefully you should not incur any costs. If you wish to use another instance type anyway, you can do so by specifying the optional `fcos_instance_type` variable, e.g.

```bash
$ terraform apply -var fcos_ami="$FCOS_AMI_ID" -var fcos_instance_type="m5.large"
```

Wait for the associated resources to be created, and then note down the public IP of the instance reported by Terraform and export it to an environment variable `FCOS_PUBLIC_IP`:

```bash
$ export FCOS_PUBLIC_IP="X.X.X.X"
```

If you left the Ignition config in this repo intact, you should now be able to SSH into your instance, typing the password `clouduser` when prompted:

```bash
$ ssh clouduser@"$FCOS_PUBLIC_IP"
```

Run a few commands on the instance to confirm everything is working as expected, then exit the session:

```bash
$ exit
logout
Connection to X.X.X.X closed.
```

Now tear down the infrastructure to save costs, answering `yes` when prompted:

```bash
$ terraform destroy -var fcos_ami="$FCOS_AMI_ID"
```

If you specified an instance type other than `t2.micro`, you'll need to specify the `fcos_instance_type` variable accordingly as well with the above command.

Congratulations! You have completed the [Cloud launch - AWS](https://fedoraproject.org/wiki/QA:Testcase_CoreOS_AWS) test case for FCOS.

### GCP

This assumes you have [Google Cloud SDK](https://cloud.google.com/sdk) installed and have [application default credentials](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login) configured. If not, run `gcloud auth application-default login` after installing the SDK. Furthermore, you should have a [Google Cloud project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) ready.

Make this project your working directory. Now move into the `gcp` directory:

```bash
$ cd gcp
```

Initialize the project:

```bash
$ terraform init
```

Export the project ID in an environment variable `GCP_PROJECT_ID`:

```bash
$ export GCP_PROJECT_ID="XXXXXXXXXX"
```

Now apply the config, answering `yes` when prompted. The `project_id` input variable must be specified; all others are optional:

```bash
$ terraform apply -var project_id="$GCP_PROJECT_ID"
```

Once the resources are created, Terraform reports the public IP of the instance. Export that in an environment variable `FCOS_PUBLIC_IP`:

```bash
$ export FCOS_PUBLIC_IP="X.X.X.X"
```

Now connect to the instance, entering `clouduser` as the password when prompted:

```bash
$ ssh clouduser@"$FCOS_PUBLIC_IP"
```

Run a few commands in the instance to confirm everything is working as expected. Now exit the session:

```bash
$ exit
logout
Connection to X.X.X.X closed.
```

Tear down the infrastructure to save costs, specifying the same set of variables as you did with `apply`:

```bash
$ terraform destroy -var project_id="$GCP_PROJECT_ID"
```

Congratulations! You have completed the [Cloud launch - GCP](https://fedoraproject.org/wiki/QA:Testcase_CoreOS_GCP) test case for FCOS.

P.S. here's a list of optional variables supported:

| Name | Description | Default value |
| --- | --- | --- |
| `region` | The region to launch the instance in | `us-central1` |
| `zone` | The zone to launch the instance in within the specified region | `us-central1-a` |
| `machine_type` | The instance type to use | `e2-micro` |
| `fcos_stream` | The stream to use for the FCOS instance | `next` |

## License

[MIT](./LICENSE)
