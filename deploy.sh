#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "Usage: ./deploy.sh <project_id>"
  exit 1
fi

PROJECT_ID=$1

IMAGE_NAME="docker.io/${DOCKERHUB_USERNAME}/zyte_cloud"
TAG="latest"

echo "Deploying to project ID: ${PROJECT_ID}"

# Build the Docker image
echo "Building Docker image for linux/amd64..."
docker buildx build --platform=linux/amd64 -t spiders-image:latest --load .

# Tag and push the Docker image to Docker Hub
echo "Tagging image for Docker Hub..."
docker tag spiders-image:latest ${IMAGE_NAME}:${TAG}
echo "Pushing image to Docker Hub..."
docker push ${IMAGE_NAME}:${TAG}

# Update scrapinghub.yml with the correct image and tag
echo "Updating scrapinghub.yml for project ${PROJECT_ID}..."
cat <<EOL > scrapinghub.yml
projects:
  default: ${PROJECT_ID}
requirements_file: requirements.txt
image: ${IMAGE_NAME}:${TAG}
EOL

# Deploy the image to Zyte
echo "Deploying image to Zyte..."
shub image deploy --version ${TAG} --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PAT}

echo "Deployment to project ${PROJECT_ID} completed successfully."
