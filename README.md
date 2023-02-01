 # Kestra Deploy Action

Official GitHub Action to create CI/CD pipelines that deploys [Flows](https://kestra.io/docs/concepts/flows.html)
or [Templates](https://kestra.io/docs/developer-guide/templates/) to your Kestra server.

This action should be used within a workflow that runs only on your <code>main</code> branch.
<br/>Only one namespace can be specified in each <code>Kestra Deploy Action</code> so you may need to
reuse the action for each namespace. The Action version is based on the Kestra Version. Only Kestra
v0.6.1+ is supported.

## What does the action do ?

* Take a folder in input containing your `Flow` **or** `Template` as yaml files.
* For each resource, 3 actions are possible:
    * **Create**, if the resource does not exist.
    * **Update**, if the resource exist.
    * **Delete**, if the resource exist but the file does not exist anymore.
        * **Optional**, you can disable the deletion of the `Flow` by the CI.
* Log each resource updated, included deleted one.

## Usage

Note that the action can not update multiple namespace at once. So it's advice to regroup in subfolder your `Flows` and
`Templates` by namespace.

**Also, you should always deploy your `Templates` before your `Flows`, to avoid running before their
templates are created.**

### Inputs

| Inputs        | Required           | Default | Description                                                                |
|---------------|--------------------|---------|----------------------------------------------------------------------------|
| ``namespace`` | :heavy_check_mark: |         | Namespace to update                                                        |
| ``directory`` | :heavy_check_mark: |         | Folder containing your resources                                           |
| ``resource``  | :x:                | flow    | Resource you want to update in your namespace, can be `flow` or `template` |
| ``server``    | :heavy_check_mark: |         | URL of your Kestra server                                                  |
| ``user``      | :x:                |         | User for the basic auth                                                    |
| ``password``  | :x:                |         | Password for the basic auth                                                |
| ``delete``    | :x:                | true    | If `Flows` not found in directory should be deleted from the namespace     |

### Auth

Depending on your Kestra edition, you may need to include `user` and `password` to authenticate
on the server.

### Example

Example with `Flows`

```yaml
      - name: flow update namespace action
        uses: actions/kestra-deploy-action@v0.6.1
        with:
          namespace: io.kestra.namespace
          directory: ./kestra/flows/namespace_dedicate_folder
          server: https:/kestra.io
```

Example with `Templates`

```yaml
      - name: template update namespace action
        uses: actions/kestra-deploy-action@v0.6.1
        with:
          namespace: io.kestra.namespace
          resource: template
          directory: ./kestra/templates/namespace_dedicate_folder
          server: https:/kestra.io
```