pages 153-170

--set and --values

To pass a value explicitly from the command line, use:
--set
for simple values, like env, version...

To specify values from a YAML file or URL, use:
--values
for complex values like list, map, etc = use yaml file.

---
making changes in wordpress-values.yaml
adding
replicaCount: 2
resources:
  requests:
    memory: 256Mi
    cpu: 100m

upgrade chart
helm upgrade wordpress bitnami/wordpress --values wordpress-values.yaml -n chapter3 --version 12.1.6

revision value is changed
helm list -n chapter3 

if you run upgrade without link to the custom values then values would be not changed to default chart values from custom
in our case
helm upgrade wordpress bitnami/wordpress -n chapter3 --version 12.1.6

then go to check values
helm get values wordpress -n chapter3

Different behavior can be observed when values are provided during an upgrade.
If values are passed via the --set or --values flags, all of the chart’s values that are not provided are reset to their defaults.

helm upgrade wordpress bitnami/wordpress --set replicaCount=1 --set wordpressUsername=helm-user --set wordpressPassword=my-password -n chapter3 --version 12.1.6
helm get values wordpress -n chapter3

[Important]
To prevent confusion during your upgrades and to simplify how values are
managed, try to manage all of your values in a values file. This provides a
more declarative approach, and it makes it clear which values will be applied
each time you upgrade.

