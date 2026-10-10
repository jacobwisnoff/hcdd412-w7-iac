# hcdd412-w7-iac

This template provisions the core Azure resources needed for a simple web application with Azure AI Language support.

## What the template creates

The Bicep template deploys the following resources in a target Azure resource group:

- A Linux App Service plan named `'<appName>-<environment>-plan'` on the Basic B1 tier
- A Linux Web App named `'<appName>-<environment>'` running Node.js 20 LTS
- HTTPS-only configuration with TLS 1.2 minimum and FTP disabled
- A Language resource using the Azure AI Text Analytics service (`Microsoft.CognitiveServices/accounts`) with a free F0 SKU
- An output called `languageEndpoint` that exposes the deployed language service endpoint

This is useful for hosting a lightweight app and connecting it to Azure AI Language for natural language processing.

## How to deploy it

1. Sign in to Azure:

   ```bash
   az login
   ```

2. Create or select a resource group:

   ```bash
   az group create --name <resource-group-name> --location <azure-region>
   ```

3. Deploy the template:

   ```bash
   az deployment group create \
     --resource-group <resource-group-name> \
     --template-file main.bicep \
     --parameters appName=<unique-app-name> environment=dev location=<azure-region>
   ```

4. After deployment, view the output values:

   ```bash
   az deployment group show \
     --resource-group <resource-group-name> \
     --name <deployment-name> \
     --query properties.outputs
   ```

You can change the `environment` value to `staging` or `prod` as needed.

## Example JSON result

```json
{
  "kind": "SentimentAnalysisResults",
  "results": {
    "documents": [
      {
        "id": "1",
        "sentiment": "positive",
        "confidenceScores": {
          "positive": 1.0,
          "neutral": 0.0,
          "negative": 0.0
        },
        "sentences": [
          {
            "sentiment": "positive",
            "confidenceScores": {
              "positive": 1.0,
              "neutral": 0.0,
              "negative": 0.0
            },
            "offset": 0,
            "length": 57,
            "text": "The deployment finished cleanly and the team is thrilled."
          }
        ],
        "warnings": []
      }
    ],
    "errors": [],
    "modelVersion": "2025-01-01"
  }
}
```