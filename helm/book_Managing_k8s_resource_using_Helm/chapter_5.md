pages 170-

view helm release revision history
kubectl get secrets -n chapter3
sh.helm.release.v1.wordpress.v1   helm.sh/release.v1   1      38m
sh.helm.release.v1.wordpress.v2   helm.sh/release.v1   1      13m
sh.helm.release.v1.wordpress.v3   helm.sh/release.v1   1      9m7s
sh.helm.release.v1.wordpress.v4   helm.sh/release.v1   1      4m9s

helm history wordpress -n chapter3
REVISION        UPDATED                         STATUS          CHART                   APP VERSION     DESCRIPTION     
1               Sat Feb 17 21:05:01 2024        superseded      wordpress-12.1.6        5.8.0           Install complete
2               Sat Feb 17 21:29:32 2024        superseded      wordpress-12.1.6        5.8.0           Upgrade complete
3               Sat Feb 17 21:33:56 2024        superseded      wordpress-12.1.6        5.8.0           Upgrade complete
4               Sat Feb 17 21:38:54 2024        deployed        wordpress-12.1.6        5.8.0           Upgrade complete

view values from specific revision
helm get values wordpress --revision 3 -n chapter3

rollback to the specific revision
helm rollback wordpress 3 -n chapter3 # actually creates new revision

helm history wordpress -n chapter3
REVISION        UPDATED                         STATUS          CHART                   APP VERSION     DESCRIPTION     
1               Sat Feb 17 21:05:01 2024        superseded      wordpress-12.1.6        5.8.0           Install complete
2               Sat Feb 17 21:29:32 2024        superseded      wordpress-12.1.6        5.8.0           Upgrade complete
3               Sat Feb 17 21:33:56 2024        superseded      wordpress-12.1.6        5.8.0           Upgrade complete
4               Sat Feb 17 21:38:54 2024        superseded      wordpress-12.1.6        5.8.0           Upgrade complete
5               Sat Feb 17 21:46:17 2024        deployed        wordpress-12.1.6        5.8.0           Rollback to 3 


removing\uninstalling release
helm uninstall wordpress -n chapter3 #removing everything

[Important]
check all k8s resources as pv\pvc might not be deleted with helm uninstall
In Kubernetes, PersistentVolumeClaim resources that are created by StatefulSets are not
automatically removed if the StatefulSet is deleted. During the helm
uninstall process, the StatefulSet was deleted but the associated
PersistentVolumeClaim was not, as expected.







1. What is Artifact Hub? How can a user interact with it to find charts and chart repositories?
Artifact Hub is a web-based platform for finding, sharing, and collaborating on Kubernetes-related packages, including Helm charts. Users can interact with Artifact Hub through its web interface, where they can search for charts and repositories using keywords, browse curated collections, view details about individual charts, and access documentation. Additionally, users can use the Artifact Hub API to programmatically interact with the platform and integrate it into their CI/CD pipelines or other workflows.

2. What is the difference between the helm get and helm show commands?
helm get and helm show are similar commands but serve slightly different purposes:
helm get is used to retrieve information about a specific release deployed in the cluster. It can display detailed information about a release, including its status, configuration, and notes.
helm show is used to display information about a chart or a specific resource within a chart. It can show metadata about the chart, values schema, and even render the templates without installing the chart.

3. What is the difference between the --set and --values parameters in the helm install and helm upgrade commands?
What are the benefits of using one over the other?
The --set and --values parameters in helm install and helm upgrade commands are used to customize the configuration of Helm charts:
--set allows users to override specific values in the chart's values.yaml file directly from the command line.
--values allows users to provide a YAML file containing custom configuration values for the chart.
The benefit of using --set is its simplicity for providing individual value overrides directly in the command line. On the other hand, --values is beneficial when dealing with more complex configurations or when managing multiple overrides in a structured YAML file.

4. What command can be used to provide the list of revisions for a release?
The helm history command can be used to provide the list of revisions for a release. It displays a history of releases, including revision numbers, the user who initiated the release, the status, and the time of deployment.

5. What happens by default when you upgrade a release without providing any values?
How does this behavior differ from when you do provide values for an upgrade?
By default, when you upgrade a release without providing any values, Helm retains the existing configuration values from the release. If you provide values during an upgrade, Helm applies those new values to the release, potentially modifying the configuration of the deployed resources.

6. Imagine that you have five revisions of a release. What would the helm
history command show after you roll back the release to revision 3?
After rolling back the release to revision 3 using helm rollback, the helm history command would show the five revisions, with revision 3 being the current release, and the newer revisions being marked as superseded or deleted.

7. Imagine that you want to view all of the releases deployed to a Kubernetes
namespace. What command should you run?
To view all releases deployed to a Kubernetes namespace, you should run the following command:
helm list -n <namespace>

8. Imagine that you run helm repo add to add a chart repository. What
command can you run to list all of the charts in that repository?
To list all charts in a specific chart repository after adding it using helm repo add, you can run the following command:
helm search repo <repository-name>
This command will display a list of charts available in the specified repository.