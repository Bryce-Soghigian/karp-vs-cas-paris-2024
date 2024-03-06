az account set --subscription $LG_SUB 

# Create a resource group 
RG_NAME="karpenter-default" 
CLUSTER_NAME="karpenter-default" 
LOCATION="eastus" 
az group create --name $RG_NAME --location $LOCATION 
az aks create --resource-group $RG_NAME --name $CLUSTER_NAME --node-count 3 --enable-addons monitoring --tier Standard --node-provisioning-mode Auto --network-policy cilium --network-plugin-mode overlay --network-plugin azure --network-dataplane cilium --enable-cost-analysis
az aks get-credentials --resource-group $RG_NAME --name $CLUSTER_NAME 
kubectl taint nodes CriticalAddonsOnly=true:NoSchedule --all --overwrite
