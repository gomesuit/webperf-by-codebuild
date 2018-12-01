```bash
$ cat terraform.tfvars
my_ip = "XXX.XXX.XXX.XXX/32"

git_repository = "https://github.com/gomesuit/webperf-by-codebuild.git"
```

```bash
$ cat backend.tfvars
bucket = "example-terraform"
```

```bash
terraform init -backend-config backend.tfvars
```
