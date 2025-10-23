#!/bin/bash

###############################################################################
# Static Website Deployment Script to Azure Blob Storage
# Capstone Project: TechCrush Group 3
# A Project by Chibueze Benjamin Chikelu (Aspiring DevOps Engineer)
#
# What this script does:
# 1. Creates a Resource Group (if it doesn’t exist)
# 2. Creates a Storage Account
# 3. Enables Static Website Hosting
# 4. Uploads the HTML, CSS, and Image files to the $web container
# 5. Displays the live website URL at the end
###############################################################################

# ---------------------------
# ===== VARIABLES/CONFIGURATIONS (USER-DEFINED) =====
# ---------------------------
RESOURCE_GROUP="Chibuezecapstone"
STORAGE_ACCOUNT="chibuezeblob"
LOCATION="uksouth"
SOURCE_FOLDER="ChibuezeStaticSite"

# ---------------------------
# ===== Script to Create a Resource Group =====
# ---------------------------
echo " Creating resource group: $RESOURCE_GROUP (if it doesn't exist)..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# ---------------------------
# ===== Script to Create Storage Account =====
# ---------------------------
echo " Creating storage account: $STORAGE_ACCOUNT..."
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2

# ---------------------------
# ===== Script to Enable Static Website Hosting =====
# ---------------------------
echo " Enabling static website hosting..."
az storage blob service-properties update \
  --account-name $STORAGE_ACCOUNT \
  --static-website \
  --index-document index.html
  

# ---------------------------
# ===== Script to Upload Static Files =====
# ---------------------------
echo " Uploading files from $SOURCE_FOLDER to Azure Blob Storage..."
az storage blob upload-batch \
  --account-name $STORAGE_ACCOUNT \
  --destination '$web' \
  --source . \
  --overwrite

# ---------------------------
# ===== Script to Get Website URL =====
# ---------------------------
WEB_URL=$(az storage account show \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --query "primaryEndpoints.web" \
  -o tsv)

echo " Deployment complete!"
echo " Your static website is live at:"
echo "$WEB_URL"
