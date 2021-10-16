Simple Docker and Kubernetes Tests
# Multistage dockerfile

FROM golang:alpine as stage1

ENV GO111MODULE=on

WORKDIR /app

ADD ./ /app

RUN apk update --no-cache

RUN apk add git

RUN go build -o golang-test  .

FROM golang:alpine as stage2

WORKDIR /data

COPY --from=stage1 /app/golang-test .

ENTRYPOINT ["/data/golang-test"]

EXPOSE 8000

# Kubernetes deployment steps
  
   # Deployment 
   1. git clone to my fork repo (git clone https://github.com/bsownda/technical-tests.git)

   2. Docker image build 
   docker build -t golang-test .

   3. Docker push  using dockerhub credentials 
   docker tag golang-test:latest bsownda/golang-test:latest

   docker push bsownda/golang-test:latest

   4. Kubernetes manifest files (Kubernetes_manifest)
    deployment.yaml
    I have created simple kubernetes manifest file for deployment with two replicas

    image : bsownda/golang-test:latest

    replicas : 2 for (HA)

    compute : 1Core,1 GB memory


    kubectl apply -f deployment.yaml

# Exposing service

    1. service.yaml - exposing 8000 using service.yaml, which is contain service type,selector ,protocal and port 

    2. In kubernetes four service type is available 

    3. ClusterIP (default) - Exposes the Service on an internal IP in the cluster. This type makes the Service only reachable from within the cluster.
    
    4. NodePort - Exposes the Service on the same port of each selected Node in the cluster using NAT. Makes a Service accessible from outside the cluster using <NodeIP>:<NodePort>. Superset of ClusterIP.

    5. LoadBalancer - Creates an external load balancer in the current cloud (if supported) and assigns a fixed, external IP to the Service. Superset of NodePort.

    6. ExternalName - Maps the Service to the contents of the externalName field (e.g. foo.bar.example.com), by returning a CNAME record with its value. No proxying of any kind is set up. This type requires v1.7 or higher of kube-dns, or CoreDNS version 0.0.8 or higher.

    7. I am using ClusterIP on kubernetes service manifest .

    kubectl apply -f service.yaml 

 # HPA - Horizontal Pod Autoscaler

    The Horizontal Pod Autoscaler automatically scales the number of Pods in a replication controller, deployment, replica set or stateful set based on observed CPU utilization (or, with custom metrics support, on some other application-provided metrics). Note that Horizontal Pod Autoscaling does not apply to objects that can't be scaled, for example, DaemonSets.

    kubectl apply -f hpa.yaml








     

