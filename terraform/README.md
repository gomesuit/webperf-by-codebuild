```bash
terraform init -backend-config "bucket=<my s3 bucket>"
```

```bash
$ cat terraform.tfvars
my_ip = "XXX.XXX.XXX.XXX/32"

git_repository = "https://github.com/gomesuit/webperf-by-codebuild.git"
```
