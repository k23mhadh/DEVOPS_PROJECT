#!/bin/bash

kubectl apply -f db-manifest.yaml
kubectl apply -f redis-manifest.yaml
kubectl apply -f result-manifest.yaml
kubectl apply -f vote-manifest.yaml
kubectl apply -f worker-manifest.yaml


# Wait for pods to be ready
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=db --timeout=120s
kubectl wait --for=condition=ready pod -l app=redis --timeout=120s
kubectl wait --for=condition=ready pod -l app=vote --timeout=120s
kubectl wait --for=condition=ready pod -l app=result --timeout=120s
kubectl wait --for=condition=ready pod -l app=worker --timeout=120s

# Finally deploy the seed job once everything is running
kubectl apply -f seed-manifest.yaml

echo "Deployment completed successfully!"
echo "Getting service information..."
kubectl get services