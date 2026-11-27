Here is the complete, final file tree for your repository, integrating your GNU Texinfo manual, GitHub Actions CI/CD pipeline, root Terraform configuration, and the lmlmxtend-runtime module with its test suites.

Complete Repository File Tree

```texi
Texi-/
├── .github/
│   └── workflows/
│       └── build-docs.yml          # CI/CD: Terraform fmt/validate/test, pytest, & Texinfo Pages deploy
├── .gitignore                      # Ignores compiled .info/.html/.pdf, TeX temp files, & .terraform/
├── Makefile                        # Automates local `make info`, `make html`, `make pdf`, & `make clean`
├── README.md                       # Root project overview and local build instructions
├── backend.tf                      # Remote S3 state storage with native `use_lockfile` state locking
├── main.tf                         # Root Terraform config wiring Hub VPC, Private Subnet, & module
│
├── doc/                            # GNU Texinfo Multi-File Documentation
│   ├── mymanual.texi               # Master Texinfo entry point (@titlepage, @top, @menu, @include)
│   ├── version.texi                # Release version and update date variables
│   ├── intro.texi                  # Chapter 1: Project overview and prerequisites
│   ├── usage.texi                  # Chapter 2: Command-line usage and flags
│   ├── infrastructure.texi         # Chapter 3: Terraform module, networking, & TTL reaper docs
│   └── include/
│       ├── macros.texi             # Shared @set variables and custom @macro definitions
│       └── fdl.texi                # Appendix: GNU Free Documentation License (FDL v1.3)
│
└── modules/
    └── lmlmxtend-runtime/          # Reusable AWS Compute & TTL Lifecycle Module
        ├── README.md               # Module-specific inputs, outputs, and architecture reference
        ├── versions.tf             # Terraform (>= 1.5.0), AWS, and Archive provider constraints
        ├── variables.tf            # Input declarations & validation rules (env, VPC, TTL, runtime)
        ├── main.tf                 # Security group, IAM role, and EC2 / ECS Fargate / Lambda compute
        ├── vpc_endpoints.tf        # PrivateLink Interface (SSM, ECR, Logs) & S3 Gateway endpoints
        ├── reaper.tf               # Hourly EventBridge rule and IAM permissions for TTL reaper
        ├── outputs.tf              # Exposes runtime_id, security_group_id, reaper ARN, & expires_at
        ├── reaper/
        │   ├── index.py            # Python 3.12 Lambda handler terminating expired tagged resources
        │   └── test_reaper.py      # Mocked boto3 pytest suite verifying TTL expiration logic
        └── tests/
         └── runtime.tftest.hcl  # Native `terraform test` suite validating plans and inputs
```
Use code with caution.

Pre-Push Verification Checklist

Run these commands from your repository root before pushing to main to confirm every component works cleanly together:
```bash
1. Verify Documentation Builds:bash
make all && make clean
Use code with caution.
```
2. Verify Terraform Formatting, Validation, and Unit Tests:bash
```bash
terraform fmt -check -recursive
cd modules/lmlmxtend-runtime
terraform init -backend=false
terraform validate
terraform test
```
Use code with caution.
3. Verify Python Reaper Unit Tests:bash
```
cd reaper && pytest -v
Use code with caution.
4. Commit and Push to Trigger GitHub Actions:bash
cd ../../..
git add .
git commit -m "Add complete Texinfo manual, Terraform runtime module, and CI tests"
git push origin main
```
Use code with caution.

Would you like help troubleshooting any GitHub Actions output once you push, or adding OIDC authentication (aws-actions/configure-aws-credentials) so GitHub Actions can run terraform plan against your live AWS account?
