---
# Flux version: v0.9.0
# Components: source-controller,kustomize-controller,helm-controller,notification-controller
apiVersion: v1
kind: Namespace
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: flux-system
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.1
  creationTimestamp: null
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: alerts.notification.toolkit.fluxcd.io
spec:
  group: notification.toolkit.fluxcd.io
  names:
    kind: Alert
    listKind: AlertList
    plural: alerts
    singular: alert
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.conditions[?(@.type=="Ready")].status
      name: Ready
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].message
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        description: Alert is the Schema for the alerts API
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            description: AlertSpec defines an alerting rule for events involving a list of objects
            properties:
              eventSeverity:
                default: info
                description: Filter events based on severity, defaults to ('info'). If set to 'info' no events will be filtered.
                enum:
                - info
                - error
                type: string
              eventSources:
                description: Filter events based on the involved objects.
                items:
                  description: CrossNamespaceObjectReference contains enough information to let you locate the typed referenced object at cluster level
                  properties:
                    apiVersion:
                      description: API version of the referent
                      type: string
                    kind:
                      description: Kind of the referent
                      enum:
                      - Bucket
                      - GitRepository
                      - Kustomization
                      - HelmRelease
                      - HelmChart
                      - HelmRepository
                      - ImageRepository
                      - ImagePolicy
                      - ImageUpdateAutomation
                      type: string
                    name:
                      description: Name of the referent
                      maxLength: 53
                      minLength: 1
                      type: string
                    namespace:
                      description: Namespace of the referent
                      maxLength: 53
                      minLength: 1
                      type: string
                  required:
                  - name
                  type: object
                type: array
              exclusionList:
                description: A list of Golang regular expressions to be used for excluding messages.
                items:
                  type: string
                type: array
              providerRef:
                description: Send events using this provider.
                properties:
                  name:
                    description: Name of the referent
                    type: string
                required:
                - name
                type: object
              summary:
                description: Short description of the impact and affected cluster.
                type: string
              suspend:
                description: This flag tells the controller to suspend subsequent events dispatching. Defaults to false.
                type: boolean
            required:
            - eventSources
            - providerRef
            type: object
          status:
            description: AlertStatus defines the observed state of Alert
            properties:
              conditions:
                items:
                  description: "Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` \n     // other fields }"
                  properties:
                    lastTransitionTime:
                      description: lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
                      format: date-time
                      type: string
                    message:
                      description: message is a human readable message indicating details about the transition. This may be an empty string.
                      maxLength: 32768
                      type: string
                    observedGeneration:
                      description: observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance.
                      format: int64
                      minimum: 0
                      type: integer
                    reason:
                      description: reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty.
                      maxLength: 1024
                      minLength: 1
                      pattern: ^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$
                      type: string
                    status:
                      description: status of the condition, one of True, False, Unknown.
                      enum:
                      - "True"
                      - "False"
                      - Unknown
                      type: string
                    type:
                      description: type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                      maxLength: 316
                      pattern: ^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$
                      type: string
                  required:
                  - lastTransitionTime
                  - message
                  - reason
                  - status
                  - type
                  type: object
                type: array
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.1
  creationTimestamp: null
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.11.0
  name: buckets.source.toolkit.fluxcd.io
