# GCP Produder Consumer

This project is a website status poller that uses GCP's Pub/Sub to move info about website status to a yet to be determined SQL database. 


## Table of Contents

* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Features](#features)
* [Screenshots](#screenshots)
* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Project Status](#project-status)
* [Room for Improvement](#room-for-improvement)
* [Acknowledgements](#acknowledgements)
* [Contact](#contact)


## General Information

This is for my own practice and trainning.

The idea is to create a scalable web monitor application that feeds information about website availability over a GCP's Pub/Sub instance to be inserted  into an SQL database, yet to be determined.


## Technologies Used

- Python    - version 3.10.4
- Git       - version 2.36.1


## Features

List the ready features here:

- 


## Screenshots




## Requirements

- Python 3.6+
- Terraform X.X


## Installation

First, create a project in GCP so we can start creating the infrastructure in it.
After that's done, we need to create the service account and the bucket where we are gonna store the Terraform state for the infrastructure. In order to achieve that, here is a snipet in bash that does so:

```bash
# Set project
# PROJECTID="<YOUR-PROJECT-UNIQUE-ID>"
PROJECTID="muscia-test"
gcloud config set project $PROJECTID

# Set region and zone - Use 'gcloud compute zones list' to check options
LOCATION_REGION="europe-west1"
LOCATION_ZONE="europe-west1-b"
gcloud config set compute/region $LOCATION_REGION
gcloud config set compute/zone $LOCATION_ZONE

# Grant permission to the build API
gcloud services enable appengine.googleapis.com bigquery.googleapis.com bigquerystorage.googleapis.com cloudapis.googleapis.com cloudbuild.googleapis.com clouddebugger.googleapis.com cloudresourcemanager.googleapis.com cloudtrace.googleapis.com containerregistry.googleapis.com datastore.googleapis.com logging.googleapis.com monitoring.googleapis.com pubsub.googleapis.com servicemanagement.googleapis.com serviceusage.googleapis.com sql-component.googleapis.com storage-api.googleapis.com storage-component.googleapis.com storage.googleapis.com

# Create service account and grant the necessary permissions
ACCOUNT_NAME="cloud-build-${PROJECTID}"
gcloud iam service-accounts create ${ACCOUNT_NAME} --display-name "${ACCOUNT_NAME}" --description "Service account used for ${PROJECTID} in GitHub and deploying in" 

# We need to assign the roles one by one, hence the loop
LISTROLES=( --role="roles/storage.admin" --role="roles/viewer" --role="roles/iam.serviceAccountUser" --role="roles/cloudbuild.builds.editor" --role="roles/appengine.appCreator" --role="roles/appengine.appAdmin" --role="roles/pubsub.editor" --role="roles/cloudfunctions.developer" )
for ROLE in "${LISTROLES[@]}"; do gcloud projects add-iam-policy-binding ${PROJECTID} --member="serviceAccount:${ACCOUNT_NAME}@${PROJECTID}.iam.gserviceaccount.com" $ROLE; done

# Create credentials for that service account
gcloud iam service-accounts keys create secrets/service-account-credentials.json --iam-account ${ACCOUNT_NAME}@${PROJECTID}.iam.gserviceaccount.com

# Create the bucket for the Terraform state with a unique name
RANDOM_VALUE=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 8)
gsutil mb -c standard -l europe-west1 gs://bucket-tf-${PROJECTID}-${RANDOM_VALUE}

# Give permissions for the Pub/Sub service account
gcloud projects add-iam-policy-binding ${PROJECTID} --member=serviceAccount:service-<PROJECT-NUMBER-ID>@gcp-sa-pubsub.iam.gserviceaccount.com --role=roles/iam.serviceAccountTokenCreator
```




## Usage

### Producer simple usage



## Project Status
Project is: _Getting started_.


## Room for Improvement
Include areas you believe need improvement / could be improved. Also add TODOs for future development.

Room for improvement:
- Restrict API creation on the start and put it in Terraform
- Terraform IaC
    - Improve way to auto configure bucket for state
    - Usage for terraform.tfvars?
    - PubSub permissions in README?
- Makefiles
- Show data for web services in a Grafana


## Acknowledgements
Give credit here.
- This project was helped by [Python](https://www.python.org/).
- This project was inspired on the [README cheatsheet](https://github.com/ritaly/README-cheatsheet).
- Help on UUID in bash is from [here](https://linuxhint.com/generate-random-string-bash/)
- Instructions on setting backend for Terraform can be checked on this [link](https://gmusumeci.medium.com/how-to-configure-the-gcp-backend-for-terraform-7ea24f59760a)
- How to create functions in [Terraform](https://ruanmartinelli.com/posts/terraform-cloud-functions-nodejs-api)
- Cloud scheduler information was taken from [here](https://medium.com/geekculture/setup-gcp-cloud-functions-triggering-by-cloud-schedulers-with-terraform-1433fbf1abbe)


## Contact
Created by [@thaeimos]

