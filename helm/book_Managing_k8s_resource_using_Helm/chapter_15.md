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

In the Helm hook basics section, we noted that Helm hooks, by default, are
not removed with the rest of the chart’s resources when the helm uninstall
command is invoked. Instead, we must clean up the resources manually.
Luckily, several strategies can be employed to automatically remove hooks
during a release’s life cycle. These options include configuring a deletion
policy and setting a time to live (TTL) on a job.

Annotation
Value                 Description
before-hookcreation   Deletes the previous resources before the hook is
                      launched (this is the default)

hooksucceeded         Deletes the resources after the hook is successfully
                      executed

hook-failed           Deletes the resources if the hook failed during
                      execution


Similar to the helm.sh/hook annotation, multiple deletion policies can be applied by
setting the helm.sh/hook-delete-policy annotation with a comma-separated string:

annotations:
  "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded


The following code shows an
example of using the ttlSecondsAfterFinished job setting
In this example, the job will be removed 60 seconds after it completes or
fails.

apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-hook
  annotations:
    "helm.sh/hook": post-install
spec:
  ttlSecondsAfterFinished: 60
  <omitted>


A common use case for this is
when your chart has created persistent storage via a standalone
PersistentVolumeClaim resource (as opposed to a PersistentVolumeClaim
resource managed by a StatefulSet object). You may want this storage to be
retained beyond the release’s normal life cycle. You can enable this behavior
by applying the helm.sh/resource-policy annotation to the resource, as
shown in the following snippet:

annotations:
  "helm.sh/resource-policy": keep

Note that when using this annotation on non-hook resources, naming
conflicts may occur if the chart is reinstalled.


# Writing hooks in the Guestbook Helm chart

The first hook will occur in the pre-upgrade lifecycle phase. This phase
takes place immediately after the helm-upgrade command is run, but
before any Kubernetes resources have been modified. This hook will be
used to take a data snapshot of the Redis database before the upgrade is
performed, ensuring that the database is backed up in case any errors
occur during the upgrade.
The second hook will occur in the pre-rollback lifecycle phase. This phase
takes place immediately after the helm-rollback command is run, but
before any Kubernetes resources are reverted. This hook will restore the
Redis database to a previously taken snapshot and ensure that the
Kubernetes resources are reverted so that they match the configuration at
the point in time when the snapshot was taken.

Create a new folder called templates/backup in your guestbook Helm chart,
as follows:
mkdir -p guestbook/templates/backup

Next, you should create the two template files required to perform the
backup. The first template that’s required is a PersistentVolumeClaim
template since this will be used to contain the backup dump.rdb file. The
second template will be a job template that will be used to perform the
copy.

touch guestbook/templates/backup/persistentvolumeclaim.yaml
touch guestbook/templates/backup/job.yaml

persistentvolumeclaim.yaml:
{{- if .Values.redis.master.persistence.enabled }}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "guestbook.fullname" . }}-{{ .Values.redis.fullnameOverride }}-backup-{{ sub .Release.Revision 1 }}
  labels:
    {{- include "guestbook.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": pre-upgrade
    "helm.sh/hook-weight": "0"
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ .Values.redis.master.persistence.size }}
{{- end }}

Lines 1 and 17 of the backup/persistentvolumeclaim.yaml file consist of
an if action. Since this action encapsulates the whole file, it indicates that
this resource will only be included if the
redis.master.persistence.enabled value is set to true. This value
defaults to true in the Redis chart and can be observed using the helm
show values command.
Line 5 determines the name of the new backup PVC
(PersistentVolumeClaim). This name is based on the release name, Redis
name, and the revision number from which the backup was taken. Notice
the usage of the sub function, which aids in calculating the revision
number. This is used to subtract 1 from the revision number since the helm
upgrade command increments this value before the templates are rendered.
Line 9 creates an annotation to declare this resource as a pre-upgrade
hook. Finally, line 10 creates a helm.sh/hook-weight annotation to
determine the order in which this resource should be created compared to
other pre-upgrade hooks. Weights are run in ascending order, so this
resource will be created before other pre-upgrade resources.


