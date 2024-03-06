az account set --subscription $LG_SUB
# Create a resource group 
RG_NAME="cost-optimized-cas"
CLUSTER_NAME="cost-optimized-cas" 
LOCATION="eastus" 

az group create --name $RG_NAME --location $LOCATION 
az aks create --resource-group $RG_NAME --name $CLUSTER_NAME --node-count 3 --enable-addons monitoring --generate-ssh-keys --tier Standard --enable-cluster-autoscaler --min-count 1 --max-count 10 --node-vm-size Standard_DS2_v2 --cluster-autoscaler-profile scan-interval=30s,scale-down-unneeded-time=3m,scale-down-unready-time=3m,max-graceful-termination-sec=30,skip-nodes-with-local-storage=false,max-empty-bulk-delete=1000,max-total-unready-percentage=100,ok-total-unready-count=1000,scale-down-delay-after-add=10m --enable-cost-analysis

az aks get-credentials --resource-group $RG_NAME --name $CLUSTER_NAME
kubectl taint nodes CriticalAddonsOnly=true:NoSchedule --all --overwrite

# Add a 4 and 8 core node pool 
az aks nodepool add --resource-group $RG_NAME --cluster-name $CLUSTER_NAME --name np4 --node-count 0 --node-vm-size Standard_DS4_v2 --min-count 0 --max-count 50 --enable-cluster-autoscaler
az aks nodepool add --resource-group $RG_NAME --cluster-name $CLUSTER_NAME --name np8 --node-count 0 --node-vm-size Standard_DS8_v2 --min-count 0 --max-count 50 --enable-cluster-autoscaler
az aks nodepool add --resource-group $RG_NAME --cluster-name $CLUSTER_NAME --name np16 --node-count 0 --node-vm-size Standard_DS16_v2 --min-count 0 --max-count 50 --enable-cluster-autoscaler 
az aks nodepool add --resource-group $RG_NAME --cluster-name $CLUSTER_NAME --name np32 --node-count 0 --node-vm-size Standard_DS32_v3 --min-count 0 --max-count 50 --enable-cluster-autoscaler

