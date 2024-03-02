
az account set --subscription $LG_SUB
# Create a resource group 
RG_NAME="default-cas"
CLUSTER_NAME="default-cas" 
LOCATION="eastus" 

az group create --name $RG_NAME --location $LOCATION 
az aks create --resource-group $RG_NAME --name $CLUSTER_NAME --node-count 3 --enable-addons monitoring --generate-ssh-keys --sku Standard --enable-cluster-autoscaler --min-count 1 --max-count 10 --node-vm-size Standard_DS2_v2 --enable-cost-analysis
az aks get-credentials --resource-group $RG_NAME --name $CLUSTER_NAME
kubectl taint nodes CriticalAddonsOnly=true:NoSchedule --all --overwrite

# Add a 4 and 8 core node pool 
az aks nodepool add --resource-group $RG_NAME --cluster-name $CLUSTER_NAME --name np4 --node-count 0 --node-vm-size Standard_DS4_v2 --min-count 0 --max-count 50 --enable-cluster-autoscaler
az aks nodepool add --resource-group $RG_NAME --cluster-name $CLUSTER_NAME --name np8 --node-count 0 --node-vm-size Standard_DS8_v2 --min-count 0 --max-count 50 --enable-cluster-autoscaler
az aks nodepool add --resource-group $RG_NAME --cluster-name $CLUSTER_NAME --name np16 --node-count 0 --node-vm-size Standard_DS16_v2 --min-count 0 --max-count 50 --enable-cluster-autoscaler 
az aks nodepool add --resource-group $RG_NAME --cluster-name $CLUSTER_NAME --name np32 --node-count 0 --node-vm-size Standard_DS32_v3 --min-count 0 --max-count 50 --enable-cluster-autoscaler
