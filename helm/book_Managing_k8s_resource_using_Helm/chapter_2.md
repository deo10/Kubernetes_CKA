pages 103-119

1. How does Helm authenticate to a Kubernetes cluster?

Helm authenticates to a Kubernetes cluster typically by utilizing the Kubernetes configuration file (~/.kube/config by default) or by directly setting the kubeconfig environment variable (KUBECONFIG). This configuration file contains authentication details such as API server URL, cluster certificate authority, and user credentials (like tokens or certificates).

2. What mechanism is in place to provide authorization to the Helm client?
How can an administrator manage these privileges?

Authorization for the Helm client is usually managed by Kubernetes itself. Kubernetes Role-Based Access Control (RBAC) is commonly used to define what actions a user or service account can perform within the cluster. Helm operations, therefore, inherit these permissions. Administrators can manage these privileges by creating and managing RBAC roles and role bindings using Kubernetes resources like Role, ClusterRole, RoleBinding, and ClusterRoleBinding.

3. What is the purpose of the helm repo add command?

The helm repo add command is used to add a new Helm chart repository to the Helm client's list of repositories. This command allows users to specify a name for the repository and its corresponding URL. Once added, users can then search for and install charts from these repositories.

4. What are the three file paths that are used for storing Helm metadata? What does each path contain?

The three file paths used for storing Helm metadata are:
~/.helm/repository/cache: Contains cached copies of charts downloaded from repositories.
~/.helm/repository/local: Contains locally stored charts that have been added using helm repo add or helm install.
~/.helm/repository/repositories.yaml: Contains metadata about the repositories added to the Helm client, including their names and URLs.

5. How does Helm manage the state? What options are available to change? how the state is stored?

Helm manages the state primarily through the release records stored in the Kubernetes cluster. When you install a chart, Helm creates a release object in the cluster, which includes information about the release such as chart name, version, configuration, and status. By default, Helm stores release information in Kubernetes using a Secret resource. However, Helm also supports alternative storage backends such as SQL databases or AWS S3. Administrators can configure these storage options by modifying Helm's configuration or using plugins.