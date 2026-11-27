# Texinfo

This repository contains the Texinfo project manual, supporting documentation
sources, shell-based cleanup tests, and an optional Terraform stack for the
LMLMxtend AWS runtime.

## Documentation

Install GNU Texinfo. Install TeX Live as well if you want PDF output.

From the repository root:

- \`make info\` builds the GNU Info manual.
- \`make html\` builds the single-page HTML manual in \`mymanual_html/\`.
- \`make pdf\` builds \`mymanual.pdf\`.
- \`make all\` builds Info and HTML.
- \`make clean\` removes generated documentation artifacts.

The canonical manual is \`docs/mymanual.texinfo\`. Its chapters reuse the
maintained sources under \`doc/\`; the legacy \`my-manual/\` examples remain
available and have not been removed.

## Tests

Install Python 3.12 or newer, pytest, and boto3, then run:

\`\`\`sh
make test
\`\`\`

This runs the cleanup-macro shell tests and the TTL reaper unit tests.

## Terraform runtime

The root Terraform configuration provisions a VPC, private subnets, a private
route table, and the \`modules/lmlmxtend-runtime\` module. The module creates
interface and S3 gateway VPC endpoints, IAM roles, and a scheduled EC2 TTL
reaper Lambda.

Review and configure the AWS region, CIDRs, project name, environment, and TTL
through Terraform variables before planning.

Run validation without contacting or changing live infrastructure:

\`\`\`sh
terraform init -backend=false
terraform validate
terraform fmt -check -recursive

cd modules/lmlmxtend-runtime
terraform init -backend=false
terraform validate
terraform test
\`\`\`

The file under \`lmlmxtend_runtime/backend.tf\` is an unconfigured S3 backend
example. It is not part of the root Terraform stack. Replace its placeholder
bucket and configure state storage deliberately before using it.

GitHub Actions runs documentation builds, unit tests, and Terraform validation.
It does not apply infrastructure changes automatically.
