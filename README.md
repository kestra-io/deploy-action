# Deploy Action

Official GitHub Action to create a CI/CD pipeline that deploys [Flows](https://kestra.io/docs/concepts/flows.html)
or [Templates](https://kestra.io/docs/developer-guide/templates/) to your Kestra server.

This action should be used within a workflow that runs only on your <code>main</code> branch.

## Important notes ❗️

Only **one namespace** can be specified in each <code>Kestra Deploy Action</code> so you may need to
reuse the action for each namespace. Here is an example:

```yaml
      - name: deploy-prod
        uses: kestra-io/deploy-action@develop
        with:
          namespace: prod
          directory: ./flows
      - name: deploy-prod-marketing
        uses: kestra-io/deploy-action@develop
        with:
          namespace: prod.marketing
          directory: ./flows/marketing
```

Also, note that this GitHub Action supports flows built with Kestra v0.6.1+.

## What does the action do ?

It takes a `directory` as an input argument, indicating the directory within your repository where your `Flow` or `Template` YAML files are stored.

For each resource, the following outcomes are possible:
  * **Create** a flow or a template resource, if the resource does not exist.
  * **Update** a flow or a template resource, if the resource exists.
  * **Delete** a flow or a template resource, if the resource exists, but the file does not exist anymore (i.e. the flow or template file got deleted).
      * You can disable the deletion of a given resource by setting `delete: false` in the action, as shown in the full example below.

The action logs all these outcomes by specifying which resources got updated, added or deleted.

## Usage

Note that the action can NOT update multiple namespaces at the same time. We recommend grouping your `Flows` and
`Templates` into subdirectories indicating a specific namespace. For the example shown above, your directory structure could look as follows:

```bash
.
├── flows
│   ├── flow1.yml
│   ├── flow2.yml
│   └── flow3.yml
├── marketing
│   ├── marketing__flow1.yml
│   ├── marketing__flow2.yml
│   └── marketing__flow3.yml
```

Also, you should always deploy your `Templates` before your `Flows`, to avoid running before their
templates are created.

### Inputs

| Inputs        | Required           | Default | Description                                                                                                                                                         |
|---------------|--------------------|---------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ``namespace`` | :heavy_check_mark: |         | Namespace containing your flows and templates                                                                                                                       |
| ``directory`` | :heavy_check_mark: |         | Folder containing your resources                                                                                                                                    |
| ``resource``  | :heavy_check_mark: |         | Resource you want to update in your namespace, can be either `flow` or `template`                                                                                   |
| ``server``    | :heavy_check_mark: |         | URL of your Kestra server                                                                                                                                           |
| ``user``      | :x:                |         | User name of your Kestra server                                                                                                                                     |
| ``password``  | :x:                |         | Password of your Kestra server                                                                                                                                      |
| ``delete``    | :x:                | true    | `Flows` found in Kestra server, but no longer existing in a specified directory, will be deleted by default. Set this to `false` if you want to avoid that behavior |
| ``tenant``    | :x:                |         | Tenant identifier (EE only, when multi-tenancy is enabled)                                                                                                          |

### Auth

Depending on your Kestra edition, you may need to include a `user` and `password` to authenticate the action with your Kestra server.

### Example

Example with `Flows` resources:

```yaml
      - name: flow update namespace action
        uses: kestra-io/deploy-action@develop
        with:
          namespace: io.kestra.namespace
          resource: flow
          directory: ./flows/namespace_dedicated_folder
          server: https:/kestra.io
```

Example with `Templates` resources:

```yaml
      - name: template update namespace action
        uses: kestra-io/deploy-action@develop
        with:
          namespace: io.kestra.namespace
          resource: template
          directory: ./templates/namespace_dedicated_folder
          server: https:/kestra.io
```

## Full Example

Assuming that you store all your flow YAML files in the `flows` directory and that all flows belong to the namespace `prod`, you can configure a GitHub Action workflow by creating the following file (you can store the file as `.github/workflows/main.yml`):   

```yaml
name: Kestra CI/CD
on: 
  workflow_dispatch:
jobs:
  kestra:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: deploy
        uses: kestra-io/deploy-action@develop
        with:
          namespace: prod
          directory: ./flows
          resource: flow
          server: ${{secrets.KESTRA_HOST}}
          user: ${{secrets.KESTRA_USER}}
          password: ${{secrets.KESTRA_PASSWORD}}
          delete: false
```

This setup also assumes that you stored the host name, user name and password as Actions secrets. 

Finally, instead of only running this workflow manually, you can configure it to be triggered upon push to the main branch:

```yaml
name: Kestra CI/CD
on:
  push:
    branches:
      - main
jobs:
  ...
```

