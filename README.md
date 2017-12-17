# ProjectTriangle

# develop

```
docker-compose -f docker-compose.yml -f docker-compose-dev.yml build
docker-sync-stack start
```

## pry

```
docker attach project_triangle
```

# deploy

## Add deployment

Replace v* <- here
```
export PROJECT_ID="$(gcloud config get-value project -q)"

docker build -t gcr.io/${PROJECT_ID}/project-triangle-server:v* .

gcloud docker -- push gcr.io/${PROJECT_ID}/project-triangle-server:v*

kubectl set image deployment/project-triangle-server project-triangle-server=gcr.io/${PROJECT_ID}/project-triangle-server:v*
```

cf: https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app?hl=ja  

## Change version

Change project-triangle image version number.

```
image: gcr.io/project-triangle-189113/project-triangle-server:v*
```

https://console.cloud.google.com/kubernetes/deployment/asia-east1-a/cluster-1/default/project-triangle?project=project-triangle-189113&hl=ja&tab=yaml&duration=PT1H&deployment_active_revisions_tablesize=50&pod_summary_list_tablesize=20