pages 385 - 423
# Testing Helm Charts

# Validating template generation locally with helm template

-> helm template [NAME] [CHART] [flags]
-> helm template my-guestbook guestbook

Some common aspects of chart development that you may want to validate
throughout are as follows:
-> Parameterized fields are successfully replaced by default or overridden values
-> Control structures such as if, range, and with successfully generate YAML based on the provided values.
-> Resources contain proper spacing and indentation.
-> Functions and pipelines are used correctly to properly format and manipulate YAML.
-> Input validation mechanisms such as the required and fail functions or
the values.schema.json file properly validate values based on user input.
-> Dependencies have been declared properly and their resource definitions
appear in the helm template output.

# Adding server-side validation to chart rendering

If you would like to ensure that your resources are valid after they have been generated, you can
use the --validate flag to instruct helm template to communicate with the Kubernetes API server:
-> helm template my-release <chart_name> --validate

As an alternative approach, you can apply the -- dry-run flag against the install, upgrade, rollback, and uninstall commands. Here is an example of using this flag with the install command:
-> helm install my-chart <chart_name> --dry-run


# Linting Helm charts and templates

Linting a Helm chart involves two high-level steps:
1. Ensuring that a Helm chart is valid
2. Ensuring that a Helm chart follows consistent formatting practices
To ensure that a Helm chart is valid, we can use the helm lint command,
which has the following syntax:

-> helm lint <chart-name> [flags]

The helm lint command is great for checking whether your chart contains
the appropriate contents, but it does not carry out exhaustive linting of your
chart’s YAML style. To perform this type of linting, you can use another tool
called yamllint, which can be found at
https://github.com/adrienverge/yamllint.

-> helm template my-guestbook chapter9/guestbook | yamllint -

output to determine its line numbers:
-> cat -n <(helm template my-guestbook chapter9/guestbook)

The yamllint tool performs linting against many different rules, including the
following:
- Indentation
- Line length
- Trailing spaces
- Empty lines
- Comment format


# Testing in a live cluster

Testing can involve, but is not limited to, the following two different
constructs:
- Readiness probes and the helm install --wait command
- Test hooks and the helm test command

A readiness probe is a type of health check in Kubernetes that, upon success,
marks a pod as Ready and makes the pod eligible to receive ingress traffic. An
example of a readiness probe is located at chapter9/guestbook/templates/deployment.yaml:
readinessProbe:
  httpGet:
    path: /
    port: http

This readiness probe will mark the pod as Ready when an HTTP GET request
succeeds against the / path.

-> helm install my-guestbook chapter9/guestbook --wait

Also support the --wait flag include upgrade, rollback, and uninstall.


Besides readiness probes, testing in Helm can also be performed by using test
hooks and the helm test command. Test hooks are pods that perform custom
tests after the Helm chart is installed to confirm they execute successfully.
They are defined under the templates directory and contain the
helm.sh/hook: test annotation.
When the helm test command is run, templates with the test annotation are created and execute their defined functions.
We can see an example test in chapter9/guestbook/templates/tests/testconnection.yaml:
(helm\guestbook\templates\tests\test-connection.yaml)

apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "guestbook.fullname" . }}-test-connection"
  labels:
    {{- include "guestbook.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['{{ include "guestbook.fullname" . }}:{{ .Values.service.port }}']
  restartPolicy: Never

to run test:
install the helm chart:
helm install my-guestbook chapter9/guestbook -n chapter9 –wait

run test:
helm test my-guestbook –n chapter9


---
Questions
Answer the following questions to test your knowledge of this chapter:
1. What is the purpose of the helm template command? How does it differ
from the helm lint command?
The purpose of the helm template command is to locally render the YAML manifests without actually installing the chart onto the Kubernetes cluster. It helps check and debug the output YAML before deploying the chart. The helm lint command, on the other hand, checks for issues within the chart contents (e.g., metadata, templates syntax) to ensure that the chart follows the best practices and it doesn't check the rendered output.

2. What tool can be leveraged to lint the YAML style of rendered Helm
templates?
A popular tool that can be leveraged to lint the YAML style of rendered Helm templates is yamllint. This tool can be used to check the correctness and consistency of the YAML syntax in the files output by the helm template command.

3. How is a chart test created? How is a chart test executed?
A chart test in Helm is created by adding test files under the templates/tests/ directory in the chart. These files typically define Kubernetes Job resources that can run tests against the deployed chart. A chart test is executed using the helm test command which runs the Jobs defined for testing and reports the results.   

4. What is the difference between helm test and ct lint-and-install?
The difference between helm test and ct lint-and-install is that helm test purely runs the tests defined in the chart to ensure that a release is functioning as expected after it has been deployed. ct (Chart Testing) lint-and-install, on the other hand, is a broader tool that not only lints the chart but also tries to install the chart (using a kind cluster or specified kubeContext) and can run tests to validate deployment as well autonomously. Essentially, ct lint-and-install covers the end-to-end process validating the syntax, installation, and operational assertion.

5. What is the purpose of the ci/ folder when used with the ct tool?
The purpose of the ci/ folder when used with the ct (Chart Testing) tool is to hold configuration files and value overrides that are specific to continuous integration environments. These files define different setups (value files) that will be applied when the chart is tested under the ct lint-and-install command in a CI system, enabling validation across various configurations.

6. How does the --upgrade flag change the behavior of the ct lint-andinstall
command?
The --upgrade flag alters the behavior of the ct lint-and-install command by not just installing the chart as part of the test but also testing the upgrade path from the previous version of the chart. This flag helps validate whether the chart can be upgraded successfully and ensures that upgrades do not break or disrupt the existing deployments.