spec:
  group: source.toolkit.fluxcd.io
  names:
    kind: Bucket
    listKind: BucketList
    plural: buckets
    singular: bucket
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .spec.url
      name: URL
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].status
      name: Ready
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].message
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        description: Bucket is the Schema for the buckets API
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            description: BucketSpec defines the desired state of an S3 compatible bucket
            properties:
              bucketName:
                description: The bucket name.
                type: string
              endpoint:
                description: The bucket endpoint address.
                type: string
              ignore:
                description: Ignore overrides the set of excluded patterns in the .sourceignore format (which is the same as .gitignore). If not provided, a default will be used, consult the documentation for your version to find out what those are.
                type: string
              insecure:
                description: Insecure allows connecting to a non-TLS S3 HTTP endpoint.
                type: boolean
              interval:
                description: The interval at which to check for bucket updates.
                type: string
              provider:
                default: generic
                description: The S3 compatible storage provider name, default ('generic').
                enum:
                - generic
                - aws
                type: string
              region:
                description: The bucket region.
                type: string
              secretRef:
                description: The name of the secret containing authentication credentials for the Bucket.
                properties:
                  name:
                    description: Name of the referent
                    type: string
                required:
                - name
                type: object
              suspend:
                description: This flag tells the controller to suspend the reconciliation of this source.
                type: boolean
              timeout:
                default: 20s
                description: The timeout for download operations, defaults to 20s.
                type: string
            required:
            - bucketName
            - endpoint
            - interval
            type: object
          status:
            description: BucketStatus defines the observed state of a bucket
            properties:
              artifact:
                description: Artifact represents the output of the last successful Bucket sync.
                properties:
                  checksum:
                    description: Checksum is the SHA1 checksum of the artifact.
                    type: string
                  lastUpdateTime:
                    description: LastUpdateTime is the timestamp corresponding to the last update of this artifact.
                    format: date-time
                    type: string
                  path:
                    description: Path is the relative file path of this artifact.
                    type: string
                  revision:
                    description: Revision is a human readable identifier traceable in the origin source system. It can be a Git commit SHA, Git tag, a Helm index timestamp, a Helm chart version, etc.
                    type: string
                  url:
                    description: URL is the HTTP address of this artifact.
                    type: string
                required:
                - path
                - url
                type: object
              conditions:
                description: Conditions holds the conditions for the Bucket.
                items:
                  description: "Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` \n     // other fields }"
                  properties:
                    lastTransitionTime:
                      description: lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
                      format: date-time
                      type: string
                    message:
                      description: message is a human readable message indicating details about the transition. This may be an empty string.
                      maxLength: 32768
                      type: string
                    observedGeneration:
                      description: observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance.
                      format: int64
                      minimum: 0
                      type: integer
                    reason:
                      description: reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty.
                      maxLength: 1024
                      minLength: 1
                      pattern: ^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$
                      type: string
                    status:
                      description: status of the condition, one of True, False, Unknown.
                      enum:
                      - "True"
                      - "False"
                      - Unknown
                      type: string
                    type:
                      description: type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                      maxLength: 316
                      pattern: ^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$
                      type: string
                  required:
                  - lastTransitionTime
                  - message
                  - reason
                  - status
                  - type
                  type: object
                type: array
              lastHandledReconcileAt:
                description: LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change can be detected.
                type: string
              observedGeneration:
                description: ObservedGeneration is the last observed generation.
                format: int64
                type: integer
              url:
                description: URL is the download link for the artifact output of the last Bucket sync.
                type: string
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.1
  creationTimestamp: null
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: gitrepositories.source.toolkit.fluxcd.io
spec:
  group: source.toolkit.fluxcd.io
  names:
    kind: GitRepository
    listKind: GitRepositoryList
    plural: gitrepositories
    singular: gitrepository
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .spec.url
      name: URL
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].status
      name: Ready
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].message
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        description: GitRepository is the Schema for the gitrepositories API
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            description: GitRepositorySpec defines the desired state of a Git repository.
            properties:
              gitImplementation:
                default: go-git
                description: Determines which git client library to use. Defaults to go-git, valid values are ('go-git', 'libgit2').
                enum:
                - go-git
                - libgit2
                type: string
              ignore:
                description: Ignore overrides the set of excluded patterns in the .sourceignore format (which is the same as .gitignore). If not provided, a default will be used, consult the documentation for your version to find out what those are.
                type: string
              interval:
                description: The interval at which to check for repository updates.
                type: string
              ref:
                description: The Git reference to checkout and monitor for changes, defaults to master branch.
                properties:
                  branch:
                    default: master
                    description: The Git branch to checkout, defaults to master.
                    type: string
                  commit:
                    description: The Git commit SHA to checkout, if specified Tag filters will be ignored.
                    type: string
                  semver:
                    description: The Git tag semver expression, takes precedence over Tag.
                    type: string
                  tag:
                    description: The Git tag to checkout, takes precedence over Branch.
                    type: string
                type: object
              secretRef:
                description: The secret name containing the Git credentials. For HTTPS repositories the secret must contain username and password fields. For SSH repositories the secret must contain identity, identity.pub and known_hosts fields.
                properties:
                  name:
                    description: Name of the referent
                    type: string
                required:
                - name
                type: object
              suspend:
                description: This flag tells the controller to suspend the reconciliation of this source.
                type: boolean
              timeout:
                default: 20s
                description: The timeout for remote Git operations like cloning, defaults to 20s.
                type: string
              url:
                description: The repository URL, can be a HTTP/S or SSH address.
                pattern: ^(http|https|ssh)://
                type: string
              verify:
                description: Verify OpenPGP signature for the Git commit HEAD points to.
                properties:
                  mode:
                    description: Mode describes what git object should be verified, currently ('head').
                    enum:
                    - head
                    type: string
                  secretRef:
                    description: The secret name containing the public keys of all trusted Git authors.
                    properties:
                      name:
                        description: Name of the referent
                        type: string
                    required:
                    - name
                    type: object
                required:
                - mode
                type: object
            required:
            - interval
            - url
            type: object
          status:
            description: GitRepositoryStatus defines the observed state of a Git repository.
            properties:
              artifact:
                description: Artifact represents the output of the last successful repository sync.
                properties:
                  checksum:
                    description: Checksum is the SHA1 checksum of the artifact.
                    type: string
                  lastUpdateTime:
                    description: LastUpdateTime is the timestamp corresponding to the last update of this artifact.
                    format: date-time
                    type: string
                  path:
                    description: Path is the relative file path of this artifact.
                    type: string
                  revision:
                    description: Revision is a human readable identifier traceable in the origin source system. It can be a Git commit SHA, Git tag, a Helm index timestamp, a Helm chart version, etc.
                    type: string
                  url:
                    description: URL is the HTTP address of this artifact.
                    type: string
                required:
                - path
                - url
                type: object
              conditions:
                description: Conditions holds the conditions for the GitRepository.
                items:
                  description: "Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` \n     // other fields }"
                  properties:
                    lastTransitionTime:
                      description: lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
                      format: date-time
                      type: string
                    message:
                      description: message is a human readable message indicating details about the transition. This may be an empty string.
                      maxLength: 32768
                      type: string
                    observedGeneration:
                      description: observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance.
                      format: int64
                      minimum: 0
                      type: integer
                    reason:
                      description: reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty.
                      maxLength: 1024
                      minLength: 1
                      pattern: ^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$
                      type: string
                    status:
                      description: status of the condition, one of True, False, Unknown.
                      enum:
                      - "True"
                      - "False"
                      - Unknown
                      type: string
                    type:
                      description: type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                      maxLength: 316
                      pattern: ^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$
                      type: string
                  required:
                  - lastTransitionTime
                  - message
                  - reason
                  - status
                  - type
                  type: object
                type: array
              lastHandledReconcileAt:
                description: LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change can be detected.
                type: string
              observedGeneration:
                description: ObservedGeneration is the last observed generation.
                format: int64
                type: integer
              url:
                description: URL is the download link for the artifact output of the last repository sync.
                type: string
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.1
  creationTimestamp: null
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: helmcharts.source.toolkit.fluxcd.io
spec:
  group: source.toolkit.fluxcd.io
  names:
    kind: HelmChart
    listKind: HelmChartList
    plural: helmcharts
    singular: helmchart
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .spec.chart
      name: Chart
      type: string
    - jsonPath: .spec.version
      name: Version
      type: string
    - jsonPath: .spec.sourceRef.kind
      name: Source Kind
      type: string
    - jsonPath: .spec.sourceRef.name
      name: Source Name
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].status
      name: Ready
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].message
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        description: HelmChart is the Schema for the helmcharts API
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            description: HelmChartSpec defines the desired state of a Helm chart.
            properties:
              chart:
                description: The name or path the Helm chart is available at in the SourceRef.
                type: string
              interval:
                description: The interval at which to check the Source for updates.
                type: string
              sourceRef:
                description: The reference to the Source the chart is available at.
                properties:
                  apiVersion:
                    description: APIVersion of the referent.
                    type: string
                  kind:
                    description: Kind of the referent, valid values are ('HelmRepository', 'GitRepository', 'Bucket').
                    enum:
                    - HelmRepository
                    - GitRepository
                    - Bucket
                    type: string
                  name:
                    description: Name of the referent.
                    type: string
                required:
                - kind
                - name
                type: object
              suspend:
                description: This flag tells the controller to suspend the reconciliation of this source.
                type: boolean
              valuesFile:
                description: Alternative values file to use as the default chart values, expected to be a relative path in the SourceRef. Ignored when omitted.
                type: string
              version:
                default: '*'
                description: The chart version semver expression, ignored for charts from GitRepository and Bucket sources. Defaults to latest when omitted.
                type: string
            required:
            - chart
            - interval
            - sourceRef
            type: object
          status:
            description: HelmChartStatus defines the observed state of the HelmChart.
            properties:
              artifact:
                description: Artifact represents the output of the last successful chart sync.
                properties:
                  checksum:
                    description: Checksum is the SHA1 checksum of the artifact.
                    type: string
                  lastUpdateTime:
                    description: LastUpdateTime is the timestamp corresponding to the last update of this artifact.
                    format: date-time
                    type: string
                  path:
                    description: Path is the relative file path of this artifact.
                    type: string
                  revision:
                    description: Revision is a human readable identifier traceable in the origin source system. It can be a Git commit SHA, Git tag, a Helm index timestamp, a Helm chart version, etc.
                    type: string
                  url:
                    description: URL is the HTTP address of this artifact.
                    type: string
                required:
                - path
                - url
                type: object
              conditions:
                description: Conditions holds the conditions for the HelmChart.
                items:
                  description: "Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` \n     // other fields }"
                  properties:
                    lastTransitionTime:
                      description: lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
                      format: date-time
                      type: string
                    message:
                      description: message is a human readable message indicating details about the transition. This may be an empty string.
                      maxLength: 32768
                      type: string
                    observedGeneration:
                      description: observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance.
                      format: int64
                      minimum: 0
                      type: integer
                    reason:
                      description: reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty.
                      maxLength: 1024
                      minLength: 1
                      pattern: ^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$
                      type: string
                    status:
                      description: status of the condition, one of True, False, Unknown.
                      enum:
                      - "True"
                      - "False"
                      - Unknown
                      type: string
                    type:
                      description: type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                      maxLength: 316
                      pattern: ^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$
                      type: string
                  required:
                  - lastTransitionTime
                  - message
                  - reason
                  - status
                  - type
                  type: object
                type: array
              lastHandledReconcileAt:
                description: LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change can be detected.
                type: string
              observedGeneration:
                description: ObservedGeneration is the last observed generation.
                format: int64
                type: integer
              url:
                description: URL is the download link for the last chart pulled.
                type: string
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.1
  creationTimestamp: null
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: helmreleases.helm.toolkit.fluxcd.io
spec:
  group: helm.toolkit.fluxcd.io
  names:
    kind: HelmRelease
    listKind: HelmReleaseList
    plural: helmreleases
    shortNames:
    - hr
    singular: helmrelease
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.conditions[?(@.type=="Ready")].status
      name: Ready
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].message
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v2beta1
    schema:
      openAPIV3Schema:
        description: HelmRelease is the Schema for the helmreleases API
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            description: HelmReleaseSpec defines the desired state of a Helm release.
            properties:
              chart:
                description: Chart defines the template of the v1beta1.HelmChart that should be created for this HelmRelease.
                properties:
                  spec:
                    description: Spec holds the template for the v1beta1.HelmChartSpec for this HelmRelease.
                    properties:
                      chart:
                        description: The name or path the Helm chart is available at in the SourceRef.
                        type: string
                      interval:
                        description: Interval at which to check the v1beta1.Source for updates. Defaults to 'HelmReleaseSpec.Interval'.
                        type: string
                      sourceRef:
                        description: The name and namespace of the v1beta1.Source the chart is available at.
                        properties:
                          apiVersion:
                            description: APIVersion of the referent.
                            type: string
                          kind:
                            description: Kind of the referent.
                            enum:
                            - HelmRepository
                            - GitRepository
                            - Bucket
                            type: string
                          name:
                            description: Name of the referent.
                            maxLength: 253
                            minLength: 1
                            type: string
                          namespace:
                            description: Namespace of the referent.
                            maxLength: 63
                            minLength: 1
                            type: string
                        required:
                        - name
                        type: object
                      valuesFile:
                        description: Alternative values file to use as the default chart values, expected to be a relative path in the SourceRef. Ignored when omitted.
                        type: string
                      version:
                        default: '*'
                        description: Version semver expression, ignored for charts from v1beta1.GitRepository and v1beta1.Bucket sources. Defaults to latest when omitted.
                        type: string
                    required:
                    - chart
                    - sourceRef
                    type: object
                required:
                - spec
                type: object
              dependsOn:
                description: DependsOn may contain a dependency.CrossNamespaceDependencyReference slice with references to HelmRelease resources that must be ready before this HelmRelease can be reconciled.
                items:
                  description: CrossNamespaceDependencyReference holds the reference to a dependency.
                  properties:
                    name:
                      description: Name holds the name reference of a dependency.
                      type: string
                    namespace:
                      description: Namespace holds the namespace reference of a dependency.
                      type: string
                  required:
                  - name
                  type: object
                type: array
              install:
                description: Install holds the configuration for Helm install actions for this HelmRelease.
                properties:
                  createNamespace:
                    description: CreateNamespace tells the Helm install action to create the HelmReleaseSpec.TargetNamespace if it does not exist yet. On uninstall, the namespace will not be garbage collected.
                    type: boolean
                  disableHooks:
                    description: DisableHooks prevents hooks from running during the Helm install action.
                    type: boolean
                  disableOpenAPIValidation:
                    description: DisableOpenAPIValidation prevents the Helm install action from validating rendered templates against the Kubernetes OpenAPI Schema.
                    type: boolean
                  disableWait:
                    description: DisableWait disables the waiting for resources to be ready after a Helm install has been performed.
                    type: boolean
                  remediation:
                    description: Remediation holds the remediation configuration for when the Helm install action for the HelmRelease fails. The default is to not perform any action.
                    properties:
                      ignoreTestFailures:
                        description: IgnoreTestFailures tells the controller to skip remediation when the Helm tests are run after an install action but fail. Defaults to 'Test.IgnoreFailures'.
                        type: boolean
                      remediateLastFailure:
                        description: RemediateLastFailure tells the controller to remediate the last failure, when no retries remain. Defaults to 'false'.
                        type: boolean
                      retries:
                        description: Retries is the number of retries that should be attempted on failures before bailing. Remediation, using an uninstall, is performed between each attempt. Defaults to '0', a negative integer equals to unlimited retries.
                        type: integer
                    type: object
                  replace:
                    description: Replace tells the Helm install action to re-use the 'ReleaseName', but only if that name is a deleted release which remains in the history.
                    type: boolean
                  skipCRDs:
                    description: SkipCRDs tells the Helm install action to not install any CRDs. By default, CRDs are installed if not already present.
                    type: boolean
                  timeout:
                    description: Timeout is the time to wait for any individual Kubernetes operation (like Jobs for hooks) during the performance of a Helm install action. Defaults to 'HelmReleaseSpec.Timeout'.
                    type: string
                type: object
              interval:
                description: Interval at which to reconcile the Helm release.
                type: string
              kubeConfig:
                description: KubeConfig for reconciling the HelmRelease on a remote cluster. When specified, KubeConfig takes precedence over ServiceAccountName.
                properties:
                  secretRef:
                    description: SecretRef holds the name to a secret that contains a 'value' key with the kubeconfig file as the value. It must be in the same namespace as the HelmRelease. It is recommended that the kubeconfig is self-contained, and the secret is regularly updated if credentials such as a cloud-access-token expire. Cloud specific `cmd-path` auth helpers will not function without adding binaries and credentials to the Pod that is responsible for reconciling the HelmRelease.
                    properties:
                      name:
                        description: Name of the referent
                        type: string
                    required:
                    - name
                    type: object
                type: object
              maxHistory:
                description: MaxHistory is the number of revisions saved by Helm for this HelmRelease. Use '0' for an unlimited number of revisions; defaults to '10'.
                type: integer
              postRenderers:
                description: PostRenderers holds an array of Helm PostRenderers, which will be applied in order of their definition.
                items:
                  description: PostRenderer contains a Helm PostRenderer specification.
                  properties:
                    kustomize:
                      description: Kustomization to apply as PostRenderer.
                      properties:
                        images:
                          description: Images is a list of (image name, new name, new tag or digest) for changing image names, tags or digests. This can also be achieved with a patch, but this operator is simpler to specify.
                          items:
                            description: Image contains an image name, a new name, a new tag or digest, which will replace the original name and tag.
                            properties:
                              digest:
                                description: Digest is the value used to replace the original image tag. If digest is present NewTag value is ignored.
                                type: string
                              name:
                                description: Name is a tag-less image name.
                                type: string
                              newName:
                                description: NewName is the value used to replace the original name.
                                type: string
                              newTag:
                                description: NewTag is the value used to replace the original tag.
                                type: string
                            required:
                            - name
                            type: object
                          type: array
                        patchesJson6902:
                          description: JSON 6902 patches, defined as inline YAML objects.
                          items:
                            description: JSON6902Patch contains a JSON6902 patch and the target the patch should be applied to.
                            properties:
                              patch:
                                description: Patch contains the JSON6902 patch document with an array of operation objects.
                                items:
                                  description: JSON6902 is a JSON6902 operation object. https://tools.ietf.org/html/rfc6902#section-4
                                  properties:
                                    from:
                                      type: string
                                    op:
                                      enum:
                                      - test
                                      - remove
                                      - add
                                      - replace
                                      - move
                                      - copy
                                      type: string
                                    path:
                                      type: string
                                    value:
                                      x-kubernetes-preserve-unknown-fields: true
                                  required:
                                  - op
                                  - path
                                  type: object
                                type: array
                              target:
                                description: Target points to the resources that the patch document should be applied to.
                                properties:
                                  annotationSelector:
                                    description: AnnotationSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource annotations.
                                    type: string
                                  group:
                                    description: Group is the API group to select resources from. Together with Version and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
                                    type: string
                                  kind:
                                    description: Kind of the API Group to select resources from. Together with Group and Version it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
                                    type: string
                                  labelSelector:
                                    description: LabelSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource labels.
                                    type: string
                                  name:
                                    description: Name to match resources with.
                                    type: string
                                  namespace:
                                    description: Namespace to select resources from.
                                    type: string
                                  version:
                                    description: Version of the API Group to select resources from. Together with Group and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
                                    type: string
                                type: object
                            required:
                            - patch
                            - target
                            type: object
                          type: array
                        patchesStrategicMerge:
                          description: Strategic merge patches, defined as inline YAML objects.
                          items:
                            x-kubernetes-preserve-unknown-fields: true
                          type: array
                      type: object
                  type: object
                type: array
              releaseName:
                description: ReleaseName used for the Helm release. Defaults to a composition of '[TargetNamespace-]Name'.
                maxLength: 53
                minLength: 1
                type: string
              rollback:
                description: Rollback holds the configuration for Helm rollback actions for this HelmRelease.
                properties:
                  cleanupOnFail:
                    description: CleanupOnFail allows deletion of new resources created during the Helm rollback action when it fails.
                    type: boolean
                  disableHooks:
                    description: DisableHooks prevents hooks from running during the Helm rollback action.
                    type: boolean
                  disableWait:
                    description: DisableWait disables the waiting for resources to be ready after a Helm rollback has been performed.
                    type: boolean
                  force:
                    description: Force forces resource updates through a replacement strategy.
                    type: boolean
                  recreate:
                    description: Recreate performs pod restarts for the resource if applicable.
                    type: boolean
                  timeout:
                    description: Timeout is the time to wait for any individual Kubernetes operation (like Jobs for hooks) during the performance of a Helm rollback action. Defaults to 'HelmReleaseSpec.Timeout'.
                    type: string
                type: object
              serviceAccountName:
                description: The name of the Kubernetes service account to impersonate when reconciling this HelmRelease.
                type: string
              storageNamespace:
                description: StorageNamespace used for the Helm storage. Defaults to the namespace of the HelmRelease.
                maxLength: 63
                minLength: 1
                type: string
              suspend:
                description: Suspend tells the controller to suspend reconciliation for this HelmRelease, it does not apply to already started reconciliations. Defaults to false.
                type: boolean
              targetNamespace:
                description: TargetNamespace to target when performing operations for the HelmRelease. Defaults to the namespace of the HelmRelease.
                maxLength: 63
                minLength: 1
                type: string
              test:
                description: Test holds the configuration for Helm test actions for this HelmRelease.
                properties:
                  enable:
                    description: Enable enables Helm test actions for this HelmRelease after an Helm install or upgrade action has been performed.
                    type: boolean
                  ignoreFailures:
                    description: IgnoreFailures tells the controller to skip remediation when the Helm tests are run but fail. Can be overwritten for tests run after install or upgrade actions in 'Install.IgnoreTestFailures' and 'Upgrade.IgnoreTestFailures'.
                    type: boolean
                  timeout:
                    description: Timeout is the time to wait for any individual Kubernetes operation during the performance of a Helm test action. Defaults to 'HelmReleaseSpec.Timeout'.
                    type: string
                type: object
              timeout:
                description: Timeout is the time to wait for any individual Kubernetes operation (like Jobs for hooks) during the performance of a Helm action. Defaults to '5m0s'.
                type: string
              uninstall:
                description: Uninstall holds the configuration for Helm uninstall actions for this HelmRelease.
                properties:
                  disableHooks:
                    description: DisableHooks prevents hooks from running during the Helm rollback action.
                    type: boolean
                  keepHistory:
                    description: KeepHistory tells Helm to remove all associated resources and mark the release as deleted, but retain the release history.
                    type: boolean
                  timeout:
                    description: Timeout is the time to wait for any individual Kubernetes operation (like Jobs for hooks) during the performance of a Helm uninstall action. Defaults to 'HelmReleaseSpec.Timeout'.
                    type: string
                type: object
              upgrade:
                description: Upgrade holds the configuration for Helm upgrade actions for this HelmRelease.
                properties:
                  cleanupOnFail:
                    description: CleanupOnFail allows deletion of new resources created during the Helm upgrade action when it fails.
                    type: boolean
                  disableHooks:
                    description: DisableHooks prevents hooks from running during the Helm upgrade action.
                    type: boolean
                  disableOpenAPIValidation:
                    description: DisableOpenAPIValidation prevents the Helm upgrade action from validating rendered templates against the Kubernetes OpenAPI Schema.
                    type: boolean
                  disableWait:
                    description: DisableWait disables the waiting for resources to be ready after a Helm upgrade has been performed.
                    type: boolean
                  force:
                    description: Force forces resource updates through a replacement strategy.
                    type: boolean
                  preserveValues:
                    description: PreserveValues will make Helm reuse the last release's values and merge in overrides from 'Values'. Setting this flag makes the HelmRelease non-declarative.
                    type: boolean
                  remediation:
                    description: Remediation holds the remediation configuration for when the Helm upgrade action for the HelmRelease fails. The default is to not perform any action.
                    properties:
                      ignoreTestFailures:
                        description: IgnoreTestFailures tells the controller to skip remediation when the Helm tests are run after an upgrade action but fail. Defaults to 'Test.IgnoreFailures'.
                        type: boolean
                      remediateLastFailure:
                        description: RemediateLastFailure tells the controller to remediate the last failure, when no retries remain. Defaults to 'false' unless 'Retries' is greater than 0.
                        type: boolean
                      retries:
                        description: Retries is the number of retries that should be attempted on failures before bailing. Remediation, using 'Strategy', is performed between each attempt. Defaults to '0', a negative integer equals to unlimited retries.
                        type: integer
                      strategy:
                        description: Strategy to use for failure remediation. Defaults to 'rollback'.
                        enum:
                        - rollback
                        - uninstall
                        type: string
                    type: object
                  timeout:
                    description: Timeout is the time to wait for any individual Kubernetes operation (like Jobs for hooks) during the performance of a Helm upgrade action. Defaults to 'HelmReleaseSpec.Timeout'.
                    type: string
                type: object
              values:
                description: Values holds the values for this Helm release.
                x-kubernetes-preserve-unknown-fields: true
              valuesFrom:
                description: ValuesFrom holds references to resources containing Helm values for this HelmRelease, and information about how they should be merged.
                items:
                  description: ValuesReference contains a reference to a resource containing Helm values, and optionally the key they can be found at.
                  properties:
                    kind:
                      description: Kind of the values referent, valid values are ('Secret', 'ConfigMap').
                      enum:
                      - Secret
                      - ConfigMap
                      type: string
                    name:
                      description: Name of the values referent. Should reside in the same namespace as the referring resource.
                      maxLength: 253
                      minLength: 1
                      type: string
                    optional:
                      description: Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.
                      type: boolean
                    targetPath:
                      description: TargetPath is the YAML dot notation path the value should be merged at. When set, the ValuesKey is expected to be a single flat value. Defaults to 'None', which results in the values getting merged at the root.
                      type: string
                    valuesKey:
                      description: ValuesKey is the data key where the values.yaml or a specific value can be found at. Defaults to 'values.yaml'.
                      type: string
                  required:
                  - kind
                  - name
                  type: object
                type: array
            required:
            - chart
            - interval
            type: object
          status:
            description: HelmReleaseStatus defines the observed state of a HelmRelease.
            properties:
              conditions:
                description: Conditions holds the conditions for the HelmRelease.
                items:
                  description: "Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` \n     // other fields }"
                  properties:
                    lastTransitionTime:
                      description: lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
                      format: date-time
                      type: string
                    message:
                      description: message is a human readable message indicating details about the transition. This may be an empty string.
                      maxLength: 32768
                      type: string
                    observedGeneration:
                      description: observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance.
                      format: int64
                      minimum: 0
                      type: integer
                    reason:
                      description: reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty.
                      maxLength: 1024
                      minLength: 1
                      pattern: ^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$
                      type: string
                    status:
                      description: status of the condition, one of True, False, Unknown.
                      enum:
                      - "True"
                      - "False"
                      - Unknown
                      type: string
                    type:
                      description: type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                      maxLength: 316
                      pattern: ^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$
                      type: string
                  required:
                  - lastTransitionTime
                  - message
                  - reason
                  - status
                  - type
                  type: object
                type: array
              failures:
                description: Failures is the reconciliation failure count against the latest desired state. It is reset after a successful reconciliation.
                format: int64
                type: integer
              helmChart:
                description: HelmChart is the namespaced name of the HelmChart resource created by the controller for the HelmRelease.
                type: string
              installFailures:
                description: InstallFailures is the install failure count against the latest desired state. It is reset after a successful reconciliation.
                format: int64
                type: integer
              lastAppliedRevision:
                description: LastAppliedRevision is the revision of the last successfully applied source.
                type: string
              lastAttemptedRevision:
                description: LastAttemptedRevision is the revision of the last reconciliation attempt.
                type: string
              lastAttemptedValuesChecksum:
                description: LastAttemptedValuesChecksum is the SHA1 checksum of the values of the last reconciliation attempt.
                type: string
              lastHandledReconcileAt:
                description: LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change can be detected.
                type: string
              lastReleaseRevision:
                description: LastReleaseRevision is the revision of the last successful Helm release.
                type: integer
              observedGeneration:
                description: ObservedGeneration is the last observed generation.
                format: int64
                type: integer
              upgradeFailures:
                description: UpgradeFailures is the upgrade failure count against the latest desired state. It is reset after a successful reconciliation.
                format: int64
                type: integer
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.1
  creationTimestamp: null
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: helmrepositories.source.toolkit.fluxcd.io
spec:
  group: source.toolkit.fluxcd.io
  names:
    kind: HelmRepository
    listKind: HelmRepositoryList
    plural: helmrepositories
    singular: helmrepository
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .spec.url
      name: URL
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].status
      name: Ready
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].message
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        description: HelmRepository is the Schema for the helmrepositories API
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            description: HelmRepositorySpec defines the reference to a Helm repository.
            properties:
              interval:
                description: The interval at which to check the upstream for updates.
                type: string
              secretRef:
                description: The name of the secret containing authentication credentials for the Helm repository. For HTTP/S basic auth the secret must contain username and password fields. For TLS the secret must contain a certFile and keyFile, and/or caCert fields.
                properties:
                  name:
                    description: Name of the referent
                    type: string
                required:
                - name
                type: object
              suspend:
                description: This flag tells the controller to suspend the reconciliation of this source.
                type: boolean
              timeout:
                default: 60s
                description: The timeout of index downloading, defaults to 60s.
                type: string
              url:
                description: The Helm repository URL, a valid URL contains at least a protocol and host.
                type: string
            required:
            - interval
            - url
            type: object
          status:
            description: HelmRepositoryStatus defines the observed state of the HelmRepository.
            properties:
              artifact:
                description: Artifact represents the output of the last successful repository sync.
                properties:
                  checksum:
                    description: Checksum is the SHA1 checksum of the artifact.
                    type: string
                  lastUpdateTime:
                    description: LastUpdateTime is the timestamp corresponding to the last update of this artifact.
                    format: date-time
                    type: string
                  path:
                    description: Path is the relative file path of this artifact.
                    type: string
                  revision:
                    description: Revision is a human readable identifier traceable in the origin source system. It can be a Git commit SHA, Git tag, a Helm index timestamp, a Helm chart version, etc.
                    type: string
                  url:
                    description: URL is the HTTP address of this artifact.
                    type: string
                required:
                - path
                - url
                type: object
              conditions:
                description: Conditions holds the conditions for the HelmRepository.
                items:
                  description: "Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` \n     // other fields }"
                  properties:
                    lastTransitionTime:
                      description: lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
                      format: date-time
                      type: string
                    message:
                      description: message is a human readable message indicating details about the transition. This may be an empty string.
                      maxLength: 32768
                      type: string
                    observedGeneration:
                      description: observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance.
                      format: int64
                      minimum: 0
                      type: integer
                    reason:
                      description: reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty.
                      maxLength: 1024
                      minLength: 1
                      pattern: ^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$
                      type: string
                    status:
                      description: status of the condition, one of True, False, Unknown.
                      enum:
                      - "True"
                      - "False"
                      - Unknown
                      type: string
                    type:
                      description: type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                      maxLength: 316
                      pattern: ^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$
                      type: string
                  required:
                  - lastTransitionTime
                  - message
                  - reason
                  - status
                  - type
                  type: object
                type: array
              lastHandledReconcileAt:
                description: LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change can be detected.
                type: string
              observedGeneration:
                description: ObservedGeneration is the last observed generation.
                format: int64
                type: integer
              url:
                description: URL is the download link for the last index fetched.
                type: string
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.1
  creationTimestamp: null
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: kustomizations.kustomize.toolkit.fluxcd.io
spec:
  group: kustomize.toolkit.fluxcd.io
  names:
    kind: Kustomization
    listKind: KustomizationList
    plural: kustomizations
    shortNames:
    - ks
    singular: kustomization
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.conditions[?(@.type=="Ready")].status
      name: Ready
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].message
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        description: Kustomization is the Schema for the kustomizations API.
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            description: KustomizationSpec defines the desired state of a kustomization.
            properties:
              decryption:
                description: Decrypt Kubernetes secrets before applying them on the cluster.
                properties:
                  provider:
                    description: Provider is the name of the decryption engine.
                    enum:
                    - sops
                    type: string
                  secretRef:
                    description: The secret name containing the private OpenPGP keys used for decryption.
                    properties:
                      name:
                        description: Name of the referent
                        type: string
                    required:
                    - name
                    type: object
                required:
                - provider
                type: object
              dependsOn:
                description: DependsOn may contain a dependency.CrossNamespaceDependencyReference slice with references to Kustomization resources that must be ready before this Kustomization can be reconciled.
                items:
                  description: CrossNamespaceDependencyReference holds the reference to a dependency.
                  properties:
                    name:
                      description: Name holds the name reference of a dependency.
                      type: string
                    namespace:
                      description: Namespace holds the namespace reference of a dependency.
                      type: string
                  required:
                  - name
                  type: object
                type: array
              force:
                default: false
                description: Force instructs the controller to recreate resources when patching fails due to an immutable field change.
                type: boolean
              healthChecks:
                description: A list of resources to be included in the health assessment.
                items:
                  description: NamespacedObjectKindReference contains enough information to let you locate the typed referenced object in any namespace
                  properties:
                    apiVersion:
                      description: API version of the referent, if not specified the Kubernetes preferred version will be used
                      type: string
                    kind:
                      description: Kind of the referent
                      type: string
                    name:
                      description: Name of the referent
                      type: string
                    namespace:
                      description: Namespace of the referent, when not specified it acts as LocalObjectReference
                      type: string
                  required:
                  - kind
                  - name
                  type: object
                type: array
              images:
                description: Images is a list of (image name, new name, new tag or digest) for changing image names, tags or digests. This can also be achieved with a patch, but this operator is simpler to specify.
                items:
                  description: Image contains an image name, a new name, a new tag or digest, which will replace the original name and tag.
                  properties:
                    digest:
                      description: Digest is the value used to replace the original image tag. If digest is present NewTag value is ignored.
                      type: string
                    name:
                      description: Name is a tag-less image name.
                      type: string
                    newName:
                      description: NewName is the value used to replace the original name.
                      type: string
                    newTag:
                      description: NewTag is the value used to replace the original tag.
                      type: string
                  required:
                  - name
                  type: object
                type: array
              interval:
                description: The interval at which to reconcile the Kustomization.
                type: string
              kubeConfig:
                description: The KubeConfig for reconciling the Kustomization on a remote cluster. When specified, KubeConfig takes precedence over ServiceAccountName.
                properties:
                  secretRef:
                    description: SecretRef holds the name to a secret that contains a 'value' key with the kubeconfig file as the value. It must be in the same namespace as the Kustomization. It is recommended that the kubeconfig is self-contained, and the secret is regularly updated if credentials such as a cloud-access-token expire. Cloud specific `cmd-path` auth helpers will not function without adding binaries and credentials to the Pod that is responsible for reconciling the Kustomization.
                    properties:
                      name:
                        description: Name of the referent
                        type: string
                    required:
                    - name
                    type: object
                type: object
              patchesJson6902:
                description: JSON 6902 patches, defined as inline YAML objects.
                items:
                  description: JSON6902Patch contains a JSON6902 patch and the target the patch should be applied to.
                  properties:
                    patch:
                      description: Patch contains the JSON6902 patch document with an array of operation objects.
                      items:
                        description: JSON6902 is a JSON6902 operation object. https://tools.ietf.org/html/rfc6902#section-4
                        properties:
                          from:
                            type: string
                          op:
                            enum:
                            - test
                            - remove
                            - add
                            - replace
                            - move
                            - copy
                            type: string
                          path:
                            type: string
                          value:
                            x-kubernetes-preserve-unknown-fields: true
                        required:
                        - op
                        - path
                        type: object
                      type: array
                    target:
                      description: Target points to the resources that the patch document should be applied to.
                      properties:
                        annotationSelector:
                          description: AnnotationSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource annotations.
                          type: string
                        group:
                          description: Group is the API group to select resources from. Together with Version and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
                          type: string
                        kind:
                          description: Kind of the API Group to select resources from. Together with Group and Version it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
                          type: string
                        labelSelector:
                          description: LabelSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource labels.
                          type: string
                        name:
                          description: Name to match resources with.
                          type: string
                        namespace:
                          description: Namespace to select resources from.
                          type: string
                        version:
                          description: Version of the API Group to select resources from. Together with Group and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
                          type: string
                      type: object
                  required:
                  - patch
                  - target
                  type: object
                type: array
              patchesStrategicMerge:
                description: Strategic merge patches, defined as inline YAML objects.
                items:
                  x-kubernetes-preserve-unknown-fields: true
                type: array
              path:
                description: Path to the directory containing the kustomization.yaml file, or the set of plain YAMLs a kustomization.yaml should be generated for. Defaults to 'None', which translates to the root path of the SourceRef.
                type: string
              postBuild:
                description: PostBuild describes which actions to perform on the YAML manifest generated by building the kustomize overlay.
                properties:
                  substitute:
                    additionalProperties:
                      type: string
                    description: Substitute holds a map of key/value pairs. The variables defined in your YAML manifests that match any of the keys defined in the map will be substituted with the set value. Includes support for bash string replacement functions .
                    type: object
                  substituteFrom:
                    description: SubstituteFrom holds references to ConfigMaps and Secrets containing the variables and their values to be substituted in the YAML manifests. The ConfigMap and the Secret data keys represent the var names and they must match the vars declared in the manifests for the substitution to happen.
                    items:
                      description: SubstituteReference contains a reference to a resource containing the variables name and value.
                      properties:
                        kind:
                          description: Kind of the values referent, valid values are ('Secret', 'ConfigMap').
                          enum:
                          - Secret
                          - ConfigMap
                          type: string
                        name:
                          description: Name of the values referent. Should reside in the same namespace as the referring resource.
                          maxLength: 253
                          minLength: 1
                          type: string
                      required:
                      - kind
                      - name
                      type: object
                    type: array
                type: object
              prune:
                description: Prune enables garbage collection.
                type: boolean
              retryInterval:
                description: The interval at which to retry a previously failed reconciliation. When not specified, the controller uses the KustomizationSpec.Interval value to retry failures.
                type: string
              serviceAccountName:
                description: The name of the Kubernetes service account to impersonate when reconciling this Kustomization.
                type: string
              sourceRef:
                description: Reference of the source where the kustomization file is.
                properties:
                  apiVersion:
                    description: API version of the referent
                    type: string
                  kind:
                    description: Kind of the referent
                    enum:
                    - GitRepository
                    - Bucket
                    type: string
                  name:
                    description: Name of the referent
                    type: string
                  namespace:
                    description: Namespace of the referent, defaults to the Kustomization namespace
                    type: string
                required:
                - kind
                - name
                type: object
              suspend:
                description: This flag tells the controller to suspend subsequent kustomize executions, it does not apply to already started executions. Defaults to false.
                type: boolean
              targetNamespace:
                description: TargetNamespace sets or overrides the namespace in the kustomization.yaml file.
                maxLength: 63
                minLength: 1
                type: string
              timeout:
                description: Timeout for validation, apply and health checking operations. Defaults to 'Interval' duration.
                type: string
              validation:
                description: Validate the Kubernetes objects before applying them on the cluster. The validation strategy can be 'client' (local dry-run), 'server' (APIServer dry-run) or 'none'. When 'Force' is 'true', validation will fallback to 'client' if set to 'server' because server-side validation is not supported in this scenario.
                enum:
                - none
                - client
                - server
                type: string
            required:
            - interval
            - prune
            - sourceRef
            type: object
          status:
            description: KustomizationStatus defines the observed state of a kustomization.
            properties:
              conditions:
                items:
                  description: "Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` \n     // other fields }"
                  properties:
                    lastTransitionTime:
                      description: lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
                      format: date-time
                      type: string
                    message:
                      description: message is a human readable message indicating details about the transition. This may be an empty string.
                      maxLength: 32768
                      type: string
                    observedGeneration:
                      description: observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance.
                      format: int64
                      minimum: 0
                      type: integer
                    reason:
                      description: reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty.
                      maxLength: 1024
                      minLength: 1
                      pattern: ^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$
                      type: string
                    status:
                      description: status of the condition, one of True, False, Unknown.
                      enum:
                      - "True"
                      - "False"
                      - Unknown
                      type: string
                    type:
                      description: type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                      maxLength: 316
                      pattern: ^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$
                      type: string
                  required:
                  - lastTransitionTime
                  - message
                  - reason
                  - status
                  - type
                  type: object
                type: array
              lastAppliedRevision:
                description: The last successfully applied revision. The revision format for Git sources is <branch|tag>/<commit-sha>.
                type: string
              lastAttemptedRevision:
                description: LastAttemptedRevision is the revision of the last reconciliation attempt.
                type: string
              lastHandledReconcileAt:
                description: LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change can be detected.
                type: string
              observedGeneration:
                description: ObservedGeneration is the last reconciled generation.
                format: int64
                type: integer
              snapshot:
                description: The last successfully applied revision metadata.
                properties:
                  checksum:
                    description: The manifests sha1 checksum.
                    type: string
                  entries:
                    description: A list of Kubernetes kinds grouped by namespace.
                    items:
                      description: Snapshot holds the metadata of namespaced Kubernetes objects
                      properties:
                        kinds:
                          additionalProperties:
                            type: string
                          description: The list of Kubernetes kinds.
                          type: object
                        namespace:
                          description: The namespace of this entry.
                          type: string
                      required:
                      - kinds
                      type: object
                    type: array
                required:
                - checksum
                - entries
                type: object
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.1
  creationTimestamp: null
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: providers.notification.toolkit.fluxcd.io
spec:
  group: notification.toolkit.fluxcd.io
  names:
    kind: Provider
    listKind: ProviderList
    plural: providers
    singular: provider
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.conditions[?(@.type=="Ready")].status
      name: Ready
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].message
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        description: Provider is the Schema for the providers API
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            description: ProviderSpec defines the desired state of Provider
            properties:
              address:
                description: HTTP/S webhook address of this provider
                pattern: ^(http|https)://
                type: string
              channel:
                description: Alert channel for this provider
                type: string
              proxy:
                description: HTTP/S address of the proxy
                pattern: ^(http|https)://
                type: string
              secretRef:
                description: Secret reference containing the provider webhook URL using "address" as data key
                properties:
                  name:
                    description: Name of the referent
                    type: string
                required:
                - name
                type: object
              type:
                description: Type of provider
                enum:
                - slack
                - discord
                - msteams
                - rocket
                - generic
                - github
                - gitlab
                - bitbucket
                - azuredevops
                type: string
              username:
                description: Bot username for this provider
                type: string
            required:
            - type
            type: object
          status:
            description: ProviderStatus defines the observed state of Provider
            properties:
              conditions:
                items:
                  description: "Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` \n     // other fields }"
                  properties:
                    lastTransitionTime:
                      description: lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
                      format: date-time
                      type: string
                    message:
                      description: message is a human readable message indicating details about the transition. This may be an empty string.
                      maxLength: 32768
                      type: string
                    observedGeneration:
                      description: observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance.
                      format: int64
                      minimum: 0
                      type: integer
                    reason:
                      description: reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty.
                      maxLength: 1024
                      minLength: 1
                      pattern: ^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$
                      type: string
                    status:
                      description: status of the condition, one of True, False, Unknown.
                      enum:
                      - "True"
                      - "False"
                      - Unknown
                      type: string
                    type:
                      description: type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                      maxLength: 316
                      pattern: ^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$
                      type: string
                  required:
                  - lastTransitionTime
                  - message
                  - reason
                  - status
                  - type
                  type: object
                type: array
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.1
  creationTimestamp: null
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: receivers.notification.toolkit.fluxcd.io
spec:
  group: notification.toolkit.fluxcd.io
  names:
    kind: Receiver
    listKind: ReceiverList
    plural: receivers
    singular: receiver
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.conditions[?(@.type=="Ready")].status
      name: Ready
      type: string
    - jsonPath: .status.conditions[?(@.type=="Ready")].message
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        description: Receiver is the Schema for the receivers API
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            description: ReceiverSpec defines the desired state of Receiver
            properties:
              events:
                description: A list of events to handle, e.g. 'push' for GitHub or 'Push Hook' for GitLab.
                items:
                  type: string
                type: array
              resources:
                description: A list of resources to be notified about changes.
                items:
                  description: CrossNamespaceObjectReference contains enough information to let you locate the typed referenced object at cluster level
                  properties:
                    apiVersion:
                      description: API version of the referent
                      type: string
                    kind:
                      description: Kind of the referent
                      enum:
                      - Bucket
                      - GitRepository
                      - Kustomization
                      - HelmRelease
                      - HelmChart
                      - HelmRepository
                      - ImageRepository
                      - ImagePolicy
                      - ImageUpdateAutomation
                      type: string
                    name:
                      description: Name of the referent
                      maxLength: 53
                      minLength: 1
                      type: string
                    namespace:
                      description: Namespace of the referent
                      maxLength: 53
                      minLength: 1
                      type: string
                  required:
                  - name
                  type: object
                type: array
              secretRef:
                description: Secret reference containing the token used to validate the payload authenticity
                properties:
                  name:
                    description: Name of the referent
                    type: string
                required:
                - name
                type: object
              suspend:
                description: This flag tells the controller to suspend subsequent events handling. Defaults to false.
                type: boolean
              type:
                description: Type of webhook sender, used to determine the validation procedure and payload deserialization.
                enum:
                - generic
                - generic-hmac
                - github
                - gitlab
                - bitbucket
                - harbor
                - dockerhub
                - quay
                - gcr
                - nexus
                type: string
            required:
            - resources
            - type
            type: object
          status:
            description: ReceiverStatus defines the observed state of Receiver
            properties:
              conditions:
                items:
                  description: "Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` \n     // other fields }"
                  properties:
                    lastTransitionTime:
                      description: lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
                      format: date-time
                      type: string
                    message:
                      description: message is a human readable message indicating details about the transition. This may be an empty string.
                      maxLength: 32768
                      type: string
                    observedGeneration:
                      description: observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance.
                      format: int64
                      minimum: 0
                      type: integer
                    reason:
                      description: reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty.
                      maxLength: 1024
                      minLength: 1
                      pattern: ^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$
                      type: string
                    status:
                      description: status of the condition, one of True, False, Unknown.
                      enum:
                      - "True"
                      - "False"
                      - Unknown
                      type: string
                    type:
                      description: type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                      maxLength: 316
                      pattern: ^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$
                      type: string
                  required:
                  - lastTransitionTime
                  - message
                  - reason
                  - status
                  - type
                  type: object
                type: array
              url:
                description: Generated webhook URL in the format of '/hook/sha256sum(token+name+namespace)'.
                type: string
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: helm-controller
  namespace: flux-system
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: kustomize-controller
  namespace: flux-system
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: notification-controller
  namespace: flux-system
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: source-controller
  namespace: flux-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: crd-controller-flux-system