job.yaml:
{{- if .Values.redis.master.persistence.enabled }}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "guestbook.fullname" . }}-{{ .Values.redis.fullnameOverride }}-backup-{{ sub .Release.Revision 1 }}
  labels:
    {{- include "guestbook.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": pre-upgrade
    "helm.sh/hook-weight": "1"
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
spec:
  template:
    spec:
      containers:
        - name: backup
          image: redis:alpine3.15
          command: ["/bin/sh", "-c"]
          args:
            - |-
              redis-cli -h {{ .Values.redis.fullnameOverride }}-master save
              cp /data/dump.rdb /backup/dump.rdb
          volumeMounts:
            - name: redis-data
              mountPath: /data
            - name: backup
              mountPath: /backup
      restartPolicy: Never
      volumes:
        - name: redis-data
          persistentVolumeClaim:
            claimName: redis-data-{{ .Values.redis.fullnameOverride }}-master-0
        - name: backup
          persistentVolumeClaim:
            claimName: {{ include "guestbook.fullname" . }}-{{ .Values.redis.fullnameOverride }}-backup-{{ sub .Release.Revision 1 }}
{{- end }}


Once again, line 9 defines this template as a pre-upgrade hook, while line
10 sets the hook weight to 1, indicating that this resource will be created
after the persistentvolumeclaim.yaml template.
Line 11 sets the helm.sh/hook-delete-policy annotation to specify when
this job should be deleted. Here, we have applied two different policies.
The first is before-hook-creation, which indicates it will be removed
during subsequent helm upgrade commands if the job already exists in the
namespace, allowing a fresh job to be created in its place. The second
policy is hook-succeeded, which deletes the job if it finishes successfully.
Another policy we could have added is hook-failed, which would delete
the job if it failed. However, given that we want to keep failures around
for the sake of troubleshooting, we haven’t implemented this policy.
Lines 19 through 22 contain the commands for backing up the Redis
database. First, redis-cli is used to save the current state. Then, the
dump.rdb file is copied from the master to the backup PVC created in the
backup/persistentvolumeclaim.yaml template.
Finally, lines 29 through 35 define the volumes that reference the master
and backup PVCs.


# Creating the pre-rollback hook to restore the database

mkdir guestbook/templates/restore

touch guestbook/templates/restore/serviceaccount.yaml
touch guestbook/templates/restore/rolebinding.yaml
touch guestbook/templates/restore/job.yaml


serviceaccount.yaml:
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "guestbook.fullname" . }}-rollout
  labels:
    {{- include "guestbook.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": pre-rollback
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
    "helm.sh/hook-weight": "0"

Line 8 defines this template as a pre-rollback hook. Since the hook’s weight
is 0 (on line 10), this will be created before the other pre-rollback templates.


rolebinding.yaml:
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "guestbook.fullname" . }}-rollout
  labels:
    {{- include "guestbook.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": pre-rollback
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
    "helm.sh/hook-weight": "1"
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: edit
subjects:
- apiGroup: ""
  kind: ServiceAccount
  name: {{ include "guestbook.fullname" . }}-rollout
  namespace: {{ .Release.Namespace }}

Lines 11 through 14 reference the edit ClusterRole that we want to grant,
while lines 15 through 19 target our ServiceAccount in the namespace we are
going to release to.


job.yaml:
{{- if .Values.redis.master.persistence.enabled }}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "guestbook.fullname" . }}-{{ .Values.redis.fullnameOverride }}-restore-{{ .Release.Revision }}
  labels:
    {{- include "guestbook.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": pre-rollback
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
    "helm.sh/hook-weight": "2"
spec:
  template:
    spec:
      serviceAccountName: {{ include "guestbook.fullname" . }}-rollout
      initContainers:
        ## This will reload the master's database with the backup dump.rdb file
        - name: restore-master-state
          image: redis:alpine3.15
          command: ["/bin/sh", "-c"]
          args:
            - |-
              cp /backup/dump.rdb /data/dump.rdb
              redis-cli -h {{ .Values.redis.fullnameOverride }}-master debug reload nosave
          volumeMounts:
            - name: redis-data
              mountPath: /data
            - name: backup
              mountPath: /backup
      containers:
        ## This will roll out new Replica pods
        - name: rollout-new-replicas
          image: bitnami/kubectl
          command: ["/bin/sh", "-c"]
          args:
            - |-
              kubectl rollout restart statefulset {{ .Values.redis.fullnameOverride }}-replicas
      restartPolicy: Never
      volumes:
        - name: redis-data
          persistentVolumeClaim:
            claimName: redis-data-{{ .Values.redis.fullnameOverride }}-master-0
        - name: backup
          persistentVolumeClaim:
            claimName: {{ include "guestbook.fullname" . }}-{{ .Values.redis.fullnameOverride }}-backup-{{ .Release.Revision }}
{{- end }}

This job.yaml template is where the core pre-rollback logic takes place. Lines
18 through 29 define an initContainer that copies the backup dump.rdb file
to the Redis master and performs a reload, reverting the state of the master, as
represented in the backup dump.rdb file. An initContainer is a container that
runs until completion before any of the containers listed under the containers
section are run. We created this first to ensure that the master is reverted
before we move on to the next step.
Lines 30 through 37 represent the next step of the rollback. Here, we restart
the Redis replica’s StatefulSet. When the replicas reconnect to the master,
they will serve the data represented by the backup dump.rdb file.
With the pre-upgrade and pre-rollback hooks created, let’s see them in
action within the minikube environment.

# Executing the life cycle hooks

install your chart by:
helm install guestbook chapter7/guestbook -n chapter7 --dependency-update

access your Guestbook by a port-forward:
kubectl port-forward svc/guestbook 8080:80 –n chapter7

Enter the app http://localhost:8080
Enter a message and submit

run the helm upgrade command to trigger the pre-upgrade hook:
helm upgrade guestbook guestbook –n chapter7  # upgrade RELEASE CHART

Enter the app http://localhost:8080
Enter a message and submit

run the helm rollback command to trigger the rollback hook:
helm rollback guestbook 1 –n chapter7 # rollback RELEASE

Enter the app http://localhost:8080
you should see only first message


# Summary
Lifecycle hooks open the door to additional capabilities by allowing chart
developers to install resources at different lifecycle phases. Hooks commonly
include job resources to execute the actions that take place within a hook, but
they also often include other resources, such as ServiceAccounts, policies
including RoleBindings, and PersistentVolumeClaims. At the end of this
chapter, we added lifecycle hooks to our Guestbook chart and ran through a
backup and restore of the Redis database.

# Questions
Answer the following questions to test your knowledge of this chapter:

1. What are the nine different types of lifecycle hooks?
pre-install,post-install etc

2. What annotation is used to define a hook?
annotations:
    "helm.sh/hook":

3. What annotation is used to define the order in which a hook should be
created?
"helm.sh/hook-weight": "2"

4. What can a chart developer add to ensure that hooks are always deleted
upon success?
helm.sh/hook-delete-policy annotation

5. How can a Helm user skip lifecycle hooks?
--no-hooks flag to the helm
install, helm upgrade, helm rollback, and helm delete commands

6. What Kubernetes resource is most often used to execute a lifecycle hook?
job / ServiceAccounts, RoleBindings, and PersistentVolumeClaims