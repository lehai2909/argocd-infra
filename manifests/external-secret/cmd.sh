gcloud secrets add-iam-policy-binding k8s-secret \
  --project=org-tools-458804 \
  --role="roles/secretmanager.secretAccessor" \
  --member="principal://iam.googleapis.com/projects/328183267090/locations/global/workloadIdentityPools/org-tools-458804.svc.id.goog/subject/ns/demo/sa/demo-secrets-sa"

  gcloud container clusters describe autopilot-cluster-tools \
  --project=heroic-night-453607-n0