# Microsoft Web IQ Demo

A demo of Microsoft Web IQ, covering customer management, scopes, search through the REST API, the MCP Server, and the Python SDK. It deploys its Azure prerequisites with Terraform and walks through each step in a Jupyter notebook.

> **Note:** I'm lazy and had an agent create this README. If there are mistakes, blame Anthropic!

## Repository layout

| Path | Purpose |
| --- | --- |
| [notebooks/web-iq-demo.ipynb](notebooks/web-iq-demo.ipynb) | The demo notebook. Run it top to bottom. |
| [infra/](infra/) | Terraform configuration that deploys the Web IQ account and resource group. |
| [images/](images/) | Portal screenshots referenced by the notebook. |
| [requirements.txt](requirements.txt) | Python packages the notebook needs, including `webiq==1.2.1`. |
| [.env.example](.env.example) | Template for the `.env` file the notebook writes to. |

## Prerequisites

- An Azure subscription where you can create resources.
- Permission in Microsoft Entra ID to create app registrations and service principals.
- Azure CLI, signed in with `az login`.
- Terraform.
- Python with Jupyter.

## Setup

1. Create and activate a virtual environment, then install the requirements:

   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

2. Copy `.env.example` to `.env`. The notebook fills in the values it creates.

3. Open [notebooks/web-iq-demo.ipynb](notebooks/web-iq-demo.ipynb) and run the cells in order.

## Notebook sections

| Section | What it covers |
| --- | --- |
| 0. Pre-reqs | Installs libraries, configures logging, signs in with the Azure CLI, creates a service principal, and deploys Terraform resources. |
| 1. Administer access | Grants the service principal access to the Customer Management API and binds an Entra app to a Web IQ AppID. |
| 2. Create scopes | Lists authorized billing accounts and AppIDs, then creates a Web IQ scope. |
| 3. REST search | Runs `auto` searches without a scope, with an exclude scope, and with an include scope. |
| 4. MCP Server | Lists the tools on the Web IQ MCP Server and runs a web search through it. |
| 5. SDK | Uses the `webiq` Python SDK for auto search, web and news search, and Browse fetch. |
| 6. Clean up | Destroys the Terraform resources and deletes the service principal. |

## Cleanup

Section 6 runs `terraform destroy` and then deletes the service principal. Deleting the Web IQ resource also removes its scopes, so the notebook doesn't delete scopes separately.

The service principal delete needs permission to manage app registrations. If the Azure CLI is signed in as a service principal without that permission, the delete fails with "Insufficient privileges". In that case, sign in with a user account that has the role, or delete the app registration in the Entra portal.

## Security notes

- `.env` holds the service principal's client secret. It's listed in [.gitignore](.gitignore) and must not be committed.
- Terraform state files (`*.tfstate`) and `*.tfvars` are also ignored, because they can contain secrets.
- The notebook reads secrets from environment variables and doesn't hardcode them.
- The Terraform step currently passes the full notebook environment to Terraform, so every variable in `.env` is visible to it.