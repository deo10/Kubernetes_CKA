pages 119-153

install wordpress chart

prep work:
search
helm search hub wordpress
helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
helm repo list
helm search repo wordpress --version 12.1.6

check chart, ready and default values
helm show chart bitnami/wordpress --version 12.1.6
helm show readme bitnami/wordpress --version 12.1.6
helm show values bitnami/wordpress --version 12.1.6

override values in yaml file:
wordpress-values.yaml
wordpressUsername: helm-user
wordpressPassword: my-password
wordpressEmail: helm-user@example.com
wordpressFirstName: Helm_is
wordpressLastName: Fun
wordpressBlogName: Learn Helm!
service:
  type: NodePort

istall chart:
helm install [name] bitnami/wordpress --values=wordpress-values.yaml --namespace chapter3 --version 12.1.6

inspect:
helm list --namespace chapter3 #view releases

helm get manifest wordpress --namespace chapter3 #view manifest of the release

helm get notes wordpress --namespace chapter3 #view installation notes (like how to open app, admin, etc)




