```bash
$ cp terraform.tfvars.sample terraform.tfvars
$ vim terraform.tfvars
```

```bash
$ cp backend.tfvars.sample backend.tfvars`
$ vim backend.tfvars
```

```bash
terraform init -backend-config backend.tfvars
```
