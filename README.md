mera terraform ka code git hub reppo m hai mujhe git hub action se pipeline banana hai to ushe liye kya kya pre-requisit hai or kaise banate hai git hub action se pipeline detail m batao

Aapka objective hai: Terraform code ko GitHub pe push karke GitHub Actions se automatic pipeline (CI/CD) chalana — jisse aapka infrastructure Azure (ya kisi aur cloud) pe deploy ho.

Chaliye, isko detail mein step-by-step samjhte hain, including prerequisites aur GitHub Actions workflow banane ka process:

🔧 Step 1: Pre-requisites
1.1. ✅ Terraform code ready hona chahiye
Ensure you have a working Terraform project in your GitHub repo (main.tf, variables.tf, etc.)

1.2. ✅ Azure credentials (agar aap Azure use kar rahe ho)
You need to create a Service Principal in Azure and save its credentials in GitHub Secrets.

Run this in Azure CLI:

az ad sp create-for-rbac --role="Contributor" \
  --scopes="/subscriptions/<your-subscription-id>" \
  --sdk-auth
Replace <your-subscription-id> with your Azure subscription ID.

This will return a JSON like this:

{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "...",
  "activeDirectoryEndpointUrl": "...",
  "resourceManagerEndpointUrl": "...",
  "clientCertificate": null,
  ...
}
1.3. ✅ Add this JSON to GitHub secrets
Go to your GitHub repo → Settings → Secrets and variables → Actions → New repository secret

Create a secret named:

nginx
AZURE_CREDENTIALS
Paste the entire JSON output in the value.

📁 Step 2: Setup Terraform GitHub Actions workflow
Create a directory in your repo:

.github/workflows/
Inside it, create a file like:

terraform.yml
✅ Example GitHub Actions workflow (terraform.yml)
yaml
name: Terraform CI/CD

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  terraform:
    name: 'Terraform Apply'
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v3
      with:
        terraform_version: 1.6.6

    - name: Authenticate with Azure
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Terraform Init
      run: terraform init

    - name: Terraform Validate
      run: terraform validate

    - name: Terraform Plan
      run: terraform plan

    - name: Terraform Apply
      if: github.ref == 'refs/heads/main' && github.event_name == 'push'
      run: terraform apply -auto-approve
💡 Optional Enhancements
Use terraform fmt -check to check formatting

Add a backend block in main.tf to store state remotely (e.g., in Azure Blob Storage)

Add environments for dev/stage/prod using workflows or workspaces

🧪 Test your pipeline
Push changes to the main branch:

git add .
git commit -m "Added GitHub Actions pipeline"
git push origin main
Go to GitHub → Actions tab in your repo. You'll see the pipeline running.

✅ Summary
Step	Description
Create Azure SP	az ad sp create-for-rbac ...
Save secret	Add to GitHub as AZURE_CREDENTIALS
Add workflow	.github/workflows/terraform.yml
Push code	Triggers the GitHub Actions pipeline
