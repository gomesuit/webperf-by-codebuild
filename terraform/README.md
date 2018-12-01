# terraform.tfvarsの作成

```bash
$ cp terraform.tfvars.sample terraform.tfvars
$ vim terraform.tfvars
```

# backend.tfvarsの作成

```bash
$ cp backend.tfvars.sample backend.tfvars`
$ vim backend.tfvars
```

# terraform init

```bash
terraform init -backend-config backend.tfvars
```
