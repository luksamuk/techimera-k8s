from diagrams import Cluster, Diagram
from diagrams.k8s.clusterconfig import HPA
from diagrams.k8s.compute import Deployment, Pod
from diagrams.k8s.network import Ingress, Service
from diagrams.k8s.storage import PV, PVC
from diagrams.k8s.podconfig import ConfigMap, Secret

graph_attr = {
    "bgcolor": "transparent"
}

with Diagram("Backend", show=False, outformat="png", graph_attr=graph_attr, filename="techimera/backend-arq", direction='LR'):
    api_ingress = Ingress("/api")
    backend_svc = Service("backend (LoadBalancer)")
    backend_secret = Secret("backend-secret")
    backend_config = ConfigMap("backend-configmap")
    backend = Deployment("backend-deployment")
    backend_hpa = HPA("backend-hpa (CPU 85%)")
    api_ingress >> backend_svc >> backend
    backend << backend_secret
    backend << backend_config
    backend << backend_hpa
    with Cluster("Pods", direction='TB'):
        backend - Pod("backend")

with Diagram("PostgreSQL", show=False, outformat="png", graph_attr=graph_attr, filename="techimera/pgsql-arq"):
    postgres_svc = Service("postgresql (ClusterIP)")
    postgres_secret = Secret("postgresql-secret")
    postgres_config = ConfigMap("postgresql-init-configmap")
    postgres_pvc = PVC("postgresql-pvc (1Gi)")
    postgres = Deployment("postgresql-deployment")
    postgres_svc >> postgres
    postgres << postgres_secret
    postgres << postgres_config
    postgres << postgres_pvc
    postgres - Pod("") - PV("1Gi")
    
with Diagram("PgAdmin4", show=False, outformat="png", graph_attr=graph_attr, filename="techimera/pgadmin-arq"):
    pgadmin_ingress = Ingress("/pgadmin")
    pgadmin_svc = Service("pgadmin (NodePort)")
    pgadmin_secret = Secret("pgadmin-secret")
    pgadmin_config = ConfigMap("pgadmin-configmap")
    pgadmin_pvc = PVC("pgadmin-pvc (300Mi)")
    pgadmin = Deployment("pgadmin")
    pgadmin_ingress >> pgadmin_svc >> pgadmin
    pgadmin << pgadmin_secret
    pgadmin << pgadmin_config
    pgadmin << pgadmin_pvc
    pgadmin - Pod("") - PV("300Mi")
