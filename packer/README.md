## Building the AMI

### Initialize Packer
```bash
cd packer
packer init nginx-ami.pkr.hcl
```

### Validate Configuration
```bash
packer validate -var-file=variables.pkrvars.hcl nginx-ami.pkr.hcl
```

### Build AMI
```bash
packer build -var-file=variables.pkrvars.hcl nginx-ami.pkr.hcl
```