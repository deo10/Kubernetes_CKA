Task 3: Test a Chart
Install the mariadb chart with default values. Once installed:

Run Helm’s built-in test mechanism to validate if the release is running correctly.
Report the status of the Helm tests afterward.

Steps to Complete Task 3:
# Install the mariadb chart with default values:
$ helm install mariadb bitnami/mariadb
# Run Helm's built-in test mechanism:
$ helm test mariadb
# Report the status of the Helm tests:
$ helm test mariadb --logs
# Check the status of the release:
$ helm status mariadb