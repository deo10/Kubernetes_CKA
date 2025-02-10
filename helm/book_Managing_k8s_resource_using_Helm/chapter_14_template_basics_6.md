pages 318-326

# Updating and deploying the Guestbook chart

The redis.fullnameOverride value is used to ensure that deployed Redis
instances are prefixed with redis. This will help ensure the Guestbook
application is talking to consistently named instances.
Setting the redis.auth.enabled value to false will disable Redis
authentication. This is necessary because the Guestbook frontend is not
configured to authenticate with Redis.

go to \Kubernetes_CKA\helm\guestbook\values.yaml

redis:
  fullnameOverride: redis
  auth:
    enabled: false

# Updating Guestbook’s deployment template and values.yaml file

GET_HOSTS_FROM: Informs Guestbook whether or not it should retrieve the
Redis hostnames from the environment. We will set this to env so that
hostnames are retrieved from the two environment variables defined next.

REDIS_LEADER_SERVICE_HOST: Provides the hostname of the Redis leader.
Because the Redis dependency we are using specifies the leader as redismaster,
we will set this value to redis-master.

REDIS_FOLLOWER_SERVICE_HOST: Provides the hostname of the Redis
follower. The Redis dependency we are using specifies the follower as
redis-replicas, so we will set this value to redis-replicas.

go to \Kubernetes_CKA\helm\guestbook\templates\deployment.yaml

env:
    {{- toYaml .Values.env | nindent 12 }}

Here, we added a new env object. Underneath, we are using the toYaml
function to format the env value (which we will add shortly) as a YAML
object. Then, we are using a pipeline and the nindent function to form a new
line and indent by 12 spaces.


Next, we need to add the env object with the associated content to our
values.yaml file.

go to \Kubernetes_CKA\helm\guestbook\values.yaml

env:
  - name: GET_HOSTS_FROM
    value: env
  - name: REDIS_LEADER_SERVICE_HOST
    value: redis-master
  - name: REDIS_FOLLOWER_SERVICE_HOST
    value: redis-replicas


# Run helm chart
helm install guestbook guestbook
kubectl port-forward svc/guestbook 8080:80
curl http://localhost:8080


# Questions
1. Which Helm templating construct can you take advantage of to generate
repeating YAML portions?

Helm Templating Construct for Repeating YAML Portions: Helm provides the range function, which is used to iterate over lists and maps. This is particularly useful for generating repeating sections of YAML based on the contents of a list or the keys and values of a map. It allows for dynamic generation of Kubernetes resources based on the values provided in the values.yaml file or passed through the command line.

2. What is the purpose of the "with" action?

Purpose of the "with" Action: The with action in Helm templates sets the scope of the current context to the object passed to it. This is useful for reducing redundancy and simplifying templates when multiple operations need to be performed on the same object. It helps in making the templates cleaner and more readable by avoiding repeated references to the same object.

3. What are the different built-in objects in Helm templates?

Built-in Objects in Helm Templates: Helm templates come with several built-in objects:

.Release: Contains information like the release name, namespace, and whether the chart is being installed or upgraded.
.Values: Contains the values passed to the chart from the values.yaml file or from user overrides.
.Chart: Provides metadata about the chart (name, version, etc.).
.Files: Allows access to files packaged into the chart.
.Capabilities: Provides information about the capabilities of the Kubernetes cluster (e.g., supported API versions).
.Template: Contains information about the current template that’s being rendered (name, base path).

4. How does a Kubernetes resource template differ from a named template?

Difference Between Kubernetes Resource Template and Named Template: A Kubernetes resource template is a direct definition of a Kubernetes object (like a Deployment, Service, etc.) that gets created when the Helm chart is installed. A named template, on the other hand, is a reusable snippet that can be defined once and called in multiple places within a chart. Named templates are defined using the define action and invoked using the include action.

5. How does an application chart differ from a library chart?

Difference Between Application Chart and Library Chart: An application chart is a type of Helm chart that defines and installs complete applications in Kubernetes. It typically includes Kubernetes resources like Deployments, Services, and Ingresses. A library chart, however, is used to provide utility or helper functions and templates that can be used by other charts but does not define any Kubernetes resources directly and cannot be installed independently.

6. What can a chart developer do to perform input validation?

Performing Input Validation in Helm Charts: Chart developers can perform input validation using the required function to ensure necessary values are provided. They can also use conditional logic with if-else constructs to check values and provide defaults or errors accordingly. Additionally, Helm schema files (.schema.json) can be used to validate the values file against a JSON schema.

7.  What are some examples of different functions commonly used in Helm
templates?

Examples of Functions Commonly Used in Helm Templates:
include: Used to include named templates.
toYaml: Converts an object to YAML format.
default: Provides a default value if the given value is empty.
quote: Wraps a string in double quotes.
printf: Formats strings based on a format specifier.
trunc: Truncates a string to a specified length.
indent: Indents every line of a string to align YAML properly.


8. What is the difference between a template variable and a value?

Difference Between Template Variable and Value: A template variable is a local variable used within a template to store intermediate data. These are usually defined within the scope of a template and do not persist outside of it. A value, on the other hand, refers to data passed into the template from the values.yaml file or from user overrides. Values are persistent and can be configured externally, influencing how templates are rendered.









