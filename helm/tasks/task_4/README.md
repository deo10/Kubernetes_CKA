Task 4: Explore Chart Information
Find and display the following information about the postgresql Helm chart:

The available versions in the repository.
The default values for the chart.
A description of the chart and its maintainers.

# steps to complete the task
1. Use the `helm search repo` command to find the postgresql chart and its versions:
```bash
   $ helm search repo postgresql
```
2. Use the `helm show values` command to display the default values for the chart:
```bash
   $ helm show values bitnami/postgresql
```
3. Use the `helm show chart` command to display the chart's metadata, including its description and maintainers:
```bash
   $ helm show chart bitnami/postgresql
```
4. Use the `helm search repo` command with the `--versions` flag to list all available versions of the postgresql chart:
```bash
   $ helm search repo postgresql --versions
```
5. Use the `helm show readme` command to display the README file of the chart, which often contains additional information about the chart:
```bash
$ helm show readme bitnami/postgresql
```