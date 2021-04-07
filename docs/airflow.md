# Airflow

To create a new admin user:
- Open a shell on the web pod
- Run: `FLASK_APP=airflow.www.app flask fab create-admin`

## Troubleshooting
If the init container check-db-migration fails, create a new job with the following:
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  annotations:
    meta.helm.sh/release-name: airflow
    meta.helm.sh/release-namespace: airflow
  labels:
    app: airflow
    app.kubernetes.io/managed-by: Helm
    chart: airflow-8.0.0
    component: jobs
    helm.toolkit.fluxcd.io/name: airflow
    helm.toolkit.fluxcd.io/namespace: airflow
    heritage: Helm
    release: airflow
  name: airflow-upgrade-db
  namespace: airflow
spec:
  backoffLimit: 6
  template:
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                - key: beta.kubernetes.io/arch
                  operator: In
                  values:
                    - amd64
      containers:
      - args:
        - bash
        - -c
        - exec airflow db upgrade
        command:
        - /usr/bin/dumb-init
        - --
        env:
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              key: postgresql-password
              name: airflow-postgresql
        - name: REDIS_PASSWORD
          valueFrom:
            secretKeyRef:
              key: redis-password
              name: airflow-redis
        envFrom:
        - secretRef:
            name: airflow-config
        image: apache/airflow:2.0.1-python3.8
        imagePullPolicy: IfNotPresent
        name: upgrade-db
        resources: {}
        securityContext:
          runAsGroup: 50000
          runAsUser: 50000
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      initContainers:
      - args:
        - bash
        - -c
        - exec airflow db check
        command:
        - /usr/bin/dumb-init
        - --
        env:
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              key: postgresql-password
              name: airflow-postgresql
        - name: REDIS_PASSWORD
          valueFrom:
            secretKeyRef:
              key: redis-password
              name: airflow-redis
        envFrom:
        - secretRef:
            name: airflow-config
        image: apache/airflow:2.0.1-python3.8
        imagePullPolicy: IfNotPresent
        name: check-db
        resources: {}
        securityContext:
          runAsGroup: 50000
          runAsUser: 50000
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      restartPolicy: OnFailure
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
```