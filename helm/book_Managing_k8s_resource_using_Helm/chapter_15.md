pages 326 - 361
# Helm Lifecycle Hooks

A hook executes as a one-time action at a designated point in time during the
life span of a release. A hook is implemented as a Kubernetes resource and,
more specifically, within a container. While the majority of workloads within
Kubernetes are designed to be long-living processes, such as an application
serving API requests, hooks are made up of a single task or set of tasks that
return 0 to indicate success or non-0 to indicate a failure.

Since hooks are simply defined as Kubernetes resources, they are created like
other Helm templates and are placed in the templates/ folder. However,
hooks are different in that they are always annotated with the helm.sh/hook
annotation. Hooks use this annotation to ensure that they are not rendered in
the same fashion as the rest of the resources during standard processing.
Instead, they are rendered and applied based on the value specified within the
helm.sh/hook annotation, which determines when it should be executed
within Kubernetes as part of the Helm release lifecycle.

chapter7/examples/hookexample/templates/hooks/job.yaml:

apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-hook
  annotations:
    "helm.sh/hook": post-install
spec:
  template:
    metadata:
      name: {{ .Release.Name }}-hook
    spec:
      restartPolicy: Never
      containers:
      - name: {{ .Release.Name }}-hook
        command: ["/bin/sh", "-c"]
        args:
        - echo "Hook executed at $(date)"
        image: alpine

Once hooks have been created and executed, they become unmanaged. (This
happens unless the helm.sh/hook-delete-policy annotation is applied. We
will cover this later in this chapter in the Advanced hook concepts section.)
As a result, we are responsible for cleaning up the hook ourselves.

# Helm hook life cycle

Annotation
Value                 |   Description
preinstall
                        Executes after templates are rendered but before any
                        resources are created in Kubernetes.
postinstall
                        Executes after all resources are created in Kubernetes.
pre-delete
                        Executes due to a deletion request before any resources
                        are deleted from Kubernetes.
postdelete
                        Executes due to a deletion request after all the release’s
                        resources have been deleted.
preupgrade
                        Executes due to an upgrade request after templates are
                        rendered but before any resources are updated.
postupgrade
                        Executes due to an upgrade after all the resources have
                        been upgraded.
prerollback
                        Executes due to a rollback request after templates are
                        rendered but before any resources are rolled back.
postrollback
                        Executes due to a rollback request after all resources
                        have been modified.
test
                        Executes when the helm test subcommand is invoked.
                        This will be discussed in more detail in Chapter 9,
                        Testing Helm Charts.


You can define the order in which these resources are created by using
the helm.sh/weight annotation. This annotation is used to assign weighted
values to each of the hook resources that are marked to execute in the same
phase. Weights are sorted in ascending order, so the resource marked with the
lowest weight is executed first. If weights are not applied but the Helm chart
contains multiple hooks that execute in the same phase, then Helm infers the
order by sorting the templates by resource kind and name in alphabetical
order.

annotations:
  "helm.sh/hook": pre-upgrade
  "helm.sh/weight": "0"

annotations:
  "helm.sh/hook": pre-install,post-install

In this example, where both the pre-install and post-install options are
selected, the helm install command would be executed as follows:
1. The user initiates the installation of a Helm chart (by running, for
example, helm install wordpress bitnami/wordpress).
2. Any CRDs in the crds/ folder, if present, are installed in the Kubernetes
environment.
3. The chart templates are verified and the resources are rendered.
4. The pre-install hooks are ordered by weight, then rendered and applied
to the Kubernetes environment.
5. Helm waits until the hook resources have been created and, for pods and
jobs, are reported to have been Completed or in an Error state.
6. The template resources are rendered and applied to the Kubernetes
environment.
7. The post-install hooks are ordered by weight and then executed.
8. Helm waits until the post-install hooks have finished running.
9. The results of the helm install command are returned.

# Helm hook cleanup

