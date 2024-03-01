# youtube video
https://youtu.be/EonWeoFPpvM?si=siY6t0rbSfZ2mf2P

# installation
https://external-secrets.io/latest/introduction/getting-started/

Option 1: Install from chart repository
helm repo add external-secrets https://charts.external-secrets.io

helm install external-secrets \
   external-secrets/external-secrets \
    -n external-secrets \
    --create-namespace \
  # --set installCRDs=false

Option 2: Install chart from local build
Build and install the Helm chart locally after cloning the repository.

make helm.build

helm install external-secrets \
    ./bin/chart/external-secrets.tgz \
    -n external-secrets \
    --create-namespace \
  # --set installCRDs=false

Create a secret containing your AWS credentials
echo -n 'KEYID' > ./access-key
echo -n 'SECRETKEY' > ./secret-access-key

kubectl create secret generic awssm-secret --from-file=./access-key --from-file=./secret-access-key