rules:
- apiGroups:
  - source.toolkit.fluxcd.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - kustomize.toolkit.fluxcd.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - helm.toolkit.fluxcd.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - notification.toolkit.fluxcd.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - image.toolkit.fluxcd.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
  - patch
- apiGroups:
  - ""
  resources:
  - configmaps
  - configmaps/status
  verbs:
  - get
  - list
  - watch
  - create
  - update
  - patch
  - delete
- apiGroups:
  - coordination.k8s.io
  resources:
  - leases
  verbs:
  - get
  - list
  - watch
  - create
  - update
  - patch
  - delete
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: cluster-reconciler-flux-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kustomize-controller
  namespace: flux-system
- kind: ServiceAccount
  name: helm-controller
  namespace: flux-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: crd-controller-flux-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: crd-controller-flux-system
subjects:
- kind: ServiceAccount
  name: kustomize-controller
  namespace: flux-system
- kind: ServiceAccount
  name: helm-controller
  namespace: flux-system
- kind: ServiceAccount
  name: source-controller
  namespace: flux-system
- kind: ServiceAccount
  name: notification-controller
  namespace: flux-system
- kind: ServiceAccount
  name: image-reflector-controller
  namespace: flux-system
- kind: ServiceAccount
  name: image-automation-controller
  namespace: flux-system
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
    control-plane: controller
  name: notification-controller
  namespace: flux-system
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: http
  selector:
    app: notification-controller
  type: ClusterIP
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
    control-plane: controller
  name: source-controller
  namespace: flux-system
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: http
  selector:
    app: source-controller
  type: ClusterIP
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
    control-plane: controller
  name: webhook-receiver
  namespace: flux-system
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: http-webhook
  selector:
    app: notification-controller
  type: ClusterIP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
    control-plane: controller
  name: helm-controller
  namespace: flux-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: helm-controller
  template:
    metadata:
      annotations:
        prometheus.io/port: "8080"
        prometheus.io/scrape: "true"
      labels:
        app: helm-controller
    spec:
      containers:
      - args:
        - --events-addr=http://notification-controller/
        - --watch-all-namespaces=true
        - --log-level=info
        - --log-encoding=json
        - --enable-leader-election
        env:
        - name: RUNTIME_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        image: ${ECR_HOST}/${FLUXCD_HELM_CONTROLLER}
        imagePullPolicy: IfNotPresent
        livenessProbe:
          httpGet:
            path: /healthz
            port: healthz
        name: manager
        ports:
        - containerPort: 9440
          name: healthz
          protocol: TCP
        - containerPort: 8080
          name: http-prom
        readinessProbe:
          httpGet:
            path: /readyz
            port: healthz
        resources:
          limits:
            cpu: 1000m
            memory: 1Gi
          requests:
            cpu: 100m
            memory: 64Mi
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
        volumeMounts:
        - mountPath: /tmp
          name: temp
      nodeSelector:
        kubernetes.io/os: linux
      serviceAccountName: helm-controller
      terminationGracePeriodSeconds: 600
      volumes:
      - emptyDir: {}
        name: temp
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
    control-plane: controller
  name: kustomize-controller
  namespace: flux-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kustomize-controller
  template:
    metadata:
      annotations:
        prometheus.io/port: "8080"
        prometheus.io/scrape: "true"
      labels:
        app: kustomize-controller
    spec:
      containers:
      - args:
        - --events-addr=http://notification-controller/
        - --watch-all-namespaces=true
        - --log-level=info
        - --log-encoding=json
        - --enable-leader-election
        env:
        - name: RUNTIME_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        image: ${ECR_HOST}/${FLUXCD_KUSTOMIZE_CONTROLLER}
        #mage: ghcr.io/fluxcd/kustomize-controller:v0.9.1
        imagePullPolicy: IfNotPresent
        livenessProbe:
          httpGet:
            path: /healthz
            port: healthz
        name: fluxcd-kustomize-controller
        ports:
        - containerPort: 9440
          name: healthz
          protocol: TCP
        - containerPort: 8080
          name: http-prom
        readinessProbe:
          httpGet:
            path: /readyz
            port: healthz
        resources:
          limits:
            cpu: 1000m
            memory: 1Gi
          requests:
            cpu: 100m
            memory: 64Mi
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
        volumeMounts:
        - mountPath: /tmp
          name: temp
      nodeSelector:
        kubernetes.io/os: linux
      securityContext:
        fsGroup: 1337
      serviceAccountName: kustomize-controller
      terminationGracePeriodSeconds: 60
      volumes:
      - emptyDir: {}
        name: temp
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
    control-plane: controller
  name: notification-controller
  namespace: flux-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: notification-controller
  template:
    metadata:
      annotations:
        prometheus.io/port: "8080"
        prometheus.io/scrape: "true"
      labels:
        app: notification-controller
    spec:
      containers:
      - args:
        - --watch-all-namespaces=true
        - --log-level=info
        - --log-encoding=json
        - --enable-leader-election
        env:
        - name: RUNTIME_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        image: ${ECR_HOST}/${FLUXCD_NOTIFICATION_CONTROLLER}
        imagePullPolicy: IfNotPresent
        livenessProbe:
          httpGet:
            path: /healthz
            port: healthz
        name: manager
        ports:
        - containerPort: 9440
          name: healthz
          protocol: TCP
        - containerPort: 9090
          name: http
        - containerPort: 9292
          name: http-webhook
        - containerPort: 8080
          name: http-prom
        readinessProbe:
          httpGet:
            path: /readyz
            port: healthz
        resources:
          limits:
            cpu: 1000m
            memory: 1Gi
          requests:
            cpu: 100m
            memory: 64Mi
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
        volumeMounts:
        - mountPath: /tmp
          name: temp
      nodeSelector:
        kubernetes.io/os: linux
      serviceAccountName: notification-controller
      terminationGracePeriodSeconds: 10
      volumes:
      - emptyDir: {}
        name: temp
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
    control-plane: controller
  name: source-controller
  namespace: flux-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: source-controller
  strategy:
    type: Recreate
  template:
    metadata:
      annotations:
        prometheus.io/port: "8080"
        prometheus.io/scrape: "true"
      labels:
        app: source-controller
    spec:
      containers:
      - args:
        - --events-addr=http://notification-controller/
        - --watch-all-namespaces=true
        - --log-level=info
        - --log-encoding=json
        - --enable-leader-election
        - --storage-path=/data
        - --storage-adv-addr=source-controller.$(RUNTIME_NAMESPACE).svc.cluster.local.
        env:
        - name: RUNTIME_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        image: ${ECR_HOST}/${FLUXCD_SOURCE_CONTROLLER}
        imagePullPolicy: IfNotPresent
        livenessProbe:
          httpGet:
            path: /healthz
            port: healthz
        name: manager
        ports:
        - containerPort: 9090
          name: http
        - containerPort: 8080
          name: http-prom
        - containerPort: 9440
          name: healthz
        readinessProbe:
          httpGet:
            path: /
            port: http
        resources:
          limits:
            cpu: 1000m
            memory: 1Gi
          requests:
            cpu: 50m
            memory: 64Mi
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
        volumeMounts:
        - mountPath: /data
          name: data
        - mountPath: /tmp
          name: tmp
      nodeSelector:
        kubernetes.io/os: linux
      securityContext:
        fsGroup: 1337
      serviceAccountName: source-controller
      terminationGracePeriodSeconds: 10
      volumes:
      - emptyDir: {}
        name: data
      - emptyDir: {}
        name: tmp
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: allow-scraping
  namespace: flux-system
spec:
  ingress:
  - from:
    - namespaceSelector: {}
    ports:
    - port: 8080
      protocol: TCP
  podSelector: {}
  policyTypes:
  - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: allow-webhooks
  namespace: flux-system
spec:
  ingress:
  - from:
    - namespaceSelector: {}
  podSelector:
    matchLabels:
      app: notification-controller
  policyTypes:
  - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/version: v0.9.0
  name: deny-ingress
  namespace: flux-system
spec:
  egress:
  - {}
  ingress:
  - from:
    - podSelector: {}
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
---
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: Bucket
metadata:
  name: bucket
  namespace: default
spec:
  interval: 5m
  provider: aws
  bucketName: bucket1
  endpoint: s3.amazonaws.com
  region: us-east-1
  timeout: 30s
